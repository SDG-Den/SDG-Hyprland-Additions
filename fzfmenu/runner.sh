#!/bin/bash
CONFIG="$1"

USER=$(getent passwd 1000 | sed 's/:/ /' | awk '{print $1}')
COMMANDS_FILE="/home/$USER/SDG-Hyprland-Additions/fzfmenu/$CONFIG.list"

cmd1=$(cat $COMMANDS_FILE | sed 's/].* .*/]/'| fzf --style full --layout reverse)
cmd2=$(cat $COMMANDS_FILE | grep -F "$cmd1" | sed 's/^\[[^]]*] *//')


# Named pipe for communication with the parent process
PIPE="/tmp/launcher_parent_pipe"
echo "$cmd2" > "$PIPE"
  