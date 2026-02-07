#!/usr/bin/env bash

cd /opt
wget https://www.python.org/ftp/python/3.10.16/Python-3.10.16.tgz -O /opt/python-3.10.16.tgz
tar xfz /opt/python-3.10.16.tgz
cd Python-3.10.16

# compile
./configure --enable-optimizations
make altinstall -j12

# create python3 symlink so this version is first on PATH
ln -s /usr/local/bin/python3.10 /usr/local/bin/python3
