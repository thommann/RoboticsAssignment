
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

	// 4. Sleep a while and let the robot move
	int c;
	while(true){
		c = getchar();
		switch(c){
			case 'w':
				robot.setVel(robot.getVel() + 10);
				break;
			case 's':
				robot.setVel(robot.getVel() - 10);
				break;
			case ' ':
				robot.stop();
				break;
		}
		printf("%f %f %f\n", robot.getX(), robot.getY(), robot.getTh());
		ArUtil::sleep(1000);
	}

	// End of controling


	Aria::shutdown();

	Aria::exit(0);
}
