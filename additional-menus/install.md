# dependencies

tldr or tealdeer
pacman
yay
these rely on the process daemon.
alacritty is used as a default, but these can be spawned with any tty.

# to install

source the hyprland.conf file in your main hyprland configuration or copy the contents over.
`source = ~/SDG-Hyprland-Additions/additional-menus/hyprland.conf`

ensure the scripts are executable (chmod a+X filename.sh)

# to customize

only keybinds.sh really offers any customization, and it's in plaintext.

simply edit keybinds.list however you want, and the menu will look like that.

you can alter the included keybinds in hyprland.conf. 

# to use

all of these should be run using a separate terminal process with the right class to get the right window rules, examples:

`alacritty --class floating-terminal-large -e ~/SDG-Hyprland-Additions/additional-menus/aur-install.sh`
`alacritty --class floating-terminal-large -e ~/SDG-Hyprland-Additions/additional-menus/pkg-install.sh`
`alacritty --class quickrun -e ~/SDG-Hyprland-Additions/additional-menus/quickrun.sh`
`alacritty --class floating-terminal -e ~/SDG-Hyprland-Additions/additional-menus/keybinds.sh`
`alacritty --class tldr -e ~/SDG-Hyprland-Additions/additional-menus/tldr.sh`