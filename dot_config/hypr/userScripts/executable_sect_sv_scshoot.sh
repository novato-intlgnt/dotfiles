#!/usr/bin/zsh
tmpfile=$(mktemp --suffix=.png)
grim -g "$(slurp)" "$tmpfile" && \
wl-copy < "$tmpfile" && \
cp "$tmpfile" ~/Pictures/screenshots/screenshot_$(date +%Y-%m-%d_%H-%M-%S).png && \
notify-send "Screenshot saved and copied" -a "ss"

