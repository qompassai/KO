#!/bin/bash
# Use: ./scripts/localbuild.sh
# Script to build and install liboqs for user-accessible OpenSSL compatibility

set -euo pipefail

# Ensure that this script is run from the liboqs directory (not the scripts directory)
LIBOQS_DIR=$(pwd)
BUILD_DIR="${LIBOQS_DIR}/build"

# Create build directory
sudo mkdir -p "${BUILD_DIR}"

# Run cmake to configure the build
sudo cmake -GNinja \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="/usr/local" \
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
    -DCMAKE_C_FLAGS="-march=native -fno-stack-protector -Wno-sign-conversion -Wno-implicit-function-declaration -Wno-unknown-pragmas" \
    -DCMAKE_REQUIRED_LIBRARIES="c" \
    -DOPENSSL_ROOT_DIR="/usr/local/ssl" \
    -DOPENSSL_INCLUDE_DIR="/usr/local/ssl/include" \
    -DOPENSSL_LIBRARIES="/usr/local/ssl/lib/libcrypto.so;/usr/local/ssl/lib/libssl.so" \
    -DCMAKE_LIBRARY_PATH="/usr/local/ssl/lib" \
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

# Generate documentation for liboqs
printf "Generating documentation...\n"
sudo cmake --build "${LIBOQS_DIR}" --target docs || {
    printf "Documentation generation failed. Proceeding without docs.\n"
}

# Install documentation to /usr/local/share/liboqs/docs
printf "Installing documentation to /usr/local/share/liboqs/docs...\n"
if [[ -d "${LIBOQS_DIR}/docs" ]]; then
    sudo mkdir -p /usr/local/share/liboqs/docs
    sudo cp -r "${LIBOQS_DIR}/docs"/* /usr/local/share/liboqs/docs/ || {
        printf "Documentation installation failed.\n"
    }
else
    printf "Documentation directory not found. Skipping documentation installation.\n"
fi

# Install algorithms documentation to /usr/local/share/liboqs/docs/algorithms
printf "Installing algorithms documentation to /usr/local/share/liboqs/docs/algorithms...\n"
if [[ -d "${LIBOQS_DIR}/docs/algorithms" ]]; then
    sudo mkdir -p /usr/local/share/liboqs/docs/algorithms
    sudo cp -r "${LIBOQS_DIR}/docs/algorithms"/* /usr/local/share/liboqs/docs/algorithms/ || {
        printf "Algorithms documentation installation failed.\n"
    }
else
    printf "Algorithms documentation directory not found. Skipping algorithms documentation installation.\n"
fi

# Run tests and capture results
TEST_REPORT_FILE="${BUILD_DIR}/test_report_$(date +'%Y%m%d_%H%M%S').txt"
printf "Running tests and capturing results to %s...\n" "${TEST_REPORT_FILE}"
sudo ninja -C "${BUILD_DIR}" run_tests | tee "${TEST_REPORT_FILE}" || {
    printf "Some tests failed. Test report saved to %s\n" "${TEST_REPORT_FILE}"
}

# Install the library to /usr/local
if [[ -d "${BUILD_DIR}" ]]; then
    printf "Installing liboqs to /usr/local...\n"
    sudo ninja -C "${BUILD_DIR}" install || {
        printf "Installation failed, some issues occurred.\n"
    }
else
    printf "Build directory not found, skipping installation.\n"
fi

# Create a configuration file for /usr/local
printf "Creating ld.so configuration for liboqs...\n"
echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/liboqs.conf
sudo ldconfig

# Create environment wrapper script
sudo mkdir -p /usr/local/share/liboqs
WRAPPER_SCRIPT="/usr/local/share/liboqs/liboqs_env.sh"
cat <<EOF | sudo tee "${WRAPPER_SCRIPT}" || true
#!/bin/bash
export LD_LIBRARY_PATH="/usr/local/lib:/usr/local/ssl/lib:\$LD_LIBRARY_PATH"
export C_INCLUDE_PATH="/usr/local/include:/usr/local/ssl/include:\$C_INCLUDE_PATH"
export PATH="/usr/local/bin:/usr/local/ssl/bin:\$PATH"
EOF
sudo chmod +x "${WRAPPER_SCRIPT}"

# Summary message
cat <<EOF

To use Qompass liboqs, you may want to source the environment variables for your current shell session:

. /usr/local/share/liboqs/liboqs_env.sh

Alternatively, you can use the commands in the script above in a terminal when needed.

For convenience, you can create an alias:

alias oqs_env_setup="source /usr/local/share/liboqs/liboqs_env.sh"

EOF
