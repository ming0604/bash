#!/bin/bash

source /opt/ros/melodic/setup.bash
source devel/setup.bash

if [ -z "$1" ]; then
    echo "No map"
    echo "Command: bash smap.sh map_name"
    exit
else
    echo "Using map:" $1
    map_name=$1
fi

echo "Opening roscore..."
tmux new -d -s roscore "roscore"
echo "Waiting for roscore to start..."
sleep 3

echo "Save map..."
tmux new -d -s smap "rosrun map_server map_saver -f /home/lab816/agv_ws/src/sdc/maps/${map_name} map:=/map"

tmux a -t smap