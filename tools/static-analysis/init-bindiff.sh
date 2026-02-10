#!/usr/bin/env bash

# BinExport Ghidra extension
wget -q "https://github.com/google/binexport/releases/download/v12/ghidra_BinExport.zip" -O /tmp/binexport.zip
mkdir -p /opt/ghidra/Extensions/Ghidra
unzip -q /tmp/binexport.zip -d /opt/ghidra/Extensions/Ghidra/
rm /tmp/binexport.zip

# BinDiff 8
wget -q "https://github.com/google/bindiff/releases/download/v8/bindiff_8_amd64.deb" -O /tmp/bindiff.deb
dpkg -i /tmp/bindiff.deb || apt-get install -f -y
rm /tmp/bindiff.deb
