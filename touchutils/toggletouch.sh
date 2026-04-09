#!/bin/bash

touchstate=$(cat ~/.config/touchmode)

if [ "$touchstate" == "on" ]; then
echo "toggling from on to off"
echo "off" > ~/.config/touchmode
fi

if [ "$touchstate" == "off" ]; then
echo "toggling from off to on"
echo "on" > ~/.config/touchmode
fi