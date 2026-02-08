#!/usr/bin/env bash

apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    wget \
    ca-certificates \
    tk-dev \
    libncursesw5-dev \
    libssl-dev \
    libsqlite3-dev \
    libgdbm-dev \
    libc6-dev \
    libbz2-dev \
    libffi-dev \
    zlib1g-dev

apt-get clean && rm -rf /var/lib/apt/lists/*

wget https://www.python.org/ftp/python/3.10.16/Python-3.10.16.tgz -O /opt/python-3.10.16.tgz
cd /opt && tar xfz /opt/python-3.10.16.tgz
cd Python-3.10.16

# compile
./configure --enable-optimizations
make altinstall -j12

# create python3 symlink so this version is first on PATH
ln -s /usr/local/bin/python3.10 /usr/local/bin/python3

# upgrade pip
/usr/local/bin/python3.10 -m pip install --upgrade pip
