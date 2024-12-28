#!/bin/bash
# Use: sudo -E ./scripts/optbuild2.sh
# Script to build and install liboqs for OQS-Provider compatibility

set -euo pipefail

# Ensure that this script is run from the liboqs directory (not the scripts directory)
LIBOQS_DIR=$(pwd)
BUILD_DIR="${LIBOQS_DIR}/build"

# Create build directory
mkdir -p "${BUILD_DIR}"

# Run cmake to configure the build
cmake -GNinja \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="/opt/liboqs" \
    -DOQS_ALGS_ENABLED=All \
    -DOQS_BUILD_ONLY_LIB=OFF \
    -DOQS_DIST_BUILD=ON \
    -DOQS_USE_OPENSSL=ON \
    -DOQS_USE_AES_OPENSSL=ON \
    -DOQS_USE_SHA2_OPENSSL=ON \
    -DOQS_USE_SHA3_OPENSSL=ON \
    -DOQS_ENABLE_SIG_STFL_XMSS=ON \
    -DOQS_ENABLE_SIG_STFL_LMS=ON \
    -DOQS_HAZARDOUS_EXPERIMENTAL_ENABLE_SIG_STFL_KEY_SIG_GEN=ON \
    -DOQS_OPT_TARGET=x86-64 \
    -DOQS_STRICT_WARNINGS=ON \
    -Wno-dev \
    -B "${BUILD_DIR}"

# Build liboqs
printf "Building liboqs...\n"
sudo ninja -C "${BUILD_DIR}" || {
    printf "Ninja build failed, continuing for debugging purposes...\n"
}

# Generate documentation
printf "Generating documentation...\n"
sudo ninja -C "${BUILD_DIR}" gen_docs || {
    printf "Documentation generation failed.\n"
}

# Install documentation to /opt/liboqs/docs
printf "Installing documentation to /opt/liboqs/docs...\n"
if [[ -d "${BUILD_DIR}/docs" ]]; then
    sudo mkdir -p /opt/liboqs/docs
    sudo cp -r "${BUILD_DIR}/docs"/* /opt/liboqs/docs/ || {
        printf "Documentation installation failed.\n"
    }
else
    printf "Documentation directory not found. Skipping documentation installation.\n"
fi

# Run tests and capture results
TEST_REPORT_FILE="${BUILD_DIR}/test_report_$(date +'%Y%m%d_%H%M%S').txt"
printf "Running tests and capturing results to %s...\n" "${TEST_REPORT_FILE}"
sudo ninja -C "${BUILD_DIR}" run_tests | tee "${TEST_REPORT_FILE}" || {
    printf "Some tests failed. Test report saved to %s\n" "${TEST_REPORT_FILE}"
}

# Install the library to /opt/liboqs
if [[ -d "${BUILD_DIR}" ]]; then
    printf "Installing liboqs to /opt/liboqs...\n"
    sudo ninja -C "${BUILD_DIR}" install || {
        printf "Installation failed, some issues occurred.\n"
    }
else
    printf "Build directory not found, skipping installation.\n"
fi

# Create a configuration file for /opt/liboqs
printf "Creating ld.so configuration for liboqs...\n"
echo "/opt/liboqs/lib" | sudo tee /etc/ld.so.conf.d/liboqs.conf
sudo ldconfig

# Create environment wrapper script
WRAPPER_SCRIPT="/opt/liboqs/liboqs_env.sh"
cat <<EOF | sudo tee "${WRAPPER_SCRIPT}" || true
#!/bin/bash
export LD_LIBRARY_PATH="/opt/liboqs/lib:\$LD_LIBRARY_PATH"
export C_INCLUDE_PATH="/opt/liboqs/include:\$C_INCLUDE_PATH"
export PATH="/opt/liboqs/bin:\$PATH"
EOF
sudo chmod +x "${WRAPPER_SCRIPT}"

# Summary message
cat <<EOF

To use Qompass liboqs, you may want to source the environment variables for your current shell session:

. /opt/liboqs/liboqs_env.sh

Alternatively, you can use the commands in the script above in a terminal when needed.

EOF

