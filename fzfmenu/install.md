# dependencies

you will need the process daemon.
alacritty is used as a default.
some options in the example apps.list use scripts from other parts of the repo (additional-menus and styles). these are not required and can be safely removed from the file. 

# to install

source the hyprland.conf file in your main hyprland config or copy the contents to your config.

make sure runner.sh is executable (chmod a+X runner.sh)


the runner needs to be run within a new terminal process, so the command to call the menu is as follows:

`alacritty --class runner -e ~/SDG-Hyprland-Additions/fzfmenu/runner.sh apps`

this will call the runner menu using the "apps" list file.


# customizing

you can replace alacritty with any TTY of your choice. 

the lists are formatted pretty simply:
everything between square brackets will be shown as text in the menu, everything after it on the same line is the command the option runs.

for example:

[Terminal] kitty

will show "Terminal" as a searchable option in the menu, which when chosen will launch kitty. 


