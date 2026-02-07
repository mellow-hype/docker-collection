FROM ubuntu:24.04

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-21-jdk-headless \
    wget \
    unzip \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create ubuntu user with passwordless sudo
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu \
    && chmod 0440 /etc/sudoers.d/ubuntu

# Download and install Ghidra
ENV GHIDRA_VERSION=12.0.1
COPY ./init.sh /tmp/init.sh
RUN /tmp/init.sh

# Environment setup
ENV GHIDRA_HOME=/opt/ghidra
ENV PATH="${GHIDRA_HOME}/support:${PATH}"

# Create projects directory and set user
RUN mkdir -p /home/ubuntu/ghidra_projects \
    && chown -R ubuntu:ubuntu /home/ubuntu/ghidra_projects

USER ubuntu
WORKDIR /home/ubuntu

ENTRYPOINT ["analyzeHeadless"]
