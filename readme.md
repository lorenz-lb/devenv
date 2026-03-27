# devenv

This repo is a porable development environment consisting of neovim and my personal dotfiles.
I use this repo when developing and when I don't want some tools installed on my machine e.g. node or python.


## usage
Build this image with: 
```bash
podman compose up -d --build
```

and enter the container with:
```bash
podman compose exec dev bash
```
