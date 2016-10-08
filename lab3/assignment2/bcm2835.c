#include <bcm2835.h>
#include <stdio.h>

#define PIN RPI_GPIO_P1_12
#define PWM_CHANNEL 0 
#define RANGE 1024

int main(int argc, char **argv)
{
    if (!bcm2835_init())
        return 1;
    bcm2835_gpio_fsel(PIN, BCM2835_GPIO_FSEL_ALT5);
    
    bcm2835_pwm_set_clock(BCM2835_PWM_CLOCK_DIVIDER_16);
    bcm2835_pwm_set_mode(PWM_CHANNEL, 1, 1);
    bcm2835_pwm_set_range(PWM_CHANNEL, RANGE);
	
    int direction = 10;
    int data = 10;
    while (1)
      {
        if (data == 10)
          direction = 10;
        else if (data >= RANGE)
          direction = -10;
        data += direction;
          bcm2835_pwm_set_data(PWM_CHANNEL, data);
        bcm2835_delay(10);
      }
    bcm2835_close();
    return 0;
}
