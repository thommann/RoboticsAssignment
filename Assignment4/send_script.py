#!/usr/bin/env python

import sys
import time
from os.path import exists
from typing import List

import numpy as np
import rclpy

from Assignment4 import shapes

sys.path.append('/home/robot/colcon_ws/install/tm_msgs/lib/python3.6/site-packages')
from tm_msgs.msg import *
from tm_msgs.srv import *

import cv2


# arm client
def send_script(script):
    arm_node = rclpy.create_node('arm')
    arm_cli = arm_node.create_client(SendScript, 'send_script')

    while not arm_cli.wait_for_service(timeout_sec=1.0):
        arm_node.get_logger().info('service not availabe, waiting again...')

    move_cmd = SendScript.Request()
    move_cmd.script = script
    arm_cli.call_async(move_cmd)
    arm_node.destroy_node()


# gripper client
def set_io(state):
    gripper_node = rclpy.create_node('gripper')
    gripper_cli = gripper_node.create_client(SetIO, 'set_io')

    while not gripper_cli.wait_for_service(timeout_sec=1.0):
        node.get_logger().info('service not availabe, waiting again...')

    io_cmd = SetIO.Request()
    io_cmd.module = 1
    io_cmd.type = 1
    io_cmd.pin = 0
    io_cmd.state = state
    gripper_cli.call_async(io_cmd)
    gripper_node.destroy_node()


def main(args=None):
    rclpy.init(args=args)

    # --- move command by joint angle ---#
    # script = 'PTP(\"JPP\",45,0,90,0,90,0,35,200,0,false)'

    # --- move command by end effector's pose (x,y,z,a,b,c) ---#
    # targetP1 = "398.97, -122.27, 748.26, -179.62, 0.25, 90.12"s

    # Initial camera position for taking image (Please do not change the values)
    # For right arm: targetP1 = "230.00, 230, 730, -180.00, 0.0, 135.00"
    # For left  arm: targetP1 = "350.00, 350, 730, -180.00, 0.0, 135.00"
    target_p1 = "350.00, 350, 730, -180.00, 0.0, 135.00"
    script1 = "PTP(\"CPP\"," + target_p1 + ",100,200,0,false)"
    send_script(script1)
    send_script("Vision_DoJob(job1)")

    image_idx = 0
    start = time.time()
    while True:
        filename = f'IMG-{image_idx}.png'

        if exists(filename):
            image = cv2.imread(filename)

            objs: List = shapes.detect(image)
            print(str(objs))

            # TODO: Tune robot arm orientation (rz)
            for object in objs:
                x, y, _ = shapes.img2camera(object)
                x, y = (shapes.T @ np.array([x, y + 85, 0, 1]))[:2]

                print(f"Target: {x}, {y}")

                frame = f"{x:.0f}, {y:.0f}, 200, -180.00, 0.0, 135.00"
                script_ptp = "PTP(\"CPP\"," + frame + ",100,200,0,false)"

                send_script(script_ptp)
                set_io(0.0)

                image_idx += 1

        else:
            if time.time() - start > 1000:
                break

    rclpy.shutdown()


if __name__ == '__main__':
    main()
