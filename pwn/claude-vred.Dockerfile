## Claude Code + Vulnerability Research Environment
## Base: claude-docker:latest (Ubuntu 24.04 with Claude Code CLI)
## Tools: pwndbg, pwntools, gdb, binutils, Ghidra, Semgrep, CodeQL, xxd
## For authorized security research, CTF competitions, and defensive security work
FROM claude-docker:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

USER root

# System packages: gdb, binutils, JDK 21 for Ghidra, python dev libs
RUN apt-get update && apt-get install -y --no-install-recommends \
    binutils \
    file \
    gdb \
    libffi-dev \
    libssl-dev \
    openjdk-21-jdk-headless \
    procps \
    python3-dev \
    tmux \
    unzip \
    xxd \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install pwndbg
RUN curl -qsLk 'https://install.pwndbg.re' -o /opt/pwndbg.sh \
    && chmod +x /opt/pwndbg.sh \
    && bash /opt/pwndbg.sh -t pwndbg-gdb

# Allow pip to install system-wide (PEP 668 workaround for Ubuntu 24.04)
RUN echo '[global]\nbreak-system-packages = true' > /etc/pip.conf

# Install pwntools via shared script
ADD ./shared/pwntools.sh /opt/pwntools.sh
RUN /opt/pwntools.sh

# Install Ghidra 11.3.1
RUN cd /tmp \
    && wget -q https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.3.1_build/ghidra_11.3.1_PUBLIC_20250123.zip \
    && unzip -q ghidra_11.3.1_PUBLIC_20250123.zip -d /opt \
    && mv /opt/ghidra_11.3.1_PUBLIC /opt/ghidra \
    && ln -s /opt/ghidra/ghidraRun /usr/local/bin/ghidra \
    && rm ghidra_11.3.1_PUBLIC_20250123.zip

# Install Semgrep via pip
RUN python3 -m pip install --upgrade semgrep

# Download and install CodeQL v2.20.3
ADD https://github.com/github/codeql-action/releases/download/codeql-bundle-v2.20.3/codeql-bundle-linux64.tar.gz /opt/
RUN cd /opt \
    && tar -xzf codeql-bundle-linux64.tar.gz \
    && ln -s /opt/codeql/codeql /usr/local/bin/codeql \
    && rm codeql-bundle-linux64.tar.gz

# Final cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

USER ubuntu

VOLUME [ "/home/ubuntu/src" ]
WORKDIR /workspace

RUN echo 'export PATH=\$HOME/.local/bin:\$PATH' >> /home/ubuntu/.bashrc

ENTRYPOINT [ "/bin/bash" ]
