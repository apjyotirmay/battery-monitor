#!/bin/bash

# This script is called by the main script and sounds alarm under favourable conditions
# To enable alarm, it needs to be turned on in the main script

while true
do
	paplay sound/alarm.oga
done
