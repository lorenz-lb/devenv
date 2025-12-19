#!/bin/bash


echo "STOP CONTAINER"
podman container stop devenv-ghpages
echo "DELETE CONTAINER"
podman container rm devenv-ghpages
#echo "DELETE IMAGE"
#podman image rm localhost/devenv-ghpages
