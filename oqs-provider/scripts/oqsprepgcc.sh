#!/bin/bash

# Enable strict error handling
set -euo pipefail

# Variables
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROVIDER_DIR="${SCRIPT_DIR}/.."
PKGNAME="oqs-provider"
PKGVER="0.7.0"
LIBOQS_VERSION="0.11.0"
TEMPLATE_DIR="${PROVIDER_DIR}/oqs-template"
LIBOQS_SRC_DIR="${1:-/home/phaedrus/Forge/GH/Qompass/KO/liboqs}"

# Help message
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    printf "Usage: %s [LIBOQS_SRC_DIR]\n" "$0"
    printf "This script prepares, builds, and tests oqs-provider.\n"
    printf "LIBOQS_SRC_DIR: The path to the liboqs source directory (default: %s)\n" "${LIBOQS_SRC_DIR}"
    exit 0
fi

# Check if required commands are available
command -v python3 >/dev/null 2>&1 || {
    printf >&2 "Python 3 is required but not installed. Aborting.\n"
    exit 1
}
command -v sed >/dev/null 2>&1 || {
    printf >&2 "sed is required but not installed. Aborting.\n"
    exit 1
}

# Change to template directory
cd "${TEMPLATE_DIR}" || {
    printf "Directory %s not found. Aborting.\n" "${TEMPLATE_DIR}"
    exit 1
}

# Back up generate.yml for safety (optional)
cp generate.yml generate.yml.bak

# Update generate.yml to enable all algorithms
printf "Updating generate.yml to enable all algorithms.\n"
sed -i -e 's/enable: false/enable: true/g' generate.yml

# Run generatehelpers.py if necessary
if [[ -f "${TEMPLATE_DIR}/generatehelpers.py" ]]; then
    printf "Running generatehelpers.py.\n"
    python3 "${TEMPLATE_DIR}/generatehelpers.py"
else
    printf "generatehelpers.py not found. Skipping.\n"
fi

# Run generate.py
cd "${PROVIDER_DIR}" || {
    printf "Failed to change directory to %s. Aborting.\n" "${PROVIDER_DIR}"
    exit 1
}

if [[ -d "${LIBOQS_SRC_DIR}" ]]; then
    printf "Running generate.py with LIBOQS_SRC_DIR set to %s.\n" "${LIBOQS_SRC_DIR}"
    LIBOQS_SRC_DIR="${LIBOQS_SRC_DIR}" python3 oqs-template/generate.py
else
    printf "LIBOQS source directory %s not found. Aborting.\n" "${LIBOQS_SRC_DIR}"
    exit 1
fi

# Run generate_oid_nid_table.py to generate the OID and NID table
printf "Running generate_oid_nid_table.py to generate the OID and NID table.\n"
python3 oqs-template/generate_oid_nid_table.py --liboqs-docs-dir "${LIBOQS_SRC_DIR}/docs"

printf "Preparation completed successfully.\n"

# Build step
printf "Starting the build process.\n"

# Set compiler to GCC (recommended to avoid atomic issues with Clang)
# You can modify these variables to use Clang if desired.
C_COMPILER="/usr/bin/gcc"
CXX_COMPILER="/usr/bin/g++"

# Compiler flags to ensure C11 compatibility and fix atomic type issues
C_FLAGS="-std=gnu11 -Wno-error=incompatible-pointer-types -Wno-error=unknown-pragmas"

# Run cmake configuration and build
cmake -B build -S "${PROVIDER_DIR}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_C_COMPILER=${C_COMPILER} \
    -DCMAKE_CXX_COMPILER=${CXX_COMPILER} \
    -DCMAKE_C_FLAGS="${C_FLAGS}" \
    -Wno-dev

cmake --build build

# Check step
printf "Running tests to validate the build.\n"
cd build
ctest --verbose

printf "Build and test completed successfully.\n"

# End of Script
