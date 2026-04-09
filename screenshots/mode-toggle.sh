#!/bin/bash


if [ -e ~/.config/screenshot-state ]; then
    state=$(cat ~/.config/screenshot-state)
    case $state in
        file)
            echo "clipboard" > ~/.config/screenshot-state
            notify-send "screenshot mode changed to: Save to Clipboard"
            echo "detected file, set to clipboard"
            ;;
        clipboard)
            echo "editor" > ~/.config/screenshot-state
            notify-send "screenshot mode changed to: Open in Editor"
            echo "detected clipboard, set to editor"
            ;;
        editor)
            echo "file" > ~/.config/screenshot-state
            notify-send "screenshot mode changed to: Save to File"
            echo "detected editor, set to file"
            ;;
    esac
else
    echo "clipboard" > ~/.config/screenshot-state
    notify-send "screenshot mode changed to: Save to Clipboard"
    echo "detected no file ,set to clipboard"
fi



