#include <qk_program.h>
#include <qk_debug.h>
#include <qk_peripheral.h>

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
float  adc_data_ch4 = 0.0;
float  adc_data_ch5 = 0.0;

int adc_aux = 0;

void sample_callback()
{

	adc_data_ch4 = qk_adc_read(4)*3.3/4096.0;
	adc_data_ch5 = qk_adc_read(5)*3.3/4096.0;
	
	

	qk_data_set_value_f(0, adc_data_ch4);
	qk_data_set_value_f(1, adc_data_ch5);


    //if((data_cnt % 25) == 0)
  
    //QK_LOG_DEBUG("adc_data %d", adc_data);

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

	qk_board_set_name("Test Sensors");

	qk_config_set_buffer(cfg_buf, CFG_COUNT);
	
	qk_config_set_label(0, "INT");
	qk_config_set_type(0, QK_CONFIG_TYPE_INTDEC);
	qk_config_set_value_i(0, 123);

	//>>DATA BUFFER CONFIGURATION
	qk_data_set_buffer(dat_buf, DAT_COUNT);

	qk_data_set_type(QK_DATA_TYPE_FLOAT);
	qk_data_set_label(0, "ADC_CH4");
	qk_data_set_label(1, "ADC_CH5");
	
	

	//<<

	qk_event_set_buffer(evt_buf, EVT_COUNT);
	qk_event_set_label(0, "EVT");
	
	qk_action_set_buffer(act_buf, ACT_COUNT);
	qk_action_set_label(0, "ACT_BOOL");
	qk_action_set_type(0, QK_ACTION_TYPE_BOOL);

	qk_action_set_callback(action_callback);

	qk_sampling_set_callback(QK_SAMPLING_CALLBACK_SAMPLE, sample_callback);	
	qk_sampling_set_frequency(10);
}

int main(void)
{
	return qk_main();
}
