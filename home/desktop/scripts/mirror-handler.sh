#!/usr/bin/env bash
# Keeps satanael's displays in the right layout. Called on Hyprland start and
# on monitor hotplug:
#   - HP monitor (DP-3) on:  it is the main desktop and the TV (HDMI-A-1)
#                            mirrors it.
#   - HP monitor off/gone:   the TV runs as a normal desktop on its own, so
#                            windows and workspaces move over to it.
set -euo pipefail

main="DP-3"
second="HDMI-A-1"

monitor_field() {
  # monitor_field <name> <jq field>; prints nothing if the monitor is absent
  hyprctl monitors all -j | jq -r --arg n "$1" ".[] | select(.name == \$n) | $2"
}

main_id="$(monitor_field "$main" .id)"
second_id="$(monitor_field "$second" .id)"
[ -n "$second_id" ] || exit 0

# Only reconfigure when needed: changing the layout fires monitor events that
# call this script again.
if [ -n "$main_id" ] && [ "$(monitor_field "$main" .disabled)" = "false" ]; then
  if [ "$(monitor_field "$second" .mirrorOf)" != "$main_id" ]; then
    hyprctl eval "hl.monitor({output = '$second', mode = '1920x1080@60', position = 'auto', scale = 1, mirror = '$main', disabled = false})"
  fi
else
  if [ "$(monitor_field "$second" .disabled)" != "false" ] \
     || [ "$(monitor_field "$second" .mirrorOf)" != "none" ]; then
    hyprctl eval "hl.monitor({output = '$second', mode = '1920x1080@60', position = 'auto', scale = 1, mirror = 'none', disabled = false})"
  fi
fi
