# ros2_docker
Dockerfile for ROS2 Container

### Pull the image:
```
./docker_pull
```
### Bring up the image:
```
./docker_run
```
### Attach terminal to the image:
```
./docker_exec
```
If you want to run the commands from any directory without using `./` :
```
echo "export PATH=$PATH:{path_where_the_repo_is_located}/ros2_docker" >> $HOME/.bashrc
source ~/.bashrc
```
OR
```
echo "export PATH=$PATH:{path_where_the_repo_is_located}/ros2_docker" >> $HOME/.zshrc
source ~/.zshrc
```
