# Claude Code Docker Container

This Docker container provides a ready-to-use environment for running Claude Code with your projects.

## Prerequisites

- Docker installed on your system

## Quick Start

### Option 1: Using the `clauded.sh` Script (Recommended)

The `clauded.sh` script handles volume mounts and configuration persistence automatically. Run it from the directory you want to work in:

```bash
cd /path/to/your/project
/path/to/clauded.sh
```

By default, configuration is stored in `$HOME/.config/claude-docker/`. This keeps the container's Claude sessions and settings separate from any host Claude installation.

**Options:**

```
-i, --image IMAGE  Docker image to run (default: claude-docker:latest, or $CLAUDE_DOCKER_IMAGE)
-u, --user USER    Container username for mount paths (default: ubuntu, or $CLAUDE_DOCKER_USER)
-c, --config DIR   Local configuration directory (default: $HOME/.config/claude-docker)
-v, --volume MOUNT Additional volume mount(s) passed to docker run
-h, --help         Show help message
```

**Examples:**

```bash
# Use a custom config directory
clauded.sh --config /tmp/my-claude-config

# Mount an additional directory
clauded.sh -v /path/to/extra:/mnt/extra

# Run a Debian variant image
clauded.sh --image claude-docker-deb13 --user user
```

The script mounts:
- The current working directory to `/workspace`
- `<config-dir>/.claude/` to `/home/<user>/.claude` (session data)
- `<config-dir>/.claude.json` to `/home/<user>/.claude.json` (settings)

Where `<user>` is the container username (`ubuntu` by default, or the value passed via `--user`).

### Option 2: Using Docker Compose

1. **Edit docker-compose.yml** to mount your project:
   - Change the source path in the volumes section to point at your project directory
   - The `claude-config` named volume persists Claude Code configuration across restarts

2. **Start the container**:
   ```bash
   docker-compose up -d
   docker-compose exec claude-code bash
   ```

### Option 3: Using Make

The Makefile supports building the default image and named variants with configurable base images, users, and packages.

**Targets:**

| Target | Description |
|--------|-------------|
| `make build` | Build the default `claude-docker` image (Ubuntu 24.04) |
| `make build-<label>` | Build a variant tagged `claude-docker-<label>` |
| `make install` | Symlink `clauded.sh` into `~/bin` |
| `make all` | Run `build` + `install` |

**Build variables** (override on the command line):

| Variable | Default | Description |
|----------|---------|-------------|
| `BASE_IMAGE` | `ubuntu:24.04` | Base Docker image |
| `DOCKUSER` | `ubuntu` | Non-root username created in the image |
| `EXTRA_PACKAGES` | *(empty)* | Additional apt packages to install |

**Examples:**

```bash
# Default build (identical to the original image)
make build

# Debian 13 variant
make build-deb13 BASE_IMAGE=debian:13 DOCKUSER=user

# Ubuntu 22.04 with extra packages
make build-u22 BASE_IMAGE=ubuntu:22.04 EXTRA_PACKAGES="golang-go jq"

# Override the default build's base image
make build BASE_IMAGE=debian:12 DOCKUSER=user
```

### Option 4: Using Docker Directly

1. **Build the image**:
   ```bash
   docker build -t claude-docker:latest .
   ```

2. **Run the container**:
   ```bash
   docker run -it \
     -v /path/to/your/project:/workspace \
     -v /path/to/claude/config/.claude:/home/ubuntu/.claude \
     -v /path/to/claude/config/.claude.json:/home/ubuntu/.claude.json \
     claude-docker:latest
   ```

## Portability

The `claude-docker/` directory is self-contained and portable. You can copy it to multiple locations on your system (or across machines) to create separate, independent environments. When doing so:

- Edit `docker-compose.yml` volume paths to point at the desired project directory for that copy
- Use distinct named volumes (or bind-mount paths) for each copy so that configuration and sessions stay isolated between environments
- If using `clauded.sh`, pass `--config` to specify a unique configuration directory per environment

## Usage

Once inside the container:

1. Your project files are available at `/workspace`

2. Navigate to your code:
   ```bash
   cd /workspace
   ```

3. Start Claude Code:
   ```bash
   claude
   ```

## Helpful Commands

- `ll` - List files with details
- `exit` - Exit the container

## Project Structure

```
.
├── Dockerfile           # Container definition
├── Makefile             # Build targets and variables
├── docker-compose.yml   # Docker Compose configuration
├── clauded.sh           # Convenience launcher script
└── README.md            # This file
```

## Customization

### Add Additional Tools

Edit the Dockerfile to add more development tools:

```dockerfile
RUN apt-get update && apt-get install -y \
    your-tool-here \
    && rm -rf /var/lib/apt/lists/*
```

### Persist Configuration

The `docker-compose.yml` includes a named volume (`claude-config`) that persists Claude Code configuration across container restarts. When using `clauded.sh`, configuration is persisted via bind-mounts to the config directory instead.

## Troubleshooting

### Permission Issues
If you have permission issues with mounted files:
- The container runs as a non-root user (`ubuntu` by default, or the value of `DOCKUSER`) with passwordless sudo
- Ensure the files are readable on your host system
- Consider adding user mapping in docker-compose.yml if UID/GID mismatches cause issues

### Container Won't Start
- Check Docker logs: `docker-compose logs`
- Verify the project path in docker-compose.yml exists

## Notes

- The container runs as a non-root user (`ubuntu` by default) with passwordless sudo
- All changes outside mounted volumes are lost when the container stops
- Your project files in `/workspace` are safe as they're mounted from your host
