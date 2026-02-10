# Static analysis toolbox for Claude Code agent control via docker run.
# Includes: Semgrep, CodeQL, Ghidra (headless), BinDiff/BinExport, radare2,
#           C toolchain, and binary triage utilities.
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=America/Los_Angeles \
    TERM=xterm-256color \
    LANG=en_US.UTF-8

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# System packages: build toolchain, binary analysis, Java, Python, utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Build toolchain
    build-essential \
    clang \
    cmake \
    ninja-build \
    # Binary analysis & triage
    binutils \
    checksec \
    file \
    patchelf \
    radare2 \
    # Debug / trace
    gdb \
    strace \
    ltrace \
    # Dev libraries
    libelf-dev \
    libncurses-dev \
    libssl-dev \
    zlib1g-dev \
    # Java (Ghidra requirement)
    openjdk-21-jdk-headless \
    # Python
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    # Utilities
    ca-certificates \
    curl \
    git \
    locales \
    sudo \
    tmux \
    unzip \
    vim \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen && locale-gen

# Semgrep (latest stable from PyPI)
RUN pip3 install --no-cache-dir --break-system-packages semgrep

# CodeQL
COPY init-codeql.sh /tmp/init-codeql.sh
RUN chmod +x /tmp/init-codeql.sh && /tmp/init-codeql.sh && rm /tmp/init-codeql.sh
ENV PATH="${PATH}:/opt/codeql"

# Ghidra
COPY init-ghidra.sh /tmp/init-ghidra.sh
RUN chmod +x /tmp/init-ghidra.sh && /tmp/init-ghidra.sh && rm /tmp/init-ghidra.sh
ENV GHIDRA_HOME=/opt/ghidra
ENV PATH="${GHIDRA_HOME}/support:${PATH}"

# BinDiff + BinExport (must run after Ghidra is installed)
COPY init-bindiff.sh /tmp/init-bindiff.sh
RUN chmod +x /tmp/init-bindiff.sh && /tmp/init-bindiff.sh && rm /tmp/init-bindiff.sh
ENV PATH="${PATH}:/opt/bindiff/bin"

# Non-root user with passwordless sudo
RUN useradd -m ubuntu && \
    echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu && \
    chmod 0440 /etc/sudoers.d/ubuntu

RUN mkdir -p /home/ubuntu/workspace /home/ubuntu/output && \
    chown -R ubuntu:ubuntu /home/ubuntu

VOLUME ["/home/ubuntu/workspace"]
VOLUME ["/home/ubuntu/output"]

USER ubuntu
WORKDIR /home/ubuntu

ENTRYPOINT ["/bin/bash"]
CMD ["-l"]
