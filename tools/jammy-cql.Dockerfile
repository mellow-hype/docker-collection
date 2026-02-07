# Container set up with CodeQL and baseline build tools. Based on Ubuntu 22.04
FROM ubuntu:jammy
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    bzip2 \
    cmake \
    git-core \
    gzip \
    lzop \
    ocaml-nox \
    gawk \
    python2.7-dev \
    python3 \
    python3-lzo \
    python3-pip \
    python3-setuptools \
    python3-dev \
    squashfs-tools \
    srecord \
    tar \
    unzip \
    perl \
    rsync \
    bison \
    flex \
    fakeroot \
    ccache \
    ninja-build \
    meson \
    ecj \
    fastjar \
    gettext \
    git \
    java-propose-classpath \
    rsync \
    subversion \
    pkg-config \
    wget \
    sudo \
    cpio \
    bc \
    vim \
    liblzma-dev \
    liblzo2-dev \
    libelf-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libssl-dev \
    zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# download and set up codeql
ADD https://github.com/github/codeql-action/releases/download/codeql-bundle-v2.17.6/codeql-bundle-linux64.tar.gz /opt/
RUN cd /opt && tar -xzf /opt/codeql-bundle-linux64.tar.gz && cp /opt/codeql/codeql /usr/local/bin/codeql

# add non-root user required for buildroot
RUN useradd -m builder &&\
    echo 'builder ALL=NOPASSWD: ALL' > /etc/sudoers.d/builder
USER builder

# this is where images produced by buildroot will be copied for export to the host
VOLUME [ "/home/builder/src" ]

ENTRYPOINT [ "/bin/bash" ]


