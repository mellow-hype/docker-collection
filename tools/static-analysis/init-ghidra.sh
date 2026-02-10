#!/usr/bin/env bash
GHIDRA_VERSION="12.0.1"
wget -q "https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_${GHIDRA_VERSION}_build/ghidra_${GHIDRA_VERSION}_PUBLIC_20260114.zip" -O /tmp/ghidra.zip
unzip -q /tmp/ghidra.zip -d /opt
mv /opt/ghidra_${GHIDRA_VERSION}_PUBLIC /opt/ghidra
rm /tmp/ghidra.zip
chmod +x /opt/ghidra/support/analyzeHeadless
