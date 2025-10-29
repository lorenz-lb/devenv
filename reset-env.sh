#!/bin/bash
CONTAINER_NAME=$1

echo "STOP CONTAINER"
podman container stop $CONTAINER_NAME 
echo "DELETE CONTAINER"
podman container rm $CONTAINER_NAME 
#echo "DELETE IMAGE"
#podman image rm $IMAGE_NAME 
