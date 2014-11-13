#include <qk_program.h>
#include <qk_peripheral.h>
#include <qk_debug.h>

#define UART_ID			1  //FIXME

bool send = true;

void core_callback_app(qk_callback_arg *arg)
{
	char str[7] = "hello\n\0";
	if(send)
	{
		qk_uart_write(QK_UART_1, (uint8_t*)str, 7);
		send = false;
	}

	if(qk_uart_bytes_available(QK_UART_1) > 0)
	{
		char rxbuf[16];
		qk_uart_read(QK_UART_1, rxbuf, 16);
		QK_LOG_DEBUG("rx: %s\n", rxbuf);
		send = true;
	}
}

void protocol_callback_send_bytes(qk_callback_arg *arg)
{
//	uint8_t *buf = QK_BUF_PTR( QK_CALLBACK_ARG_BUF(arg) );
//	uint16_t count =  QK_BUF_COUNT( QK_CALLBACK_ARG_BUF(arg) );
//	qk_uart_write(UART_ID, buf, count);
}

void qk_setup()
{
	qk_board_set_name("Bluetooth 2.0");

	qk_core_register_callback(QK_CORE_CALLBACK_APP,
							  core_callback_app);

	qk_protocol_register_callback(qk_protocol_comm,
								  QK_PROTOCOL_CALLBACK_SENDBYTES,
								  protocol_callback_send_bytes);


	qk_peripheral_setup();


	qk_gpio_set_mode(QK_GPIO_PC0, QK_GPIO_MODE_INPUT);
	qk_gpio_set_mode(QK_GPIO_PC1, QK_GPIO_MODE_OUTPUT);
	qk_uart_set_baudrate(QK_UART_1, 38400);
	qk_uart_enable(QK_UART_1, true);


//	qk_protocol_comm->callback.send_packet = comm_send_packet;
//	qk_protocol_comm->callback.process_packet = comm_process_packet;

//	qk_comm_set_callback(QK_COMM_CALLBACK_SENDPACKET, 		comm_send_packet);
//	qk_comm_set_callback(QK_COMM_CALLBACK_PROCESSRXPACKET,	comm_process_rx_packet);

//	_hal_uart2.rx_callback = bluetooth_spp_processRxByte;
}

int main()
{
	qk_main();
}
