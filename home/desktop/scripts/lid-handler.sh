#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "usage: $0 open|close" >&2
  exit 1
fi
action="$1"
internal="eDP-1"
external="HDMI-A-1"

external_connected() {
  hyprctl monitors all -j | grep -q "\"name\": \"$external\""
}

case "$action" in
  close)
    if external_connected; then
      # Docked: hand the desktop over to the external monitor at its own
      # native resolution instead of mirroring a now-off internal panel.
      hyprctl eval "hl.monitor({output = '$internal', disabled = true})"
      hyprctl eval "hl.monitor({output = '$external', mode = 'preferred', position = 'auto', scale = 'auto', mirror = 'none', disabled = false})"
    else
      # No external monitor to fall back on: behave like a normal lid close.
      systemctl suspend
    fi
    ;;
  open)
    hyprctl eval "hl.monitor({output = '$internal', mode = 'preferred', position = 'auto', scale = 'auto', disabled = false})"
    if external_connected; then
      hyprctl eval "hl.monitor({output = '$external', mode = 'preferred', position = 'auto', scale = 'auto', mirror = '$internal', disabled = false})"
    fi
    ;;
  *)
    echo "usage: $0 {open|close}" >&2
    exit 1
    ;;
esac
