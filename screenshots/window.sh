#!/bin/bash

if [ -e ~/.config/screenshot-state ]; then
    state=$(cat ~/.config/screenshot-state)
    case $state in
        file)
            mkdir -p ~/Screenshots
            hyprshot -m window -m active --output-folder ~/Screenshots
            ;;
        clipboard)
            hyprshot -m window -m active --clipboard-only
            ;;
        editor)
            hyprshot -m window -m active --raw | satty --filename -
            ;;
    esac
else
    echo "clipboard" > ~/.config/screenshot-state
    notify-send 'No mode detected, set mode to "Save to Clipboard". re-run your screenshot'
fi