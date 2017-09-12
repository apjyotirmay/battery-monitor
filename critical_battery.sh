#!/bin/bash

criticalLevel=9

while true; do
    STAT=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | grep "\(charging\|discharging\)" -o)
    BAT=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | grep '[0-9]' -o)
    if [ "$STAT" == 'discharging' ] && [ "$BAT" -lt $criticalLevel ]; then
        sudo /usr/scripts/gotosleep.sh  # puts the system in hibernation
        exit 0
    fi
    sleep 30s
done

