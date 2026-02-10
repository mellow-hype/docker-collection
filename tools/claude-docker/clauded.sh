#!/usr/bin/env bash

IMAGE="claude-docker:latest"
CONF_LOCAL="$HOME/.config/claude-docker"
CONFDIR_CLAUDE="$CONF_LOCAL/.claude"

# ensure the local config dir exists (NOTE: this is separate from the hosts's real configs)
mkdir -p "$CONF_LOCAL"

# make sure the local .claude.json exists; if it didn't already then this will ensure the session
# and settings are correctly preserved for the next run.
touch $CONF_LOCAL/.claude.json

docker run \
    -v $PWD:/workspace \
    -v "$CONFDIR_CLAUDE":/home/ubuntu/.claude \
    -v "$CONF_LOCAL/.claude.json":/home/ubuntu/.claude.json \
    -it "$IMAGE"

