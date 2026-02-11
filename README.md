# Docker Build Environments

Standardized Docker images for kernel compilation, cross-architecture builds, exploit development, and toolchain construction across Ubuntu and Debian.

## Image Hierarchy

```
Ubuntu / Debian upstream
 └─ base-templates/                Minimal images: non-root user, locale, basic tools
     ├─ builders/kbuilders/base/   Heavy build toolchains (gcc, cmake, flex, bison, ...)
     │   ├─ *-kbuild-generic       Tag aliases (generic = base, no extra Dockerfile)
     │   ├─ *-kbuild-lede          Tag aliases (LEDE packages already in base)
     │   ├─ kbuilder-cross.Dockerfile  Cross-arch builders (ARM64, ARMhf)
     │   └─ builders/kbuilders/standalones/  Self-contained legacy builders
     ├─ pwn/                       Exploit-dev environments (pwndbg, pwntools, GDB)
     │   └─ claude-vred            Claude Code + vuln research (Ghidra, Semgrep, CodeQL)
     ├─ cross-arch/                Lightweight cross-compilation toolchains
     └─ builders/glibc-toolchains/ Glibc + GCC/binutils toolchain builders

tools/static-analysis/             Standalone static analysis toolbox (not based on base-templates)
```

Builder base images (`kbuild-base`) must be built before the architecture-specific builders that `FROM` them. The kbuilders Makefile handles this via target dependencies.

## Root Makefile

The top-level Makefile orchestrates builds across all subdirectories. Run `make list` for a full summary.

```bash
make all              # bases + exploit-dev + cross-arch + tools
make bases            # All base-template images (Ubuntu + Debian)
make exploit-dev      # Build bases, then all pwn/ exploit-dev images
make cross-arch       # Lightweight cross-arch toolchains (depends on bases)
make aarch64-tools    # AArch64 cross-compilation toolchain only
make tools            # claude-docker + ghidra-headless + static-analysis
make claude-docker    # Claude Code development container
make ghidra-headless  # Ghidra headless analysis container
make static-analysis  # Static analysis toolbox
make kbuilders        # All kernel builder images (base + generic + cross)
make kbuilders-cross  # Cross-architecture kernel builders only
make glibc-toolchains # Glibc toolchain builders (u20 + u24)
make llvm-builder     # LLVM/Clang builder container
make lede-builder     # LEDE/OpenWrt builder
make claude-vred      # Claude Code + vulnerability research environment
make list             # Show all available targets
make clean            # Remove all known image tags
```

## Base Templates

Minimal images with a non-root user, passwordless sudo, UTF-8 locale, tmux config, and basic tools (build-essential, git, curl, vim, tmux). All distros are built from a single parameterized Dockerfile (`base-templates/base.Dockerfile`) with `--build-arg BASE_IMAGE` and `USERNAME`. The non-root user is created automatically if it doesn't already exist in the base image.

| Distro | Tag | Base Image |
|--------|-----|------------|
| Ubuntu 20.04 | `ubuntu20-base` | `ubuntu:20.04` |
| Ubuntu 22.04 | `ubuntu22-base` | `ubuntu:22.04` |
| Ubuntu 24.04 | `ubuntu24-base` | `ubuntu:24.04` |
| Debian 11 | `debian11-base` | `debian:bullseye` |
| Debian 12 | `debian12-base` | `debian:bookworm` |
| Debian 13 | `debian13-base` | `debian:trixie` |

Dockerfile: `base-templates/base.Dockerfile`

```bash
make -C base-templates all       # all base images
make -C base-templates ubuntu    # Ubuntu only (ubuntu20 ubuntu22 ubuntu24)
make -C base-templates debian    # Debian only (debian11 debian12 debian13)
make -C base-templates ubuntu24  # single image
```

## Kernel Builders

Two-layer system: a single parameterized **base Dockerfile** (`base/kbuilder-base.Dockerfile`) installs the full compilation toolchain for each distro, then **cross-architecture builders** layer on cross-compiler packages. Generic builders and LEDE builders are `docker tag` aliases (no separate Dockerfiles).

### Builder Bases

All base images are built from one Dockerfile parameterized via `--build-arg BASE_IMAGE` and `--build-arg EXTRA_PACKAGES`:

| Tag | Base Image |
|-----|------------|
| `ubuntu18-kbuild-base` | `ubuntu:18.04` |
| `ubuntu20-kbuild-base` | `ubuntu:20.04` |
| `ubuntu22-kbuild-base` | `ubuntu:22.04` |
| `ubuntu24-kbuild-base` | `ubuntu:24.04` |
| `debian11-kbuild-base` | `debian:bullseye` |
| `debian12-kbuild-base` | `debian:bookworm` |
| `debian13-kbuild-base` | `debian:trixie` |

Dockerfile: `builders/kbuilders/base/kbuilder-base.Dockerfile`

### Generic Builders

Generic builders are `docker tag` aliases — the base images are functionally complete, so no separate Dockerfiles are needed. Each `*-kbuild-generic` tag points to the same image as its corresponding `*-kbuild-base`.

| Tag | Alias of |
|-----|----------|
| `ubuntu18-kbuild-generic` | `ubuntu18-kbuild-base` |
| `ubuntu20-kbuild-generic` | `ubuntu20-kbuild-base` |
| `ubuntu22-kbuild-generic` | `ubuntu22-kbuild-base` |
| `ubuntu24-kbuild-generic` | `ubuntu24-kbuild-base` |
| `debian11-kbuild-generic` | `debian11-kbuild-base` |
| `debian12-kbuild-generic` | `debian12-kbuild-base` |
| `debian13-kbuild-generic` | `debian13-kbuild-base` |

### Cross-Architecture Builders

All cross-builders use a single parameterized Dockerfile (`kbuilder-cross.Dockerfile`) with `--build-arg BASE_IMAGE` and `--build-arg CROSS_PACKAGES`:

| Tag | Arch | Cross Packages |
|-----|------|----------------|
| `ubuntu18-kbuild-arm64` | ARM64 | `gcc-aarch64-linux-gnu libc6-dev-arm64-cross` |
| `ubuntu20-kbuild-arm64` | ARM64 | `gcc-aarch64-linux-gnu libc6-dev-arm64-cross` |
| `ubuntu18-kbuild-armhf` | ARMhf | `gcc-arm-linux-gnueabihf` |
| `ubuntu20-kbuild-armhf` | ARMhf | `gcc-arm-linux-gnueabihf libc6-dev-armhf-cross` |

Dockerfile: `builders/kbuilders/kbuilder-cross.Dockerfile`

### LEDE/OpenWrt Builders

LEDE builders are `docker tag` aliases — the required packages (`swig`, `automake`, `xsltproc`) are already included in the base images. These targets are not included in `make all`.

| Tag | Alias of |
|-----|----------|
| `ubuntu20-kbuild-lede` | `ubuntu20-kbuild-base` |
| `ubuntu20-kbuild-lede-arm64` | `ubuntu20-kbuild-arm64` |

### Build Commands

```bash
make -C builders/kbuilders all              # everything (bases + generic + cross)
make -C builders/kbuilders ubuntu24_base    # single base image
make -C builders/kbuilders generic_builders # all generic builders (tag aliases)
make -C builders/kbuilders ubuntu24_generic # single generic builder
make -C builders/kbuilders cross            # all cross-arch (arm + arm64)
make -C builders/kbuilders arm64_builders   # ARM64 only
make -C builders/kbuilders arm_builders     # ARMhf only
make -C builders/kbuilders ubuntu20_arm64   # single cross-builder
make -C builders/kbuilders lede             # LEDE alias (not in 'all')
make -C builders/kbuilders lede_arm64       # LEDE ARM64 alias (not in 'all')
```

### Standalone Legacy Builders

Self-contained images in `builders/kbuilders/standalones/` that do not depend on the base layer. Covers Ubuntu 13.04 (i386), 16.04 (generic, ARM, MIPS), and 18.04 (generic, ARM, MIPS).

### Volumes

All kernel builder containers expose:

- `/home/builder/images` — build output
- `/home/builder/src` — kernel source

## Glibc Toolchain Builders

Environments for building glibc from source with matching GCC and binutils. Two variants cover the glibc version range:

| Tag | Base | Glibc Range | Dockerfile |
|-----|------|-------------|------------|
| `ubuntu20-toolchain-builder` | Ubuntu 20.04 | 2.29 – 2.34 | `builders/glibc-toolchains/ubuntu_20.04-toolchain-builder.Dockerfile` |
| `ubuntu24-toolchain-builder` | Ubuntu 24.04 | 2.35+ | `builders/glibc-toolchains/ubuntu_24.04-toolchain-builder.Dockerfile` |

```bash
make -C builders/glibc-toolchains all                # both variants
make -C builders/glibc-toolchains glibc-builder-u20  # glibc 2.29-2.34
make -C builders/glibc-toolchains glibc-builder-u24  # glibc 2.35+
make -C builders/glibc-toolchains build-all          # build images then run build-all-glibc.sh
make -C builders/glibc-toolchains download-sources   # download glibc source tarballs only
```

Volumes: `/home/builder/images` (output), `/home/builder/src` (source). Built toolchains are installed under `/home/builder/toolchains`.

## LLVM Builder

Clang 18 / LLVM 18 build environment on Ubuntu 24.04 with cmake, ninja-build, Python 3 venv, and the `libclang` Python bindings.

```bash
sudo docker build -t llvm-builder -f builders/llvm-builder.Dockerfile builders/
```

## Exploit Development

GDB + pwndbg + pwntools environments for every supported distro, built from a single parameterized Dockerfile (`pwn/exploitdev.Dockerfile`). Each image is based on the corresponding `base-templates/` image. Build args control distro-specific behavior (`BUILD_PYTHON310` for older distros, `PEP668_WORKAROUND` for newer ones).

| Tag | Base | Username |
|-----|------|----------|
| `xdev-ubu20` | `ubuntu20-base` | `ubuntu` |
| `xdev-ubu22` | `ubuntu22-base` | `ubuntu` |
| `xdev-ubu24` | `ubuntu24-base` | `ubuntu` |
| `xdev-deb11` | `debian11-base` | `deb` |
| `xdev-deb12` | `debian12-base` | `deb` |
| `xdev-deb13` | `debian13-base` | `deb` |

Dockerfile: `pwn/exploitdev.Dockerfile`

```bash
make -C pwn all         # all exploit-dev images (requires base-templates built first)
make -C pwn xdev-ubu24  # single image
# or from root:
make exploit-dev        # builds bases then all exploit-dev images
```

Volume: `/home/<user>/src` (`ubuntu` on Ubuntu, `deb` on Debian).

### Claude VRED (Vulnerability Research Environment)

Claude Code CLI + full exploit-dev / static-analysis toolkit based on `claude-docker`. Includes pwndbg, pwntools, Ghidra 11.3.1, Semgrep, and CodeQL 2.20.3.

```bash
make -C pwn claude-vred   # requires claude-docker built first
# or from root:
make claude-vred
```

Dockerfile: `pwn/claude-vred.Dockerfile` — Image tag: `claude-vred`

## Cross-Architecture Toolchains

Lightweight cross-compilation toolchains based on `ubuntu24-base`. Lighter weight alternative to the full kbuilder cross-arch images.

| Tag | Arch | Dockerfile |
|-----|------|------------|
| `aarch64-tools` | ARM64 | `cross-arch/aarch64-tools.Dockerfile` |

Sets `CROSS_COMPILE=aarch64-linux-gnu-`. Includes gcc, g++, binutils, and libc for aarch64-linux-gnu targets.

```bash
make cross-arch       # all cross-arch toolchains
make aarch64-tools    # ARM64 only
```

Volume: `/home/ubuntu/src`

## Tools

### Claude Code (`tools/claude-docker/`)

Ubuntu 24.04 container with Claude Code CLI pre-installed.

```bash
make -C tools/claude-docker build
# or use docker-compose:
cd tools/claude-docker && docker-compose up -d && docker-compose exec claude-code bash
```

Image tag: `claude-docker`. Mounts project to `/workspace`.

### Static Analysis (`tools/static-analysis/`)

Standalone Ubuntu 24.04 container with a comprehensive static analysis and binary triage toolbox. Not based on base-templates.

Includes: Semgrep, CodeQL v2.17.6, Ghidra 12.0.1 (headless), BinDiff 8 + BinExport v12, radare2, gdb, strace, ltrace, full C toolchain (gcc, clang, cmake, ninja), binary utilities (binutils, checksec, patchelf), and OpenJDK 21.

```bash
make static-analysis
# or:
sudo docker build -t static-analysis -f tools/static-analysis/Dockerfile tools/static-analysis/
```

Image tag: `static-analysis`. Volumes: `/home/ubuntu/workspace`, `/home/ubuntu/output`.

### Ghidra Headless (`tools/ghidraHeadless/`)

Headless Ghidra (v12.0.1) on Ubuntu 24.04 with OpenJDK 21. Entrypoint is `analyzeHeadless`.

```bash
make -C tools/ghidraHeadless build     # tag: ghidra-headless
./tools/ghidraHeadless/run.sh /home/ubuntu/ghidra_projects MyProject -import /data/binary
```

### CodeQL (`tools/jammy-cql.Dockerfile`)

Ubuntu 22.04 with CodeQL bundle (v2.17.6) and full build toolchain.

```bash
sudo docker build -t jammy-cql -f tools/jammy-cql.Dockerfile tools/
```

### Kaitai Struct (`tools/kaitai.Dockerfile`)

Ubuntu 22.04 with Kaitai Struct Compiler 0.10 for binary format parsing.

```bash
sudo docker build -t kaitai -f tools/kaitai.Dockerfile tools/
```

### Node.js (`tools/node.Dockerfile`)

Node 22 application container. Copies `package.json`, runs `npm install`, exposes port 9080.

### PHP (`tools/php.Dockerfile`)

PHP 8 + Apache. Copies `src/` to `/var/www/`.

## Misc

### LEDE/OpenWrt Builder (`misc/jammy-lede-builder.Dockerfile`)

Ubuntu 22.04 (jammy) based OpenWrt/LEDE build environment. Requires `jammy-base` to be built first.

## Shared Scripts

Reusable install scripts and config in `shared/`:

| File | Purpose |
|------|---------|
| `build_python3.10.sh` | Build Python 3.10 from source |
| `pwntools.sh` | Install pwntools via pip |
| `install_pwndbg.sh` | Install pwndbg GDB plugin |
| `install_claude_code.sh` | Install Claude Code CLI (auto-detects user) |
| `tmux.conf` | Shared tmux config (vim-style nav, mouse support) |

## Container Conventions

- All containers create a non-root user (`builder`, `ubuntu`, or `deb`) with passwordless sudo
- Locale: `en_US.UTF-8`
- Timezone: `America/Los_Angeles`
- Builder containers expose volumes at `/home/builder/images` (output) and `/home/builder/src` (source)
- All Makefile targets use `sudo docker build`
