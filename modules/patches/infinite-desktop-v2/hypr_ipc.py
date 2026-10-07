#!/usr/bin/env python3

import json
import os
import socket
import threading
import queue


def _socket_path():
    runtime = os.environ.get('XDG_RUNTIME_DIR', f'/run/user/{os.getuid()}')
    sig = os.environ['HYPRLAND_INSTANCE_SIGNATURE']
    return f'{runtime}/hypr/{sig}/.socket.sock'


def _send(payload, timeout=2):
    s = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    s.settimeout(timeout)
    try:
        s.connect(_socket_path())
        s.sendall(payload.encode())
        chunks = []
        while True:
            chunk = s.recv(65536)
            if not chunk:
                break
            chunks.append(chunk)
        return b''.join(chunks)
    finally:
        s.close()


def hyprctl_json(args, timeout=2):
    data = _send('j/' + '/'.join(args), timeout=timeout)
    return json.loads(data) if data.strip() else None


def dispatch(lua_expr, timeout=2):
    return _send(f'dispatch {lua_expr}', timeout=timeout)


# infinite_desktop_core.py calls dispatch_async()/batch_async() up to ~60
# times a second while panning. Spawning a new thread + new socket
# connection per call piles up the instant the IPC socket lags even
# slightly, starving the GIL and making the pan feel laggy. A single
# worker draining a 1-slot queue keeps at most one send in flight and
# collapses bursts to just the latest command (stale intermediate pan
# positions are useless anyway).
_async_queue = queue.Queue(maxsize=1)


def _async_worker():
    while True:
        cmd = _async_queue.get()
        try:
            _send(cmd, timeout=1)
        except Exception:
            pass


threading.Thread(target=_async_worker, daemon=True).start()


def _submit_async(cmd):
    try:
        _async_queue.get_nowait()
    except queue.Empty:
        pass
    try:
        _async_queue.put_nowait(cmd)
    except queue.Full:
        pass


def dispatch_async(lua_expr):
    _submit_async(f'dispatch {lua_expr}')


def batch(lua_exprs, timeout=5):
    cmd = '[[BATCH]]' + ' ; '.join(f'dispatch {e}' for e in lua_exprs)
    return _send(cmd, timeout=timeout)


def batch_async(lua_exprs):
    if not lua_exprs:
        return
    cmd = '[[BATCH]]' + ' ; '.join(f'dispatch {e}' for e in lua_exprs)
    _submit_async(cmd)


def toggle_floating_lua(address=None):
    w = f', window = "address:{address}"' if address else ""
    return f'hl.dsp.window.float({{ action = "toggle"{w} }})'

def toggle_floating(address=None):
    return dispatch(toggle_floating_lua(address))


def focus_window_lua(address):
    return f'hl.dsp.focus({{ window = "address:{address}" }})'

def focus_window(address):
    return dispatch(focus_window_lua(address))


def move_focus_lua(direction_lud):
    return f'hl.dsp.focus({{ direction = "{direction_lud}" }})'

def move_focus(direction_lud):
    return dispatch(move_focus_lua(direction_lud))


def move_window_tiled_lua(direction_lud):
    return f'hl.dsp.window.move({{ direction = "{direction_lud}" }})'

def move_window_tiled(direction_lud):
    return dispatch(move_window_tiled_lua(direction_lud))


def exec_cmd_lua(cmd):
    escaped = cmd.replace('\\', '\\\\').replace('"', '\\"')
    return f'hl.dsp.exec_cmd("{escaped}")'


def move_window_exact_lua(x, y, address):
    return (f'hl.dsp.window.move({{ window = "address:{address}", '
            f'x = {int(x)}, y = {int(y)}, relative = false }})')

def move_window_exact(x, y, address, timeout=2):
    return dispatch(move_window_exact_lua(x, y, address), timeout=timeout)

def move_window_exact_async(x, y, address):
    dispatch_async(move_window_exact_lua(x, y, address))


def resize_window_exact_lua(w, h, address):
    return (f'hl.dsp.window.resize({{ window = "address:{address}", '
            f'x = {int(w)}, y = {int(h)}, relative = false }})')

def resize_window_exact(w, h, address, timeout=2):
    return dispatch(resize_window_exact_lua(w, h, address), timeout=timeout)


def eval_lua(code, timeout=2):
    return _send(f'eval {code}', timeout=timeout)


def focused_monitor_bounds(timeout=2):
    """Logical (scale/rotation-aware) bounds of the focused monitor, i.e.
    the same coordinate space window `at`/`size` are reported in."""
    monitors = hyprctl_json(['monitors'], timeout=timeout) or []
    m = next((m for m in monitors if m.get('focused')), monitors[0] if monitors else None)
    if not m:
        return {'left': 0, 'top': 0, 'right': 1920, 'bottom': 1080,
                'width': 1920, 'height': 1080}
    scale = m.get('scale') or 1
    w, h = m['width'] / scale, m['height'] / scale
    if m.get('transform', 0) % 2:
        w, h = h, w
    w, h = int(round(w)), int(round(h))
    return {'left': m['x'], 'top': m['y'], 'right': m['x'] + w,
            'bottom': m['y'] + h, 'width': w, 'height': h}


# While panning, every frame re-targets each window's move animation, so the
# windows trail behind the pointer ("drag and wait"). Turn the windowsMove
# animation off for the duration of a pan and put it back afterwards.
_FALLBACK_MOVE_ANIM = {'speed': 4, 'bezier': 'easeOutQuint'}
_saved_move_anim = None
_move_anim_lock = threading.Lock()


def suspend_move_animation():
    global _saved_move_anim
    with _move_anim_lock:
        if _saved_move_anim is not None:
            return
        _saved_move_anim = _read_and_disable_move_animation()


def _read_and_disable_move_animation():
    saved = dict(_FALLBACK_MOVE_ANIM)
    try:
        anims = hyprctl_json(['animations'], timeout=0.5) or [[]]
        cur = next((a for a in anims[0] if a.get('name') == 'windowsMove'), None)
        if cur and cur.get('overridden') and cur.get('enabled'):
            saved = {'speed': cur['speed'], 'bezier': cur['bezier']}
        eval_lua('hl.animation({ leaf = "windowsMove", enabled = false })', timeout=0.5)
    except Exception:
        pass
    return saved


def restore_move_animation():
    global _saved_move_anim
    with _move_anim_lock:
        if _saved_move_anim is None:
            return
        a, _saved_move_anim = _saved_move_anim, None
    try:
        eval_lua(f'hl.animation({{ leaf = "windowsMove", enabled = true, '
                 f'speed = {a["speed"]}, bezier = "{a["bezier"]}" }})', timeout=0.5)
    except Exception:
        pass
