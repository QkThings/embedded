#include <qk_program.h>

extern void qk_board_led_blink(unsigned int n, unsigned int msec)
{

}
extern void qk_board_hwfc_out(qk_board_hwfc_state state)
{

}
extern qk_board_hwfc_state qk_board_hwfc_in(void)
{

}
extern void qk_uart_read(uint8_t uart_id, uint8_t *buf, uint16_t count)
{

}
extern void qk_uart_write(uint8_t uart_id, uint8_t *buf, uint16_t count)
{
  
}

void qk_setup()
{

}

int main()
{
  qk_init();
  qk_loop();
  return 0;
}