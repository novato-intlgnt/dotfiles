#!/bin/sh

#config key eng
setxkbmap -layout us -variant altgr-intl &

#system icons
cbatticon -u 5 -i Papirus-Dark & #--lowbatt 20 --command 'notify-send "Low Battery"' &

nm-applet &

run volumeicon &

nitrogen --restore &

picom &
