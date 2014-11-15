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
	int bytes_available = qk_uart_bytes_available(COMM_UART_ID);

	if(bytes_available > 0)
	{
		int bytes_read = 0;
		uint8_t rxbuf[128];
		bytes_read = qk_uart_read(COMM_UART_ID, rxbuf, bytes_available);
		rxbuf[bytes_read] = '\0';
		QK_LOG_DEBUG("%s\n", (char*)rxbuf);

		qk_protocol_process_bytes(rxbuf, bytes_read, qk_protocol_comm);
	}
}

void protocol_callback_send_bytes(qk_callback_arg *arg)
{
	uint8_t *buf = QK_BUF_PTR( QK_CALLBACK_ARG_BUF(arg) );
	uint16_t count =  QK_BUF_COUNT( QK_CALLBACK_ARG_BUF(arg) );
	qk_uart_write(COMM_UART_ID, buf, count);
}

void hc05_init()
{
	// Configure GPIO
	qk_gpio_set_mode(BT_MODE, QK_GPIO_MODE_OUTPUT);
	qk_gpio_set_mode(BT_RST, QK_GPIO_MODE_OUTPUT);

	qk_gpio_set_mode(COMM_TX, QK_GPIO_MODE_OUTPUT);
	qk_gpio_set_mode(COMM_RX, QK_GPIO_MODE_INPUT);

	// Enable UART
	qk_uart_enable(COMM_UART_ID);

	// Reset with MODE=1
	qk_gpio_set_pin(BT_MODE, HIGH);
	qk_gpio_set_pin(BT_RST, LOW);
	delay_ms(50);
	qk_gpio_set_pin(BT_RST, HIGH);
	delay_ms(80);

	// Configure serial port parameters (38400, 1 stop bit, no parity)
	qk_uart_write(QK_UART_1, "AT+UART=38400,1,0\r\n", 19);
	delay_ms(200);

	// Reset with MODE=0
	qk_gpio_set_pin(BT_MODE, LOW);
	qk_gpio_set_pin(BT_RST, LOW);
	delay_ms(50);
	qk_gpio_set_pin(BT_RST, HIGH);
	delay_ms(80);
}

void qk_setup()
{
	qk_log_set_levels(QK_LOG_LEVEL_DEBUG);

	qk_board_set_name("Bluetooth 2.0");

	qk_core_register_callback(QK_CORE_CALLBACK_APP,
							  core_callback_app);

	qk_protocol_register_callback(qk_protocol_comm,
								  QK_PROTOCOL_CALLBACK_SENDBYTES,
								  protocol_callback_send_bytes);

	hc05_init();
}

int main()
{
	qk_init();
	qk_loop();
}
