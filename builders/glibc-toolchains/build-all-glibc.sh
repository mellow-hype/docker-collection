#!/usr/bin/env bash
#
# build-all-glibc.sh — Host-side orchestrator for building glibc versions
#
# Manages Docker runs for building multiple glibc versions (2.29-2.39) with
# full debug symbols, using the correct toolchain container for each version.
#
# Usage:
#   ./build-all-glibc.sh                        # build all versions (2.29-2.39)
#   ./build-all-glibc.sh 2.31 2.35              # build specific versions only
#   ./build-all-glibc.sh --download-only        # download all tarballs without building
#   ./build-all-glibc.sh --download-only 2.31   # download a specific tarball only

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST_SRC_DIR="${SCRIPT_DIR}/cache/src"
HOST_OUTPUT_DIR="${SCRIPT_DIR}/output"

ALL_VERSIONS=(2.29 2.30 2.31 2.32 2.33 2.34 2.35 2.36 2.37 2.38 2.39)

# Version-to-image mapping
declare -A VERSION_IMAGE
for v in 2.29 2.30 2.31 2.32 2.33 2.34; do
    VERSION_IMAGE[$v]="ubuntu20-toolchain-builder"
done
for v in 2.35 2.36 2.37 2.38 2.39; do
    VERSION_IMAGE[$v]="ubuntu24-toolchain-builder"
done

GNU_BASE_URL="https://ftp.gnu.org/gnu/glibc"

# --- Parse arguments ---
DOWNLOAD_ONLY=false
VERSIONS=()

for arg in "$@"; do
    case "${arg}" in
        --download-only|-d)
            DOWNLOAD_ONLY=true
            ;;
        *)
            if [[ -n "${VERSION_IMAGE[${arg}]+x}" ]]; then
                VERSIONS+=("${arg}")
            else
                echo "Error: Unknown version '${arg}'."
                echo "Supported versions: ${ALL_VERSIONS[*]}"
                exit 1
            fi
            ;;
    esac
done

# Default to all versions if none specified
if [ ${#VERSIONS[@]} -eq 0 ]; then
    VERSIONS=("${ALL_VERSIONS[@]}")
fi

# --- Create directories ---
mkdir -p "${HOST_SRC_DIR}" "${HOST_OUTPUT_DIR}"

# --- Download-only mode ---
if [ "${DOWNLOAD_ONLY}" = true ]; then
    echo "=== Download-only mode ==="
    echo "Downloading ${#VERSIONS[@]} tarball(s) to ${HOST_SRC_DIR}"
    echo ""

    fail_count=0
    for version in "${VERSIONS[@]}"; do
        tarball="glibc-${version}.tar.xz"
        tarball_path="${HOST_SRC_DIR}/${tarball}"

        if [ -f "${tarball_path}" ]; then
            echo "[${version}] Already cached: ${tarball_path}"
        else
            echo "[${version}] Downloading ${GNU_BASE_URL}/${tarball} ..."
            if wget -q --show-progress -O "${tarball_path}" "${GNU_BASE_URL}/${tarball}"; then
                echo "[${version}] Downloaded successfully."
            else
                echo "[${version}] FAILED to download."
                rm -f "${tarball_path}"
                ((fail_count++))
            fi
        fi
    done

    if [ "${fail_count}" -gt 0 ]; then
        echo ""
        echo "${fail_count} download(s) failed."
        exit 1
    fi
    echo ""
    echo "All downloads complete."
    exit 0
fi

# --- Build mode ---
echo "=== glibc Debug Build Orchestrator ==="
echo "Versions: ${VERSIONS[*]}"
echo "Source cache: ${HOST_SRC_DIR}"
echo "Output dir:   ${HOST_OUTPUT_DIR}"
echo ""

declare -A RESULTS
succeeded=0
failed=0

for version in "${VERSIONS[@]}"; do
    image="${VERSION_IMAGE[${version}]}"
    echo "----------------------------------------------"
    echo " glibc ${version} — image: ${image}"
    echo "----------------------------------------------"

    if sudo docker run --rm \
        --name "glibc-build-${version}" \
        -v "${HOST_SRC_DIR}:/home/builder/src" \
        -v "${HOST_OUTPUT_DIR}:/home/builder/images" \
        -v "${SCRIPT_DIR}/build-glibc.sh:/home/builder/build-glibc.sh:ro" \
        "${image}" \
        /home/builder/build-glibc.sh "${version}"; then
        RESULTS[${version}]="OK"
        ((succeeded++))
    else
        RESULTS[${version}]="FAILED"
        ((failed++))
    fi
    echo ""
done

# --- Summary ---
echo "============================================"
echo " Build Summary"
echo "============================================"
for version in "${VERSIONS[@]}"; do
    printf "  glibc %-6s %s\n" "${version}" "${RESULTS[${version}]}"
done
echo ""
echo "Succeeded: ${succeeded}  Failed: ${failed}  Total: ${#VERSIONS[@]}"
echo "Output:    ${HOST_OUTPUT_DIR}/"

if [ "${failed}" -gt 0 ]; then
    exit 1
fi
