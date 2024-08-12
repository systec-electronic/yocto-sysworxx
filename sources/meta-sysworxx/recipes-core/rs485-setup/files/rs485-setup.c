#include <stdio.h>
#include <string.h>
#include <strings.h>
#include <unistd.h>
#include <errno.h>
#include <stdlib.h>
#include <fcntl.h>
#include <termios.h>
#include <sys/select.h>
#include <sys/ioctl.h>
#include <linux/serial.h>

int main(int argc, char* argv[]) {

	if (argc != 2) {
		printf("The serial interface must be specified (e.g. /dev/ttyS6)\n");
		exit(1);
	}
	int iInterface = open(argv[1], O_RDWR | O_SYNC);

	if (iInterface < 0) {
		printf("Error when opening the interface (%s): Error %d\n", argv[1], iInterface);
		exit(iInterface);
	}

	struct serial_rs485 RS485;

	ioctl(iInterface, TIOCGRS485, &RS485);
	RS485.flags |= SER_RS485_ENABLED;
	RS485.flags &= ~SER_RS485_RX_DURING_TX;

	ioctl(iInterface, TIOCSRS485, &RS485);
	close(iInterface);
}
