#!/bin/bash
# Script to build and install oqs-provider aligned with liboqs installation into /opt/liboqs without interfering with system packages

# Set liboqs installation directory
LIBOQS_INSTALL_DIR="/opt/liboqs"

# Set OpenSSL installation directory
OPENSSL_INSTALL_DIR="/opt/openssl-oqs"

# Step 1: Build oqs-provider with CMake
# Ensure the script is run from the oqs-provider directory
OQSPROV_SRC_DIR="$(pwd)/.."

# Clean any existing build artifacts
BUILD_DIR="${OQSPROV_SRC_DIR}/_build"
sudo rm -rf "$BUILD_DIR"
mkdir "$BUILD_DIR"
cd "$BUILD_DIR"

# Configure the oqs-provider build
cmake -GNinja \
    -DCMAKE_INSTALL_PREFIX="${OPENSSL_INSTALL_DIR}" \
    -DOPENSSL_ROOT_DIR="${OPENSSL_INSTALL_DIR}" \
    -DOPENSSL_CRYPTO_LIBRARY="${LIBOQS_INSTALL_DIR}/lib/liboqs.so" \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -Dliboqs_DIR="${LIBOQS_INSTALL_DIR}" \
    -Wno-dev ..

# Build oqs-provider
ninja

# Step 2: Install oqs-provider
sudo ninja install

# Step 3: Verify the installation
# Check if oqs-provider was installed correctly
if [[ -f "${OPENSSL_INSTALL_DIR}/lib/ossl-modules/oqsprovider.so" ]]; then
    echo "oqs-provider installed successfully to: ${OPENSSL_INSTALL_DIR}/lib/ossl-modules"
else
    echo "oqs-provider installation failed."
    exit 1
fi

# Step 4: Update environment variables script (Optional)
# Create a wrapper script to use these environment variables locally when needed
WRAPPER_SCRIPT="${OPENSSL_INSTALL_DIR}/oqsprovider_env.sh"
cat << EOF | sudo tee "$WRAPPER_SCRIPT"
#!/bin/bash
export PKG_CONFIG_PATH="${LIBOQS_INSTALL_DIR}/lib/pkgconfig:\$PKG_CONFIG_PATH"
export PATH="${OPENSSL_INSTALL_DIR}/bin:\$PATH"
EOF
sudo chmod +x "$WRAPPER_SCRIPT"

cat << EOF

To use OpenSSL with oqs-provider, source the environment variables for your current shell session:

source ${OPENSSL_INSTALL_DIR}/oqsprovider_env.sh

Alternatively, use the commands in the script above in a terminal when needed.
EOF

