#!/bin/bash

hyprctl dispatch moveactive 0% -80%
# Named pipe for communication with the parent process
PIPE="/tmp/launcher_parent_pipe"

# Function to send a command to the parent process
send_command() {
    local cmd="$*"
    echo "$cmd" > "$PIPE"
}
read -p "run command: " CMD

send_command $CMD
