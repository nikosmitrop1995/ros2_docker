#Inspired from OSRF
#Set the ROS distro version
ARG ROS_DISTRO=humble
ARG DEBIAN_FRONTEND=noninteractive

#Get the base image based on the distro selected
FROM ros:${ROS_DISTRO}-ros-core-jammy

# This is to change default user password
ARG USER_NAME="microbot"
ARG USER_PASSWORD="microbot"

# And make it accessible via RUN commands
ENV USER_NAME $USER_NAME
ENV USER_PASSWORD $USER_PASSWORD

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    iputils-ping \
    mlocate \
    nano \
    python3-colcon-common-extensions \
    python3-pip \
    python3-rosdep \
    python3-vcstool \
    wget \ 
    zsh

# Create the user
RUN adduser --quiet --disabled-password --shell /bin/zsh --home /home/$USER_NAME $USER_NAME

# Change its password and add him to sudo group
RUN echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd && usermod -aG sudo $USER_NAME

# Ensure sudo group users are not 
# asked for a password when using 
# sudo command by ammending sudoers file
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> \
    /etc/sudoers

# Login as $USER
USER $USER_NAME

# Install oh-my-zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Scripts used to run ROS 2 and autocomplete on zsh
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.zsh" >> $HOME/.zshrc && \
    echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> $HOME/.zshrc && \
    echo "export _colcon_cd_root=/opt/ros/${ROS_DISTRO}/" >> $HOME/.zshrc && \
    echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.zsh" >> $HOME/.zshrc && \
    echo 'eval "$(register-python-argcomplete3 ros2)"' >> $HOME/.zshrc && \
    echo "source $HOME/workspace/install/local_setup.zsh" >> $HOME/.zshrc
