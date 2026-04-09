#!/bin/bash

hyprctl dispatch moveactive 0% -80%
hyprctl dispatch tagwindow focused
clear
echo "which command do you want to get information on? "
read -p "cmd: " CMD 
hyprctl dispatch resizeactive 150% 1600% && hyprctl dispatch moveactive 0% -140%
hyprctl dispatch tagwindow focused
clear
tldr $CMD 