#!/usr/bin/env bash

IMAGE="claude-docker:latest"
CONF_LOCAL="$HOME/.config/claude-docker"
mkdir -p "$CONF_LOCAL"

docker run \
    -v $PWD:/workspace \
    -v $CONF_LOCAL/.claude:/home/ubuntu/.claude \
    -v $CONF_LOCAL/.claude.json:/home/ubuntu/.claude.json \
    -it "$IMAGE"

