# dependencies
jq

# to use

run `setlayout.sh <preset-number>` to switch the current active workspace to that static layout.

the script automatically uses the config file for the amount of windows on the active workspace. each config contains numbered layouts.

for each window, it contains 4 values:
{ "x": 2, "y": 5, "width": 47, "height": 94 }

these are all in percentages.

the monitor's top left corner is 0% 0%, so the above makes the window's top left corner be 2% from the left edge and 5% from the top edge.
this also makes the window 47% of the monitor's width wide, and 94% of the monitor's height tall. 

to configure your own layouts, you'll have to do some head math in order to also have gaps. 

the script supports an arbitrary amount of windows, so you can make config files for window amounts higher than 6. tested up to 8, but i don't think there's a theoretical limit.

hyprland.conf contains example binds (mainmod + alt + number for presets 1 through 9, auto-detecting which config file to use. mainmod + alt + 0 to reset back to adaptive)

running resetlayout is what resets the layout to adaptive, you can also run it manually.