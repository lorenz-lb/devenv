# =========================
# BASE
# =========================
FROM debian:bookworm AS base

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIM_INSTALL_DIR=/opt/nvim

# Create a home for settings and configs 
ENV HOME=/home/debian
ENV XDG_CONFIG_HOME=/home/debian/.config
RUN mkdir -p /home/debian/.config && \
    mkdir -p /home/debian/.cache && \
    mkdir -p /home/debian/.local && \
    chmod -R 777 /home/debian && \
    chown -R 1000:1000 /home/debian
    

# essentials 
RUN apt update && \
    apt install -y \
      git \
      curl \
      ca-certificates \
      tar \
      gzip \
      unzip \
      build-essential \
      ripgrep \
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

# UV (PYTHON)
RUN apt update && \
    apt install -y \
      python3 \
      python3-pip \
      python3-venv \
      && apt clean && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR=/usr/local/bin sh

# CODE SERVER
RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN mkdir "$XDG_CONFIG_HOME/code-server" && chmod -R 777 "$XDG_CONFIG_HOME/code-server"



