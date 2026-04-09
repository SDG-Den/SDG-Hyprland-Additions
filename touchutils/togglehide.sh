#!/bin/bash

togglestate=$1
command=$2
if [ -f ~/.config/touchmode ]; then
    touchstate=$(cat ~/.config/touchmode)
    if [ "$touchstate" == "$togglestate" ]; then
    eval $command
    else
    echo ""
    fi
else
    echo "off" ~/.config/touchmode
fi
