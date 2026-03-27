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
