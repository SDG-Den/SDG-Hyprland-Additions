#!/bin/bash

if [ -f ~/.config/touchmode ]; then
    cat ~/.config/touchmode
else
    echo "off" ~/.config/touchmode
fi
