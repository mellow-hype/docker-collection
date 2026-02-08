FROM ubuntu:24.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # Clang/LLVM tooling
    clang-18 \
    llvm-18 \
    llvm-18-dev \
    libclang-18-dev \
    clang-tools-18 \
    # Build essentials
    build-essential \
    cmake \
    ninja-build \
    git \
    # Python and pip
    python3 \
    python3-pip \
    python3-venv \
    # Utilities
    wget \
    curl \
    vim \
    bear \
    unzip \
    jq \
    # For passwordless sudo
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Grant ubuntu user passwordless sudo access
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu

# Create symbolic links for clang tools (optional, for convenience)
RUN update-alternatives --install /usr/bin/clang clang /usr/bin/clang-18 100 && \
    update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-18 100 && \
    update-alternatives --install /usr/bin/llvm-config llvm-config /usr/bin/llvm-config-18 100

# Create workspace directory structure (as root, before switching to ubuntu)
RUN mkdir -p /workspace \
    && chown -R ubuntu:ubuntu /workspace

# Switch to unprivileged user
USER ubuntu
WORKDIR /home/ubuntu

# Set up Python virtual environment
RUN python3 -m venv /home/ubuntu/venv

# Activate venv and install Python packages
ENV PATH="/home/ubuntu/venv/bin:$PATH"
RUN pip install --no-cache-dir \
    libclang==18.1.1 \
    clang==18.1.8 \
    pyyaml

# Set environment variables for Clang
ENV LLVM_CONFIG=/usr/bin/llvm-config-18
ENV CLANG_LIBRARY_PATH=/usr/lib/llvm-18/lib
ENV LD_LIBRARY_PATH=/usr/lib/llvm-18/lib

WORKDIR /workspace

# Default command
CMD ["/bin/bash"]
