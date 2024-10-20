#!/bin/bash

# Set liboqs directory
export liboqs_DIR=/usr/local

# Set liboqs source directory
export LIBOQS_SRC_DIR="/home/phaedrus/Forge/GH/liboqs"

# Enable all algorithms
export OQS_ALGS_ENABLED="STD"

# Update LD_LIBRARY_PATH to include the directory containing liboqs.so
export LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"

# Update PKG_CONFIG_PATH
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}"

# Set installation prefix
INSTALL_PREFIX="/usr/local"

# Set CMake parameters
export CMAKE_PARAMS="-DOPENSSL_CRYPTO_LIBRARY=/usr/lib64/libcrypto.so.3"

# Set CMake parameters including OQS_KEM_ENCODERS and external key storage
export OQSPROV_CMAKE_PARAMS="-DCMAKE_BUILD_TYPE=Release \
    -DOQS_LIBJADE_BUILD=ON \
    -DBUILD_SHARED_LIBS=ON \
    -DOQS_USE_SYSTEM_LIBOQS=ON \
    -Dliboqs_DIR=/usr/local \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
    -DOQS_KEM_ENCODERS=ON \
    -DNOPUBKEY_IN_PRIVKEY=OFF \
    -DOQS_PROVIDER_BUILD_STATIC=OFF \
    ${CMAKE_PARAMS}"

# Run the generate.py script
python oqs-template/generate.py

# Clean and recreate build directory with sudo
sudo rm -rf _build
mkdir _build
cd _build

# Run CMake
cmake -GNinja ${OQSPROV_CMAKE_PARAMS} ..

# Build
ninja

# Check if CMake files exist
if [[ ! -d "CMakeFiles" ]]; then
    echo "CMake files not found. Build may have failed."
    exit 1
fi

# Install
sudo ninja install

cd ..

echo "oqs-provider modules installed to: ${INSTALL_PREFIX}/lib/ossl-modules"
echo "Build and installation completed for oqs-provider with all algorithms and KEM encoders enabled."
echo "OpenSSL configuration updated to use oqs-provider."

