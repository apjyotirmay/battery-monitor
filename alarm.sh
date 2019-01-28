#!/bin/bash

# This script is called by the main script and sounds alarm under favourable conditions
# To enable alarm, it needs to be turned on in the main script

source environmentVariables.sh

batteryStatus
INITSTATE=$STAT

while true
do
    batteryStatus
    if [ "$INITSTATE" != "$STAT" ]
    then
        exit
    fi

    SoundLevel=`pulseaudio-ctl current | sed 's/\%//'`

    if [ "$SoundLevel"  -lt 50 ]
    then
        `paplay sound/alarm-00.ogg`
    elif [ "$SoundLevel" -lt 80 ]
    then
        `paplay sound/alarm-10.ogg`
    else
        `paplay sound/alarm-20.ogg`
    fi
    sleep 2s
done
