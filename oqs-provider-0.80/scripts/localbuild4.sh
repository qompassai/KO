#!/bin/bash
set -euo pipefail

# Ensure QLIBOQS is set
if [[ -z "${QLIBOQS:-}" ]]; then
    echo "Error: QLIBOQS environment variable is not set. Exiting."
    exit 1
fi
echo "Using QLIBOQS source directory: $QLIBOQS"

# Check and use OpenSSL installation
if [[ -z "${OPENSSL_INSTALL:-}" ]]; then
    openssl version | grep "OpenSSL 3" > /dev/null 2>&1
    if [[ $? -ne 0 || -n "${OPENSSL_BRANCH:-}" ]]; then
        if [[ -z "${OPENSSL_BRANCH:-}" ]]; then
            OPENSSL_BRANCH="master"
        fi
        echo "Building OpenSSL 3 from source (branch: $OPENSSL_BRANCH)..."
        if [[ ! -d "openssl" ]]; then
            git clone --depth 1 --branch "$OPENSSL_BRANCH" https://github.com/openssl/openssl.git
        fi
        cd openssl
        ./config --prefix=$(pwd)/../.local
        make -j$(nproc) && make install_sw
        cd ..
        OPENSSL_INSTALL=$(pwd)/.local
    else
        OPENSSL_INSTALL=$(openssl version -d | awk -F'"' '{print $2}')
    fi
fi
echo "Using OpenSSL installation: $OPENSSL_INSTALL"

# Check if liboqs is built
if [[ ! -f "$QLIBOQS/_build/lib/liboqs.a" ]]; then
    echo "Building liboqs from source in $QLIBOQS..."
    cd "$QLIBOQS"
    cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=$(pwd)/../.local \
        -DOPENSSL_ROOT_DIR="$OPENSSL_INSTALL" \
        -B _build -S .
    ninja -C _build install
    cd -
fi
liboqs_DIR="$QLIBOQS/_build"
echo "Using liboqs build directory: $liboqs_DIR"

# Build OQS provider
if [[ ! -f "_build/lib/oqsprovider.so" ]]; then
    echo "Building OQS provider..."
    cmake -GNinja -DCMAKE_BUILD_TYPE=Release \
        -Dliboqs_DIR="$liboqs_DIR" \
        -DOPENSSL_ROOT_DIR="$OPENSSL_INSTALL" \
        -B _build -S .
    cmake --build _build
fi

# Run tests
echo "Running tests..."
cd _build
ctest --output-on-failure --verbose
cd -

