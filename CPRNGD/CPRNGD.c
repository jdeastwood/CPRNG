#include "stdio.h"
#include "string.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <termios.h>
#include <sys/ioctl.h>
#include <stdlib.h>
#include <errno.h>
#include <syslog.h>
#include <linux/random.h>

#define BAUDRATE B9600
#define DEVICE "/dev/ttyACM2"

void daemonize();

int main() {
	daemonize();

	//TODO: check that we are root.
	
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
			for (int i=0; i < rd; i++) {
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

void daemonize() {
	pid_t pid, sid;
	
	pid = fork();
	if (pid < 0) {
		exit(EXIT_FAILURE);
	}
	if (pid > 0) {
		exit(EXIT_SUCCESS);	
	}
	
	umask(0);

	/*TODO: open some logs here*/

	sid = setsid();
	if (sid < 0) {
		//log!
		exit(EXIT_FAILURE);
	}

	if ((chdir("/")) < 0) {
		//log!		
		exit(EXIT_FAILURE);
	}

	close(STDIN_FILENO);
	close(STDOUT_FILENO);
	close(STDERR_FILENO);

}
