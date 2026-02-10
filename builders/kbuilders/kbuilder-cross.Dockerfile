ARG BASE_IMAGE=ubuntu24-kbuild-base:latest
FROM ${BASE_IMAGE}

ARG CROSS_PACKAGES=""

RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    ${CROSS_PACKAGES} && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

USER builder
WORKDIR /home/builder
