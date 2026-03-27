<<<<<<< HEAD
# =========================
# BASE
# =========================
FROM ubuntu:24.04 AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIM_INSTALL_DIR=/opt/nvim
ENV XDG_CONFIG_HOME=/opt/xdg

RUN apt update && \
    apt install -y \
      git \
      curl \
      ca-certificates \
      tar \
      gzip \
      unzip \
      build-essential \
      && apt clean && rm -rf /var/lib/apt/lists/*

# install latest neovim (no apt)
RUN curl -LO https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz && \
    mkdir -p "$NVIM_INSTALL_DIR" && \
    tar xzf nvim-linux-x86_64.tar.gz --directory="$NVIM_INSTALL_DIR" --strip-components=1 && \
    ln -s "$NVIM_INSTALL_DIR/bin/nvim" /usr/local/bin/nvim && \
    rm nvim-linux-x86_64.tar.gz

RUN mkdir -p "$XDG_CONFIG_HOME" && \
    git clone https://github.com/lorenz-lb/personal_kickstart.nvim.git "$XDG_CONFIG_HOME/nvim" && \
    chmod -R 777 "$XDG_CONFIG_HOME/nvim"


# workspace
WORKDIR /workspace

CMD ["sleep", "infinity"]

# =========================
# PYTHON
# =========================
FROM base AS python

RUN apt update && \
    apt install -y \
      python3 \
      python3-pip \
      python3-venv \
      && apt clean && rm -rf /var/lib/apt/lists/*
=======
FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIM_INSTALLER_DIR="/opt/nvim"
ENV PATH="$NVIM_INSTALL_DIR/bin:$PATH"
ARG HOST_USER=defaultuser
ENV HOME="/home/$HOST_USER"


RUN apt update && \
    apt install -y git curl sudo python3 python3-pip && \
    apt clean

RUN useradd -m -s /bin/bash $HOST_USER && \
    echo "$HOST_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# NeoVim installation
RUN mkdir $NVIM_INSTALLER_DIR && \
    curl -LO https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz && \
    tar xzvf nvim-linux-x86_64.tar.gz --directory=$NVIM_INSTALLER_DIR --strip-components=1 && \
    ln -s $NVIM_INSTALLER_DIR/bin/nvim /usr/bin/nvim

# load dotfiles
RUN git clone https://github.com/lorenz-lb/personal_kickstart.nvim.git /home/$HOST_USER/.config/nvim

RUN chown -R $HOST_USER:$HOST_USER /home/$HOST_USER

WORKDIR /workspace 

# rust for Wasm  
#RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
#ENV PATH="$PATH:$HOME/.cargo/bin"

CMD ["sleep", "infinity"]
>>>>>>> 65f1d12e185129c0c597bc6f452f52084809e8b0
