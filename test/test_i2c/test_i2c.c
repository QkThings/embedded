#include <qk_program.h>
#include <qk_debug.h>
#include <qk_peripheral.h>

#include "test_i2c.h"

#define CFG_COUNT 1
#define DAT_COUNT 2
#define EVT_COUNT 1
#define ACT_COUNT 1

qk_data   dat_buf[DAT_COUNT];
qk_event  evt_buf[EVT_COUNT];
qk_action act_buf[ACT_COUNT];
qk_config cfg_buf[CFG_COUNT];

int	 data_cnt = 0;
float evt_args[1];
int  accel_x = 0;
int  accel_y = 0;

#define IMU_ACCEL_I2C_ADDR 


void sample_callback()
{

	//accel_x = (int) qk_i2c_read(IMU_ACCEL_I2C,IMU_ACCEL_ADDR_OUT_X_H_A);
	//qk_data_set_value_i(0, accel_x);
	

    //if((data_cnt % 25) == 0)
  
    QK_LOG_DEBUG("adc_data %d", accel_x);

    if((data_cnt % 50) == 0)
    {
        evt_args[0] = (int) data_cnt;
        qk_event_set_args(0, evt_args, 1);
        qk_event_generate(0, "Milestone reached: %0");
    }

        
}

void action_callback(qk_action_id id)
{
	if(id == 0)
		qk_board_led_set(qk_action_get_value_b(0));
}

void qk_setup()
{
	qk_log_set_levels(QK_LOG_LEVEL_DEBUG | QK_LOG_LEVEL_ERROR);

	qk_board_set_name("test_i2c");

	qk_config_set_buffer(cfg_buf, CFG_COUNT);
	
	qk_config_set_label(0, "INT");
	qk_config_set_type(0, QK_CONFIG_TYPE_INTDEC);
	qk_config_set_value_i(0, 123);

	//>>DATA BUFFER CONFIGURATION
	qk_data_set_buffer(dat_buf, DAT_COUNT);

	qk_data_set_type(QK_DATA_TYPE_INT);
	qk_data_set_label(0, "ACCEL_X");
	//<<

	qk_event_set_buffer(evt_buf, EVT_COUNT);
	qk_event_set_label(0, "EVT");
	
	qk_action_set_buffer(act_buf, ACT_COUNT);
	qk_action_set_label(0, "ACT_BOOL");
	qk_action_set_type(0, QK_ACTION_TYPE_BOOL);

	qk_action_set_callback(action_callback);

	qk_sampling_set_callback(QK_SAMPLING_CALLBACK_SAMPLE, sample_callback);	
	qk_sampling_set_frequency(10);

	// write to CTRL1 register

	
	qk_i2c_write(IMU_ACCEL_I2C, IMU_ACCEL_ADDR_CTRL1, IMU_ACCEL_CTRL1);


}

int main(void)
{
	return qk_main();
}
