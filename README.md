# Battery monitoring script for Linux

There is no proper utility to restrict the charging of laptop battery at a certain level, as all the technologies used are proprietary. It's kind of difficult to mimic the same functionality as that of Lenovo battery monitor, but this script can still help in managing the proper charge levels of the laptop battery which should be helpful in extending its life.

This script monitors the battery level and notifies the user when,
* Battery is low (default: 30%) and needs to be charged,
* Battery is charged enough (default: 90%) and the charging should be cut off.

*Additional feature:*
In any case if the user is unable to turn on the charging, the script (critical_action.sh) can also take an action for critical level of battery (shutdown, suspend, or hibernate), or you can adapt the script (critical_action.sh) as per your need.

**Note: Hibernate and suspend must be enabled and supported by your system to be used by this script.**

## How to
Use **start.sh** to start the script.

First, mark the file as an executable using commandline
> chmod +x start.sh

Then, start the script.
> ./start.sh

Add this script to autostart, so it is executed every time the user logs in

**All the basic options can be modified in the environmentVariables.sh script, and it is recommended to do the necessary modifications before using the script.**
