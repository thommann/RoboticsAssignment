
#include "Aria.h"
#include <cstdio>

int main(int argc, char **argv)
{
	// Setup
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
		// Get Robot Parameters and Sensor Readings
		double reading = sonar.cumulativeReadingPolar(-20, 20);
		double velocity = robot.getVel();
		double rotation_velocity = robot.getRotVel();

		printf("Distance: %f\n", reading);
		printf("Velocity: %f\n", velocity);
		printf("Rotation: %f\n", rotation_velocity);

		if(100 >= velocity && velocity > 0 && reading < velocity * 10){
			// If I am slow and too close to an object, stop the robot
			printf("stop\n");
			robot.setVel(0);
		} else if(velocity > 100 && reading < velocity * 10){
			// if I am fast and too close to an object, slow the robot down
			printf("slow\n");
			robot.setVel(100);
		} else {
			c = getchar();
			int exit = 0;
			switch (c) {
				case 'w':
					printf("accelerate\n");
					robot.setVel(velocity + 100);
					break;
				case 's':
					printf("decelerate\n");
					robot.setVel(velocity - 100);
					break;
				case 'a':
					printf("left\n");
					robot.setRotVel(rotation_velocity + 5);
					break;
				case 'd':
					printf("right\n");
					robot.setRotVel(rotation_velocity - 5);
					break;
				case ' ':
					printf("stop\n");
					robot.stop();
					break;
				case '.':
					printf("exit\n");
					exit = 1;
					break;
				default:
					break;
			}
			if (exit) break;
		}
		// Wait for the robot to execute the action
		ArUtil::sleep(500);
	}
	// End of controling

	Aria::shutdown();
	Aria::exit(0);
}
