# Battery monitoring script for Linux

There is no proper utility to restrict the charging of laptop battery at a certain level, as all the technologies used are proprietary. It's kind of difficult to mimic the same functionality as that of Lenovo battery monitor, but this script can still help in managing the proper charge levels of the laptop battery which should be helpful in extending its life.

This script monitors the battery level and notifies the user when,
* Battery is low and needs to be charged,
* Battery is charged enough (90%) and the charging should be cut off.

*Additional feature:*
In any case if the user is unable to turn on the charging, this script can also take an action for critical level of battery (shutdown, suspend, or hibernate).

**Note: Hibernation must be enabled and supported by your system to be used by this script.**
