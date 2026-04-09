#!/bin/bash

# Create a temporary directory for screenshots
timestamp=$(date +%s)
TEMP_DIR="/tmp/screenshot-$timestamp"
mkdir $TEMP_DIR
echo "Saving screenshots to: $TEMP_DIR"

# Capture screenshots of all monitors
hyprctl monitors | grep -A 1 -e "Monitor " | while read -r line; do
    if [[ $line == Monitor* ]]; then
        # Extract monitor name
        monitor_name=$(echo "$line" | awk '{print $2}')
        echo "Capturing $monitor_name..."
        grim -o "$monitor_name" "$TEMP_DIR/$monitor_name.png"
    fi
done
notify-send "Screenshots complete, please wait for stitch..."
# Initialize variables for bounds
tl_x=0
tl_y=0
br_x=0
br_y=0

while read -r monitor; do
    # Extract resolution
    echo "monitor is $monitor"
    line=$(hyprctl monitors | grep -A 1 -e "$monitor" | grep -v "Monitor" | awk '{print $1 " " $2 " " $3}')
    monitor_name=$(echo $monitor | awk '{print $2}')
    echo "monitor name is $monitor_name"
    echo "line is $line"
    transform=$(hyprctl monitors | grep -A 15 "Monitor $monitor_name" | grep "transform:" | awk '{print $2}')
    echo "transform is $transform"
    resolution=$(echo "$line" | sed 's/@.*//' | awk '{print $1}')
    if [ "$transform" -eq 1 ]; then
    height=$(echo "$resolution" | cut -d'x' -f1)
    width=$(echo "$resolution" | cut -d'x' -f2)
    echo "width is $width, height is $height"
    else
    width=$(echo "$resolution" | cut -d'x' -f1)
    height=$(echo "$resolution" | cut -d'x' -f2)
    echo "width is $width, height is $height"
    fi
    # Extract offset
    offset=$(echo "$line" | awk '{print $3}')
    offset_x=$(echo "$offset" | cut -d'x' -f1)
    offset_y=$(echo "$offset" | cut -d'x' -f2)
    echo "offset is $offset, offset x is $offset_x, offset y is $offset_y"

    corner_x=$(( $offset_x + $width ))
    corner_y=$(( $offset_y + $height ))
    echo "corners are: $corner_x and $corner_y"

    # Update bounds
    if (( $offset_x <= $tl_x )); then
        echo "offset is smaller than $tl_x, setting TL_X to $offset_x"
        tl_x=$(echo $offset_x)
        echo "new tl_x is $tl_x"
    fi
    if (( $offset_y <= $tl_y )); then
        echo "offset is smaller than $tl_y, setting TL_Y to $offset_y"
        tl_y=$(echo $offset_y)
        echo "new tl_y is $tl_y"
    fi
    if (( $corner_x >= $br_x )); then
        echo "corner is bigger than $br_x, setting BR_X to $corner_x"
        br_x=$(echo $corner_x)
        echo "new br_x is $br_x"
    fi
    if (( $corner_y >= $br_y )); then
        echo "corner is bigger than $br_y, setting BR_y to $corner_y"
        br_y=$(echo $corner_y)
        echo "new br_y is $br_y"
    fi
done < <(hyprctl monitors | grep -e "Monitor " --no-group-separator)


# calculate total width and height needed to fit all monitors
total_width=$(($br_x - $tl_x))
total_height=$(($br_y - $tl_y))
echo "Total stitched image size: ${total_width}x${total_height}"

# Create a blank canvas
ffmpeg -f lavfi -i color=color=black:size=${total_width}x${total_height} -frames:v 1 "$TEMP_DIR/canvas.png"

# Overlay each screenshot at the correct position
while read -r monitor; do
    # Extract monitor name
    echo "monitor is $monitor"
    line=$(hyprctl monitors | grep -A 1 -e "$monitor" | grep -v "Monitor" | awk '{print $1 " " $2 " " $3}')
    monitor_name=$(echo $monitor | awk '{print $2}')
    echo "monitor name is $monitor_name"
    echo "line is $line"

    # Extract resolution and offset
    resolution=$(echo "$line" | sed 's/@.*//' | awk '{print $1}')
    offset=$(echo "$line" | awk '{print $3}')
    offset_x=$(echo "$offset" | cut -d'x' -f1)
    offset_y=$(echo "$offset" | cut -d'x' -f2)

    # Calculate the correct position on the canvas
    canvas_x=$((offset_x - tl_x))
    canvas_y=$((offset_y - tl_y))

    echo "Placing $monitor_name at ($canvas_x, $canvas_y)..."

    # Use a temporary file for the output to avoid overwriting the input
    ffmpeg -i "$TEMP_DIR/canvas.png" -i "$TEMP_DIR/$monitor_name.png" -filter_complex "[0][1] overlay=$canvas_x:$canvas_y:shortest=0" -y "$TEMP_DIR/canvas_temp.png"
    mv "$TEMP_DIR/canvas_temp.png" "$TEMP_DIR/canvas.png"
done < <(hyprctl monitors | grep -e "Monitor " --no-group-separator)

echo "Final canvas saved to $TEMP_DIR/canvas.png"

# Save the final stitched image

USER=$(getent passwd 1000 | sed 's/:/ /' | awk '{print $1}')
mkdir -p /home/$USER/Screenshots
mv "$TEMP_DIR/canvas.png" "/home/$USER/Screenshots/stitched_screenshot_$timestamp.png"
cat /home/$USER/Screenshots/stitched_screenshot_$timestamp.png | wl-copy
notify-send "Stitched screenshot copied to clipboard and saved as: stitched_screenshot_$timestamp.png"

