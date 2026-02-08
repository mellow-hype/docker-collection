FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles
ENV TERM=xterm-256color

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential make automake autoconf libtool \
    gcc g++ gcc-multilib g++-multilib \
    bison flex gawk texinfo m4 \
    libgmp-dev libmpc-dev libmpfr-dev \
    zlib1g-dev libelf-dev libssl-dev libisl-dev \
    python3 perl gettext \
    wget curl git xz-utils tar bzip2 gzip patch unzip \
    diffutils file rsync pkg-config ca-certificates \
    sudo vim locales \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen && locale-gen
ENV LANG=en_US.UTF-8

RUN useradd -m builder && \
    echo 'builder ALL=NOPASSWD: ALL' > /etc/sudoers.d/builder

RUN mkdir -p /home/builder/toolchains /home/builder/build && \
    chown -R builder:builder /home/builder/toolchains /home/builder/build
ENV TOOLCHAIN_PREFIX=/home/builder/toolchains

USER builder
VOLUME ["/home/builder/images"]
VOLUME ["/home/builder/src"]
WORKDIR /home/builder
ENTRYPOINT ["/bin/bash"]
