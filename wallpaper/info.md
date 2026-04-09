# dependencies
awww

# to run:

`wallpaper-daemon.sh path/to/config/here.json`

configuration:

wallpaper_directory: must be your wallpaper directory

switch_frequency: how many seconds between transitions

transition_type: uses the awww transition types

cycling_type:

has the following:

no cycling - set a single, static image for your background, treats wallpaper_directory like a file location
no cycling, random - sets a random wallpaper for each monitor once when the daemon starts
random - sets a random wallpaper
cycling - cycles through wallpapers

sync_type:

can be set to all or individual, determines whether each monitor gets a unique background or the same one.

