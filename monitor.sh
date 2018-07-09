#!/bin/bash

source environmentVariables.sh

while true
do
	batteryStatus
	batteryPercentage

	##################################################
	# status: charging and power is above max charge #
	##################################################
	if [ "$STAT" = 'charging' ]
	then
		nots=inactive
		# begin charging while loop
		while true
		do
			batteryStatus
			batteryPercentage
			
			# If charge is more than the set maxCharge limit, start notification and alarm
			if [ "$BAT" -gt "$maxCharge" ]
			then
				if [ "$nots" = 'inactive' ]
				then
					./notification.sh 0 &
					
					if [ "$alarm" = "on" ]
					then
						./alarm.sh &
						alarmPID=$!
					fi
					nots=active
				fi
			fi
			# End of alarm and notification if-block
			
			# If charging is disconnected, kill alarm and execute acOffAction
			# and end the while loop if discharging or fully-charged
			if [ "$STAT" = 'discharging' ]
			then
				if [ "$acOffAction" = 'on' ]
				then
					./acOffScript.sh &
				fi
				
				if [ "$BAT" -gt "$maxCharge" ]
				then
					# kill all the scripts started in this scenario
					if [ "$STAT" = "discharging" ] || [ "$STAT" = "fully-charged" ]
					then
						if [ "$alarm" = 'on' ]
						then
							kill -9 $alarmPID
							kill -9 $(ps ax | grep "paplay" | grep -v grep | awk '{ print $1 }')
						fi
					fi
					# end of killing scripts
				fi
				break
			elif [ "$STAT" = 'fully-charged' ]
			then
				if [ "$alarm" = 'on' ]
				then
					kill -9 $alarmPID
					kill -9 $(ps ax | grep "paplay" | grep -v grep | awk '{ print $1 }')
				fi
				break
			fi
			# End of the if-block for discharging

			# sleep command to slow down the while-loop
			sleep 1s
		done
		# End charging while loop

	####################################################
	# status: full-charged & power is above max charge #
	####################################################
	elif [ "$STAT" = 'fully-charged' ] && [ "$BAT" -gt "$maxCharge" ]
	then
		# start notifications
		./notification.sh 1 &

		if [ "$alarm" = "on" ]
		then
			./alarm.sh &
			alarmPID=$!
		fi
		# end of the notification initiation

		# begin fully-charged while loop
		while true
		do
			batteryStatus
			
			# if external power is disconnected, kill the alarm and break
			# the while-loop
			if [ "$STAT" = 'discharging' ]
			then
				# Kill all the scripts started for this scenario
				if [ "$alarm" = "on" ]
				then
					kill -9 $alarmPID
					kill -9 $(ps ax | grep "paplay" | grep -v grep | awk '{ print $1 }')
				fi
				# End of killing scripts

				# Start acOffAction if needed
				if [ "$acOffAction" = 'on' ]
				then
					./acOffScript.sh &
				fi
				# End of acOffAction

				break
			fi
			# End the if-block for discharging

			# sleep call to slow down the while-loop
			sleep 1s
		done
		# End fully-charged while loop

	###################################################
	# status: discharging & power is below low charge #
	###################################################
	elif [ "$STAT" = 'discharging' ]
	then
		nots=inactive

		# begin discharge while loop
		while true
		do
			batteryStatus
			batteryPercentage
			# if charge is less than minimum charge, then start this if-block
			if [ "$BAT" -lt "$minCharge" ]
			then
				# Send a notification, start alarm and critical action script
				if [ "$nots" = "inactive" ]
				then
					./notification.sh 2 &

					if [ "$criticalAction" = 'on' ]
					then
						./critical_battery.sh &
						criticalActionPID=$!
					fi

					if [ "$alarm" = "on" ]
					then
						./alarm.sh &
						alarmPID=$!
					fi
					nots=active
				fi
				# End of the notification block
			fi
			# End of the minCharge if-block

			# if power is plugged in, kill alarm and critical action script
			if [ "$STAT" = "charging" ]
			then
				# Kill all the scripts if power is below minimum level
				if [ "$BAT" -lt "$minCharge" ]
				then
					if [ "$alarm" = 'on' ]
					then
						kill -9 $alarmPID
						kill -9 $(ps ax | grep "paplay" | grep -v grep | awk '{ print $1 }')
					fi

					if [ "$criticalAction" = 'on' ]
					then
						kill -9 $criticalActionPID
					fi
				fi
				# End of killing the scripts

				# Start acOnAction script if needed
				if [ "$acOnAction" = "on" ]
				then
					./acOnScript.sh &
				fi
				# End of starting acOnAction script

				break
			fi
			# End of the power plugged in block
			
			# sleep call of 1 second to slowdown the while-loop
			sleep 1s
		done
		# End discharge while-loop
	fi
	sleep 1s
done
