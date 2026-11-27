#!/usr/bin/env bash

BAT="/sys/class/power_supply/BAT0"
LOW_THRESHOLD=20
CRITICAL_THRESHOLD=10

notified_low=false
notified_critical=false

while true; do
    capacity=$(cat "$BAT/capacity")
    status=$(cat "$BAT/status")

    if [[ "$status" == "Discharging" ]]; then
        if (( capacity <= CRITICAL_THRESHOLD )) && ! $notified_critical; then
            notify-send -u critical "Battery Critical" "Battery is at ${capacity}%. Plug in immediately!"
            notified_critical=true
        elif (( capacity <= LOW_THRESHOLD )) && ! $notified_low; then
            notify-send -u normal "Battery Low" "Battery is at ${capacity}%."
            notified_low=true
        fi
    else
        # Reset flags when charging or full
        notified_low=false
        notified_critical=false
    fi

    sleep 60
done

