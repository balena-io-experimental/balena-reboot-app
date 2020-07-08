#!/bin/sh

set -x

if [ ! -e /data/fcount ]; then
	echo 0 > /data/fcount
fi

count=$(cat /data/fcount)
count=$(expr ${count} + 1)
echo ${count} > /data/fcount

if [ "${count}" -gt 101 ]; then
	echo "Completed reboot test"
	rm -f /data/fcount
	exit 0
fi

echo "Reboot count ${count}...rebooting in 2 seconds"
sleep 2

result=1
while [ "${result}" -ne 0 ]; do
	curl -X POST --header "Content-Type:application/json" "$BALENA_SUPERVISOR_ADDRESS/v1/reboot?apikey=$BALENA_SUPERVISOR_API_KEY"
	result=$?
	sleep 20
done
while true; do echo "Waiting for reboot.."; sleep 5; done
