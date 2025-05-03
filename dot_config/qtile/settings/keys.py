# Antonio Sarosi
# https://youtube.com/c/antoniosarosi
# https://github.com/antoniosarosi/dotfiles

# Qtile keybindings

from libqtile.config import Key
from libqtile.lazy import lazy

mod = "mod4"

keys = [
    Key(key[0], key[1], *key[2:], key[3])
    for key in [
        # ------------ Window Configs ------------
        # Switch between windows in current stack pane
        ([mod], "j", lazy.layout.down(), "Move focus down in stack pane"),
        ([mod], "k", lazy.layout.up(), "Move focus up in stack pane"),
        ([mod], "h", lazy.layout.left(), "Move focus left in stack pane"),
        ([mod], "l", lazy.layout.right(), "Move focus right in stack pane"),
        ([mod], "space", lazy.layout.next(), "Move window focus to other window"),
        # Change window sizes (MonadTall)
        ([mod, "shift"], "l", lazy.layout.grow(), "Grow window size"),
        ([mod, "shift"], "h", lazy.layout.shrink(), "Shrink window size"),
        # Move windows up or down in current stack
        ([mod, "shift"], "j", lazy.layout.shuffle_down(), "Move window down in stack"),
        ([mod, "shift"], "k", lazy.layout.shuffle_up(), "Move window up in stack"),
        ([mod], "n", lazy.layout.normalize(), "Normalize the window"),
        ([mod], "o", lazy.layout.maximize(), "Maximize the window"),
        # Grow windows in specific directions
        ([mod, "control"], "h", lazy.layout.grow_left(), "Grow window to the left"),
        ([mod, "control"], "l", lazy.layout.grow_right(), "Grow window to the right"),
        ([mod, "control"], "j", lazy.layout.grow_down(), "Grow window down"),
        ([mod, "control"], "k", lazy.layout.grow_up(), "Grow window up"),
        ([mod], "n", lazy.layout.normalize(), "Reset all window sizes"),
        # Toggle between split and unsplit sides of stack
        (
            [mod, "shift"],
            "Return",
            lazy.layout.toggle_split(),
            "Toggle between split and unsplit sides of stack",
        ),
        # Toggle floating
        ([mod], "f", lazy.window.toggle_floating(), "Toggle floating window"),
        # Toggle fullscreen
        (
            [mod],
            "f",
            lazy.window.toggle_fullscreen(),
            "Toggle fullscreen on the focused window",
        ),
        # Toggle between different layouts as defined below
        ([mod], "Tab", lazy.next_layout(), "Toggle between layouts"),
        ([mod, "shift"], "Tab", lazy.prev_layout(), "Toggle to previous layout"),
        # Kill window
        ([mod], "w", lazy.window.kill(), "Kill focused window"),
        # Switch focus of monitors
        ([mod], "period", lazy.next_screen(), "Move focus to next monitor"),
        ([mod], "comma", lazy.prev_screen(), "Move focus to previous monitor"),
        # Restart Qtile
        ([mod, "control"], "r", lazy.restart(), "Restart Qtile"),
        # Shutdown Qtile
        ([mod, "control"], "q", lazy.shutdown(), "Shutdown Qtile"),
        ([mod, "shift"], "q", lazy.spawn("shutdown now"), "Shutdown the computer"),
        (
            [mod, "shift"],
            "l",
            lazy.spawn(
                "betterlockscreen --lock blur --text 'if (focus) { don’t disturb(); }'"
            ),
            "Lock the screen",
        ),
        # # Spawn a command using a prompt widget
        # ([mod], "r", lazy.spawncmd(), "Spawn a command using a prompt widget"),
        # ------------ App Configs ------------
        # Launch terminal
        ([mod], "Return", lazy.spawn("kitty"), "Launch terminal"),
        # Mapping to launch spotify
        ([mod], "s", lazy.spawn("spotify"), "Launch spotify"),
        # Mappings to launch menu rofi
        ([mod], "m", lazy.spawn("rofi -show drun"), "Launch rofi"),
        # Window Nav
        ([mod, "shift"], "m", lazy.spawn("rofi -show"), "Launch rofi to navigate"),
        # Launch firefox developer edition
        (
            [mod],
            "b",
            lazy.spawn("firefox-developer-edition"),
            "Launch Firefox Developer Edition",
        ),
        # File Explorer
        ([mod], "e", lazy.spawn("dolphin"), "Launch file explorer"),
        # Redshift
        ([mod], "r", lazy.spawn("redshift -O 6000"), "Set redshift to 2400K"),
        ([mod, "shift"], "r", lazy.spawn("redshift -x"), "Reset redshift"),
        # ------------ Commented Keymaps ------------
        # Screenshot
        # ([], "Print", lazy.spawn("scrot -s"), "Captura de pantalla con Ksnip"),
        # ([], "Print", lazy.spawn("scrot 'screenshot_%Y-%m-%d-%T_$wx$h.png' -e 'mkdir -p ~/Imagenes/screenshots/ | mv $f ~/Imagenes/screenshots/'"), "Screenshot with scrot",),
        # ([mod], "Print", lazy.spawn("scrot -s"), "Capture an area of the screen"),
        (
            [],
            "Print",
            lazy.spawn(
                "scrot 'screenshot_%Y-%m-%d-%T_$wx$h.png' -e 'mkdir -p ~/Imágenes/screenshots/; mv $f ~/Imágenes/screenshots/; xclip -selection clipboard -target image/png -i ~/Imágenes/screenshots/$f'"
            ),
            "Captura completa y copia al portapapeles",
        ),
        (
            [mod],
            "Print",
            lazy.spawn(
                "scrot -s '/tmp/screenshot.png' -e 'xclip -selection clipboard -target image/png -i /tmp/screenshot.png'"
            ),
            "Captura de región y copia al portapapeles",
        ),
        # # Volume
        (
            [],
            "XF86AudioLowerVolume",
            lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
            "Bajar volumen",
        ),
        (
            [],
            "XF86AudioRaiseVolume",
            lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
            "Subir volumen",
        ),
        (
            [],
            "XF86AudioMute",
            lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
            "Mute volumen",
        ),
        # # Brightness
        (
            [],
            "XF86MonBrightnessUp",
            lazy.spawn("brightnessctl set +5%"),
            "Subir brillo",
        ),
        (
            [],
            "XF86MonBrightnessDown",
            lazy.spawn("brightnessctl set 5%-"),
            "Bajar brillo",
        ),
    ]
]
