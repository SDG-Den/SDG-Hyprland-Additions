# to install
copy the config, modules.json and style.css files to your ~/.config/waybar folder

either source the hyprland.conf file in your main hyprland.conf or copy and paste the contents.
source = ~/SDG-Hyprland-Additions/my-dots/waybar/hyprland.conf

# dependencies
this is tied into a chunk of my scripts, primarily the touchutils, fzfmenu and additional-menus folders.
it also makes use of some of the scripts from various. 

make sure your touchmode and keyboardmode are both set, otherwise, some components of the top bar will fail to run.

make sure all scripts in the various, fzfmenu, touchutils and additional-menus folders are executable (chmod a+x filename.sh)

also manually run toggletouch.sh and keyboard.sh once.

this includes the waybar config from touchutils.

