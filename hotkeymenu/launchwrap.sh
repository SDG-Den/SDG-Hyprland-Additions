#!/bin/bash

#use kando menu if touch mode is on:
touchstate=$(cat ~/.config/touchmode)
if [ "$touchstate" == "on" ]; then
kandomenu=$(echo $1 | sed 's/.json//' | awk '{print $1}' )
kando --menu $kandomenu
exit 0
else
alacritty --class floating-term-slim -e ~/SDG-Hyprland-Additions/hotkeymenu/menu.sh $1
fi
