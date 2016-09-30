#!/bin/bash
# sudo bash <this_script>
TFILE="/etc/rc.local"
SEARCH_TEXT='#nat-script-in-rc.local'
LINES="\n modprobe iptable_nat\n iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE\n echo '1' > /proc/sys/net/ipv4/ip_forward\n #kbdrate -r 10 -d 600\n"
grep "$SEARCH_TEXT" $TFILE
if [ $? -eq 0 ]
then 
	echo "$TFILE: $SEARCH_TEXT found; Do nothing"
else
	echo -e "$TFILE: $SEARCH_TEXT not found; add lines \n $SEARCH_TEXT \n $LINES"
	FILE_OLD=/etc/rc.local.FILE_OLD
	FILE=/etc/rc.local
	if [ ! -f $FILE_OLD ]
		then
			cp $FILE $FILE_OLD
	fi
	sed -i "/^exit 0/i $SEARCH_TEXT \n $LINES" $TFILE #append lines
fi
