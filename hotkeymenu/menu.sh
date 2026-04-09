#!/bin/bash
# Power Menu Script (Submenu Support, No Back Button, Exits on Invalid Input)
# Usage: ./power_menu.sh <config_file.json>

if [ $# -eq 0 ]; then
    echo "Usage: $0 <config_file.json>"
    exit 1
fi

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
CONFIG_FILE="$SCRIPT_DIR/$1"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file $CONFIG_FILE not found"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed"
    exit 1
fi

# Named pipe for communication with the parent process
PIPE="/tmp/launcher_parent_pipe"

# Function to send a command to the parent process
send_command() {
    local cmd="$*"
    echo "$cmd" > "$PIPE"
}

# Function to display menu
display_menu() {
    local json_data="$1"
    local title="$2"
    #clear
    echo "---------------"
    echo "$title"
    echo "---------------"
    echo "$json_data" | jq -r '.items[] | "[" + .key + "] " + .description'
    echo ""
}

# Function to handle menu navigation (no back button, exits on invalid input)
navigate_menu() {
    local current_menu="$1"
    local breadcrumb="$2"

    while true; do
        local title=$(echo "$current_menu" | jq -r '.title')
        display_menu "$current_menu" "$title ($breadcrumb)"

        read -n1 -r key
        echo ""

        # Find selected item
        local selected_item=$(echo "$current_menu" | jq --arg key "$key" '.items[] | select(.key == $key)')

        if [ -z "$selected_item" ]; then
            echo "Invalid option. Exiting."
            exit 1
        fi

        # Check if it's a command or submenu
        local command=$(echo "$selected_item" | jq -r '.command // empty')
        local has_submenu=$(echo "$selected_item" | jq 'has("submenu")')

        if [ -n "$command" ]; then
            send_command $command
            sleep 0.2
            exit 0
        elif [ "$has_submenu" = "true" ]; then
            local submenu=$(echo "$selected_item" | jq -c '.submenu')
            navigate_menu "$submenu" "$breadcrumb > $(echo "$selected_item" | jq -r '.description')"
        fi
    done
}

# Start navigation with the main menu



navigate_menu "$(cat "$CONFIG_FILE")" "Main"
sleep 0.2