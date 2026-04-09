

# sudoborders

this is a simple daemon scripts that checks the child processes of the hyprland process (as all programs that have a window should be launched as children of this process), checks their UID, and if it is 0 (root), tag the related window process with the "elevated" tag. you can then apply custom window rules to the window when it is elevated.

the script also removes the elevated tag once no elevated processes are associated with the window. 

the daemon script is primarily a wrapper for the main sudoborders script, it ensures the right environment variables are set. This is primarily important if you need this service to run as a different user (for example root if you want to run it via a systemD service)

the main sudoborders script handles all the actual logic, it loops by itself so the recommended method of using it is by adding it to your hyprland config as an autostart item.

# touch utils

this contains the modifications i've done to get hyprland functional on my surface go. Includes gestures, rotation and a riceable virtual keyboard as well as a touch-friendly menu recommendation.

it contains 4 scripts, an example gestures file and a file with waybar modules. 

the scripts have the following functions:

keyboard.sh: toggles the state of the keyboard. state is tracked using the file ~/.config/keyboard

toggletouch.sh: toggles "touchscreen mode" on/off, state is tracked using the file ~/.config/touchmode

togglehide.sh: this is a wrapper script you can use for your custom waybar modules, it takes an on/off input as well as a command, and outputs the output of the given command if the touchmode state matches the state you provided. in the example modules, this is used to hide the keyboard button when touch mode is off. 

touchcheck.sh: simple script used by the waybar module to get the current touch state. 

# Process Daemon

rather than relying on the hyprctl dispatch exec command, i decided to write my own daemon to handle launching processes. This ensures the processes launched this way are launched under the hyprland process which prevents errors on shutdown as well as ensuring these processes are compatible with sudo borders.

this is included because it is a dependency for other scripts. 

# hotkey menu

a terminal-based menu to be used with hotkeys, simply press the key related to the item and it'll launch that command. 

also contains a wrapper script that changes over to kando if you're using touch utils and your touch mode is on. 

this was initially built to replicate the windows superuser menu (accessible with win+x), which is also what the example.json tries to emulate.

# fuzzy find runner menu

this is meant to be kind of a rofi runner replacement. it simply takes a list file and provides the user with human readable options, running the related command on selection.

hyprland window rules for placing this terminal on the top left are included. 

# additional menus

this contains a couple of menus:

quickrun.sh - a way to send commands to the process daemon directly, this can be very useful if you want to (for example) manually start a daemon or background script. it also works to open any program that launches with a GUI from the commandline (for example, you can type "firefox" to open firefox)

keybinds.sh - gives you a graphical overview of your keybinds based on the keybinds.list file.

tldr.sh - opens a small window to type a command in, which then expands to show you the TLDR or tealdeer page for that command

pkg-install.sh - gives you a TUI interface for browsing and installing pacman packages.

aur-install.sh - gives you a TUI interface for browsing and installing packages from the arch user repository using yay.

# layout

the layout scripts allow you to use hotkeys to set pre-configured static layouts on a workspace. this sets all the windows on that workspace to floating and moves/sizes them to the preset layout. 

this supports any amount of windows (configurations are provided for 2 to 6 windows) as well as any monitor size (Though the provided configs are designed for 16:9).

# screenshots

this includes a set of scripts that together, give you a way to toggle between screenshotting to clipboard, file or editor, with scripts provided for region select, active window, active workspace and a screen capture for all monitors that gets stitched together. 

# my waybar config

my waybar config is included, because it's required for styles to work properly (you can retrofit it for any waybar config, but you'll need to know how to use waybar)

it comes with a swaync-output.sh daemon, which is used so that the notification button can be entirely hidden using togglehide.sh from the touchutils script. 

# wallpaper

this contains a simple daemon script that you can call with a json config file to easily set the way your wallpaper should cycle.

this is then used by the styles system to allow different styles to come with different wallpaper cycling methods.

supports static, static random on boot, random timed and cycling timed both for the same image on all monitors and for all monitors individually.

# styles-config

this contains the scripts i use for style switching and adaptive theming.

its companion pre-included styles are included in the styles directory.

it contains a menu to set the style, including an adaptive style. 

it also contains a script for changing the adaptive style (both random wallpapers as well as a specific wallpaper of your choice)

and it contains a script for easily saving an adaptive style to a persistent style, allowing you to edit it and use it whenever you want.

