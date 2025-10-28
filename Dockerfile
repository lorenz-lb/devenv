FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive
ENV NVIM_INSTALLER_DIR="/opt/nvim"

RUN apt update && \
    apt install -y git curl python3 python3-pip && \
    apt clean

WORKDIR /tmp

RUN mkdir $NVIM_INSTALLER_DIR && \
    curl -LO https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz && \
    tar xzvf nvim-linux-x86_64.tar.gz --directory=$NVIM_INSTALLER_DIR --strip-components=1 && \
    ln -s $NVIM_INSTALLER_DIR/bin/nvim /usr/bin/nvim

ENV PATH="$NVIM_INSTALL_DIR/bin:$PATH"

ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=1000

# delete user if exists
RUN if getent passwd $USER_UID ; then \
        USER_TO_DEL=$(getent passwd $USER_UID | cut -d: -f1) ; \
        echo "Removing conflicting user $USER_TO_DEL" ; \
        userdel --remove $USER_TO_DEL || true; \
    fi

RUN groupadd -g $USER_GID $USERNAME || true && \
    useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME

WORKDIR /home/$USERNAME
USER $USERNAME

# clone dotfiles for custom settings
RUN git clone https://github.com/lorenz-lb/personal_kickstart.nvim.git /home/$USERNAME/.config/nvim

RUN mkdir /home/$USERNAME/workspace

CMD ["/bin/bash"]
