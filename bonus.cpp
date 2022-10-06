
#include "Aria.h"
#include "Aria/include/Aria.h"
#include <cmath>
#include <iostream>
#include <cstdio>
#include <sstream>


using namespace std;

void waitForRot(){
	while (true) {
		ArUtil::sleep(500);
		if (robot.getRotVel() == 0) break;
	}
}

void waitForMove(){
	while (true) {
		ArUtil::sleep(500);
		if (robot.getVel() == 0) break;
	}
}

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


	// Start of controling

	// 1. Lock the robot
	robot.lock();

	// 2. Write your control code here,
	//    e.g. robot.setVel(150);
	robot.setVel(0);

	// 3. Unlock the robot
	robot.unlock();

	// 4. Read the command sequence and execute it.
	double initial_x = 5090;
	double initial_y = 3580;
	double initial_th = 3093.97;

	ArPose initialPose(initial_x, initial_y, initial_th);
	robot.moveTo(initialPose);


	double target_x;
	double target_y;
	double target_th;

	int obstacle = 0;

	while(true) {

		if(!obstacle) {
			string input, coord;

			printf("Input your target coordinates: ");

			getline(cin, input);
			printf("Input: %s\n", input.c_str());

			stringstream ss(input.c_str());

			int i = 0;
			while (getline(ss, coord, ' ')) {
				printf("Coord: %s\n", coord.c_str());
				if (i == 0)
					target_x = atof(coord.c_str());
				else if (i == 1)
					target_y = atof(coord.c_str());
				else
					target_th = atof(coord.c_str());
				i++;
			}

			printf("Input doubles: %f %f %f\n", target_x, target_y, target_th);
		}

		obstacle = 0;

		target_x = target_x * 1000;
		target_y = target_y * 1000;
		target_th = radiansToDegrees(target_th);

		double current_x = robot.getX();
		double current_y = robot.getY();

		double delta_x = target_x - current_x;
		double delta_y = target_y - current_y;

		double distance = sqrt(pow(delta_x, 2) + pow(delta_y, 2));
		double angle_rad = atan2(delta_y, delta_x);
		double angle = radiansToDegrees(angle_rad);

		printf("Target:\n");
		printf("\tDirection:\t%f\n", angle);
		printf("\tDistance:\t%f\n", distance);

		printf("Start:\t%f\t%f\t%f\n", robot.getX(), robot.getY(), robot.getTh());

		robot.setHeading(angle);
		waitForRot();

		printf("Target Direction:\t%f\t%f\t%f\n", robot.getX(), robot.getY(), robot.getTh());

		robot.move(distance);
		while (true) {
			ArUtil::sleep(500);
			double reading = sonar.cumulativeReadingPolar(-20, 20);
			if(reading < 500){
				obstacle = 1;
				robot.setDeltaHeading(45);
				waitForRot();
				robot.move(100);
				waitForMove();
				break;
			}
			if (robot.getVel() == 0) break;
		}
		if (obstacle) continue;

		printf("Final Position:\t%f\t%f\t%f\n", robot.getX(), robot.getY(), robot.getTh());

		robot.setHeading(target_th);
		waitForRot();

		printf("Final Heading:\t%f\t%f\t%f\n", robot.getX(), robot.getY(), robot.getTh());
	}

	// End of controling

	Aria::shutdown();

	Aria::exit(0);
}