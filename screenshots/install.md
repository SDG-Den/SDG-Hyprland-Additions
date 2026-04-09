# dependencies
hyprshot
grim
ffmpeg
libnotify
satty (to open in editor)
a notification daemon of your choice (i use swayNC)

# to install
make sure the scripts are all executable

include the hyprland.conf file or copy the contents to your hyprland.conf
source = ~/SDG-Hyprland-Additions/screenshots/hyprland.conf

running fullscreen, region or window scripts will perform that respective screenshot type. 

running mode-toggle will toggle between saving to clipboard, saving to file (saves to ~/Screenshots) and opening in editor

if no mode is selected, the screenshot scripts wont work. 

with the included binds, pressing the printscreen button will cycle modes.
mainMod + printscreen will allow you to select a region
mainMod + shift + printscreen will screenshot the focused window
mainMod + ctrl + printscreen will screenshot the active workspace
ctrl + shift + printscreen will screenshot all 3 windows using grim and stitch them together using ffmpeg. 


