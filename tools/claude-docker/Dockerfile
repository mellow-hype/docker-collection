# Use Ubuntu 24.04 as base image
FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
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
    && rm -rf /var/lib/apt/lists/*

# grant passwordless sudo to ubuntu user
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu

# Create a workspace directory for mounting projects
RUN mkdir -p /workspace && chown ubuntu:ubuntu /workspace

# Switch to ubuntu user
USER ubuntu

# Install Claude Code native
RUN curl -fsSL https://claude.ai/install.sh | bash -

# Switch working dir and set up environment variables
WORKDIR /workspace
ENV TERM=xterm-256color

# Add helpful aliases and prompt customization
RUN echo 'alias ll="ls -lah"' >> /home/ubuntu/.bashrc \
    && echo 'export PS1="\[\033[01;32m\]claude-code-container\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> /home/ubuntu/.bashrc \
    && echo 'export PATH="/home/ubuntu/.local/bin:$PATH"' >> /home/ubuntu/.bashrc \
    && echo 'echo "Welcome to Claude Code Docker Container"' >> /home/ubuntu/.bashrc \
    && echo 'echo "Your project should be mounted at /workspace"' >> /home/ubuntu/.bashrc \
    && echo 'echo ""' >> /home/ubuntu/.bashrc

# Default command is bash
CMD ["/bin/bash"]
