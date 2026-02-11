# AArch64 (ARM64) cross-compilation toolchain
# Full GCC/G++/binutils + libc for aarch64-linux-gnu targets
FROM ubuntu24-base:latest

USER root

ENV CROSS_COMPILE=aarch64-linux-gnu-

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    binutils-aarch64-linux-gnu \
    libc6-dev-arm64-cross \
    linux-libc-dev-arm64-cross \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

USER ubuntu
WORKDIR /home/ubuntu/src
VOLUME ["/home/ubuntu/src"]

CMD ["/bin/bash"]
