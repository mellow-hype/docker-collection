# Parameterized base template for Ubuntu and Debian distributions
# Supports Ubuntu 20.04-24.04 and Debian 11-13
ARG BASE_IMAGE=ubuntu:24.04
FROM ${BASE_IMAGE}

ARG USERNAME=ubuntu
ARG CREATE_USER=false

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=America/Los_Angeles \
    TERM=xterm-256color \
    LANG=en_US.UTF-8

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    vim \
    python3 \
    tmux \
    wget \
    curl \
    sudo \
    git \
    locales \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen && locale-gen

# Create user for Debian (Ubuntu already has ubuntu user)
RUN if [ "$CREATE_USER" = "true" ]; then useradd -m -s /bin/bash -u 1000 ${USERNAME}; fi

RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && chmod 0440 /etc/sudoers.d/${USERNAME}

COPY --chown=${USERNAME}:${USERNAME} shared/tmux.conf /home/${USERNAME}/.tmux.conf

USER ${USERNAME}
WORKDIR /home/${USERNAME}

CMD ["/bin/bash"]
