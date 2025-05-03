from libqtile import widget

from .device_net import get_active_interface
from .theme import colors

# Get the icons at https://www.nerdfonts.com/cheat-sheet (you need a Nerd Font)


def base(fg="text", bg="dark"):
    return {"foreground": colors[fg], "background": colors[bg]}


def separator():
    return widget.Sep(**base(), linewidth=0, padding=5)


def icon(fg="text", bg="dark", fontsize=16, text="?"):
    return widget.TextBox(**base(fg, bg), fontsize=fontsize, text=text, padding=3)


def powerline(fg="light", bg="dark"):
    return widget.TextBox(
        **base(fg, bg), text="", fontsize=37, padding=-2  # Icon: nf-oct-triangle_left
    )


def workspaces():
    return [
        separator(),
        widget.GroupBox(
            **base(fg="light"),
            font="Fira Code",
            fontsize=19,
            margin_y=3,
            margin_x=0,
            padding_y=8,
            padding_x=5,
            borderwidth=1,
            active=colors["active"],
            inactive=colors["inactive"],
            rounded=True,
            highlight_method="block",
            urgent_alert_method="block",
            urgent_border=colors["urgent"],
            this_current_screen_border=colors["focus"],
            this_screen_border=colors["grey"],
            other_current_screen_border=colors["dark"],
            other_screen_border=colors["dark"],
            disable_drag=True,
        ),
        separator(),
        widget.WindowName(**base(fg="focus"), fontsize=14, padding=5),
        separator(),
    ]


primary_widgets = [
    *workspaces(),
    separator(),
    # Grupo 1
    powerline("color4", "dark"),
    icon(bg="color4", text=" "),  # Icon: nf-fa-thermometer_half
    widget.ThermalSensor(
        **base(bg="color4"),
        colour_have_updates=colors["text"],
        colour_no_updates=colors["text"],
        threshold=50,
        tag_sensor="Core 0",
        fmt="T1:{}",
    ),
    widget.ThermalSensor(
        **base(bg="color4"),
        colour_have_updates=colors["text"],
        colour_no_updates=colors["text"],
        threshold=50,
        tag_sensor="Core 4",
        fmt="/T2:{}",
    ),
    icon(bg="color4", text=" "),  # Icon: nf-fa-save
    widget.Memory(
        **base(bg="color4"),
        colour_have_updates=colors["text"],
        colour_no_updates=colors["text"],
        measure_mem="G",
    ),
    # Grupo 2
    # powerline("color3", "color4"),
    # Grupo 3
    powerline("color2", "color4"),
    icon(bg="color2", text="󰁪 "),  # Icon: nf-md-autorenew
    widget.CheckUpdates(
        background=colors["color2"],
        colour_have_updates=colors["text"],
        colour_no_updates=colors["text"],
        no_update_string="0",
        display_format="{updates}",
        update_interval=1800,
        distro="Arch_checkupdates",
        custom_command="checkupdates",
    ),
    icon(bg="color2", text=" 󰓅 "),  # Icon: nf-md-speedometer
    widget.Net(
        **base(bg="color2"),
        format="{down}    {up}",  # Icon1: nf-fa-arrow_circle_down, Icon2: nf-fa-arrow_circle_up
        interface=get_active_interface(),
        use_bits="true",
    ),
    powerline("color1", "color2"),
    icon(bg="color1", fontsize=17, text=" "),  # Icon: nf-mdi-calendar_clock
    widget.Clock(**base(bg="color1"), format="%d/%m/%Y - %H:%M "),
    icon(bg="color1", fontsize=17, text=" "),  # Icon: nf-fa-volume-up
    widget.PulseVolume(
        **base(bg="color1"),
        limit_max_volume=True,
    ),
    widget.Bluetooth(**base(bg="color1")),
    widget.Systray(background=colors["color1"], padding=5, icon_size=19),
    widget.Battery(
        **base(bg="color1"),
        format="{char} {percent:2.0%}",
        update_interval=10,
        charge_char="⚡",
        discharge_char="🔋",
        full_char="✅",
        empty_char="❌",
        show_short_text=False,
    ),
    powerline("dark", "color1"),
    widget.CurrentLayoutIcon(**base(bg="dark"), scale=0.65),
    widget.CurrentLayout(**base(fg="text1", bg="dark"), padding=5),
]

secondary_widgets = [
    *workspaces(),
    separator(),
    powerline("color1", "dark"),
    widget.Clock(**base(bg="color1"), format="%d/%m/%Y - %H:%M "),
    powerline("color2", "color1"),
    widget.CurrentLayoutIcon(**base(bg="color2"), scale=0.65),
    widget.CurrentLayout(**base(fg="text1", bg="color2"), padding=5),
    powerline("dark", "color2"),
]

widget_defaults = {
    "font": "Fira Code",
    "fontsize": 14,
    "padding": 1,
}
extension_defaults = widget_defaults.copy()
