#!/bin/bash

WS_DIR=$(realpath $(dirname $0)/../../../)
REPO_NAME="purduearc/rocket-league"
CONTAINER_NAME="${CONTAINER_NAME:-arc-rocket-league-dev}"
echo "mounting host directory $WS_DIR as container directory /home/$USER/catkin_ws"

# tty-specific options
if [ -t 0 -a -t 1 ]
then
    TTY_OPTS="-it"
fi

docker run --rm \
    $TTY_OPTS \
    -e USER \
    -e DISPLAY \
    -e NVIDIA_DRIVER_CAPABILITIES=all \
    -v $XAUTHORITY:/home/$USER/.Xauthority \
    -v $WS_DIR:/home/$USER/catkin_ws \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v ~/.gitconfig:/home/$USER/.gitconfig:ro \
    -v ~/.ssh:/home/$USER/.ssh:ro \
    --name $CONTAINER_NAME \
    --network=host \
    --gpus all \
    $@ \
    $REPO_NAME:local \
    ${DOCKER_CMD:+/bin/zsh -c "$DOCKER_CMD"}
