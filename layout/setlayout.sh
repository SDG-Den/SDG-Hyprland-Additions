#!/bin/bash

# Check if a preset name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <preset_name>"
  exit 1
fi

PRESET_NAME="$1"
DOTFILES_DIR="$HOME/SDG-Hyprland-Additions/layout/config"
CONFIG_FILE="$DOTFILES_DIR/$(hyprctl activeworkspace | grep -e "windows: " | awk '{print $2}').json"
echo "detected config $CONFIG_FILE"

# Check if the config file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "No config file found for the current number of windows."
  exit 1
fi

# Extract the preset from the JSON file
LAYOUT=$(jq --arg preset "$PRESET_NAME" '.presets[$preset]' "$CONFIG_FILE")

echo "using layout $LAYOUT"

# Check if the preset exists
if [ "$LAYOUT" = "null" ]; then
  echo "Preset '$PRESET_NAME' not found in $CONFIG_FILE."
  exit 1
fi

# Get the active workspace ID
WORKSPACE_ID=$(hyprctl activeworkspace | grep -e "workspace ID " | awk '{print $3}')


# Get the list of windows in the active workspace
WINDOWS=$(hyprctl clients | grep -B 5 "workspace: $WORKSPACE_ID\b" | grep -e "Window [0-9]" | awk '{print $2}')

# Convert the JSON layout to an array
readarray -t WINDOW_POSITIONS < <(jq -r --argjson layout "$LAYOUT" '[$layout[] | "\(.x),\(.y),\(.width),\(.height)"] | .[]' <<< "$LAYOUT")

# Get the line containing the resolution and offset for the active monitor
MONITOR_DATA=$(hyprctl monitors | grep -B 12 "focused: yes" | grep -e " at " | sed 's/x/ /' | sed 's/@[0-9]*\.[0-9]*/ /' | sed 's/ *at / /' | sed 's/x/ /')

# get raw values
echo "getting raw values..."
OFFSET_X_RAW=$(echo $MONITOR_DATA | awk '{print $3}')
OFFSET_Y_RAW=$(echo $MONITOR_DATA | awk '{print $4}')
RESOLUTION_X=$(echo $MONITOR_DATA | awk '{print $1}')
RESOLUTION_Y=$(echo $MONITOR_DATA | awk '{print $2}')

# get main display res for calculations
ROOT_RES_X=$(hyprctl monitors | grep -A 1 "(ID 0)" | grep " at " | sed 's/x/ /' | sed 's/@/ /' | awk '{print $1}')
ROOT_RES_Y=$(hyprctl monitors | grep -A 1 "(ID 0)" | grep " at " | sed 's/x/ /' | sed 's/@/ /' | awk '{print $2}')

echo "calculating offset with the following data:"
echo "raw X: $OFFSET_X_RAW"
echo "raw Y: $OFFSET_Y_RAW"
echo "active monitor resolution: $RESOLUTION_X x $RESOLUTION_Y"
echo "root monitor resolution: $ROOT_RES_X x $ROOT_RES_Y"

X_OFFSET=$(expr $OFFSET_X_RAW \* 100 / $ROOT_RES_X)
Y_OFFSET=$(expr $OFFSET_Y_RAW \* 100 / $ROOT_RES_Y)

echo "offset calculated as x $X_OFFSET and y $Y_OFFSET"

# Convert JSON to array

echo "converting json to array.."
readarray -t WINDOW_POSITIONS < <(jq -r --argjson layout "$LAYOUT" '[$layout[] | "\(.x),\(.y),\(.width),\(.height)"] | .[]' <<< "$LAYOUT")
echo "done"





for window in $WINDOWS; do
    hyprctl dispatch setfloating address:0x$window
    echo "set $window to floating"
    sleep 0.05
done

i=0
for window in $WINDOWS; do
  # Focus the window
  hyprctl dispatch focuswindow address:0x$window
  echo "focused $window"
  sleep 0.05

  # Extract position and size from the JSON layout
  IFS=',' read -r x y width height <<< "${WINDOW_POSITIONS[$i]}"

  # Resize the window (using percentages)
  hyprctl dispatch resizeactive exact $width% $height%
  echo "resized $window to width $width% and height $height%"
  sleep 0.05

  # Move the window (using relative positioning)
  echo "calculating x offset: $x + $X_OFFSET"
  tempX=$(expr $x + $X_OFFSET)
  echo "calculating y offset: $y + $Y_OFFSET"
  tempY=$(expr $y + $Y_OFFSET)
  hyprctl dispatch moveactive exact $tempX% $tempY%

  echo "moved window $window to x=$tempX% y=$tempY% "
  sleep 0.05
  ((i++))
done

