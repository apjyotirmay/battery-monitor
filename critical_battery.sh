#!/bin/bash
# This script monitors the battery for critically low power level and calls the necessary script.

while true; do
    STAT=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | grep "\(charging\|discharging\)" -o)
    
    if [ "$criticalLevel" -lt '10' ]
    then
        BAT=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | grep '[0-9]' -o)
    elif [ "$criticalLevel" -ge '10' ]
    then
        BAT=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | grep '[0-9][0-9]' -o)
    fi
    
    if [ "$STAT" = "discharging" ] && [ "$BAT" -lt "$criticalLevel" ]
    then
        # takes the action specified in this script
        ./critical_action.sh
        exit 0
    fi
    
    sleep 30s
done
