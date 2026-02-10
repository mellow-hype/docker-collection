ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=ubuntu
ARG EXTRA_PACKAGES=""

RUN apt-get update && apt-get install -y \
    curl \
    git \
    tmux \
    build-essential \
    ca-certificates \
    gnupg \
    ripgrep \
    lsb-release \
    python3 \
    python3-pip \
    python3-venv \
    wget \
    sudo \
    vim \
    nano \
    ${EXTRA_PACKAGES} \
    && rm -rf /var/lib/apt/lists/*

RUN if ! id -u ${USERNAME} >/dev/null 2>&1; then \
        useradd -m -s /bin/bash -u 1000 ${USERNAME}; \
    fi && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

RUN mkdir -p /workspace && chown ${USERNAME}:${USERNAME} /workspace

USER ${USERNAME}

RUN curl -fsSL https://claude.ai/install.sh | bash -

WORKDIR /workspace
ENV TERM=xterm-256color

RUN echo 'alias ll="ls -lah"' >> /home/${USERNAME}/.bashrc \
    && echo 'export PS1="\[\033[01;32m\]claude-code-container\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> /home/${USERNAME}/.bashrc \
    && echo "export PATH=\"/home/${USERNAME}/.local/bin:\$PATH\"" >> /home/${USERNAME}/.bashrc \
    && echo 'echo "Welcome to Claude Code Docker Container"' >> /home/${USERNAME}/.bashrc \
    && echo 'echo "Your project should be mounted at /workspace"' >> /home/${USERNAME}/.bashrc \
    && echo 'echo ""' >> /home/${USERNAME}/.bashrc

CMD ["/bin/bash"]
