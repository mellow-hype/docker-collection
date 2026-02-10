# DEPRECATED: Ubuntu 13.04 reached EOL January 2014. Package repositories
# are no longer available. This Dockerfile is retained for reference only
# and will not build successfully.
FROM i386/ubuntu:13.04
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    bzip2 \
    git-core \
    gzip \
    liblzma-dev \
    liblzo2-dev \
    ocaml-nox gawk \
    lzop \
    python-lzo \
    squashfs-tools \
    srecord \
    tar \
    unzip \
    perl \
    rsync \
    bison \
    flex \
    fakeroot \
	ccache ecj fastjar \
    gettext git java-propose-classpath libelf-dev libncurses5-dev \
    libncursesw5-dev libssl-dev python python2.7-dev \
    subversion \
    gcc-multilib \
    pkg-config \
    wget \
    sudo \
    cpio \
    bc \
    vim \
    zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m builder &&\
    echo 'builder ALL=NOPASSWD: ALL' > /etc/sudoers.d/builder &&\
    chmod 0440 /etc/sudoers.d/builder
USER builder

VOLUME [ "/home/builder/images" ]

WORKDIR /home/builder

ENTRYPOINT [ "/bin/bash" ]
