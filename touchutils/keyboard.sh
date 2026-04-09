#!/bin/sh
# Wrapper script for wvkbd-mobintl to use JSON configuration.
# Usage: ./wvkbd_wrapper.sh [path/to/config.json]

# Default config file
CONFIG_FILE="keyboard.json"

# Use custom config file if provided
if [ $# -ge 1 ]; then
    CONFIG_FILE="$1"
fi

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file '$CONFIG_FILE' not found."
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' is required but not installed. Please install it first."
    exit 1
fi

# Initialize command array
CMD=("wvkbd-mobintl")

# Helper function to add flag if value exists
add_flag() {
    local value="$1"
    local flag="$2"
    if [ -n "$value" ] && [ "$value" != "null" ]; then
        CMD+=("$flag" "$value")
    fi
}

# Parse JSON and build command
PORTRAIT_HEIGHT=$(jq -r '.display.portrait_mode_height_px' "$CONFIG_FILE")
LANDSCAPE_HEIGHT=$(jq -r '.display.landscape_mode_height_px' "$CONFIG_FILE")
ROUNDING_RADIUS=$(jq -r '.display.rounding_radius_px' "$CONFIG_FILE")
FONT_FAMILY=$(jq -r '.font.family' "$CONFIG_FILE")
FONT_SIZE=$(jq -r '.font.size_pt' "$CONFIG_FILE")
BG_COLOR=$(jq -r '.colors.background.value' "$CONFIG_FILE")
KEY_COLOR=$(jq -r '.colors.keys.default.value' "$CONFIG_FILE")
SPECIAL_KEY_COLOR=$(jq -r '.colors.keys.special.value' "$CONFIG_FILE")
PRESSED_KEY_COLOR=$(jq -r '.colors.keys.pressed.value' "$CONFIG_FILE")
PRESSED_SPECIAL_KEY_COLOR=$(jq -r '.colors.keys.pressed_special.value' "$CONFIG_FILE")
SWIPED_KEY_COLOR=$(jq -r '.colors.keys.swiped.value' "$CONFIG_FILE")
SWIPED_SPECIAL_KEY_COLOR=$(jq -r '.colors.keys.swiped_special.value' "$CONFIG_FILE")
TEXT_COLOR=$(jq -r '.colors.text.default.value' "$CONFIG_FILE")
SPECIAL_TEXT_COLOR=$(jq -r '.colors.text.special.value' "$CONFIG_FILE")

# Add display flags
add_flag "$PORTRAIT_HEIGHT" "-H"
add_flag "$LANDSCAPE_HEIGHT" "-L"
add_flag "$ROUNDING_RADIUS" "-R"

# Add font flag (combine family and size if both exist)
if [ -n "$FONT_FAMILY" ] && [ "$FONT_FAMILY" != "null" ]; then
    if [ -n "$FONT_SIZE" ] && [ "$FONT_SIZE" != "null" ]; then
        add_flag "$FONT_FAMILY $FONT_SIZE" "--fn"
    else
        add_flag "$FONT_FAMILY" "--fn"
    fi
fi

# Add color flags
add_flag "$BG_COLOR" "--bg"
add_flag "$KEY_COLOR" "--fg"
add_flag "$SPECIAL_KEY_COLOR" "--fg-sp"
add_flag "$PRESSED_KEY_COLOR" "--press"
add_flag "$PRESSED_SPECIAL_KEY_COLOR" "--press-sp"
add_flag "$SWIPED_KEY_COLOR" "--swipe"
add_flag "$SWIPED_SPECIAL_KEY_COLOR" "--swipe-sp"
add_flag "$TEXT_COLOR" "--text"
add_flag "$SPECIAL_TEXT_COLOR" "--text-sp"

# Print and execute command
echo "Running: ${CMD[*]}"
exec "${CMD[@]}"