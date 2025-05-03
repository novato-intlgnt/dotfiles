#!/usr/bin/zsh
grim -g "$(slurp)" - | wl-copy && notify-send "Section screenshot copied" -a "ss"
