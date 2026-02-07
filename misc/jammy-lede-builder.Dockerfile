FROM jammy-base:latest

RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y \
    clang flex bison g++ gawk \
    gcc-multilib g++-multilib \
    gettext \
    libncurses-dev \
    libssl-dev \
    python3-distutils \
    python3-setuptools \
    rsync \
    swig \
    unzip \
    zlib1g-dev \
    file \
    wget && \
    sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*
