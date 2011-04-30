#include "stdio.h"
#include "string.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <termios.h>
#include <linux/random.h>
#include <sys/ioctl.h>

#define BAUDRATE B9600
#define DEVICE "/dev/ttyACM2"

int main() {
	char reply[6];
	int fd, devrand, rd = 1;
	struct termios tio, oldtio;
	fd = open(DEVICE, O_RDONLY);
	devrand = open("/dev/random", O_WRONLY);
	struct rand_pool_info rand;

	rand.entropy_count = 4;
	rand.buf_size = 6;

	if (fd > 0) {
		printf("open...");
		while (rd) {
			rd =read(fd, reply, 6);
			for (int i=0; i < 6; i++) {
				rand.buf[i] = reply[i];
			}			
			ioctl(devrand, RNDADDENTROPY, &rand);
		}
		close(fd);
		close(devrand);
	}
	else {
		printf("fail");	
	}

}
