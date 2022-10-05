
#include "Aria.h"
//#include "Aria/include/Aria.h"
#include <cstdio>

int main(int argc, char **argv)
{
	ArRobot robot;
	ArSonarDevice sonar;

	robot.addRangeDevice(&sonar);

	Aria::init();

	ArSimpleConnector connector(&argc,argv);

	if (!connector.connectRobot(&robot)){
		printf("Could not connect to robot... exiting\n");
		Aria::shutdown();
		Aria::exit(1);
	}

	robot.comInt(ArCommands::ENABLE, 1);

	robot.runAsync(false);

	// Used to perform actions when keyboard keys are pressed
	// ArKeyHandler keyHandler;
	// Aria::setKeyHandler(&keyHandler);

	// ArRobot contains an exit action for the Escape key. It also
	// stores a pointer to the keyhandler so that other parts of the program can
	// use the same keyhandler.
	// robot.attachKeyHandler(&keyHandler);
	// printf("You may press escape to exit\n");

	// TODO: control the robot

	// Start of controling

	// 1. Lock the robot
	robot.lock();

	// 2. Write your control code here,
	//    e.g. robot.setVel(150);
	robot.setVel(0);


	// 3. Unlock the robot
	robot.unlock();

	// 4. Read the command sequence and execute it.
	printf("You can type in your command. With pressing enter, the commands will be executed in order.\n");
	printf("The commands are:\n");
	printf("'w': accelerate\n");
	printf("'s': decelerate\n");
  printf("'a': accelerate left rotation\n");
	printf("'d': accelerate right rotation\n");
	printf("' ': stop robot\n");
	printf("'.': exit program\n");

	int c;
	while(true){
		double reading = sonar.cumulativeReadingPolar(-20, 20);
		if(robot.getVel() > 0 && reading < 300){
			robot.setVel(0);
		} else if(robot.getVel() > 100 && reading < 600){
			robot.setVel(100);
		} else {
			c = getchar();
			int exit = 0;
			switch (c) {
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
			if (exit) break;
		}
		ArUtil::sleep(300);
	}

	// End of controling


	Aria::shutdown();

	Aria::exit(0);
}
