ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=America/Los_Angeles \
    TERM=xterm-256color
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Version-specific packages passed via --build-arg (e.g., "curl python3-lzo swig unrar xsltproc")
ARG EXTRA_PACKAGES=""

# Install kernel build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    automake \
    bc \
    bison \
    build-essential \
    bzip2 \
    ca-certificates \
    ccache \
    cpio \
    ecj \
    fakeroot \
    flex \
    gawk \
    gettext \
    git \
    java-propose-classpath \
    libelf-dev \
    liblzma-dev \
    liblzo2-dev \
    libncurses-dev \
    libssl-dev \
    lzop \
    ocaml-nox \
    pkg-config \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    rsync \
    squashfs-tools \
    srecord \
    subversion \
    sudo \
    tmux \
    unzip \
    vim \
    wget \
    zlib1g-dev \
    ${EXTRA_PACKAGES} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m builder && \
    echo 'builder ALL=NOPASSWD: ALL' > /etc/sudoers.d/builder && \
    chmod 0440 /etc/sudoers.d/builder
USER builder

VOLUME [ "/home/builder/images" ]
VOLUME [ "/home/builder/src" ]

WORKDIR /home/builder

ENTRYPOINT [ "/bin/bash" ]
