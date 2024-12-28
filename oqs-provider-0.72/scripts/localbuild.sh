#!/bin/bash
# Use: sudo ./scripts/localbuild.sh

set -euo pipefail
#if command -v pass >/dev/null 2>&1; then
#    if pass show liboqs/source >/dev/null 2>&1; then
#        QLIBOQS=$(pass show liboqs/source)
#        printf "Using QLIBOQS environment variable from pass: %s\n" "${QLIBOQS}"
#    else
#        printf "Error: QLIBOQS path not found in pass. Please add it using:\n"
#        printf "pass insert liboqs/source\n"
#        exit 1
#    fi
#else
#    printf "Error: pass is not installed or not in PATH. Aborting.\n"
#    exit 1
#fi
#: "${QLIBOQS:?QLIBOQS environment variable is not set}"
LIBOQS_SRC_DIR="/home/phaedrus/Forge/.GH/Qompass/KO/liboqs"
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROVIDER_DIR="${SCRIPT_DIR}/.."
TEMPLATE_DIR="${PROVIDER_DIR}/oqs-template"
BUILD_DIR="${PROVIDER_DIR}/build"
LIBOQS_INSTALL_DIR="/usr/local"
OPENSSL_INSTALL_DIR="${PROVIDER_DIR}/openssl"
export CPATH="${CPATH:-}:/usr/local/include"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:-}:/usr/local/lib:${OPENSSL_INSTALL_DIR}/lib"
LOG_DIR="${PROVIDER_DIR}/reports"
C_COMPILER="/usr/bin/clang"
CXX_COMPILER="/usr/bin/clang++"
C_FLAGS="-std=gnu11 -march=native -Wno-error=incompatible-pointer-types -Wno-error=unknown-pragmas -Wno-error=sign-conversion"

sudo mkdir -p "${LOG_DIR}"
sudo mkdir -p "${BUILD_DIR}"

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

printf "Configuring the OQS provider build with CMake.\n"
sudo cmake -B "${BUILD_DIR}" -S "${PROVIDER_DIR}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="/usr/local" \
  -DCMAKE_C_COMPILER="${C_COMPILER}" \
  -DCMAKE_CXX_COMPILER="${CXX_COMPILER}" \
  -DOPENSSL_ROOT_DIR="/usr/local" \
  -Dliboqs_DIR="/usr/local/lib/cmake/liboqs" \
  -Dliboqs_DIR="${LIBOQS_INSTALL_DIR}/lib/cmake/liboqs" \
  -DBUILD_TESTING=ON \
  -DOPENSSL_LIBRARIES="/usr/local/lib/libssl.so;/usr/local/lib/libcrypto.so" \
  -Wno-dev

# Build the project
printf "Building the OQS provider.\n"
sudo cmake --build "${BUILD_DIR}" || {
  printf "Build failed. Aborting installation.\n"
  exit 1
}

# Run tests to validate the build
printf "Running tests to validate the build before installation.\n"
LOG_FILE="${LOG_DIR}/qbuild_test_results_$(date +'%Y-%m-%d_%H-%M-%S').txt"
MD_FILE="${LOG_DIR}/qbuild_test_results_$(date +'%Y-%m-%d_%H-%M-%S').md"
PDF_FILE="${LOG_DIR}/qbuild_test_results_$(date +'%Y-%m-%d_%H-%M-%S').pdf"
export OPENSSL_MODULES="${OPENSSL_INSTALL_DIR}/lib/ossl-modules"
export LD_LIBRARY_PATH="${OPENSSL_INSTALL_DIR}/lib:${LD_LIBRARY_PATH:-}"

pushd "${BUILD_DIR}" || {
  printf "Failed to enter build directory. Aborting.\n"
  exit 1
}
ctest --output-on-failure --verbose | tee "${LOG_FILE}"
popd

# Check test results
if grep -q "No tests were found!!!" "${LOG_FILE}" || grep -q "errors detected" "${LOG_FILE}"; then
  printf "Tests failed. Aborting installation.\n"
  exit 1
else
  printf "Tests completed successfully. Proceeding to installation.\n"
  sudo cmake --install "${BUILD_DIR}"
fi

sed -i -e 's/[^[:print:]	]//g' -e 's/\x1b\[[0-9;]*m//g' -e 's/\s\{1,\}\([0-9]\+:\)/\n\1/g' "${LOG_FILE}"
printf "# OQS-Provider Test Results\n\n" >"${MD_FILE}"
cat "${LOG_FILE}" >>"${MD_FILE}"
if command -v pandoc >/dev/null 2>&1; then
  printf "Converting test results to PDF...\n"
  if pandoc "${MD_FILE}" -o "${PDF_FILE}" --pdf-engine=xelatex; then
    printf "Test results have been successfully saved to %s\n" "${PDF_FILE}"
  else
    printf "Error: Failed to create PDF. Please check pandoc installation.\n"
  fi
else
  printf "Pandoc not found. Skipping PDF generation.\n"
fi

ALGORITHMS_TXT="${LOG_DIR}/openssl_algorithms_$(date +'%Y-%m-%d_%H-%M-%S').txt"
ALGORITHMS_MD="${LOG_DIR}/openssl_algorithms_$(date +'%Y-%m-%d_%H-%M-%S').md"
ALGORITHMS_PDF="${LOG_DIR}/openssl_algorithms_$(date +'%Y-%m-%d_%H-%M-%S').pdf"

openssl list -all-algorithms >"${ALGORITHMS_TXT}"

printf "# OpenSSL Available Algorithms\n\n" >"${ALGORITHMS_MD}"
cat "${ALGORITHMS_TXT}" >>"${ALGORITHMS_MD}"

if command -v pandoc >/dev/null 2>&1; then
  printf "Converting OpenSSL algorithms list to PDF...\n"
  if pandoc "${ALGORITHMS_MD}" -o "${ALGORITHMS_PDF}" --pdf-engine=xelatex; then
    printf "Algorithm list has been successfully saved to %s\n" "${ALGORITHMS_PDF}"
  else
    printf "Error: Failed to create PDF for algorithm list. Please check pandoc installation.\n"
  fi
else
  printf "Pandoc not found. Skipping PDF generation for algorithm list.\n"
fi

printf "Build and test completed successfully.\n"
printf "OQS-Provider Test results have been saved to:\n"
printf -- "- Log File: %s\n" "${LOG_FILE}"
printf -- "- Markdown File: %s\n" "${MD_FILE}"
if [[ -f "${PDF_FILE}" ]]; then
  printf -- "- PDF File: %s\n" "${PDF_FILE}"
fi
printf "OpenSSL Algorithms list has been saved to:\n"
printf -- "- Text File: %s\n" "${ALGORITHMS_TXT}"
printf -- "- Markdown File: %s\n" "${ALGORITHMS_MD}"
if [[ -f "${ALGORITHMS_PDF}" ]]; then
  printf -- "- PDF File: %s\n" "${ALGORITHMS_PDF}"
fi
