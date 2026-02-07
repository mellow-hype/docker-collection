#!/usr/bin/env bash

# ensure minimum deps are installed
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    build-essential \
    gdb \
    file \
    python3 \
    python3-pip \
    python3-dev \
    git libssl-dev libffi-dev

# install pwntools
python3 -m pip install -upgrade pip
python3 -m pip install -upgrade pwntools

echo "finished installing pwntools"
