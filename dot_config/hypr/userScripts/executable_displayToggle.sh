#!/bin/bash

INTERNAL="eDP-1"
EXTERNAL="HDMI-A-1"
RESOLUTION="1920x1080@60"

# Verifica si swww está disponible
RESTORE_WALLPAPER() {
    if command -v swww &> /dev/null; then
        swww init &> /dev/null
        swww img ~/.config/wallpapers/willow_rays.jpg &> /dev/null
    fi
}

# Restablece Waybar
RESTART_WAYBAR() {
    pkill waybar
    sleep 0.5
    waybar &
}

EXTERNAL_STATUS=$(wlr-randr | grep "$EXTERNAL" -A5 | grep "Enabled: yes")

if [ -z "$EXTERNAL_STATUS" ]; then
    notify-send "No external display detected or enabled."
    exit 1
fi

CHOICE=$(printf "Extend\nMirror\nExternal Only\nInternal Only" | wofi --dmenu -p "Display Mode:")

case "$CHOICE" in
    Extend)
        hyprctl keyword monitor "$INTERNAL,$RESOLUTION,0x0,1"
        hyprctl keyword monitor "$EXTERNAL,$RESOLUTION,0x-1080,1"
        # RESTORE_WALLPAPER
        RESTART_WAYBAR
        notify-send "Display Mode" "Extended to $EXTERNAL"
        ;;

    Mirror)
        hyprctl keyword monitor "$INTERNAL,preferred,auto,1"
        hyprctl keyword monitor "$EXTERNAL,preferred,0x0,1,mirror,$INTERNAL"
        RESTORE_WALLPAPER
        RESTART_WAYBAR
        notify-send "Display Mode" "Mirroring on $EXTERNAL"
        ;;

    "External Only")
        hyprctl keyword monitor "$INTERNAL,disable"
        hyprctl keyword monitor "$EXTERNAL,$RESOLUTION,0x0,1"
        RESTORE_WALLPAPER
        RESTART_WAYBAR
        notify-send "Display Mode" "External only ($EXTERNAL) active"
        ;;

    "Internal Only")
        hyprctl keyword monitor "$EXTERNAL,disable"
        hyprctl keyword monitor "$INTERNAL,$RESOLUTION,0x0,1"
        RESTORE_WALLPAPER
        RESTART_WAYBAR
        notify-send "Display Mode" "Internal only ($INTERNAL) active"
        ;;

    *)
        notify-send "Display Mode" "No action taken"
        ;;
esac
