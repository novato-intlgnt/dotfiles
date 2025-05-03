# Antonio Sarosi
# https://youtube.com/c/antoniosarosi
# https://github.com/antoniosarosi/dotfiles

# Qtile workspaces

from libqtile.config import Group, Key
from libqtile.lazy import lazy

from .keys import keys, mod

# Get the icons at https://www.nerdfonts.com/cheat-sheet (you need a Nerd Font)
# Icons:
# nf-fa-firefox,
# nf-dev-terminal,
# nf-fa-code,
# nf-md-git,
# nf-linux-docker,
# nf-cod-file_submodule,
# nf-fa-university
# nf-md-gamepad_variant
# nf-md-chat_processing_outline

groups = [
    Group(i)
    for i in ["   ", "  ", "   ", " 󰊢 ", "   ", "   ", " 󰽰 ", "   ", " 󱋊 "]
]

for i, group in enumerate(groups):
    actual_key = str(i + 1)
    keys.extend(
        [
            # Switch to workspace N
            Key([mod], actual_key, lazy.group[group.name].toscreen()),
            # Send window to workspace N
            Key([mod, "shift"], actual_key, lazy.window.togroup(group.name)),
        ]
    )
