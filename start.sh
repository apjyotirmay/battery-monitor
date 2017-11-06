#!/bin/bash

LANGUAGE="en"
user='apurv'

# location of your battery's information.
# The default should work for most, but if it doesn't modify it accordingly
loc='/org/freedesktop/UPower/devices/battery_BAT0'

# How much should the battery be charged before alerting the user
maxCharge=80

# How much should the battery be let to discharge before alerting the user
minCharge=60

# When is the system supposed to take an action before completely draining out
criticalLevel=10

# Should the system use a critical action e.g. Shutdown
criticalAction='on'

# Should there be an alarm to let the user know?
# Default is 'on'
alarm='on'

################################
# Visual notification settings #
################################
# Is the notification supposed to flash or be a static sticky one?
# Since KDE Plasma 5.11 flashing notification is not recommended because
# of the new Notification Manager introduced.
# Options 'flash', 'static'
# Recommended: static
method='flash'

# If flashing notification, what should be the rate of flash (in milisecond)
timeout=1000

##############################################
# Do not manually modify anything below here #
##############################################

if [ "$timeout" -lt '1000' ]
then
	timeout=1000
fi

export LANGUAGE user loc maxCharge minCharge criticalLevel criticalAction alarm timeout method

./monitor.sh
