#!/bin/bash
#use sudo -E ./scripts/oqsprep.sh
set -euo pipefail
if command -v pass >/dev/null 2>&1; then
    if pass show liboqs/source >/dev/null 2>&1; then
        QLIBOQS=$(pass show liboqs/source)
        printf "Using QLIBOQS environment variable from pass: %s\n" "${QLIBOQS}"
    else
        printf "Error: QLIBOQS path not found in pass. Please add it using:\n"
        printf "pass insert liboqs/source\n"
        exit 1
    fi
else
    printf "Error: pass is not installed or not in PATH. Aborting.\n"
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
if [[ -n "${CPATH:-}" ]]; then
    CPATH="${CPATH}:/opt/liboqs/include"
else
    CPATH="/opt/liboqs/include"
fi
if [[ -n "${LD_LIBRARY_PATH:-}" ]]; then
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/opt/liboqs/lib"
else
    LD_LIBRARY_PATH="/opt/liboqs/lib"
fi
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
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    printf "Usage: %s [options]\n" "$0"
    printf "This script prepares, builds, and tests the Qompass KO oqs-provider build.\n\n"
    printf "Required Environment Setup:\n"
    printf "  1. Add the source path to pass using:\n"
    printf "     pass insert liboqs/source\n"
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
    LIBOQS_SRC_DIR="${LIBOQS_SRC_DIR}" python3 -E oqs-template/generate.py
else
    printf "LIBOQS source directory %s not found. Aborting.\n" "${LIBOQS_SRC_DIR}"
    exit 1
fi
printf "Running generate_oid_nid_table.py to generate the OID and NID table.\n"
python3 -E oqs-template/generate_oid_nid_table.py --liboqs-docs-dir "${LIBOQS_SRC_DIR}/docs"
printf "Preparation completed successfully.\n"
printf "Starting the build process.\n"
C_COMPILER="/usr/bin/clang" # 18.1.8
CXX_COMPILER="/usr/bin/clang++"
C_FLAGS="-std=gnu11 -Wno-error=incompatible-pointer-types -Wno-error=unknown-pragmas"
if [[ "${EUID}" -ne 0 ]]; then
    printf "Running build configuration with elevated permissions.\n"
    sudo cmake -B build -S "${PROVIDER_DIR}" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="${OPENSSL_INSTALL_DIR}" \
        -DCMAKE_C_COMPILER="${C_COMPILER}" \
        -DCMAKE_CXX_COMPILER="${CXX_COMPILER}" \
        -DCMAKE_C_FLAGS="${C_FLAGS}" \
        -DOPENSSL_ROOT_DIR="${OPENSSL_INSTALL_DIR}" \
        -Dliboqs_DIR="${LIBOQS_INSTALL_DIR}/lib/cmake/liboqs" \
        -DCMAKE_INCLUDE_PATH="${LIBOQS_INSTALL_DIR}/include" \
        -DOPENSSL_LIBRARIES="${OPENSSL_INSTALL_DIR}/lib64/libssl.so;${OPENSSL_INSTALL_DIR}/lib64/libcrypto.so" \
        -DOPENSSL_MODULES_DIR="${OPENSSL_INSTALL_DIR}/lib64/ossl-modules" \
        -Wno-dev
else
    printf "Running build configuration with regular permissions.\n"
    cmake -B build -S "${PROVIDER_DIR}" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX="${OPENSSL_INSTALL_DIR}" \
        -DCMAKE_C_COMPILER="${C_COMPILER}" \
        -DCMAKE_CXX_COMPILER="${CXX_COMPILER}" \
        -DCMAKE_C_FLAGS="${C_FLAGS}" \
        -DOPENSSL_ROOT_DIR="${OPENSSL_INSTALL_DIR}" \
        -Dliboqs_DIR="${LIBOQS_INSTALL_DIR}/lib/cmake/liboqs" \
        -DCMAKE_INCLUDE_PATH="${LIBOQS_INSTALL_DIR}/include" \
        -DOPENSSL_LIBRARIES="${OPENSSL_INSTALL_DIR}/lib64/libssl.so;${OPENSSL_INSTALL_DIR}/lib64/libcrypto.so" \
        -DOPENSSL_MODULES_DIR="${OPENSSL_INSTALL_DIR}/lib64/ossl-modules" \
        -Wno-dev
fi
sudo cmake --build build || {
    printf "Build failed. Aborting installation.\n"
    exit 1
}
sudo cmake --install build
printf "Running tests to validate the build in the install directory.\n"
cd "${PROVIDER_DIR}" || {
    printf "Failed to change directory to %s. Aborting.\n" "${PROVIDER_DIR}"
    exit 1
}
LOG_FILE="${LOG_DIR}/qbuild_test_results_$(date +'%Y-%m-%d_%H-%M-%S').txt"
MD_FILE="${LOG_DIR}/qbuild_test_results_$(date +'%Y-%m-%d_%H-%M-%S').md"
PDF_FILE="${LOG_DIR}/qbuild_test_results_$(date +'%Y-%m-%d_%H-%M-%S').pdf"
export OPENSSL_MODULES="${OPENSSL_INSTALL_DIR}/lib64/ossl-modules"
export LD_LIBRARY_PATH="${OPENSSL_INSTALL_DIR}/lib64:${LD_LIBRARY_PATH}"
ctest --verbose | tee "${LOG_FILE}"
sed -i -e 's/[^[:print:]\t]//g' -e 's/\x1b\[[0-9;]*m//g' -e 's/\s\{1,\}\([0-9]\+:\)/\n\1/g' "${LOG_FILE}"
printf "# OQS-Provider Test Results\n\n" >"${MD_FILE}"
cat "${LOG_FILE}" >>"${MD_FILE}"
printf "Converting test results to PDF...\n"
if pandoc "${MD_FILE}" -o "${PDF_FILE}" --pdf-engine=xelatex; then
    printf "Test results have been successfully saved to %s\n" "${PDF_FILE}"
else
    printf "Error: Failed to create PDF. Please check pandoc installation.\n"
fi
printf "Build and test completed successfully.\n"
printf "OQS-Provider Test results have been saved to:\n"
printf -- "- Log File: %s\n" "${LOG_FILE}"
printf -- "- Markdown File: %s\n" "${MD_FILE}"
if [[ -f "${PDF_FILE}" ]]; then
    printf -- "- PDF File: %s\n" "${PDF_FILE}"
fi
