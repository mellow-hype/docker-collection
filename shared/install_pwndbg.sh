#!/usr/bin/env bash

curl -qsLk 'https://install.pwndbg.re' -o /opt/pwndbg.sh
chmod +x /opt/pwndbg.sh
bash /opt/pwndbg.sh -t pwndbg-gdb

