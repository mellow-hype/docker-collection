FROM debian:trixie

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

RUN useradd -m -s /bin/bash -u 1000 user
RUN echo 'user ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/user && chmod 0440 /etc/sudoers.d/user

USER user
WORKDIR /home/user

CMD ["/bin/bash"]
