#!/bin/bash

# tests if the script is already running or not
ps -C monitor.sh &> /dev/null
if [ "$?" -eq "0" ]
then
	exit 0
fi
	
while true;
do
	STAT=$(upower -i $loc | grep state | grep "\(charging\|discharging\|fully-charged\)" --only-matching)
	BAT=$(upower -i $loc | grep percentage | grep '[0-9]*' --only-matching)

	##################################################
	# status: charging and power is above max charge #
	##################################################
	if [ "$STAT" = "charging" ] && [ "$BAT" -gt "$maxCharge" ];
	then
		./notification.sh 0 &
		NOTIFICATION=$(echo $!)
		if [ "$alarm" = "on" ]
		then
			./alarm.sh &
			alarm_id=$(echo $!)
		fi

		while true;
		do
			STAT=$(upower -i $loc | grep state | grep "\(charging\|discharging\|fully-charged\)" --only-matching)

			if [ "$STAT" = "discharging" ];
			then
				if [ "$alarm" = 'on' ]
				then
					kill -9 $alarm_id
					kill -9 $(ps ax | grep "paplay" | grep -v grep | awk '{ print $1 }')
				fi

				kill -9 $NOTIFICATION
				break
			fi
			sleep 1s;
		done
	fi

	####################################################
	# status: full-charged & power is above max charge #
	####################################################
	if [ "$STAT" == 'fully-charged' ] && [ "$BAT" -gt "$maxCharge" ];
	then
		./notification.sh 1 &
		NOTIFICATION=$(echo $!)

		if [ "$alarm" = "on" ]
		then
			./alarm.sh &
			alarm_id=$(echo $!)
		fi

		while true;
		do
			STAT=$(upower -i $loc | grep state | grep "\(charging\|discharging\|fully-charged\)" --only-matching)

			if [ "$STAT" == 'discharging' ];
			then
				if [ "$alarm" = "on" ]
				then
					kill -9 $alarm_id
					kill -9 $(ps ax | grep "paplay" | grep -v grep | awk '{ print $1 }')
				fi

				kill -9 $NOTIFICATION
				break
			fi
			sleep 1s;
		done
	fi

	###################################################
	# status: discharging & power is below low charge #
	###################################################
	if [ "$STAT" = 'discharging' ] && [ "$BAT" -lt "$minCharge" ];
	then
		./notification.sh 2 &
		NOTIFICATION=$(echo $!)

		if [ "$criticalAction" = 'on' ]
		then
			./critical_battery.sh &
			CRITCAL_ACTION=$(echo $!)
		fi

		if [ "$alarm" = "on" ]
		then
			./alarm.sh &
			alarm_id=$(echo $!)
		fi

		while true;
		do
			STAT=$(upower -i $loc | grep state | grep "\(charging\|discharging\|fully-charged\)" --only-matching)

			if [ "$STAT" = "charging" ];
			then
				if [ "$alarm" = 'on' ]
				then
					kill -9 $alarm_id
					kill -9 $(ps ax | grep "paplay" | grep -v grep | awk '{ print $1 }')
				fi

				if [ "$criticalAction" = 'on' ]
				then
					kill -9 $CRITCAL_ACTION
				fi

				kill -9 $NOTIFICATION

				break
			fi
			sleep 1s;
		done
	fi
	sleep 1s;
done
