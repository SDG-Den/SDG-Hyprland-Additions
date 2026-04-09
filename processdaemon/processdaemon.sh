#!/bin/bash

# This script will run in the background and act as a parent for all commands
# launched from the menu. It will keep running until explicitly killed.

# Create a named pipe for communication
PIPE="/tmp/launcher_parent_pipe"
rm -f "$PIPE"
mkfifo "$PIPE"

echo "Launcher parent started with PID $$"

# Read commands from the pipe and execute them
while true; do
    if read cmd < "$PIPE"; then
        echo "Executing: $cmd"
        # Execute the command in the background
        eval "$cmd" &
    fi
done
