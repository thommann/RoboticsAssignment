
#include "Aria.h"
#include <cstdio>

int main(int argc, char **argv)
{
	// Setup
	ArRobot robot;
	Aria::init();
	ArSimpleConnector connector(&argc,argv);
	if (!connector.connectRobot(&robot)){
		printf("Could not connect to robot... exiting\n");
		Aria::shutdown();
		Aria::exit(1);
	}
	robot.comInt(ArCommands::ENABLE, 1);
	robot.runAsync(false);

	// Start of controlling

	// Initially do not move
	robot.lock();
	robot.setVel(0);
	robot.unlock();

	// Print all possible commands
	printf("You can type in your command. With pressing enter, the commands will be executed in order.\n");
	printf("The commands are:\n");
	printf("'w': accelerate\n");
	printf("'s': decelerate\n");
  printf("'a': accelerate left rotation\n");
	printf("'d': accelerate right rotation\n");
	printf("' ': stop robot\n");
	printf("'.': exit program\n");

	// Listen for user input and act accordingly
	// This infinite loop is a workaround because the keyhandler does not work on ARM/newer linux systems.
	int c;
	while(true){
		c = getchar();
		int exit = 0;
		switch(c){
			case 'w':
				robot.setVel(robot.getVel() + 100);
				break;
			case 's':
				robot.setVel(robot.getVel() - 100);
				break;
			case 'a':
				robot.setRotVel(robot.getRotVel() + 5);
				break;
			case 'd':
				robot.setRotVel(robot.getRotVel() - 5);
				break;
			case ' ':
				robot.stop();
				break;
			case '.':
				exit = 1;
				break;
			default:
				break;
		}
		if(exit) break;

		// Wait for the robot to execute the action
		ArUtil::sleep(300);
		printf("%f %f %f\n", robot.getX(), robot.getY(), robot.getTh());
	}
	// End of controlling

	Aria::shutdown();
	Aria::exit(0);
}
