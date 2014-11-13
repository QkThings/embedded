#include <qk_program.h>
#include <qk_peripheral.h>
#include <qk_debug.h>

bool send = true;

#define BT_EN	QK_GPIO_PIN(C,0)
#define BT_STAT	QK_GPIO_PIN(C,1)
#define BT_MODE	QK_GPIO_PIN(C,2)
#define BT_RST	QK_GPIO_PIN(C,3)

#define COMM_RTS	QK_GPIO_PIN(A,8)
#define COMM_CTS	QK_GPIO_PIN(A,9)
#define COMM_TX		QK_GPIO_PIN(D,4)
#define COMM_RX		QK_GPIO_PIN(D,5)

#define COMM_UART_ID	QK_UART_1

void core_callback_app(qk_callback_arg *arg)
{


	char str[4] = "hi\r\n";
	if(send)
	{
		qk_uart_write(COMM_UART_ID, (uint8_t*)str, 4);
		send = false;
	}

	if(qk_uart_bytes_available(COMM_UART_ID) > 0)
	{
		char rxbuf[16];
		qk_uart_read(COMM_UART_ID, rxbuf, 16);
		QK_LOG_DEBUG("rx: %s\n", rxbuf);
		send = true;
	}
}

void protocol_callback_send_bytes(qk_callback_arg *arg)
{
	uint8_t *buf = QK_BUF_PTR( QK_CALLBACK_ARG_BUF(arg) );
	uint16_t count =  QK_BUF_COUNT( QK_CALLBACK_ARG_BUF(arg) );
	qk_uart_write(COMM_UART_ID, buf, count);
}

void qk_setup()
{
	qk_board_set_name("Bluetooth 2.0");
//
//	qk_core_register_callback(QK_CORE_CALLBACK_APP,
//							  core_callback_app);
//
//	qk_protocol_register_callback(qk_protocol_comm,
//								  QK_PROTOCOL_CALLBACK_SENDBYTES,
//								  protocol_callback_send_bytes);

//	qk_gpio_set_mode(BT_EN, QK_GPIO_MODE_OUTPUT);
//	qk_gpio_set_mode(BT_STAT, QK_GPIO_MODE_INPUT);
	qk_gpio_set_mode(BT_MODE, QK_GPIO_MODE_OUTPUT);
	qk_gpio_set_mode(BT_RST, QK_GPIO_MODE_OUTPUT);

	qk_gpio_set_pin(BT_MODE, LOW);
	qk_gpio_set_pin(BT_RST, HIGH);

	qk_gpio_set_mode(COMM_TX, QK_GPIO_MODE_OUTPUT);
	qk_gpio_set_mode(COMM_RX, QK_GPIO_MODE_INPUT);

	qk_uart_enable(COMM_UART_ID, true);
}

int main()
{
	qk_init();
	qk_log_set_levels(QK_LOG_LEVEL_DEBUG);

	while(1)
	{
		qk_run();

		qk_board_led_blink(1, 500);



		QK_LOG_DEBUG("ba:%d\n", qk_uart_bytes_available(COMM_UART_ID));

		char str[7] = "hello\n";
		qk_uart_write(QK_UART_1, &str, 6);

		if(qk_uart_bytes_available(COMM_UART_ID) > 0)
		{
			char rxbuf[16];
			qk_uart_read(COMM_UART_ID, rxbuf, 16);
			QK_LOG_DEBUG("rx: %s\n", rxbuf);
		}

//		char str[4] = "hi\r\n";
//		qk_uart_write(COMM_UART_ID, (uint8_t*)str, 4);

//		qk_run();
//		qk_board_led_blink(2, 100);
//
//		if(qk_uart_bytes_available(COMM_UART_ID) > 0)
//		{
//			char rxbuf[16];
//			qk_uart_read(COMM_UART_ID, rxbuf, 16);
//			QK_LOG_DEBUG("rx: %s\n", rxbuf);
//		}
//
//		char str[4] = "hi\r\n";
//
//		qk_uart_write(COMM_UART_ID, (uint8_t*)str, 4);
//
//		delay_ms(1000);
	}
}
