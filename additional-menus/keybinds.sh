#!/bin/bash

USER=$(getent passwd 1000 | sed 's/:/ /' | awk '{print $1}')
COMMANDS_FILE="/home/$USER/SDG-Hyprland-Additions/additional-menus/keybinds.list"

cat $COMMANDS_FILE | fzf --style full --layout reverse