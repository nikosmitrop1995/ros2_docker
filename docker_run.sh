docker run --name rpi_ros_foxy \
-it \
--privileged \
--restart=always \
--net=host \
--env="DISPLAY" \
--volume="$HOME/.Xauthority:/root/.Xauthority" \
--volume="/dev:/dev" \
--volume="/media:/media" \
nikosmitrop1995/rpi-ros-foxy:test_v1 /bin/zsh