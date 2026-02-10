#!/usr/bin/env bash

IMAGE="claude-docker:latest"
CONF_LOCAL="$HOME/.config/claude-docker"
CONFDIR_CLAUDE="$CONF_LOCAL/.claude"

EXTRA_MOUNTS=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        -v|--volume)
            EXTRA_MOUNTS+=("-v" "$2")
            shift 2
            ;;
        -v=*|--volume=*)
            EXTRA_MOUNTS+=("-v" "${1#*=}")
            shift
            ;;
        -h|--help)
            echo "Usage: $(basename "$0") [-v|--volume HOST:CONTAINER[:OPTIONS]] ..."
            echo ""
            echo "Options:"
            echo "  -v, --volume  Additional volume mount(s) passed to docker run"
            echo "  -h, --help    Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            echo "Run '$(basename "$0") --help' for usage." >&2
            exit 1
            ;;
    esac
done

# ensure the local config dir exists (NOTE: this is separate from the hosts's real configs)
mkdir -p "$CONF_LOCAL"

# make sure the local .claude.json exists; if it didn't already then this will ensure the session
# and settings are correctly preserved for the next run.
touch $CONF_LOCAL/.claude.json

docker run \
    -v $PWD:/workspace \
    -v "$CONFDIR_CLAUDE":/home/ubuntu/.claude \
    -v "$CONF_LOCAL/.claude.json":/home/ubuntu/.claude.json \
    "${EXTRA_MOUNTS[@]}" \
    -it "$IMAGE"

