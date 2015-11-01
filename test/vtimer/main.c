#include <qk_program.h>
#include <qk_peripheral.h>

#define HELLO_MSEC	500
#define BLINK_MSEC	50

uint8_t led_state = 0;
uint32_t cnt = 0;

void qk_setup()
{
	qk_board_set_name("test_vtimer");
}

void print_hello(int tid, void *arg)
{
	PRINT("HELLO %d\n", cnt++);
	qk_vtimer_create(HELLO_MSEC, print_hello, 0, QK_VTIMER_MODE_SINGLE);
}

void toggle_led(int tid, void *arg)
{
	if(led_state == 0)
	{
		qk_hal_led_set(true);
		led_state = 1;
	}
	else
	{
		qk_hal_led_set(false);
		led_state = 0;
	}
}

int main(void)
{
	qk_hal_init();
	qk_board_led_blink(3, 100);

	qk_vtimer timers[2];
	qk_vtimer_init(timers, 2);

	qk_vtimer_create(50, toggle_led, 0, QK_VTIMER_MODE_PERIODIC);
	qk_vtimer_create(500, print_hello, 0, QK_VTIMER_MODE_SINGLE);

	while(1)
	{
		qk_run();
	}
}
