#!/bin/bash

CONTAINER=$1
IMAGE=$2

USER="devuser"

HOST_UID=$(id -u)
HOST_GID=$(id -g)

get_status() {
    if podman container inspect $CONTAINER &> /dev/null; then
        podman inspect -f '{{.State.Status}}' $CONTAINER
    else
        echo "not_exists"
    fi
}

STATUS=$(get_status)

if [ "$STATUS" = "running" ]; then
    echo "Container '$CONTAINER' already running."

elif [ "$STATUS" = "exited" ]; then
    echo "Start existing container '$CONTAINER'."
    podman start $CONTAINER

elif [ "$STATUS" = "not_exists" ]; then
    echo "Create and run new container '$CONTAINER'."
    podman build -t $IMAGE .
    podman run -d \
        --name $CONTAINER \
        --volume $HOME/code/src/lorenz-lb.github.io:/home/$USER/workspace:U \
        $IMAGE \
        /bin/bash -c "sleep infinity" 

    sleep 3
    podman exec $CONTAINER chmod -R 777 /home/$USER/workspace

    if [ $? -ne 0 ]; then
        echo "Error: Failed to create and run container."
        exit 1
    fi
fi

sleep 1
podman exec -it --user $USER $CONTAINER /bin/bash 

