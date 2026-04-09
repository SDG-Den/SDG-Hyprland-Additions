#!/bin/bash

# Function to remove symlinks
remove-symlink() {
    if [ -L "$1" ]; then
        echo "Removing symlink path $1"
        rm -f "$1"
    else
        echo "$1 is not a symlink or does not exist"
    fi
}




is_image_dark_or_bright() {
    local image_path=$1
    # Use ImageMagick to calculate average luminance
    # The formula for luminance is: 0.2126*R + 0.7152*G + 0.0722*B
    # We use `convert` to compute the average luminance and compare it to a threshold (0.5)
    local avg_luminance=$(magick $image_path -colorspace LAB -channel r -separate +channel -format "%[fx:100*u.mean]\n" info:)
    echo "avg luminance is $avg_luminance" > /dev/tty
    local luminance=$(echo $avg_luminance | sed 's/\./ /' | awk '{print $1}')
    echo  "luminance is $luminance" > /dev/tty
    # Classify as dark or bright based on the threshold
    if [ $luminance -gt 40 ]; then
        echo "bright"
        echo "setting bright mode" > /dev/tty
    else
        echo "dark"
        echo "setting dark mode" > /dev/tty
    fi
}

# Set the base directory
BASE_DIR="$HOME/SDG-Hyprland-Additions/styles/adaptive/$HOSTNAME"
WALLPAPER_DIR="$HOME/SDG-Hyprland-Additions/styles/adaptive/wallpapers"
echo "base dir is $BASE_DIR"
killall cpluspalette

mkdir -p $BASE_DIR/alacritty
mkdir -p $BASE_DIR/waybar
mkdir -p $BASE_DIR/hyprland
mkdir -p $BASE_DIR/starship
mkdir -p $BASE_DIR/wallpaper-config

# Check if an image path is provided
if [ $# -eq 0 ]; then
    # No input provided, select a random image from the wallpapers directory
    if [ -d "$WALLPAPER_DIR" ]; then
        WALLPAPER=$(ls "$WALLPAPER_DIR" | grep -v ' ' | grep -E '.*\.(jpg|jpeg|png|webp)$' | shuf -n 1)
        if [ -z "$WALLPAPER" ]; then
            echo "No valid image files found in $WALLPAPER_DIR"
            exit 1
        fi
        WALLPAPER_PATH="$WALLPAPER_DIR/$WALLPAPER"
    else
        echo "Wallpaper directory $WALLPAPER_DIR does not exist"
        exit 1
    fi
else
    # Use the provided image path
    WALLPAPER_PATH="$1"
fi
mkdir -p ${BASE_DIR}/wallpaper-config
rm ${BASE_DIR}/wallpaper-config/wallpaper.png
echo "$WALLPAPER_PATH"
cp $WALLPAPER_PATH ${BASE_DIR}/wallpaper-config/wallpaper.png

# Extract colors using cpluspalette
COLORS=$(cpluspalette "$WALLPAPER_PATH" 16 -k)

# Parse the colors into an array
readarray -t COLOR_ARRAY <<< "$COLORS"

# check if image is dark or bright
image_type=$(is_image_dark_or_bright $WALLPAPER_PATH)
echo "image type is $image_type" 
if [ "$image_type" = "bright" ]; then

# Extract the 8 hex color codes (sorted from darkest to lightest)
COLOR7=$(echo "${COLOR_ARRAY[15]}" | awk '{print $1}')
COLOR6=$(echo "${COLOR_ARRAY[13]}" | awk '{print $1}')
COLOR5=$(echo "${COLOR_ARRAY[11]}" | awk '{print $1}')
COLOR4=$(echo "${COLOR_ARRAY[9]}" | awk '{print $1}')
COLOR3=$(echo "${COLOR_ARRAY[7]}" | awk '{print $1}')
COLOR2=$(echo "${COLOR_ARRAY[5]}" | awk '{print $1}')
COLOR1=$(echo "${COLOR_ARRAY[3]}" | awk '{print $1}')
COLOR0=$(echo "${COLOR_ARRAY[2]}" | awk '{print $1}')
else

# Extract the 8 hex color codes (sorted from lightest to darkest)
COLOR7=$(echo "${COLOR_ARRAY[1]}" | awk '{print $1}')
COLOR6=$(echo "${COLOR_ARRAY[3]}" | awk '{print $1}')
COLOR5=$(echo "${COLOR_ARRAY[5]}" | awk '{print $1}')
COLOR4=$(echo "${COLOR_ARRAY[7]}" | awk '{print $1}')
COLOR3=$(echo "${COLOR_ARRAY[9]}" | awk '{print $1}')
COLOR2=$(echo "${COLOR_ARRAY[11]}" | awk '{print $1}')
COLOR1=$(echo "${COLOR_ARRAY[13]}" | awk '{print $1}')
COLOR0=$(echo "${COLOR_ARRAY[15]}" | awk '{print $1}')
fi

# Remove the # symbol for nohash variants
COLOR0_NOHASH=${COLOR0#\#}
COLOR1_NOHASH=${COLOR1#\#}
COLOR2_NOHASH=${COLOR2#\#}
COLOR3_NOHASH=${COLOR3#\#}
COLOR4_NOHASH=${COLOR4#\#}
COLOR5_NOHASH=${COLOR5#\#}
COLOR6_NOHASH=${COLOR6#\#}
COLOR7_NOHASH=${COLOR7#\#}

# Create the alacritty.toml file
ALACRITTY_FILE="$BASE_DIR/alacritty/alacritty.toml"
mkdir -p "$(dirname "$ALACRITTY_FILE")"
cat > "$ALACRITTY_FILE" <<EOL
[window]
decorations = "None"
opacity = 0.65
blur = false
[font.normal]
family = "monospace"
style = "Regular"

[colors]
primary.foreground = "$COLOR7"
primary.background = "$COLOR0"
[colors.normal]
# Default: "#181818"
black = "#181818"
# Default: "#ac4242"
red = "#ac4242"
# Default: "#90a959"
green = "#90a959"
# Default: "#f4bf75"
yellow = "#f4bf75"
# Default: "#6a9fb5"
blue = "#6a9fb5"
# Default: "#aa759f"
magenta = "#aa759f"
# Default: "#75b5aa"
cyan = "#75b5aa"
# Default: "#d8d8d8"
white = "#d8d8d8"
[colors.bright]
# Default: "#6b6b6b"
black = "#6b6b6b"
# Default: "#c55555"
red = "#c55555"
# Default: "#aac474"
green = "#aac474"
# Default: "#feca88"
yellow = "#feca88"
# Default: "#82b8c8"
blue = "#82b8c8"
# Default: "#c28cb8"
magenta = "#c28cb8"
# Default: "#93d3c3"
cyan = "#93d3c3"
# Default: "#f8f8f8"
white = "#f8f8f8"
EOL

# Create the waybar/style.css file
WAYBAR_FILE="$BASE_DIR/waybar/theme.css"
mkdir -p "$(dirname "$WAYBAR_FILE")"
cat > "$WAYBAR_FILE" <<EOL
@define-color black      #000000;
@define-color text       $COLOR7;
@define-color transparent rgba(0, 0, 0, 0);
@define-color transparent2 $COLOR0;
@define-color accent        $COLOR4;
@define-color highlight          $COLOR6; 
@define-color highlighttrans     $COLOR5; 
@define-color background-module     @transparent2;
@define-color background-module-2     @transparent2;
@define-color alert        @color3;
@define-color warning      @color2;
EOL

# Create the starship/starship.toml file
STARSHIP_FILE="$BASE_DIR/starship/starship.toml"
mkdir -p "$(dirname "$STARSHIP_FILE")"
cat > "$STARSHIP_FILE" <<EOL
"\$schema" = 'https://starship.rs/config-schema.json'
format = """
\$os\\
\$username\\
[](bg:color_custom_blue fg:color_custom_purple)\\
\$directory\\
[](fg:color_custom_blue bg:color_custom_teal)\\
\$git_branch\\
\$git_status\\
\$git_state\\
\$git_metrics\\
[](fg:color_custom_teal bg:color_custom_green)\\
\$c\\
\$cpp\\
\$rust\\
\$golang\\
\$nodejs\\
\$python\\
\$package\\
[](fg:color_custom_green bg:color_custom_pink)\\
\$kubernetes\\
\$docker_context\\
\$conda\\
[](fg:color_custom_pink)\\
\$character"""
add_newline = false
right_format = ""
scan_timeout = 35
command_timeout = 700
palette = 'custom'
[palettes.custom]
color_fg0 = '$COLOR7'
color_fg1 = '$COLOR6'
color_bg0 = '$COLOR0'
color_bg1 = '$COLOR0'
color_bg2 = '$COLOR0'
color_bg3 = '$COLOR0'
color_bg4 = '$COLOR0'
color_custom_blue = '$COLOR1'
color_custom_purple = '$COLOR2'
color_custom_teal = '$COLOR3'
color_custom_green = '$COLOR4'
color_custom_magenta = '$COLOR5'
color_custom_pink = '$COLOR6'
color_custom_ice = '$COLOR7'
color_fg_dark = '$COLOR0'
[username]
show_always = true
style_user = "bg:color_custom_purple fg:color_fg0"
style_root = "bg:color_custom_purple fg:color_fg0"
format = '[ \$user ](\$style)'
[directory]
style = "fg:color_fg0 bg:color_custom_blue"
format = "[ \$path ](\$style)"
truncation_length = 3
truncation_symbol = " "
truncate_to_repo = true
read_only = " "
read_only_style = "fg:color_fg_dark bg:color_custom_blue"
[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Music" = "󰝚 "
"Pictures" = " "
"Developer" = "󰲋 "
"Code" = "󰲋 "
[git_branch]
symbol = ""
style = "bg:color_aqua"
format = '[[ \$symbol \$branch ](fg:color_fg0 bg:color_custom_teal)](\$style)'
truncation_length = 24
[git_status]
style = "bg:color_custom_teal"
format = '[[(\$all_status\$ahead_behind )](fg:color_fg0 bg:color_custom_teal)](\$style)'
[git_state]
style = "bg:color_custom_teal"
format = '[[ \$state( \$progress_current/\$progress_total) ](fg:color_fg0 bg:color_custom_teal)](\$style)'
[git_metrics]
disabled = false
added_style = "fg:color_bright_yellow bg:color_custom_teal"
deleted_style = "fg:color_bright_orange bg:color_custom_teal"
format = '[[+\$added](\$added_style)/[-\$deleted](\$deleted_style) ](fg:color_fg0 bg:color_custom_teal)'
[nodejs]
symbol = ""
style = "bg:color_custom_green"
format = '[[ \$symbol ](fg:color_fg0 bg:color_custom_green)](\$style)'
[c]
symbol = " "
style = "bg:color_custom_green"
format = '[[ \$symbol ](fg:color_fg0 bg:color_custom_green)](\$style)'
[cpp]
symbol = " "
style = "bg:color_custom_green"
format = '[[ \$symbol ](fg:color_fg0 bg:color_custom_green)](\$style)'
[rust]
symbol = ""
style = "bg:color_custom_green"
format = '[[ \$symbol ](fg:color_fg0 bg:color_custom_green)](\$style)'
[golang]
symbol = "󰟓"
style = "bg:color_custom_green"
format = '[[ \$symbol ](fg:color_fg0 bg:color_custom_green)](\$style)'
[python]
symbol = ""
style = "bg:color_custom_green"
format = '[[ \$symbol ](fg:color_fg0 bg:color_custom_green)](\$style)'
[package]
disabled = false
symbol = "󰏗"
style = "bg:color_custom_green"
format = '[[ \$symbol \$version ](fg:color_fg0 bg:color_custom_green)](\$style)'
[docker_context]
symbol = ""
style = "bg:color_custom_ice"
format = '[[ \$symbol( \$context) ](fg:#83a598 bg:color_custom_ice)](\$style)'
[conda]
symbol = "󱔎"
style = "bg:color_custom_ice"
format = '[[ \$symbol( \$environment) ](fg:color_fg0 bg:color_custom_ice)](\$style)'
[kubernetes]
disabled = false
style = "bg:color_custom_ice"
format = '[[ 󱃾 \$context( \\(\$namespace\\)) ](fg:color_fg0 bg:color_custom_ice)](\$style)'
detect_files = ["kustomization.yaml", "Chart.yaml", "helmfile.yaml"]
[line_break]
disabled = true
[character]
disabled = false
success_symbol = '[ ❯](bold fg:color_custom_blue)'
error_symbol = '[ ❯](bold fg:color_custom_pink)'
vimcmd_symbol = '[ ❯](bold fg:color_custom_blue)'
vimcmd_replace_one_symbol = '[ ❯](bold fg:color_custom_blue)'
vimcmd_replace_symbol = '[ ❯](bold fg:color_custom_blue)'
vimcmd_visual_symbol = '[ ❯](bold fg:color_custom_blue)'
[cmd_duration]
min_time = 2000
style = "bg:color_bg3"
format = '[[  \$duration ](fg:color_fg0 bg:color_aqua)](\$style)'
[jobs]
threshold = 1
symbol = ""
style = "bg:color_bg1"
format = '[[ \$symbol \$number ](fg:color_fg0 bg:color_yellow)](\$style)'
EOL

if [ "$image_type" = "bright" ]; then
default_inactive="rgba(${COLOR6_NOHASH}FF)"
default_active="rgba(${COLOR2_NOHASH}FF) rgba(${COLOR0_NOHASH}FF)"
elevated_inactive="rgba(${COLOR6_NOHASH}FF)"
menu_inactive="rgba(${COLOR2_NOHASH}FF)"
menu_active="rgba(${COLOR3_NOHASH}FF) rgba(${COLOR2_NOHASH}FF)"
floating_inactive="rgba(${COLOR5_NOHASH}FF)"
floating_active="rgba(${COLOR5_NOHASH}FF) rgba(${COLOR3_NOHASH}FF)"
else
default_inactive="rgba(${COLOR1_NOHASH}FF)"
default_active="rgba(${COLOR7_NOHASH}FF) rgba(${COLOR6_NOHASH}FF)"
elevated_inactive="rgba(${COLOR1_NOHASH}FF)"
menu_inactive="rgba(${COLOR4_NOHASH}FF)"
menu_active="rgba(${COLOR5_NOHASH}FF) rgba(${COLOR4_NOHASH}FF)"
floating_inactive="rgba(${COLOR2_NOHASH}FF)"
floating_active="rgba(${COLOR2_NOHASH}FF) rgba(${COLOR3_NOHASH}FF)"
fi

# Create the hyprland/colors.conf file
HYPRLAND_FILE="$BASE_DIR/hyprland/colors.conf"
mkdir -p "$(dirname "$HYPRLAND_FILE")"
cat > "$HYPRLAND_FILE" <<EOL
general {

    # configures the gaps between windows 
    gaps_in = 3
    # configures the gaps between windows and the outer edge of the screen
    gaps_out = 6
    # changes the border thiccness
    border_size = 3

    # set default border colors
    col.active_border = $default_active 100deg
    col.inactive_border = $default_inactive
}

# floating borders
#inactive
windowrule = border_color $floating_inactive $floating_inactive, match:float 1
#active
windowrule = border_color $floating_active 90deg, match:float 1

# pinned borders
#inactive
windowrule = border_color $floating_inactive $floating_inactive, match:pin 1
#active
windowrule = border_color $floating_active 90deg, match:pin 1

# proxmox borders
#inactive
windowrule = border_color $floating_inactive $floating_inactive, match:initial_title ^Proxmox VE$
#active
windowrule = border_color $floating_active 90deg, match:initial_title ^Proxmox VE$

# menu borders
#inactive
windowrule = border_color $menu_inactive $menu_inactive, match:class floating-term-slim
#active
windowrule = border_color $menu_active 80deg, match:class floating-term-slim

# runner borders
#inactive
windowrule = border_color $menu_inactive $menu_inactive, match:class runner
#active
windowrule = border_color $menu_active 80deg, match:class runner

# quickrun borders
#inactive
windowrule = border_color $menu_inactive $menu_inactive, match:class quickrun
#active
windowrule = border_color $menu_active 80deg, match:class quickrun

# focused tag borders
#inactive
windowrule = border_color $menu_inactive $menu_inactive, match:tag focused
#active
windowrule = border_color $menu_active 80deg, match:tag focused

# sudo borders
#inactive
windowrule = border_color $elevated_inactive $elevated_inactive, match:tag elevated
#active
windowrule = border_color rgba(e64553FF) rgba(e78284CC) 100deg, match:tag elevated

# modals
#inactive
windowrule = border_color $elevated_inactive $elevated_inactive, match:modal 1
#active
windowrule = border_color rgba(e64553FF) rgba(e78284CC) 100deg, match:modal 1

EOL

# Overwrite existing theming symlinks
selected="adaptive"

# alacritty
remove-symlink "/home/$USER/.config/alacritty.toml"
ln -sf "$BASE_DIR/alacritty/alacritty.toml" "/home/$USER/.config/alacritty.toml"

# waybar
remove-symlink "/home/$USER/.config/theme.css"
ln -sf "$BASE_DIR/waybar/theme.css" "/home/$USER/.config/theme.css"

# starship
remove-symlink "/home/$USER/.config/starship.toml"
ln -sf "$BASE_DIR/starship/starship.toml" "/home/$USER/.config/starship.toml"

# hyprland
remove-symlink "/home/$USER/.config/style.conf"
ln -sf "$BASE_DIR/hyprland/style.conf" "/home/$USER/.config/style.conf"

# Set the wallpaper and restart waybar
PIPE="/tmp/launcher_parent_pipe"
send_command() {
    local cmd="$*"
    echo "$cmd" > "$PIPE"
}
killall -9 wallpaper-daemon.sh
send_command "~/SDG-Hyprland-Additions/wallpaper/wallpaper-daemon.sh ~/SDG-Hyprland-Additions/styles/$selected/$HOSTNAME/wallpaper-config/wallpaper.json"
killall -9 waybar
send_command waybar
sleep 1
hyprctl reload
# Print success message
echo "Adaptive theme applied successfully!"
