FROM ubuntu:jammy
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install kaitai compiler from deb file
# need to download from: https://github.com/kaitai-io/kaitai_struct_compiler/releases/download/0.10/kaitai-struct-compiler_0.10_all.deb

COPY kaitai-struct-compiler_0.10_all.deb /opt/kaitai-struct-compiler_0.10_all.deb
RUN apt-get update && \
    apt install -y --no-install-recommends /opt/kaitai-struct-compiler_0.10_all.deb && \
    apt-get install -y --no-install-recommends sudo vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# add non-root user with sudo
RUN useradd -m builder &&\
    echo 'builder ALL=NOPASSWD: ALL' > /etc/sudoers.d/builder
USER builder

VOLUME [ "/home/builder/src" ]
WORKDIR /home/builder/src

ENTRYPOINT [ "/bin/bash" ]

