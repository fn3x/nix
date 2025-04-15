#!/usr/bin/env sh

# Define monitor names
INTERNAL_MONITOR="eDP-1"
EXTERNAL_MONITOR="HDMI-A-1"

# Function to move all workspaces to a specified monitor
move_all_workspaces_to_monitor() {
  TARGET_MONITOR="$1"
  hyprctl workspaces | grep ^workspace | cut --delimiter ' ' --fields 3 | xargs -I '{}' hyprctl dispatch moveworkspacetomonitor '{}' "$TARGET_MONITOR"
}

# Check the number of connected monitors
NUM_MONITORS=$(hyprctl monitors all | grep --count Monitor)
NUM_MONITORS_ACTIVE=$(hyprctl monitors | grep --count Monitor)

# If both monitors are active, disable the internal monitor
if [ "$NUM_MONITORS_ACTIVE" -ge 2 ] && hyprctl monitors | cut --delimiter ' ' --fields 2 | grep --quiet ^$INTERNAL_MONITOR; then
  move_all_workspaces_to_monitor $EXTERNAL_MONITOR
  hyprctl keyword monitor "$INTERNAL_MONITOR, disable"
  exit
fi

# Toggle between monitors based on their current state
if [ "$NUM_MONITORS" -gt 1 ]; then
  if hyprctl monitors | cut --delimiter ' ' --fields 2 | grep --quiet ^$EXTERNAL_MONITOR; then
    hyprctl keyword monitor $INTERNAL_MONITOR,preferred,0x0,1
    move_all_workspaces_to_monitor $INTERNAL_MONITOR
    hyprctl keyword monitor "$EXTERNAL_MONITOR, disable"
  else
    hyprctl keyword monitor $EXTERNAL_MONITOR,preferred,0x0,1
    move_all_workspaces_to_monitor $EXTERNAL_MONITOR
    hyprctl keyword monitor "$INTERNAL_MONITOR, disable"
  fi
else
  hyprctl keyword monitor $INTERNAL_MONITOR,preferred,0x0,1
  move_all_workspaces_to_monitor $INTERNAL_MONITOR
fi

