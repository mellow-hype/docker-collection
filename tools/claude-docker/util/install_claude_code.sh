#!/usr/bin/env bash
#
# Install Claude Code CLI in Ubuntu and Debian containers.
# Installs required dependencies, then runs the official installer
# as the container's non-root user.
#
# Usage (in a Dockerfile):
#   COPY shared/install_claude_code.sh /tmp/
#   RUN bash /tmp/install_claude_code.sh [username]
#
# Arguments:
#   username  — the non-root user to install for (default: auto-detected)
#
# The script must be run as root (it installs packages via apt-get).

set -euo pipefail

# ---------- detect target user ----------
if [ -n "${1:-}" ]; then
    TARGET_USER="$1"
elif id "builder" &>/dev/null; then
    TARGET_USER="builder"
elif id "ubuntu" &>/dev/null; then
    TARGET_USER="ubuntu"
elif id "user" &>/dev/null; then
    TARGET_USER="user"
else
    echo "ERROR: Could not detect a non-root user. Pass the username as the first argument." >&2
    exit 1
fi

TARGET_HOME=$(eval echo "~${TARGET_USER}")

echo "Installing Claude Code for user: ${TARGET_USER} (home: ${TARGET_HOME})"

# ---------- install dependencies ----------
apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    ripgrep

apt-get clean && rm -rf /var/lib/apt/lists/*

# ---------- install claude code ----------
su - "${TARGET_USER}" -c 'curl -fsSL https://claude.ai/install.sh | bash -'

# ---------- ensure PATH includes ~/.local/bin ----------
LOCAL_BIN="${TARGET_HOME}/.local/bin"
BASHRC="${TARGET_HOME}/.bashrc"

if ! grep -q "${LOCAL_BIN}" "${BASHRC}" 2>/dev/null; then
    echo "export PATH=\"${LOCAL_BIN}:\$PATH\"" >> "${BASHRC}"
    chown "${TARGET_USER}:${TARGET_USER}" "${BASHRC}"
fi

echo "Claude Code installed successfully for ${TARGET_USER}."
