#!/usr/bin/env bash

# ensure minimum deps are installed
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    build-essential \
    python3 \
    python3-pip \
    python3-dev \
    libssl-dev \
    libffi-dev

sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/*

# install pwntools
python3 -m pip install --upgrade pip
python3 -m pip install --upgrade pwntools

sudo apt-get clean
echo "finished installing pwntools"
