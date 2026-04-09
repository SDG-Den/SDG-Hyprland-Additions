# prerequisites

>wvkbd (yay -S wvkbd) - keyboard
>kando (yay -S kando) - menu
>hyprgrass (hyprpm install hyprgrass && hyprpm enable hyprgrass) - gesture handling
>iio-hyprland (yay -S iio-hyprland) - automatic rotation
>pavucontrol (yay -S pavucontrol) - needed to get volume control to work
>jq (yay -S jq) - needed for keyboard.sh to parse the config.

used as part of the gestures configuration, but can be replaced entirely:
alacritty (terminal)
btop (system monitor)
hyprshot (screenshots)
firefox (browser)
nautilus (file manager)

these can be easily replaced in the gestures.conf file with whichever programs you like 

# to install

## step 1: 
source the gestures.conf file in your main hyprland config with the following line:
`source = ~/SDG-Hyprland-Additions/touchutils/gestures.conf`

do the same with hyprland.conf, or copy the exec-once files into your hyprland config at a suitable location

## step 2: 
copy and paste the waybar modules into your modules.json file or add it to the includes section of your config file.

include example:
    "include": [
        "~/SDG-Hyprland-Additions/touchutils/waybarmodule.json",
        "~/.config/waybar/modules.json"
    ],  

include the following items in your style.css:
custom-touchscreen
custom-keyboard

add custom/touchscreen and custom/keyboard to your waybar config.

## step 3:
reboot your system and troubleshoot any waybar issues you may have (the config for waybar can be pretty finicky, if you're unsure why it's not loading, try starting waybar manually from the terminal, it'll tell you where the syntax error is.)

## step 4:
for the menu's, i just went with kando since it's easy, looks nice and is touch-friendly. 

open kando from the tray and configure your menus as you'd like, make sure you remember the names of your menus, then replace the menu calls in gestures.conf with those menu's.

for testing, i'd recommend making a temporary keybind to open the kando menu you're working on, you can do that as follows:
bind = SUPER, K, exec, kando --menu MyMenuName

this will bind it to super+k.

## step 4: 
to configure the keyboard, you can edit keyboard.json, all color values are in RRGGBBAA hex notation and support transparency.
to test it, run keyboard.sh manually from a terminal. ctrl+c to quit the process.



