
#include "Aria.h"
//#include "Aria/include/Aria.h"
#include <cmath>
#include <iostream>
#include <cstdio>
#include <sstream>


using namespace std;

void waitForRot(ArRobot &robot){
	while (true) {
		ArUtil::sleep(500);
		if (robot.getRotVel() == 0) break;
	}
}

void waitForMove(ArRobot &robot){
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

	// Initially do not move
	robot.lock();
	robot.setVel(0);
	robot.unlock();

	// Set the robots initial position
	double initial_x = 0;
	double initial_y = 0;
	double initial_th = 0;
	ArPose initialPose(initial_x, initial_y, initial_th);
	robot.moveTo(initialPose);

	// Target coordinates and rotation
	double target_x;
	double target_y;
	double target_th;

	// Obstacle flag
	int obstacle = 0;

	while(true) {
		if(!obstacle) {
			// Get user input
			string input, coord;
			printf("Input your target coordinates: ");
			getline(cin, input);
			printf("Input: %s\n", input.c_str());
			// Split string
			stringstream ss(input.c_str());
			int i = 0;
			while(getline(ss, coord, ' ')){
				printf("Coord: %s\n", coord.c_str());
				if(i==0)
					target_x = atof(coord.c_str());
				else if (i==1)
					target_y = atof(coord.c_str());
				else
					target_th = atof(coord.c_str());
				i++;
			}
			printf("Input doubles: %f %f %f\n", target_x, target_y, target_th);

			// Calculate robot coordinates
			target_x = target_x * 1000;
			target_y = target_y * 1000;
			target_th = radiansToDegrees(target_th);
		}

		// Reset flag
		obstacle = 0;

		// Current position
		double current_x = robot.getX();
		double current_y = robot.getY();

		// Delta to target
		double delta_x = target_x - current_x;
		double delta_y = target_y - current_y;

		// Angle and distance to target
		double distance = sqrt(pow(delta_x, 2) + pow(delta_y, 2));
		double angle_rad = atan2(delta_y, delta_x);
		double angle = radiansToDegrees(angle_rad);
		printf("Target:\n");
		printf("\tDirection:\t%f\n", angle);
		printf("\tDistance:\t%f\n", distance);

		// Print start position and rotation
		printf("Start:\t%f\t%f\t%f\n", robot.getX(), robot.getY(), robot.getTh());

		// Set the heading to face target
		robot.setHeading(angle);
		// Wait for rotation to finish
		waitForRot(robot);

		// Print position and rotation after heading is set
		printf("Target Direction:\t%f\t%f\t%f\n", robot.getX(), robot.getY(), robot.getTh());

		// Move to target position
		robot.move(distance);
		// Wait for movement to start
		ArUtil::sleep(500);
		while (true) {
			// Wait for movement to finish

			// Read readings in a 45° angle left and right
			double reading_left = sonar.cumulativeReadingPolar(-45, 0);
			double reading_right = sonar.cumulativeReadingPolar(0, 45);
			double reading_max = max(reading_left, reading_right);
			printf("Max Reading: %f\n", reading_max);
			// If an obstacle is too close, start the avoidance
			if(reading_max < 5000 && (reading_max < 200 || reading_max < robot.getVel())){
				// Set obstacle flag to true
				obstacle = 1;
				printf("Obstacle: %f %f\n", reading_left, reading_right);
				// Stop the robot
				robot.stop();
				// Wait until stopped
				waitForMove(robot);
				if(reading_right > reading_left){
					// Turn left if obstacle is right
					robot.setDeltaHeading(90);
				} else {
					// Turn right if obstacle is left
					robot.setDeltaHeading(-90);
				}
				// Wait for rotation to finish
				waitForRot(robot);
				// Move 1000 units in new direction
				robot.move(1000);
				// Wait for movement to finish
				waitForMove(robot);
				break;
			}
			// break if reached target
			if (robot.getVel() == 0 && reading_max >= 1000) break;
			ArUtil::sleep(200);
		}
		// After avoiding obstacle, try again to go to target
		if (obstacle) continue;

		// Print final position
		printf("Final Position:\t%f\t%f\t%f\n", robot.getX(), robot.getY(), robot.getTh());

		// Set final heading
		robot.setHeading(target_th);
		waitForRot(robot);

		// Print final position and heading
		printf("Final Heading:\t%f\t%f\t%f\n", robot.getX(), robot.getY(), robot.getTh());
	}
	// End of controling

	Aria::shutdown();
	Aria::exit(0);
}
