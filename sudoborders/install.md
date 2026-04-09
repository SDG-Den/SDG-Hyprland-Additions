# to install:

## option #1: 
assuming you have the repository cloned directly to your /home/USERNAME folder:
add the following line to your core hyprland.conf:

`source = ~/SDG-Hyprland-Additions/sudoborders/hyprland.conf`

## option #2: 
copy and paste the lines from the included hyprland.conf into your hyprland configuration at the appropriate locations

## option #3: 
you can install the daemon as a systemd service using the following configuration:

```
[Unit]
Description=Tag elevated windows in Hyprland
After=graphical-session.target

[Service]
Type=simple
ExecStart=/home/USERNAME/SDG-Hyprland-Additions/sudoborders/sudoborders-daemon.sh
Restart=always
RestartSec=5


[Install]
WantedBy=default.target
```


## modifying the script

in order to change the location of various components you'll need to make sure to edit the following parts:

hyprland conf: edit the exec-once to point to your sudoborders-daemon

sudoborders-daemon: edit line 16 to point to your sudoborders script

if used, systemd service: edit the ExecStart location to your sudoborders-daemon

in order to change the way elevated windows look, simply apply windowrules with the match attribute "match:tag elevated".

check this site to know what you can do with window rules: https://wiki.hypr.land/Configuring/Window-Rules/



