#!/bin/bash

source environmentVariables.sh

status=$1

# Codes:
# 0 - Battery charging and more than maximum value of charge intended
# 1 - Battery fully-charged
# 2 - Battery is lower than the intended charge

if [ "$status" = '0' ]
then
	msg="Battery Monitor\nDisconnect charger!!"
	icon="battery-full"
elif [ "$status" = '1' ]
then
	msg="Battery Monitor\nDisconnect charger!!"
	icon="battery-full"
elif [ "$status" = 2 ]
then
	msg="Battery Monitor\nConnect charger!!"
	icon="battery-caution"
fi

if [ "$method" = "static" ]
then            
    echo -e "$msg" | xargs -d '\n' notify-send -i $icon -u critical
elif [ "$method" = "flash" ]
then
    while true
    do
        echo -e "$msg" | xargs -d '\n' notify-send -t $timeout -i $icon -u normal
        sleep $(( $timeout/1000 ))s
    done
fi
