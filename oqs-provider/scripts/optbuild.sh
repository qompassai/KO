#!/bin/bash
# Script to build and install oqs-provider aligned with liboqs and OpenSSL installation into /opt/qompassl without interfering with system packages

# Enable strict error handling
set -euo pipefail

# Set liboqs and OpenSSL installation directory
LIBOQS_INSTALL_DIR="/opt/liboqs"
OPENSSL_INSTALL_DIR="/opt/qompassl"

# Set compiler to Clang
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

# Use LLVM linker
export CMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld"
export CMAKE_SHARED_LINKER_FLAGS="-fuse-ld=lld"

if [[ ! -d "oqs-provider" ]]; then
    git clone https://github.com/open-quantum-safe/oqs-provider.git
fi
cd oqs-provider
git fetch --all --tags
git checkout tags/0.7.0

OQSPROV_SRC_DIR="${PWD}/.."

BUILD_DIR="${OQSPROV_SRC_DIR}/_build"
if [[ -d "${BUILD_DIR}" ]]; then
    rm -rf "${BUILD_DIR}"
fi
mkdir "${BUILD_DIR}"
cd "${BUILD_DIR}"

cmake -GNinja \
    -DCMAKE_INSTALL_PREFIX="${OPENSSL_INSTALL_DIR}" \
    -DOPENSSL_ROOT_DIR="${OPENSSL_INSTALL_DIR}" \
    -Dliboqs_DIR="${LIBOQS_INSTALL_DIR}/lib/cmake/liboqs" \
    -DOPENSSL_LIBRARIES="${OPENSSL_INSTALL_DIR}/lib64/libssl.so;${OPENSSL_INSTALL_DIR}/lib64/libcrypto.so" \
    -DCMAKE_C_COMPILER=/usr/bin/clang \
    -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
    -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_C_FLAGS="-I${LIBOQS_INSTALL_DIR}/include/oqs" \
    -Wno-dev ..

# Build oqs-provider using Ninja
sudo ninja

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
cat <<EOF | sudo tee "${WRAPPER_SCRIPT}"
#!/bin/bash
export PKG_CONFIG_PATH="${LIBOQS_INSTALL_DIR}/lib/pkgconfig:\$PKG_CONFIG_PATH"
export PATH="${OPENSSL_INSTALL_DIR}/bin:\$PATH"
export LD_LIBRARY_PATH="${LIBOQS_INSTALL_DIR}/lib:\$LD_LIBRARY_PATH"
EOF
sudo chmod +x "${WRAPPER_SCRIPT}"

# Inform the user about how to source the environment wrapper
cat <<EOF

To use OpenSSL with oqs-provider, source the environment variables for your current shell session:

source ${OPENSSL_INSTALL_DIR}/oqsprovider_env.sh

Alternatively, use the commands in the script above in a terminal when needed.
EOF
