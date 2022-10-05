
#include "Aria.h"
//#include "Aria/include/Aria.h"
#include <cmath>
#include <cstdio>
#include <sstream>


using namespace std;

double radiansToDegrees(double radians)
{
	return radians * 180 / M_PI;
}

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
	double target_x;
	double target_y;
	double target_th;

	while(true) {
		string target_x_string = "";
		string target_y_string = "";
		string target_th_string = "";

		printf("Input your target coordinates: ");
		int c;
		int coords = 3;
		while(true) {
			int exit = 0;
			c = getchar();
			switch(c) {
				case ' ':
					coords -= 1;
					break;
				case '\n':
					exit = 1;
					break;
				default:
					stringstream ss = c;
					if (coords == 3)
						target_x_string += ss.str();
					else if (coords == 2)
						target_y_string += ss.str();
					else if (coords == 1)
						target_th_string += ss.str();
					else:
						print("ERROR: %c", c);
					break;
			}
			if (exit){
				break;
			}
		}

		printf("Input: %s %s %s\n", target_x_string, target_y_string, target_th_string);

		double target_x = 7000;
		double target_y = 5000;
		double target_th = 90;

		double initial_x = 5090;
		double initial_y = 3580;
		double initial_th = 3093.97;

		double delta_x = target_x - initial_x;
		double delta_y = target_y - initial_y;

		double distance = sqrt(pow(delta_x, 2) + pow(delta_y, 2));

		double angle_rad = atan2(delta_y, delta_x);

		double angle = radiansToDegrees(angle_rad);

		printf("Target:\n");
		printf("Direction:\t%f\n", angle);
		printf("Distance:\t%f\n", distance);

		ArPose currentPose(initial_x, initial_y, initial_th);
		robot.moveTo(currentPose);

		printf("Start:\t%f\t%f\t%f\n", robot.getX(), robot.getY(), robot.getTh());

		robot.setHeading(angle);
		ArUtil::sleep(500);
		while (true) {
			if (robot.getRotVel() == 0) break;
			ArUtil::sleep(500);
		}

		printf("Target Direction:\t%f\t%f\t%f\n", robot.getX(), robot.getY(), robot.getTh());

		robot.move(distance);
		ArUtil::sleep(500);
		while (true) {
			if (robot.getVel() == 0) break;
			ArUtil::sleep(500);
		}

		printf("Final Position:\t%f\t%f\t%f\n", robot.getX(), robot.getY(), robot.getTh());

		robot.setHeading(target_th);
		ArUtil::sleep(500);
		while (true) {
			if (robot.getRotVel() == 0) break;
			ArUtil::sleep(500);
		}

		printf("Final Heading:\t%f\t%f\t%f\n", robot.getX(), robot.getY(), robot.getTh());
	}

	// End of controling

	Aria::shutdown();

	Aria::exit(0);
}
