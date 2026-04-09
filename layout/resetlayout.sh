#!/bin/bash

# Get the active workspace ID
WORKSPACE_ID=$(hyprctl activeworkspace | grep -e "workspace ID " | awk '{print $3}')

# Get the list of windows in the active workspace
WINDOWS=$(hyprctl clients | grep -B 5 "workspace: $WORKSPACE_ID\b" | grep -e "Window [0-9]" | awk '{print $2}')

for window in $WINDOWS; do
    hyprctl dispatch settiled address:0x$window
    echo "set $window back to tiled"
done
