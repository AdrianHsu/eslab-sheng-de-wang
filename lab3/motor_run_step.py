import RPi.GPIO as GPIO;
from time import sleep;

GPIO.setmode(GPIO.BCM);
GPIO.setup(23, GPIO.IN, pull_up_down=GPIO.PUD_UP);
GPIO.setup(17, GPIO.IN, pull_up_down=GPIO.PUD_UP);
GPIO.setup(24, GPIO.OUT);

def my_callback(channel):
	print "falling edge detected on 17"
def my_callback2(channel):
	print "falling edge detected on 23"

GPIO.add_event_detect(17, GPIO.FALLING, callback=my_callback,
bouncetime=300)
GPIO.add_event_detect(23, GPIO.FALLING, callback=my_callback2,
bouncetime=300)
try:
	while(True):
		GPIO.output(24, False);
		sleep(1);
		GPIO.output(24, True);
		sleep(1);
except KeyboardInterrupt:
	GPIO.cleanup() # clean up GPIO on CTRL+C exit
GPIO.cleanup() # clean up GPIO on normal exit
