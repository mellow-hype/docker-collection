#!/usr/bin/env bash

# Image name configurable via environment variable
GHIDRA_IMAGE="${GHIDRA_IMAGE:-ghidra-headless}"

docker run --rm \
    -v "$(pwd):/data" \
    -v "${pwd}/ghidra_projects:/home/ubuntu/ghidra_projects" \
    "$GHIDRA_IMAGE" \
    "$@"
