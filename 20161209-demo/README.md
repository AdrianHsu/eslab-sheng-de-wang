#20161209-demo

(host) sudo apt-get install nmap
nmap -sT -v 192.168.1.0/24
ssh -X pi@192.168.1.182
scp file file

## from lab 7
(target) sudo apt-get update  
(target) sudo apt-get dost-upgrade  
(target) sudo apt-get install bluez blueman libbluetooth-dev  
(target) sudo reboot  
(target) sudo systemctl status bluetooth  
(target) sudo vi /etc/systemd/system/dbus-org.bluez.service  
改這行：ExecStart=/usr/lib/bluetooth/bluetoothd --compat  
(target) sudo systemctl daemon-reload   
(target) sudo systemctl restart bluetooth  
(target) sudo hciconfig hci0 up  
###PART 1  
(target) sudo bluetoothctl   
[Bluetooth]# agent on   
[Bluetooth]# default-agent  
scan on -> 找到後 -> trust -> pair  
###PART 2  
(target) run python & c program

## for this demo  

sudo apt-get update && sudo apt-get upgrade  
sudo rpi-update  
sudo aptitude install libglib2.0-dev libdbus-1-dev libudev-dev libicaldev libreadline6-dev  

following here: http://joshondesign.com/2013/10/23/noderpi   
curl -sL https://deb.nodesource.com/setup | sudo bash -  
sudo apt-get install nodejs  


### Download Bluetooth driver:

wget http://www.kernel.org/pub/linux/bluetooth/bluez-5.11.tar.gz  
tar xvf bluez-5.11.tar.gz  
cd bluez-5.11  
./configure --disable-systemd --enable-library  
make  
sudo make install  
sudo reboot  


###Activate bluetooth adapter:

hciconfig  
sudo hciconfig hci0 up  


###Download the nodejs code and run it:

sudo node eddystone-beacon.js  

<b>To enable everything on startup (sudo crontab -e):</b>

@reboot sudo -u root hciconfig hci0 up  
@reboot sudo -u root /usr/bin/nodejs /path/to/eddystone-beacon.js  
