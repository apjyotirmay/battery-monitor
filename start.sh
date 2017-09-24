#!/bin/bash

LANGUAGE="en"
user='apurv'
loc='/org/freedesktop/UPower/devices/battery_BAT0'
maxCharge=90
minCharge=31
criticalLevel=9
criticalAction='on'
alarm='on'
timeout=1000

export LANGUAGE user loc maxCharge minCharge criticalLevel criticalAction alarm timeout 

./monitor.sh
