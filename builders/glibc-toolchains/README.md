# glibc Toolchain Builders

Docker build environments for compiling specific glibc versions from source alongside matching toolchains (GCC, binutils).

## Why Two Images?

Building older glibc versions (2.29-2.34) on modern systems (Ubuntu 24.04 / GCC 14 / binutils 2.42) frequently fails due to:

- **CET symbol conflicts** - Control-Flow Enforcement Technology symbols in modern binutils clash with older glibc expectations
- **Compiler optimization mismatches** - GCC 14 optimizations and warnings-as-errors can break older glibc source
- **Security feature incompatibilities** - Modern hardening defaults (e.g., `-fcf-protection`) cause build failures in older code

Using era-appropriate host compilers avoids these issues. The Ubuntu 20.04 image provides the right vintage of tools for older glibc, while the Ubuntu 24.04 image handles modern versions natively.

## Images

| Image | Dockerfile | Base OS | Host GCC | Host binutils | Target glibc |
|---|---|---|---|---|---|
| `ubuntu20-toolchain-builder` | `ubuntu_20.04-toolchain-builder.Dockerfile` | Ubuntu 20.04 | 9.4.0 | 2.34 | 2.29 - 2.34 |
| `ubuntu24-toolchain-builder` | `ubuntu_24.04-toolchain-builder.Dockerfile` | Ubuntu 24.04 | 14.2.0 | 2.42 | 2.35+ |

## Building

```bash
make all                # build both images
make glibc-builder-u20  # Ubuntu 20.04 image only
make glibc-builder-u24  # Ubuntu 24.04 image only
```

Or from the repo root:

```bash
make -C builders/glibc-toolchains all
```

## Container Layout

```
/home/builder/
  src/           # VOLUME - mount or download source tarballs here
  build/         # out-of-tree build directory (glibc requires this)
  toolchains/    # $TOOLCHAIN_PREFIX - install built toolchains here
  images/        # VOLUME - output artifacts
```

The container runs as the `builder` user with passwordless sudo.

## Included Packages

Both images ship the same package set. Key categories:

- **Build system**: build-essential, make, automake, autoconf, libtool
- **Host compiler**: gcc, g++, gcc-multilib, g++-multilib (enables 32-bit glibc builds)
- **Parser generators**: bison, flex, gawk, texinfo, m4
- **GCC build dependencies**: libgmp-dev, libmpc-dev, libmpfr-dev, libisl-dev
- **Utility libraries**: zlib1g-dev, libelf-dev, libssl-dev
- **Source fetching**: wget, curl, git, xz-utils, tar, bzip2, patch

Kernel UAPI headers (needed by glibc) are provided by `linux-libc-dev`, a transitive dependency of `build-essential`.

## Automated Builds

The `build-all-glibc.sh` script orchestrates building glibc versions 2.29–2.39 with full debug symbols. It automatically selects the correct Docker image for each version.

### Quick Start

```bash
make build-all              # build Docker images + all 11 glibc versions
make build-glibc-2.31       # build Docker images + a single version
make download-sources       # download all source tarballs (no Docker needed)
```

### Script Usage

```bash
./build-all-glibc.sh                        # build all versions (2.29-2.39)
./build-all-glibc.sh 2.31 2.35              # build specific versions only
./build-all-glibc.sh --download-only        # download all tarballs without building
./build-all-glibc.sh --download-only 2.31   # download a specific tarball only
```

The `--download-only` / `-d` flag fetches source tarballs from `ftp.gnu.org` to `cache/src/` without launching any Docker containers. Useful for pre-fetching sources before offline builds.

### Debug Symbol Flags

All builds use these flags for maximum debuggability:

```
CFLAGS="-g3 -O1 -gdwarf-4 -fno-omit-frame-pointer"
```

- `-g3` — maximum debug info including macro definitions
- `-O1` — minimum optimization required (glibc refuses `-O0`)
- `-gdwarf-4` — consistent DWARF format across GCC 9 and GCC 14
- `-fno-omit-frame-pointer` — preserves frame pointers for stack traces

### Output

```
builders/glibc-toolchains/
  cache/src/                          # Cached source tarballs (shared across builds)
    glibc-2.29.tar.xz ... glibc-2.39.tar.xz
  output/                             # Packaged debug builds
    glibc-2.29-debug.tar.xz ... glibc-2.39-debug.tar.xz
```

Each tarball extracts to a standard glibc prefix (`lib/`, `include/`, `bin/`, etc.) with full debug symbols embedded.

## Manual Usage Example

Building glibc 2.31 interactively with an era-appropriate toolchain:

```bash
docker run -it --rm ubuntu20-toolchain-builder

# Inside the container:
cd ~/src
wget https://ftp.gnu.org/gnu/glibc/glibc-2.31.tar.xz
tar xf glibc-2.31.tar.xz

mkdir -p ~/build/glibc-2.31 && cd ~/build/glibc-2.31
~/src/glibc-2.31/configure --prefix=$TOOLCHAIN_PREFIX/glibc-2.31
make -j$(nproc)
make install
```
