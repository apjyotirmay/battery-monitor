#!/bin/bash

source environmentVariables.sh

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
