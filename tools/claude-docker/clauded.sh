#!/usr/bin/env bash

IMAGE="${CLAUDE_DOCKER_IMAGE:-claude-docker:latest}"
DOCKUSER="${CLAUDE_DOCKER_USER:-ubuntu}"
CONF_LOCAL="$HOME/.config/claude-docker"

EXTRA_MOUNTS=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        -i|--image)
            IMAGE="$2"
            shift 2
            ;;
        -i=*|--image=*)
            IMAGE="${1#*=}"
            shift
            ;;
        -u|--user)
            DOCKUSER="$2"
            shift 2
            ;;
        -u=*|--user=*)
            DOCKUSER="${1#*=}"
            shift
            ;;
        -c|--config)
            CONF_LOCAL="$2"
            shift 2
            ;;
        -c=*|--config=*)
            CONF_LOCAL="${1#*=}"
            shift
            ;;
        -v|--volume)
            EXTRA_MOUNTS+=("-v" "$2")
            shift 2
            ;;
        -v=*|--volume=*)
            EXTRA_MOUNTS+=("-v" "${1#*=}")
            shift
            ;;
        -h|--help)
            echo "Usage: $(basename "$0") [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -i, --image   Docker image to run (default: claude-docker:latest, or \$CLAUDE_DOCKER_IMAGE)"
            echo "  -u, --user    Container username for mount paths (default: ubuntu, or \$CLAUDE_DOCKER_USER)"
            echo "  -c, --config  Local configuration directory (default: \$HOME/.config/claude-docker)"
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

CONFDIR_CLAUDE="$CONF_LOCAL/.claude"

# ensure the local config dir exists (NOTE: this is separate from the hosts's real configs)
mkdir -p "$CONF_LOCAL"

# make sure the local .claude.json exists; if it didn't already then this will ensure the session
# and settings are correctly preserved for the next run.
touch "$CONF_LOCAL/.claude.json"

echo "[+] Mounting configuration directory: $CONFDIR_CLAUDE"
docker run \
    -v "$PWD":/workspace \
    -v "$CONFDIR_CLAUDE":/home/"$DOCKUSER"/.claude \
    -v "$CONF_LOCAL/.claude.json":/home/"$DOCKUSER"/.claude.json \
    "${EXTRA_MOUNTS[@]}" \
    -it "$IMAGE"
