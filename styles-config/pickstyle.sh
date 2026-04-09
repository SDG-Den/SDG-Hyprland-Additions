#!/bin/bash

USER=$(getent passwd 1000 | sed 's/:/ /' | awk '{print $1}')

styles=$(find /home/$USER/SDG-Hyprland-Additions/styles/* -maxdepth 0 -type d -printf "%f\n" | grep -v '^\.$')

selected=$(echo "$styles" | fzf --layout reverse --preview="clear && bat /home/$USER/SDG-Hyprland-Additions/styles/{}/description.md")

if [ "$selected" = "" ]; then
    exit 1
fi

if [ "$selected" = "adaptive" ]; then
    selected="$selected/$HOSTNAME"
fi

echo "user selected $selected as theme"
remove-symlink() {

    if [ -L "$1" ]; then
        echo "removing symlink path $1"
        rm -f "$1"
    else
        echo "$1 is not a symlink or does not exist"
    fi
}
PIPE="/tmp/launcher_parent_pipe"
send_command() {
    local cmd="$*"
    echo "$cmd" > "$PIPE"
}

# alacritty
remove-symlink "/home/$USER/.config/alacritty.toml"
ln -sf /home/$USER/SDG-Hyprland-Additions/styles/$selected/alacritty/alacritty.toml /home/$USER/.config


#waybar
remove-symlink "/home/$USER/.config/theme.css"
ln -sf /home/$USER/SDG-Hyprland-Additions/styles/$selected/waybar/theme.css /home/$USER/.config


#starship
remove-symlink "/home/$USER/.config/starship.toml"
ln -sf /home/$USER/SDG-Hyprland-Additions/styles/$selected/starship/starship.toml /home/$USER/.config


#hyprland
remove-symlink "/home/$USER/.config/style.conf"
ln -sf /home/$USER/SDG-Hyprland-Additions/styles/$selected/hyprland/style.conf /home/$USER/.config

killall -9 waybar
sleep 1
send_command waybar

killall -9 wallpaper-daemon.sh
sleep 1
send_command "~/SDG-Hyprland-Additions/wallpaper/wallpaper-daemon.sh ~/SDG-Hyprland-Additions/styles/$selected/wallpaper-config/wallpaper.json"

hyprctl reload
echo "theme applied"
