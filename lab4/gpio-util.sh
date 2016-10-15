#!/bin/sh
gpio -g mode 18 out
while true
do
	gpio -g write 18 1
	sleep 1
	gpio -g write 18 0
	sleep 1
done