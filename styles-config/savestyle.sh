#!/bin/bash

# Hyprland Adaptive Theme Exporter
# Usage: Save this script, make it executable (chmod +x), and run it.

# Function to get theme name with validation
get_theme_name() {
    local base_path="$HOME/SDG-Hyprland-Additions/styles"
    local theme_name

    while true; do
        read -p "Enter a name for your new theme: " theme_name
        theme_name=$(echo "$theme_name" | tr -d ' ' | tr -d '/')  # Sanitize input

        if [ -z "$theme_name" ]; then
            echo "Error: Theme name cannot be empty."
            continue
        fi

        if [ -d "$base_path/$theme_name" ]; then
            echo "Error: Theme '$theme_name' already exists. Choose a different name."
        else
            echo "$theme_name"
            return
        fi
    done
}

# Main script
echo "Hyprland Adaptive Theme Exporter"
echo "---------------------------------"

# Get hostname
HOSTNAME=$(hostname)
echo "Detected hostname: $HOSTNAME"

# Get theme name
THEME_NAME=$(get_theme_name)

# Define paths
SOURCE_PATH="$HOME/SDG-Hyprland-Additions/styles/adaptive/$HOSTNAME"
TARGET_PATH="$HOME/SDG-Hyprland-Additions/styles"
THEME_PATH="$HOME/SDG-Hyprland-Additions/styles/$THEME_NAME"

# Copy theme
echo "Copying theme from $SOURCE_PATH to $TARGET_PATH..."
if [ ! -d "$SOURCE_PATH" ]; then
    echo "Error: Adaptive theme source not found at $SOURCE_PATH"
    exit 1
fi

if cp -r "$SOURCE_PATH" "$TARGET_PATH"; then
    echo "Successfully copied theme to $TARGET_PATH"
    mv "$TARGET_PATH/$HOSTNAME" "$THEME_PATH"
else
    echo "Error: Failed to copy theme"
    exit 1
fi

# Update wallpaper.json
WALLPAPER_FILE="$THEME_PATH/wallpaper-config/wallpaper.json"
if [ -f "$WALLPAPER_FILE" ]; then
    echo "Updating wallpaper.json..."
    sed -i "s|/adaptive/$HOSTNAME|/$THEME_NAME|g" "$WALLPAPER_FILE"
    echo "Successfully updated wallpaper.json"
else
    echo "Warning: Wallpaper config not found at $WALLPAPER_FILE"
fi

# Update style.conf
STYLE_FILE="$THEME_PATH/hyprland/style.conf"
if [ -f "$STYLE_FILE" ]; then
    echo "Updating style.conf..."
    sed -i "s|/adaptive/$HOSTNAME|/$THEME_NAME|g" "$STYLE_FILE"
    echo "Successfully updated style.conf"
else
    echo "Warning: Style config not found at $STYLE_FILE"
fi

echo ""
echo "Theme '$THEME_NAME' successfully exported!"