#include <qk_program.h>
#include <qk_peripheral.h>
#include <qk_debug.h>

#include "em_gpio.h"

#define DAT_COUNT 1
#define EVT_COUNT 1
#define ACT_COUNT 3

qk_data   dat_buf[DAT_COUNT];
qk_event  evt_buf[EVT_COUNT];
qk_action act_buf[ACT_COUNT];

#define LED_R_PIN   QK_GPIO_CREATE( QK_GPIO_PORT_C , 13)
#define LED_G_PIN   QK_GPIO_CREATE( QK_GPIO_PORT_C , 14)
#define LED_B_PIN   QK_GPIO_CREATE( QK_GPIO_PORT_C , 15)
#define PB_PIN      QK_GPIO_CREATE( QK_GPIO_PORT_C , 0)
#define PHOTO_PIN   QK_GPIO_CREATE( QK_GPIO_PORT_D , 4)


void sample_callback()
{
	
}

void action_callback(qk_action_id id)
{

}

void app_callback()
{


}

void qk_setup()
{
	qk_log_set_levels(QK_LOG_LEVEL_DEBUG | QK_LOG_LEVEL_ERROR);

	qk_board_set_name("dev_mod_test");
	qk_board_set_version(0x1234);

	qk_data_set_buffer(dat_buf, DAT_COUNT);
	qk_data_set_type(QK_DATA_TYPE_INT);
	qk_data_set_label(0, "LIGHT");

	qk_event_set_buffer(evt_buf, EVT_COUNT);
	qk_event_set_label(0, "BUTTON PRESSED");
	
	qk_action_set_buffer(act_buf, ACT_COUNT);
	qk_action_set_label(0, "LED_RED");
	qk_action_set_type(0, QK_ACTION_TYPE_BOOL);
	qk_action_set_label(1, "LED_GREEN");
	qk_action_set_type(1, QK_ACTION_TYPE_BOOL);
	qk_action_set_label(2, "LED_BLUE");
	qk_action_set_type(2, QK_ACTION_TYPE_BOOL);

	qk_action_set_callback(action_callback);

	qk_sampling_set_callback(QK_SAMPLING_CALLBACK_SAMPLE, sample_callback);	
	qk_sampling_set_frequency(10);

    
    qk_gpio_set_mode(PB_PIN, QK_GPIO_MODE_INPUT);
    qk_gpio_interrupt_set(PB_PIN, QK_GPIO_FLAG_RISE | QK_GPIO_FLAG_FALL);

    qk_gpio_set_mode(PHOTO_PIN, QK_GPIO_MODE_ANALOG);

    qk_gpio_set_mode(LED_R_PIN, QK_GPIO_MODE_OUTPUT);
    qk_gpio_set_mode(LED_G_PIN, QK_GPIO_MODE_OUTPUT);
    qk_gpio_set_mode(LED_B_PIN, QK_GPIO_MODE_OUTPUT);

    qk_gpio_set_pin(LED_R_PIN, true);
    qk_gpio_set_pin(LED_G_PIN, false);
    qk_gpio_set_pin(LED_B_PIN, true);

    qk_core_register_callback(QK_CORE_CALLBACK_APP,
                              app_callback);


}

int main(void)
{
    return qk_main();
}
