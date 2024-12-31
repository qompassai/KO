#!/bin/bash
# Use: sudo -E ./scripts/localbuild2.sh
# This script builds and prepares the OQS provider for installation to /usr/local.

set -euo pipefail

# Ensure QLIBOQS is set or retrieve it using pass
if [[ -z "${QLIBOQS:-}" ]]; then
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
        printf "Error: QLIBOQS environment variable is not set and pass is not available. Aborting.\n"
        exit 1
    fi
else
    printf "Using QLIBOQS environment variable: %s\n" "${QLIBOQS}"
fi

# Variables
LIBOQS_SRC_DIR="${QLIBOQS}"
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROVIDER_DIR="${SCRIPT_DIR}/.."
TEMPLATE_DIR="${PROVIDER_DIR}/oqs-template"
BUILD_DIR="${PROVIDER_DIR}/build"
LOG_DIR="${PROVIDER_DIR}/reports"
LIBOQS_INSTALL_DIR="/usr/local"
OPENSSL_INSTALL_DIR="/usr/local"
C_COMPILER="/usr/bin/clang"
CXX_COMPILER="/usr/bin/clang++"
C_FLAGS="-std=gnu11 -Wno-error=incompatible-pointer-types -Wno-error=unknown-pragmas"

export CPATH="${CPATH:-}/usr/local/include"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:-}/usr/local/lib"

# Prepare directories
mkdir -p "${LOG_DIR}" "${BUILD_DIR}"

# Check dependencies
for cmd in python3 sed cmake ctest; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        printf "Error: %s is required but not installed. Aborting.\n" "$cmd"
        exit 1
    fi
done

# Enable all algorithms in generate.yml
cd "${TEMPLATE_DIR}" || {
    printf "Directory %s not found. Aborting.\n" "${TEMPLATE_DIR}"
    exit 1
}
cp generate.yml generate.yml.bak
printf "Updating generate.yml to enable all algorithms.\n"
sed -i -e 's/enable: false/enable: true/g' generate.yml

# Run generatehelpers.py if available
if [[ -f "${TEMPLATE_DIR}/generatehelpers.py" ]]; then
    printf "Running generatehelpers.py.\n"
    python3 "${TEMPLATE_DIR}/generatehelpers.py"
else
    printf "generatehelpers.py not found. Skipping.\n"
fi

# Generate OQS provider source files
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

# Generate the OID and NID table
printf "Running generate_oid_nid_table.py to generate the OID and NID table.\n"
python3 oqs-template/generate_oid_nid_table.py --liboqs-docs-dir "${LIBOQS_SRC_DIR}/docs"

# Configure CMake
printf "Configuring the OQS provider build with CMake.\n"
sudo rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cmake -B "${BUILD_DIR}" -S "${PROVIDER_DIR}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="${OPENSSL_INSTALL_DIR}" \
    -DCMAKE_C_COMPILER="${C_COMPILER}" \
    -DCMAKE_CXX_COMPILER="${CXX_COMPILER}" \
    -DCMAKE_C_FLAGS="${C_FLAGS}" \
    -DOPENSSL_ROOT_DIR="${OPENSSL_INSTALL_DIR}" \
    -Dliboqs_DIR="${LIBOQS_INSTALL_DIR}/lib/cmake/liboqs" \
    -DBUILD_TESTING=ON \
    -DOPENSSL_LIBRARIES="${OPENSSL_INSTALL_DIR}/lib/libssl.so;${OPENSSL_INSTALL_DIR}/lib/libcrypto.so" \
    -Wno-dev

# Build the project
sudo cmake --build "${BUILD_DIR}" || {
    printf "Build failed. Aborting installation.\n"
    exit 1
}

# Run tests
printf "Running tests to validate the build before installation.\n"
LOG_FILE="${LOG_DIR}/qbuild_test_results_$(date +'%Y-%m-%d_%H-%M-%S').txt"
pushd "${BUILD_DIR}" || {
    printf "Failed to enter build directory. Aborting.\n"
    exit 1
}
ctest --output-on-failure --verbose | tee "${LOG_FILE}"
popd
if grep -q "No tests were found!!!" "${LOG_FILE}" || grep -q "errors detected" "${LOG_FILE}"; then
    printf "Tests failed. Aborting installation.\n"
    exit 1
else
    printf "Tests completed successfully. Proceeding to installation.\n"
    sudo cmake --install "${BUILD_DIR}"
fi

# Finalize test results
sed -i -e 's/[^[:print:]\t]//g' -e 's/\x1b\[[0-9;]*m//g' -e 's/\s\{1,\}\([0-9]\+:\)/\n\1/g' "${LOG_FILE}"
printf "Build and test completed successfully.\n"
printf "Test results have been saved to:\n"
printf "  - Log File: %s\n" "${LOG_FILE}"

