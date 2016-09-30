#!/bin/bash
# sudo bash <this_script>
#define a utility function
rep-or-add-line() {
grep "$SEARCH_TEXT" $TFILE
if [ $? -eq 0 ]
then
	echo "$TFILE: $SEARCH_TEXT found; replace a line $REPLACE_TEXT"
	sed -i "/$SEARCH_TEXT/ c $REPLACE_TEXT" $TFILE
else
	echo "$TFILE: SEARCH_TEXT not found; add a line $REPLACE_TEXT"
	set -i "$ a $REPLACE_TEXT" $TFILE
fi
}
#1. install required package
echo "#1. install requi package"
apt-get install isc-dhcp-server
#2. edit isc-dhcp-server in /etc/default
echo "#2. edit isc-dhcp-server in /etc/default"
#sudo vi /etc/default/isc-dhcp-server
TFILE="/etc/default/isc-dhcp-server"
SEARCH_TEXT='INTERFACES='
REPLACE_TEXT='INTERFACES="eth0"'
rep-or-add-line

echo "#3. edit /etc/dhcp/dhcpd.conf"
#sudo vi /etc/dhcp/dhcpd.conf
FILE_ILD=/etc/dhcp/dhcpd.conf.old
FILE=/etc/dhcp/dhcpd.conf

if [ ! -f $FILE_OLD ]
then
	cp $FILE $FILE_OLD
fi
cat > $FILE << EOF_HERE

default-lease-time 600;
max-lease-time 7200;

#log-facility local7;
subnet 192.160.0.0 netmask 255.255.255.0 {
	range 192.168.0.100 192.168.0.199
	option domain-name-servers 140.112.2.2, 8.8.8.8; #Pri DNS, Sec DNS
	#option domain-name "lintut.com"; #Domain nme
	option routers 192.168.0.1;
	option broadcase-address 192.168.0.255;
	default-lease-time 600;
	max-lease-time 7200;
}
EOF_HERE

#4. edit /etc/network/interfaces
echo "#4. edit /etc/network/interfaces"
#sudo vi /etc/network/interfaces
FILE_OLD=/etc/network/interfaces.old
FILE=/etc/network/interfaces
if [ ! -f $FILE_OLD ]
then
	cp $FILE $FILE_OLD
fi
cat > $FILE << EOF_HERE
# interfaces(5) file used by ifup(8) and ifdown(8)
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
address 192.168.0.1
netmask 255.255.255.0
up service isc-dhcp-server restart
EOF_HERE

#5. check the status of the service
echo "#5. check the status of the service"
service isc-dhcp-server status
