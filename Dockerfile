# This is an auto generated Dockerfile for ros:ros-base
# generated from docker_images_ros2/create_ros_image.Dockerfile.em
FROM ros:foxy-ros-core-focal

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    python3-colcon-common-extensions \
    python3-colcon-mixin \
    python3-rosdep \
    python3-vcstool \
    iputils-ping \
    mlocate \
    zsh wget \
    && rm -rf /var/lib/apt/lists/*

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

# install ros2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-foxy-ros-base=0.9.2-1*   
    # && rm -rf /var/lib/apt/lists/*
RUN cd $HOME && \
    git config --global user.email "nikosmitrop1995@gmail.com" && \
    git config --global user.name "Nikos Mitropoulos" && \
    wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh && \ 
    sh install.sh && \
    chsh -s $(which zsh) && \
    rm install.sh 

RUN . /opt/ros/$ROS_DISTRO/setup.sh && \
    mkdir -p $HOME/colcon_ws/src && \ 
    cd $HOME/colcon_ws/src && \
    git clone https://github.com/nikosmitrop1995/learn_ros.git && \
    git clone -b dev https://github.com/nikosmitrop1995/darkpaw_ros && \
    cd $HOME/colcon_ws/ && \
    rosdep install -i --from-path src --rosdistro $ROS_DISTRO -y && \
    colcon build && \
    echo "source /opt/ros/foxy/setup.zsh" >> $HOME/.zshrc && \ 
    echo "source $HOME/colcon_ws/install/local_setup.zsh" >> $HOME/.zshrc

# ENTRYPOINT ["/ros_entrypoint.sh"]
# CMD ["zsh"]