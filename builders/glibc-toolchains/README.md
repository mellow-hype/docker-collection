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

## Usage Example

Building glibc 2.31 with an era-appropriate toolchain:

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
