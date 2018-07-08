#!/bin/bash
# This script monitors the battery for critically low power level and calls the necessary script.

source environmentVariables.sh

while true
do
		batteryStatus
		batteryPercentage

    if [ "$STAT" = "discharging" ] && [ "$BAT" -lt "$criticalLevel" ]
    then
        # takes the action specified in this script
        ./critical_action.sh
        exit 0
    fi
    
    sleep 5s
done
