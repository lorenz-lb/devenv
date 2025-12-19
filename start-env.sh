# vars
IMAGE=$1
CONTAINER=$2

check_parameter() {
    if [ -z "$IMAGE" ]; then
        echo "Please specify parameter 1 (Image Name)"
        exit 1
    fi

    if [ -z "$CONTAINER" ]; then
        echo "Using image parameter ('$CONTAINER') as Container Name"
        CONTAINER=$IMAGE
    fi
}

get_status() {
    if podman container inspect $CONTAINER &> /dev/null; then
        podman inspect -f '{{.State.Status}}' $CONTAINER
    else
        echo "not_exists"
    fi
}

start_container() {
    echo "Start existing container '$CONTAINER'."
    podman start $CONTAINER
}

exec_into_container() {
    echo "Exec into Container '$CONTAINER'"
    podman exec -it  $CONTAINER /bin/bash 
}

create_container() {
    echo "Creating container '$CONTAINER'"
    podman create \
        --name $CONTAINER \
        --volume "${PWD}":/workspace:Z \
        --userns=keep-id \
        --replace \
        -p 5173:5173 \
        $IMAGE \
        /bin/bash -c "sleep infinity" 
}

choose_action() {
    STATUS=$(get_status)

    echo "Container status is: '$STATUS'"

    # possible status: 
        # not_exist
        # running
        # exited
        # created
    
    if [ "$STATUS" = "running" ]; then
        # container running, exec into it
        echo "Container '$CONTAINER' already running."
        sleep 1
        exec_into_container

    elif [ "$STATUS" = "exited" ]; then
        # start up container then exec into it
        echo "Container '$CONTAINER' found"
        start_container
        sleep 3
        exec_into_container

    elif [ "$STATUS" = "created" ]; then
        # start up container then exec into it
        echo "Container '$CONTAINER' found"
        start_container
        sleep 3
        exec_into_container

    elif [ "$STATUS" = "not_exists" ]; then
        # no container created, create and run then exec into it
        echo "No container found, "
        create_container
        sleep 3
        start_container
        sleep 3
        exec_into_container
    else
        echo "#################### NO OPTION CHOOSEN THIS CANT HAPPEN! ##############################"
    fi

}

check_parameter

echo "###### Using '$IMAGE' for container '$CONTAINER' ######"

choose_action

