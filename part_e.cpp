
#include "Aria.h"
//#include "Aria/include/Aria.h"
#include <cmath>

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
	double target_x = 7000;
	double target_y = 5000;
	double target_th = 90;

	double initial_x = 5090;
	double initial_y = 3580;
	double initial_th = 3093.97;

	double delta_x = target_x - initial_x;
	double delta_y = target_y - initial_y;

	double distance = sqrt(pow(delta_x, 2) + pow(delta_y, 2));

	double angle = atan2(delta_y, delta_x);

	printf("Angle: %f\n", angle);
	printf("Distance: %f\n", distance);

	ArPose currentPose(initial_x, initial_y, initial_th);
	robot.moveTo(currentPose);

	robot.setHeading(angle);
	ArUtil::sleep(10000);

	robot.move(distance);

	while(true){
		double odo_x = robot.getX();
		double odo_y = robot.getY();
		double odo_th = robot.getTh();

		printf("Odometry: %f %f %f\n", odo_x, odo_y, odo_th);
		ArUtil::sleep(500);
	}

	// End of controling

	Aria::shutdown();

	Aria::exit(0);
}
