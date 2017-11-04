#!/bin/bash

# This script monitors the battery for critically low power level and calls the necessary script.

while true; do
	STAT=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | grep "\(charging\|discharging\)" -o)
	BAT=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | grep '[0-9]' -o)
	if [ "$STAT" == 'discharging' ] && [ "$BAT" -lt $criticalLevel ]; then
		# takes the action specified in this script
		./critical_action.sh
		exit 0
	fi
	sleep 30s
done
