#!/usr/bin/zsh
grim ~/Imágenes/screenshots/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png | tee >(wl-copy) >/dev/null && notify-send "Screenshot saved" -a "ss"
