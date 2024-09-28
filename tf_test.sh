#!/bin/bash

source devel/setup.bash

echo "Connecting tf..."
tmux new -d -s tf "roslaunch accurate_localization tf_test.launch"

tmux a -t tf
