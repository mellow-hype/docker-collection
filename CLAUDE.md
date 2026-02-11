# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Docker container template and build system for creating standardized base images and kernel/cross-compilation build environments across Ubuntu (18.04–24.04) and Debian (11–13).

## Build Commands

Base template images are built via Make from `base-templates/`:

```bash
# Build base template images
make -C base-templates all       # all base images
make -C base-templates ubuntu    # Ubuntu only
make -C base-templates debian    # Debian only
```

Kernel builder images are built via Make from `builders/kbuilders/`:

```bash
# Build everything (base images + generic + cross-architecture builders)
make -C builders/kbuilders all

# Build only base images (required before builders)
make -C builders/kbuilders ubuntu24_base
make -C builders/kbuilders debian12_base

# Build generic builders (depends on base images)
make -C builders/kbuilders generic_builders

# Build cross-architecture builders
make -C builders/kbuilders cross          # all cross-arch (arm + arm64)
make -C builders/kbuilders arm_builders   # ARMhf only
make -C builders/kbuilders arm64_builders # ARM64 only

# Build individual images directly
sudo docker build -t <tag> -f <Dockerfile> <context-dir>
```

Glibc toolchain builder images are built via Make from `builders/glibc-toolchains/`:

```bash
# Build glibc toolchain builder images
make -C builders/glibc-toolchains all                # both variants
make -C builders/glibc-toolchains glibc-builder-u20  # glibc 2.29-2.34
make -C builders/glibc-toolchains glibc-builder-u24  # glibc 2.35+
```

Note: Make targets use `sudo docker build` — Docker access must be available.

## Claude Code Development Container

Located in `tools/claude-docker/`. Start with:
```bash
cd tools/claude-docker
docker-compose up -d
docker-compose exec claude-code bash
```

## Architecture

### Layered Image Hierarchy

```
Base OS (Ubuntu/Debian)
  → base-templates/              Minimal images: non-root user, locale, basic tools
  → builders/kbuilders/base/     Heavy build toolchains (gcc, cmake, etc.)
    → builders/kbuilders/        Architecture-specific builders (generic, arm, arm64, lede)
```

Builder base images must be built before architecture-specific builders (the Makefile handles this via target dependencies).

### Key Directories

- `base-templates/` — Minimal base Dockerfiles for each distro version
- `builders/kbuilders/` — Makefile + kernel builder Dockerfiles
- `builders/kbuilders/base/` — Builder base images with full compilation toolchains
- `builders/kbuilders/standalones/` — Self-contained builder images (no base dependency)
- `builders/glibc-toolchains/` — Dockerfiles for glibc + toolchain (GCC/binutils) build environments
- `tools/` — Utility containers (Claude Code, CodeQL, Kaitai, Node.js, PHP)
- `shared/` — Reusable install scripts (Python 3.10, pwntools, pwndbg)
- `misc/` — Specialized builders (LEDE/OpenWrt)

### Naming Conventions

- Base templates: `{distro}-{version}.Dockerfile` (e.g., `ubuntu-24.04.Dockerfile`)
- Builder bases: `{distro}_{version}-BUILDER-BASE.Dockerfile`
- Builders: `{distro}{version}-{arch}-builder.Dockerfile` (e.g., `ubuntu20-arm64-builder.Dockerfile`)
- Image tags follow: `{distro}{version}-kbuild-{type}` (e.g., `ubuntu24-kbuild-generic`)
- Base template image tags: `{distro}{version}-base` (e.g., `ubuntu24-base`)

### Container Conventions

- All containers create a non-root user (`builder`, `ubuntu`, or `deb` (Debian bases)) with passwordless sudo
- Locale set to UTF-8, timezone to America/Los_Angeles
- Builder containers expose volumes at `/home/builder/images` (output) and `/home/builder/src` (source)

## No Tests or CI

This repository has no test framework, linting, or CI/CD pipeline. Validation is done by building and running containers manually.
