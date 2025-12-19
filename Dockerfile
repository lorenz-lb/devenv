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
