#!/usr/bin/env bash
# Keeps arsene's displays in the right layout. Called on Hyprland start,
# on monitor hotplug and on lid open/close:
#   - HDMI connected, lid open:   HDMI runs a real 1920x1080 desktop and the
#                                 laptop panel mirrors it (shrunk to fit).
#   - HDMI connected, lid closed: laptop panel off, HDMI only.
#   - no HDMI:                    laptop panel on its own at a ~1080p-sized
#                                 scale (lid close suspends).
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "usage: $0 open|close|sync" >&2
  exit 1
fi
action="$1"
internal="eDP-1"
external="HDMI-A-1"
# Smallest scale Hyprland accepts for the 1366x768 panel: a ~2048x1152
# desktop, roughly what a 1080p monitor shows.
internal_scale="0.666667"

lid_state() {
  if grep -qs closed /proc/acpi/button/lid/*/state; then echo closed; else echo open; fi
}

monitor_field() {
  # monitor_field <name> <jq field>; prints nothing if the monitor is absent
  hyprctl monitors all -j | jq -r --arg n "$1" ".[] | select(.name == \$n) | $2"
}

sync() {
  local lid="$1"
  local ext_id
  ext_id="$(monitor_field "$external" .id)"

  if [ -z "$ext_id" ]; then
    # Undocked: plain laptop panel.
    if [ "$(monitor_field "$internal" .disabled)" != "false" ] \
       || [ "$(monitor_field "$internal" .mirrorOf)" != "none" ] \
       || [ "$(monitor_field "$internal" '.scale < 0.7')" != "true" ]; then
      hyprctl eval "hl.monitor({output = '$internal', mode = 'preferred', position = 'auto', scale = $internal_scale, mirror = 'none', disabled = false})"
    fi
    return
  fi

  # External monitor is the real desktop at its native resolution.
  if [ "$(monitor_field "$external" .disabled)" != "false" ] \
     || [ "$(monitor_field "$external" .mirrorOf)" != "none" ]; then
    hyprctl eval "hl.monitor({output = '$external', mode = 'preferred', position = 'auto', scale = 1, mirror = 'none', disabled = false})"
  fi

  if [ "$lid" = closed ]; then
    if [ "$(monitor_field "$internal" .disabled)" != "true" ]; then
      hyprctl eval "hl.monitor({output = '$internal', disabled = true})"
    fi
  else
    # Only reconfigure when needed: changing the layout fires monitor events
    # that call this script again.
    if [ "$(monitor_field "$internal" .disabled)" != "false" ] \
       || [ "$(monitor_field "$internal" .mirrorOf)" != "$ext_id" ]; then
      hyprctl eval "hl.monitor({output = '$internal', mode = 'preferred', position = 'auto', scale = $internal_scale, mirror = '$external', disabled = false})"
    fi
  fi
}

case "$action" in
  close)
    if [ -n "$(monitor_field "$external" .id)" ]; then
      sync closed
    else
      # No external monitor to fall back on: behave like a normal lid close.
      systemctl suspend
    fi
    ;;
  open)
    sync open
    ;;
  sync)
    sync "$(lid_state)"
    ;;
  *)
    echo "usage: $0 {open|close|sync}" >&2
    exit 1
    ;;
esac
