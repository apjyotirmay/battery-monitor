#!/bin/bash

export LANGUAGE="en"

# location of your battery's information.
# The default should work for most, but if it doesn't modify it accordingly
export loc='/org/freedesktop/UPower/devices/battery_BAT0'

# How much should the battery be charged before alerting the user
export maxCharge=90

# How much should the battery be let to discharge before alerting the user
export minCharge=30

# When is the system supposed to take an action before completely draining out
export criticalLevel=10

# Should the system use a critical action e.g. Shutdown
export criticalAction='on'

# Should there be an alarm to let the user know?
# Default is 'on'
export alarm='on'

# Run custom actions when AC OFF
export acOffAction='on'

# Run custom actions when AC ON
export acOnAction='off'

################################
# Visual notification settings #
################################
# Is the notification supposed to flash or be a static sticky one?
# Since KDE Plasma 5.11 flashing notification is not recommended because
# of the new Notification Manager introduced.
# Options 'flash', 'static'
# Recommended: static
export method='static'

# If flashing notification, what should be the rate of flash (in millisecond)
export timeout=1000

##############################################
# Do not manually modify anything below here #
##############################################

if [ "$timeout" -lt '1000' ]
then
	timeout=1000
fi

PROCESS_NUM=$(ps -ef | grep "monitor.sh" | grep -v "grep" | wc -l)
if [ "$PROCESS_NUM" -eq 0 ]
then
	./monitor.sh
fi

exit 0
