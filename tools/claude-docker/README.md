# Claude Code Docker Container

This Docker container provides a ready-to-use environment for running Claude Code with your projects.

## Prerequisites

- Docker installed on your system

## Quick Start

### Option 1: Using Docker Compose (Recommended)

1. **Edit docker-compose.yml** to mount your project:
   - Change `./your-project` to the path of your actual project directory
   - Recommended: mount a volume to the claude config directory to preserve sessions

2. **Start the container**:
   ```bash
   docker-compose up -d
   docker-compose exec claude-code bash
   ```

### Option 2: Using Docker directly

1. **Build the image**:
   ```bash
   docker build -t claude-code .
   ```

2. **Run the container**:
   ```bash
   docker run -it \
     -v /path/to/your/project:/workspace \
     -v /path/to/claude/config:/home/ubuntu/.claude \
     claude-code
   ```

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
├── docker-compose.yml   # Docker Compose configuration
└── README.md           # This file
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

The docker-compose.yml already includes a volume for persisting Claude Code configuration:
- `claude-config:/root/.config`

## Troubleshooting

### Permission Issues
If you have permission issues with mounted files:
- Ensure the files are readable on your host system
- Consider adding user mapping in docker-compose.yml

### Container Won't Start
- Check Docker logs: `docker-compose logs`
- Verify the project path in docker-compose.yml exists

## Notes

- The container runs as root by default for simplicity
- All changes outside `/workspace` are lost when the container stops (unless persisted via volumes)
- Your project files in `/workspace` are safe as they're mounted from your host
