#!/bin/bash
#use sudo ./scripts/oqsprep.sh
set -euo pipefail
if [[ -f ~/liboqssrc.sh ]]; then
    printf "Sourcing QLIBOQS environment variable from ~/liboqssrc.sh\n"
    . ~/liboqssrc.sh
else
    printf "Warning: ~/liboqssrc.sh not found.\n"
    printf "Please create ~/liboqssrc.sh with the following content:\n"
    printf "export QLIBOQS=\"/path/to/your/liboqs/source\"\n"
    printf "Example: export QLIBOQS=\"/home/username/Forge/GH/Qompass/KO/liboqs\"\n"
    exit 1
fi
: "${QLIBOQS:?QLIBOQS environment variable is not set}"
LIBOQS_SRC_DIR="${QLIBOQS}"
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROVIDER_DIR="${SCRIPT_DIR}/.."
PKGNAME="oqs-provider"
PKGVER="0.7.0"
LIBOQS_VERSION="0.11.0"
TEMPLATE_DIR="${PROVIDER_DIR}/oqs-template"
OPENSSL_INSTALL_DIR="/opt/qompassl"
LIBOQS_INSTALL_DIR="/opt/liboqs"
OPENSSL_MODULES_DIR="${OPENSSL_INSTALL_DIR}/lib64/ossl-modules"
CPATH="${CPATH:+${CPATH}:}/opt/liboqs/include"
LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/opt/liboqs/lib"
if [[ "${OSTYPE}" == "linux-gnu"* ]]; then
    LOG_DIR="${XDG_DATA_HOME:-${HOME}/.local/share}/oqs/logs"
elif [[ "${OSTYPE}" == "darwin"* ]]; then
    LOG_DIR="${XDG_DATA_HOME:-${HOME}/Library/Application Support}/oqs/logs"
elif [[ "${OSTYPE}" == "cygwin" || "${OSTYPE}" == "msys" ]]; then
    LOG_DIR="${APPDATA:-${HOME}/AppData/Roaming}/oqs/logs"
else
    printf "Unsupported OS."
    exit 1
fi
if [[ -n "${QLIBOQS-}" ]]; then
    LIBOQS_SRC_DIR="${QLIBOQS}"
else
    printf "Error: QLIBOQS is not set"
    exit 1
fi

LOG_DIR="${PROVIDER_DIR}/reports"
mkdir -p "${LOG_DIR}"
LOG_FILE="${LOG_DIR}/build_test_results_$(date +'%Y-%m-%d_%H-%M-%S').log"

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    printf "Usage: %s [options]\n" "$0"
    printf "This script prepares, builds, and tests the Qompass KO oqs-provider build.\n\n"
    printf "Required Environment Setup:\n"
    printf "  1. Create ~/liboqssrc.sh with the following content:\n"
    printf "     export QLIBOQS=\"/path/to/your/liboqs/source\"\n"
    printf "  2. Current QLIBOQS setting: %s\n\n" "${QLIBOQS}"
    printf "Note: QLIBOQS must point to your liboqs source directory\n"
    exit 0
fi
command -v python3 >/dev/null 2>&1 || {
    printf >&2 "Python 3 is required but not installed. Aborting.\n"
    exit 1
}
command -v sed >/dev/null 2>&1 || {
    printf >&2 "sed is required but not installed. Aborting.\n"
    exit 1
}
cd "${TEMPLATE_DIR}" || {
    printf "Directory %s not found. Aborting.\n" "${TEMPLATE_DIR}"
    exit 1
}
cp generate.yml generate.yml.bak
printf "Updating generate.yml to enable all algorithms.\n"
sed -i -e 's/enable: false/enable: true/g' generate.yml

if [[ -f "${TEMPLATE_DIR}/generatehelpers.py" ]]; then
    printf "Running generatehelpers.py.\n"
    python3 "${TEMPLATE_DIR}/generatehelpers.py"
else
    printf "generatehelpers.py not found. Skipping.\n"
fi

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
printf "Running generate_oid_nid_table.py to generate the OID and NID table.\n"
python3 oqs-template/generate_oid_nid_table.py --liboqs-docs-dir "${LIBOQS_SRC_DIR}/docs"
printf "Preparation completed successfully.\n"
printf "Starting the build process.\n"
C_COMPILER="/usr/bin/clang" # 18.1.8
CXX_COMPILER="/usr/bin/clang++"
C_FLAGS="-std=gnu11 -Wno-error=incompatible-pointer-types -Wno-error=unknown-pragmas"
BUILD_CMD="cmake -B build -S \"${PROVIDER_DIR}\" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=\"${OPENSSL_INSTALL_DIR}\" \
    -DCMAKE_C_COMPILER=\"${C_COMPILER}\" \
    -DCMAKE_CXX_COMPILER=\"${CXX_COMPILER}\" \
    -DCMAKE_C_FLAGS=\"${C_FLAGS}\" \
    -DOPENSSL_ROOT_DIR=\"${OPENSSL_INSTALL_DIR}\" \
    -Dliboqs_DIR=\"${LIBOQS_INSTALL_DIR}/lib/cmake/liboqs\" \
    -DCMAKE_INCLUDE_PATH=\"${LIBOQS_INSTALL_DIR}/include\" \
    -DOPENSSL_LIBRARIES=\"${OPENSSL_INSTALL_DIR}/lib64/libssl.so;${OPENSSL_INSTALL_DIR}/lib64/libcrypto.so\" \
    -DOPENSSL_MODULES_DIR=\"${OPENSSL_MODULES_DIR}\" \
    -Wno-dev"
if [[ "${EUID}" -ne 0 ]]; then
    printf "Running build configuration with elevated permissions.\n"
    eval "sudo ${BUILD_CMD}"
else
    printf "Running build configuration with regular permissions.\n"
    eval "${BUILD_CMD}"
fi
cmake --build build
printf "Running tests to validate the build.\n"
cd build
ctest --verbose | tee "${LOG_FILE}"
printf "Build and test completed successfully.\n"
printf "Test results have been saved to %s\n" "${LOG_FILE}"
