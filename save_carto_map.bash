#!/bin/bash

# Usage: ./save_carto_map.sh <pbstream_filename> <map_filestem> <resolution>
# Example: ./save_carto_map.sh mymap.pbstream mymap 0.05

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <pbstream_filename> <map_filename> <resolution>"
    exit 1
fi

# Define parameters
PBSTREAM_FILENAME=$1       # The name of the pbstream file to save
MAP_FILENAME=$2            # The base name of the map files (without extension)
RESOLUTION=$3              # The resolution for the map

# Define file paths
PBSTREAM_PATH="/home/mingzhun/lab_localization/src/husky_cartographer_navigation/pbstream/${PBSTREAM_FILENAME}.pbstream"  # Full path to the pbstream file
MAP_PATH="/home/mingzhun/lab_localization/src/husky_cartographer_navigation/maps/${MAP_FILENAME}"            # Full path for the map file

# Ros env source
source /home/mingzhun/carto_ws/devel_isolated/setup.bash
source /home/mingzhun/lab_localization/devel/setup.bash --extend

# Call the /finish_trajectory service to finish mapping
echo "Finishing trajectory..."
rosservice call /finish_trajectory 0

# Call the /write_state service to save the pbstream file
echo "Saving pbstream to ${PBSTREAM_PATH}..."
rosservice call /write_state "{filename: '${PBSTREAM_PATH}'}"

# Convert the pbstream to a ROS-compatible map using the specified resolution
echo "Converting pbstream to map..."
rosrun cartographer_ros cartographer_pbstream_to_ros_map \
    -map_filestem=${MAP_PATH} \
    -pbstream_filename=${PBSTREAM_PATH} \
    -resolution=${RESOLUTION}

echo "Map saved as ${MAP_PATH} with resolution ${RESOLUTION}."
