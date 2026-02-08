#!/usr/bin/env bash
#
# build-glibc.sh — Container-side glibc build script
#
# Runs inside a toolchain-builder Docker container. Downloads, configures,
# builds, installs, and packages a single glibc version with full debug symbols.
#
# Usage: bash build-glibc.sh <version>
#   e.g.: bash build-glibc.sh 2.31

set -euo pipefail

VERSION="${1:?Usage: build-glibc.sh <version>}"

SRC_DIR="${HOME}/src"
BUILD_DIR="${HOME}/build/glibc-${VERSION}"
INSTALL_DIR="${TOOLCHAIN_PREFIX}/glibc-${VERSION}"
OUTPUT_DIR="${HOME}/images"
TARBALL="glibc-${VERSION}.tar.xz"
TARBALL_PATH="${SRC_DIR}/${TARBALL}"
SOURCE_DIR="${SRC_DIR}/glibc-${VERSION}"
GNU_URL="https://ftp.gnu.org/gnu/glibc/${TARBALL}"

CFLAGS="-g3 -O1 -gdwarf-4 -fno-omit-frame-pointer -fcf-protection=none"
CXXFLAGS="${CFLAGS}"

echo "=========================================="
echo " Building glibc ${VERSION} with debug symbols"
echo "=========================================="
echo "Source:  ${SOURCE_DIR}"
echo "Build:   ${BUILD_DIR}"
echo "Install: ${INSTALL_DIR}"
echo "Output:  ${OUTPUT_DIR}/glibc-${VERSION}-debug.tar.xz"
echo ""

# --- Download ---
if [ -f "${TARBALL_PATH}" ]; then
    echo "[download] Tarball already cached: ${TARBALL_PATH}"
else
    echo "[download] Downloading ${GNU_URL} ..."
    wget -q --show-progress -O "${TARBALL_PATH}" "${GNU_URL}"
fi

# --- Extract ---
if [ -d "${SOURCE_DIR}" ]; then
    echo "[extract] Source already extracted: ${SOURCE_DIR}"
else
    echo "[extract] Extracting ${TARBALL} ..."
    tar xf "${TARBALL_PATH}" -C "${SRC_DIR}"
fi

# --- Configure ---
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

echo "[configure] Configuring glibc ${VERSION} ..."
"${SOURCE_DIR}/configure" \
    --prefix="${INSTALL_DIR}" \
    --enable-debug \
    --disable-werror \
    --with-headers=/usr/include \
    --disable-cet \
    CFLAGS="${CFLAGS}" \
    CXXFLAGS="${CXXFLAGS}"

# --- Build ---
echo "[build] Building glibc ${VERSION} ($(nproc) jobs) ..."
make -j"$((`nproc`-2))"

# --- Install ---
echo "[install] Installing to ${INSTALL_DIR} ..."
make install DESTDIR=

# --- Package ---
mkdir -p "${OUTPUT_DIR}"
ARTIFACT="${OUTPUT_DIR}/glibc-${VERSION}-debug.tar.xz"

echo "[package] Creating ${ARTIFACT} ..."
tar cJf "${ARTIFACT}" -C "${TOOLCHAIN_PREFIX}" "glibc-${VERSION}"

echo ""
echo "[done] glibc ${VERSION} build complete."
echo "  Installed: ${INSTALL_DIR}"
echo "  Artifact:  ${ARTIFACT}"
