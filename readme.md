# devenv

This repo is a porable development environment consisting of neovim and my personal dotfiles.
I use this repo when developing and when I don't want some tools installed on my machine e.g. node (ehw).


## usage
build this image with: 
```bash
podman build -t devenv . 
```

and then start the container and map your development directory to the container by executing
```bash
# perhaps remove first
# podman rm [YOUR_CONTAINTER_NAME] 
podman run -it --name [YOUR_CONTAINER_NAMER] --volume [YOUR_DIRECTORY_TO_MAP_INTO_ENV]:/home/devuser/workspace devenv
```
