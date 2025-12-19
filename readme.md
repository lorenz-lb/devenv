# devenv

This repo is a porable development environment consisting of neovim and my personal dotfiles.
I use this repo when developing and when I don't want some tools installed on my machine e.g. node (ehw).


## usage
build this image with: 
```bash
podman build -t tmpenv --build-arg HOST_USER=[YOUR USER] .
```

and then start the container with PWD mapped 
```bash
./start-env.sh tmpenv
```
