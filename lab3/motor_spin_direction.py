import RPi.GPIO as GPIO;
from time import sleep
GPIO.setmode(GPIO.BCM);
try:
	while(True):
		GPIO.setup(23, GPIO.IN);
		GPIO.setup(24, GPIO.OUT);
		GPIO.output(24, True);
		sleep(1);
		GPIO.output(24, False);
		sleep(1);
		GPIO.setup(24, GPIO.IN);
		GPIO.setup(23, GPIO.OUT);
		GPIO.output(23, True);
		sleep(1);
		GPIO.output(23, False);
		sleep(1);
except KeyboardInterrupt:
	GPIO.cleanup() # clean up GPIO on CTRL+C exit
GPIO.cleanup()