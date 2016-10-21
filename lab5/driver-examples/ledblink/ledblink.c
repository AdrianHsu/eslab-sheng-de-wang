#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/timer.h>
#include <linux/device.h>
#include <linux/err.h>
#include <linux/gpio.h>

MODULE_LICENSE("GPL");

#define NUM_BUTTONS 1
/* Define GPIOs for LEDs */
static struct gpio leds[NUM_BUTTONS] = {
                {  18, GPIOF_OUT_INIT_LOW, "LED 1" },
            //  {  23, GPIOF_OUT_INIT_LOW, "LED 2" },
};

static struct timer_list s_BlinkTimer;
static int s_BlinkPeriod = 1000;  // msecs    

static void BlinkTimerHandler(unsigned long unused)
{
	int i;
	static bool on = false;
	on = !on;
        // set all LEDs on
        for(i = 0; i < ARRAY_SIZE(leds); i++) {
                gpio_set_value(leds[i].gpio, on);
        }

	mod_timer(&s_BlinkTimer, jiffies + msecs_to_jiffies(s_BlinkPeriod));
}

static ssize_t set_period_callback(struct device* dev, struct device_attribute* attr,
								   const char* buf,
								   size_t count)
{
	long period_value = 0;
	if (kstrtol(buf, 10, &period_value) < 0)
		return -EINVAL;
	if (period_value < 10)	//Safety check
		return -EINVAL;

	s_BlinkPeriod = period_value;
	return count;
}

static DEVICE_ATTR(period, 0660, NULL, set_period_callback);

static struct class *s_pDeviceClass;
static struct device *s_pDeviceObject;

static int __init LedBlinkModule_init(void)
{
	int result, ret;

        // register LED gpios
        ret = gpio_request_array(leds, ARRAY_SIZE(leds));
        if (ret) {
                printk(KERN_ERR "Unable to request GPIOs for LEDs: %d\n", ret);
                return ret;
        }

	
	setup_timer(&s_BlinkTimer, BlinkTimerHandler, 0);
	result = mod_timer(&s_BlinkTimer, jiffies + msecs_to_jiffies(s_BlinkPeriod));
	BUG_ON(result < 0);

	s_pDeviceClass = class_create(THIS_MODULE, "LedBlink");
	BUG_ON(IS_ERR(s_pDeviceClass));

	s_pDeviceObject = device_create(s_pDeviceClass, NULL, 0, NULL, "LedBlink");
	BUG_ON(IS_ERR(s_pDeviceObject));

	result = device_create_file(s_pDeviceObject, &dev_attr_period);
	BUG_ON(result < 0);

	return 0;
}

static void __exit LedBlinkModule_exit(void)
{
        int i;
	device_remove_file(s_pDeviceObject, &dev_attr_period);
	device_destroy(s_pDeviceClass, 0);
	class_destroy(s_pDeviceClass);

        // turn all LEDs off
        for(i = 0; i < ARRAY_SIZE(leds); i++) {
                gpio_set_value(leds[i].gpio, 0);
        }
        // unregister LED gpios
        gpio_free_array(leds, ARRAY_SIZE(leds));

	del_timer(&s_BlinkTimer);
}

module_init(LedBlinkModule_init);
module_exit(LedBlinkModule_exit);
