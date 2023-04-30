#Inspired from OSRF
#Set the ROS distro version
ARG ROS_DISTRO=foxy
ARG DEBIAN_FRONTEND=noninteractive

#Get the base image based on the distro selected
FROM ros:${ROS_DISTRO}-ros-core-focal

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
    openssh-client \
    python3-colcon-common-extensions \
    python3-colcon-mixin \
    python3-pip \
    python3-rosdep \
    python3-vcstool \
    ros-${ROS_DISTRO}-demo-nodes-cpp \
    wget \ 
    zsh \
    && pip3 install adafruit-circuitpython-servokit

# bootstrap rosdep
RUN rosdep init && \
    rosdep update --rosdistro $ROS_DISTRO

# setup colcon mixin and metadata
RUN colcon mixin add default \
        https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && \
    colcon mixin update && \
    colcon metadata add default \
        https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml && \
    colcon metadata update

RUN cd $HOME && \
    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh && \ 
    sh install.sh && \
    chsh -s $(which zsh) && \
    rm install.sh 

RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    mkdir -p $HOME/colcon_ws/src && \ 
    cd $HOME/colcon_ws/ && \
    rosdep install -i --from-path src --rosdistro $ROS_DISTRO -y && \
    colcon build && \
    echo "source /opt/ros/${ROS_DISTRO}/setup.zsh" >> $HOME/.zshrc && \ 
    echo "source $HOME/colcon_ws/install/local_setup.zsh" >> $HOME/.zshrc
