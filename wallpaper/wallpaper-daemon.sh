#!/bin/bash

# Wallpaper Switcher Script
# Handles automated wallpaper switching based on a JSON config file

# Check if config file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <config_file.json>"
    exit 1
fi

CONFIG_FILE="$1"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file '$CONFIG_FILE' not found."
    exit 1
fi

USER=$(getent passwd 1000 | sed 's/:/ /' | awk '{print $1}')

# Read config file
WALLPAPER_DIR=$(jq -r '.wallpaper_directory' "$CONFIG_FILE" | sed "s/~/\/home\/$USER/")
SWITCH_FREQUENCY=$(jq -r '.switch_frequency' "$CONFIG_FILE")
TRANSITION_TYPE=$(jq -r '.transition_type' "$CONFIG_FILE")
CYCLING_TYPE=$(jq -r '.cycling_type' "$CONFIG_FILE")
SYNC_TYPE=$(jq -r '.sync_type' "$CONFIG_FILE")

# Validate config
if [ -z "$WALLPAPER_DIR" ] || [ -z "$SWITCH_FREQUENCY" ] || [ -z "$TRANSITION_TYPE" ] || [ -z "$CYCLING_TYPE" ] || [ -z "$SYNC_TYPE" ]; then
    echo "Error: Invalid config file. Missing required fields."
    exit 1
fi

# Check if wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Wallpaper directory '$WALLPAPER_DIR' not found."
    exit 1
fi

# Get list of monitors
MONITORS=($(hyprctl monitors | grep -A 0 -e "Monitor " --no-group-separator | awk '{print $2}'))
NUM_MONITORS=${#MONITORS[@]}

# Get list of wallpapers
if [ "$CYCLING_TYPE" = "no cycling" ]; then
    # Use the directory as a specific file
    WALLPAPERS=("$WALLPAPER_DIR/wallpaper.png")
elif [ "$CYCLING_TYPE" = "no cycling, random" ]; then
    # Pick a random wallpaper from the directory
    WALLPAPERS=("$WALLPAPER_DIR"/*)
    RANDOM_INDEX=$((RANDOM % ${#WALLPAPERS[@]}))
    WALLPAPERS=("${WALLPAPERS[$RANDOM_INDEX]}")
else
    # Get all wallpapers in the directory
    WALLPAPERS=("$WALLPAPER_DIR"/*)
fi

# Check if there are any wallpapers
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "Error: No wallpapers found in '$WALLPAPER_DIR'."
    exit 1
fi

# Function to set wallpaper
set_wallpaper() {
    local monitor="$1"
    local wallpaper="$2"
    awww img --transition-type "$TRANSITION_TYPE" -o "$monitor" "$wallpaper"
}

# Function to handle cycling
cycle_wallpapers() {
    local index="$1"
    if [ "$CYCLING_TYPE" = "cycling" ]; then
        # Cycle through wallpapers alphabetically
        if [ "$SYNC_TYPE" = "individual" ]; then
            local next_index=$(( (index + 3) % ${#WALLPAPERS[@]} ))
        else
            local next_index=$(( (index + 1) % ${#WALLPAPERS[@]} ))
        fi
        echo "$next_index"
    elif [ "$CYCLING_TYPE" = "random" ]; then
        # Pick a random wallpaper
        local next_index=$((RANDOM % ${#WALLPAPERS[@]}))
        echo "$next_index"
    else
        # No cycling, return the same index
        echo "$index"
    fi
}

# Main loop
INDEX=0
while true; do
    if [ "$SYNC_TYPE" = "all" ]; then
        # Set the same wallpaper on all monitors
        WALLPAPER="${WALLPAPERS[$INDEX]}"
        for monitor in "${MONITORS[@]}"; do
            set_wallpaper "$monitor" "$WALLPAPER"
        done
    else
        # Set different wallpapers on each monitor
        if [ "$CYCLING_TYPE" = "cycling" ]; then
            # Cycle in steps of NUM_MONITORS
            for i in "${!MONITORS[@]}"; do
                monitor="${MONITORS[$i]}"
                wallpaper_index=$(( (INDEX + i) % ${#WALLPAPERS[@]} ))
                set_wallpaper "$monitor" "${WALLPAPERS[$wallpaper_index]}"
            done
        elif [ "$CYCLING_TYPE" = "random" ]; then
            # Pick random wallpapers for each monitor, avoiding duplicates
            used_indices=()
            for i in "${!MONITORS[@]}"; do
                monitor="${MONITORS[$i]}"
                while true; do
                    wallpaper_index=$((RANDOM % ${#WALLPAPERS[@]}))
                    if [[ ! " ${used_indices[@]} " =~ " $wallpaper_index " ]]; then
                        used_indices+=("$wallpaper_index")
                        break
                    fi
                done
                set_wallpaper "$monitor" "${WALLPAPERS[$wallpaper_index]}"
            done
        else
            # No cycling, random or specific
            for monitor in "${MONITORS[@]}"; do
                set_wallpaper "$monitor" "${WALLPAPERS[$INDEX]}"
            done
        fi
    fi

    # Update index for next iteration
    INDEX=$(cycle_wallpapers "$INDEX")

    # Wait for the specified switch frequency
    sleep "$SWITCH_FREQUENCY"
done