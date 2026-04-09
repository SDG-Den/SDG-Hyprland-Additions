# dependencies
jq
alacritty (can be replaced with another terminal, this is what shows the menu.)
processdaemon from my aditions

# to install



ensure the scripts are executable using chmod (chmod a+x filename.sh)

either include the hyprland.conf in your hyprland config or copy the contents to your hyprland config:
`source = ~/SDG-Hyprland-Additions/hotkeymenu/hyprland.conf`

to run the menu as an actual floating menu, run the following:

`alacritty --class floating-term-slim -e ~/SDG-Hyprland-Additions/hotkeymenu/menu.sh example.json`

this pops up a focused floating menu that will take your input and launch the related command 

by default, the example.json menu is launched when pressing mainmod + x, simply set up an exec bind for the command.


# to customize/configure

if you prefer a different terminal, simply change every call for alacritty in the script to your terminal of choice (eg kitty, ghostty, etc)

make sure to use a tty that starts pretty quickly (either one that is just fast, or one with a dispatcher daemon like ghostty)
as a slow tty will make you menu's slower to launch. 

the menu is defined as a simple json file that looks like this:

{
    "title": "yourtitlegoeshere",
    "items": [
        {
            "key": "a",
            "description": "Displayed Text Here",
            "command": "run command here"
        },
        {
            "key": "b",
            "description": "Displayed Text Here",
            "command": "alacritty -e tuicommand"
        },
        {
            "key": "c",
            "description": "Submenu Displayed Text",
            "submenu": {
                "title": "Submenu Title Here,
                "items": [
                    {
                        "key": "d",
                        "description": "Displayed text Here",
                        "command": "run command here"
                    }
                ]
            }
        }
    ]
}


there is support for submenu's, these can also be nested.
the menu will always display the keys before each of the descriptions.
this menu actually uses a single character input, so the key can be any character. this also allows for modifiers as capital letters register separately.

# launchwrap

the launchwrap.sh script is there for if you make use of the touch utilities provided in this repo. this allows your menu hotkeys to dynamically switch between a kando menu and a hotkey menu of the same name. 

simply call it like this:
`alacritty --class floating-term-slim -e ~/SDG-Hyprland-Additions/hotkeymenu/launchwrap.sh example.json`

this will launch the kando menu with name/id "example" if your touchmode is on, or the menu.sh menu with the example.json config file if touchmode is off.

