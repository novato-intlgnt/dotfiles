#!/bin/bash

BAT=$(upower -e | grep 'BAT')
NOTIFY_ID_FILE="/tmp/battery_notify_id"

get_status() {
    upower -i $BAT | awk -F': ' '
    /state/ {state = $2}
    /percentage/ {gsub("%", "", $2); percent = $2}
    END {print percent, state}'
}

while true; do
    read -r PERCENT STATUS <<< "$(get_status)"

    # Cuando está cargando y llega al 80%
    if [[ "$STATUS" == "charging" && "$PERCENT" -ge 80 ]]; then
        if [[ ! -f $NOTIFY_ID_FILE ]]; then
            notify-send -u critical -t 0 "🔌 Battery at ${PERCENT}%. Unplug the charger."
            touch "$NOTIFY_ID_FILE"
        fi
    fi

    # Si se desconecta y ya se había notificado
    if [[ "$STATUS" != "charging" && -f $NOTIFY_ID_FILE ]]; then
        rm "$NOTIFY_ID_FILE"
        # Opcional: cerrar la notificación si mako soporta control
        pkill -SIGUSR1 mako
    fi

    # Cuando no está cargando y está en 20% o menos
    if [[ "$STATUS" != "charging" && "$PERCENT" -le 20 ]]; then
        if [[ ! -f $NOTIFY_ID_FILE ]]; then
            notify-send -u critical -t 0 "🔋 Battery at ${PERCENT}%. Plug in the charger."
            touch "$NOTIFY_ID_FILE"
        fi
    fi

    # Si se conecta y ya se había notificado
    if [[ "$STATUS" == "charging" && -f $NOTIFY_ID_FILE && "$PERCENT" -gt 20 ]]; then
        rm "$NOTIFY_ID_FILE"
        pkill -SIGUSR1 mako
    fi

    sleep 30
done
