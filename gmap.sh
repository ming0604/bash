#!/bin/bash

source /opt/ros/melodic/setup.bash
source devel/setup.bash

if [ -z "$1" ]; then
    echo "No bag"
    echo "Command: bash gmap.sh bag_name"
    exit
else
    echo "Using bag:" $1
    Bag=$1
fi

# if [ -z "$2" ]; then
#     echo "No map_name"
#     echo "Command: bash gmap.sh bag_name map_name"
#     exit
# else
#     echo "Map name:" $2
#     Map=$2
# fi

echo "Opening roscore..."
tmux new -d -s roscore "roscore"
echo "Waiting for roscore to start..."
sleep 5

echo "Setting rosparam..."
rosparam set use_sim_time true

# echo "Connecting tf..."
# tmux new -d -s tf "roslaunch sdc tf.launch"

echo "Starting gmap..."
echo " opening gmapping..."
tmux new -d -s gmap "roslaunch gmapping slam_gmapping_pr2.launch"
echo " playing bag..."
tmux split-window -v -t gmap "rosbag play /data/${Bag}.bag --clock -r 0.5 --pause"

echo "Waiting..."
sleep 5

# echo "Save map..."
# tmux new -d -s smap "bash smap.sh ${Map}"

tmux a -t gmap