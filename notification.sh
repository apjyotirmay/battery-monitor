#!/bin/bash

status=$1


if [ "$status" = '0' ]
then
    msg="Battery sufficiently charged\nPower holding at"
    icon="battery-full"
elif [ "$status" = '1' ]
then
    msg="Battery sufficiently charged\nPower holding at"
    icon="battery-full"
elif [ "$status" = 2 ]
then
    msg="Battery low!\nPower dropping below"
    icon="battery-caution"
fi

while true
do
    BAT=$(upower -i $loc | grep percentage | grep '[0-9][0-9]' --only-matching)
    echo -e "$msg: $BAT%" | xargs -d '\n' notify-send -t $timeout -i $icon -u normal
    sleep $(( $timeout/1000 ))s
done