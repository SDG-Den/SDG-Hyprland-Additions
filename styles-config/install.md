# dependencies

this is dependent on the following other directories in this repo:
additional-menus
fzfmenu
my-dots/waybar
processdaemon
styles
touchutils
various
wallpaper

which also makes it dependent on the following programs:
alacritty (can be swapped out)
fzf
jq
awww
ffmpeg
imagemagick
cpluspalette
waybar

# to use
first, you'll have to make sure that the following files and directories do not exist:

~/.config/alacritty.toml
~/.config/theme.css
~/.config/style.conf
~/.config/starship.toml
~/.config/alacritty (Directory)
~/.config/starship (Directory)

this relies on my waybar config, but can be retrofitted onto your own if you're willing to change how the adaptive script works or manually editing your style configurations.

you will also need to source ~/.config/style.conf in your hyprland config:
`source = ~/.config/style.conf`

theme.css and style.conf are simply sourced by waybar and hyprland respectively. this does mean that waybar will not load and hyprland will show an error until you select a style.

## pickstyle.sh


run the pickstyle script from the runner menu or by running the following command:

`alacritty --class floating-terminal -e ~/SDG-Hyprland-Additions/styles-config/pickstyle.sh`

this will allow you to select a style.
selecting a style will symlink the configs for alacritty, starship, waybar and hyprland and will run the wallpaper daemon to configure the wallpapers. the hyprland config contains an entry to start up the wallpaper daemon on boot.

## adaptive.sh

run adaptive.sh either from the terminal or bind it to a key. 

adaptive.sh has two modes: random mode and specific image mode.

just running it without any arguments will make the script pick a random wallpaper from the styles/adaptive/wallpapers directory and generate a theme.

themes are generated in styles/adaptive/$HOSTNAME, and are symlinked just like with pickstyle.

running the script with an image file as the input will generate a theme from that image with that image as the background.

the more varied the color palette, the more likely it is that re-running the script gives you different results. i'd recommend running it a couple times to try and get a nice palette.

## savestyle.sh

this script simply saves your current adaptive theme as a persistent theme. 

run it to save your theme, you'll be prompted for a name. 

you could run it as a floating menu:

`alacritty --class floating-terminal -e ~/SDG-Hyprland-Additions/styles-config/savestyle.sh`


## making styles

this just comes down to making the files in the right directory structure.

the menu for pickstyle reads the description.md in each style folder, so you can put descriptions in there.

