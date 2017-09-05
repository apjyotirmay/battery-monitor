#!/bin/bash

LANGUAGE="en"
user='apurv'
loc='/org/freedesktop/UPower/devices/battery_BAT0'
queryState='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep state | grep "\(charging\|discharging\)" --only-matching'
maxCharge=90
lowLevel=31
criticalAction='yes'

if [ $USER == $user ]
    then
        # tests if the script is already running or not
        if [ -f "/tmp/_bat_monitor_lockfile" ];
        then
            exit 0
        fi
     
        # creates a lockfile if the script starts to run
        touch "/tmp/_bat_monitor_lockfile";
        
        while true;
        do
            STAT=$(upower -i $loc | grep state | grep "\(charging\|discharging\)" --only-matching)
            BAT=$(upower -i $loc | grep percentage | grep '[0-9][0-9]' --only-matching)
            
            ##################################################
            # status: charging and power is above max charge #
            ##################################################
            if [ "$STAT" == 'charging' ] && [ "$BAT" -gt $maxCharge];
            then
                echo -e "Battery Sufficiently charged\nPower holding at: $BAT%" | 
                xargs -d '\n' notify-send -i battery-empty-charging -u critical
                
                while true;
                do
                    STAT=$(upower -i $loc | 
                    grep state | grep "\(charging\|discharging\)" --only-matching)
                    
                    if [ "$STAT" == 'charging' ];
                    then
                        espeak -a 200 -v ${LANGUAGE} "Battery sufficiently charged, please turn off the external power";
                        sleep 10;
                    elif [ "$STAT" == 'discharging' ];
                    then
                        break
                    fi
                    sleep 1s;
                done
            fi
            
            ####################################################
            # status: full-charged & power is above max charge #
            ####################################################
            if [ "$STAT" == 'fully-charged' ] && [ "$BAT" -gt $maxCharge ];
            then
                echo -e "Battery Sufficiently charged\nPower holding at: $BAT%" | 
                xargs -d '\n' notify-send -i battery-full -u critical
                while true;
                do
                    STAT=$(upower -i $loc | 
                    grep state | grep "\(charging\|discharging\)" --only-matching)
                    
                    if [ "$STAT" == 'charging' ] || [ "$STAT" == 'fully-charged' ];
                    then
                        espeak -a 200 -v ${LANGUAGE} "Battery sufficiently charged, please turn off the external power";
                        sleep 10s;
                    elif [ "$STAT" == 'discharging' ];
                    then
                        break
                    fi
                    sleep 1s;
                done
            fi
            
            ###################################################
            # status: discharging & power is below low charge #
            ###################################################
            if [ "$STAT" == 'discharging' ] && [ "$BAT" -lt $lowLevel ];
            then
                echo -e "Battery low! \nPower dropping below: $BAT%" | 
                xargs -d '\n' notify-send -i battery-caution -u critical
                # this script monitors power level to be critically low               
                if [ criticalAction = 'yes' ]
                then
                    $HOME/.applications/scripts/critical_battery.sh & 
                    CRITCAL_ACTION=$(echo $!)
                fi
                while true;
                do
                    STAT=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | 
                    grep state | grep "\(charging\|discharging\)" --only-matching)
                    
                    if [ "$STAT" == 'discharging' ];
                    then
                        espeak -a 200 -v ${LANGUAGE} "Battery low, please turn on the external power";
                        sleep 10s
                    elif [ "$STAT" == 'discharging' ];
                    then
                        kill -9 $CRITCAL_ACTION
                        break
                    fi
                    sleep 1s;
                done
            fi
            sleep 1m;
            sleep 30s;
        done

fi
