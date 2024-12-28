#!/usr/bin/env bash

# Compiler and environment settings
export CC=clang
export CXX=clang++
export CFLAGS="${CFLAGS} -DENGINE_AFALG -DENABLE_OQS_EXPERIMENTAL -DOQS_DEFAULT_SIGNATURES='dilithium2:dilithium3:dilithium5:falcon512:falcon1024:sphincssha256128frobust:sphincssha256192frobust:sphincssha256256frobust:xmss_sha256_h10:xmss_sha256_h16:xmss_sha256_h20:xmss_sha512_h10:xmss_sha512_h16:xmss_sha512_h20:xmss_shake128_h10:xmss_shake128_h16:xmss_shake128_h20:xmss_shake256_h10:xmss_shake256_h16:xmss_shake256_h20:sphincsshake128fsimple:p256_sphincsshake128fsimple:rsa3072_sphincsshake128fsimple:sphincsshake128ssimple:p256_sphincsshake128ssimple:rsa3072_sphincsshake128ssimple:sphincsshake192fsimple:p384_sphincsshake192fsimple:sphincsshake192ssimple:p384_sphincsshake192ssimple:sphincsshake256fsimple:p521_sphincsshake256fsimple:sphincsshake256ssimple:p521_sphincsshake256ssimple:mayo1:p256_mayo1:mayo2:p256_mayo2:mayo3:p384_mayo3:mayo5:p521_mayo5:dilithium2:p256_dilithium2:rsa3072_dilithium2:dilithium3:p384_dilithium3:dilithium5:p521_dilithium5:falcon512:p256_falcon512:rsa3072_falcon512:falcon1024:p521_falcon1024:sphincssha2128fsimple:p256_sphincsshake128fsimple:rsa3072_sphincsshake128fsimple:p256_sphincsshake128ssimple' -I/opt/qompassl/include/oqs-provider -I/opt/qompassl/include/openssl -I/opt/liboqs/include"
export CPPFLAGS="${CPPFLAGS} -I/opt/qompassl/include/oqs-provider -I/opt/qompassl/include/openssl -I/opt/liboqs/include"
export LDFLAGS="-fuse-ld=lld -L/opt/liboqs/lib -loqs -Wl,-rpath,/opt/liboqs/lib"
export PKG_CONFIG_PATH="/opt/qompassl/lib64/pkgconfig:/opt/liboqs/lib/pkgconfig:${PKG_CONFIG_PATH}"
export OPENSSL_MODULES="/opt/qompassl/lib64/ossl-modules"
export LD_LIBRARY_PATH="/opt/qompassl/lib64:${LD_LIBRARY_PATH}"
export LD_PRELOAD="/opt/qompassl/lib64/libcrypto.so.3:/opt/qompassl/lib64/libssl.so.3"
export OPENSSL_TEST_EXTERNAL="1"

# Directories
LIBOQS_INSTALL_DIR="/opt/liboqs"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/../build"

# Ensure build directory exists
mkdir -p "$BUILD_DIR" || {
    echo "Error: Failed to create build directory $BUILD_DIR." >&2
    exit 1
}

# Navigate to source directory
cd "$SCRIPT_DIR/.." || {
    echo "Error: Failed to change to source directory." >&2
    exit 1
}

# Run OpenSSL configuration
./Configure linux-x86_64 shared \
    --prefix=/opt/qompassl \
    --openssldir=/opt/qompassl/ssl \
    -DWITH_JITTERENTROPY=1 \
    enable-external-tests \
    enable-md2 \
    enable-sctp \
    enable-engine \
    enable-dynamic-engine \
    enable-afalgeng \
    no-ssl3 \
    enable-ktls \
    enable-legacy \
    enable-fips \
    enable-tls1_3 \
    enable-async \
    enable-quic \
    enable-asm \
    no-comp \
    enable-rdrand \
    -Wl,-rpath=/opt/qompassl/lib64 \
    -DOPENSSL_NO_HEARTBEATS \
    -DOPENSSL_TLS_SECURITY_LEVEL=2 \
    -DOPENSSL_USE_PKCS11 \
    enable-crypto-mdebug \
    enable-crypto-mdebug-backtrace \
    -Dliboqs_DIR="${LIBOQS_INSTALL_DIR}/lib/cmake/liboqs" \
    -I"${LIBOQS_INSTALL_DIR}/include" \
    enable-ec \
    enable-ecdh \
    enable-dh \
    enable-psk \
    enable-dsa \
    enable-ecdsa \
    enable-gost \
    -DOQS_DEFAULT_GROUPS="p256_mlkem512:p384_mlkem768:p521_mlkem1024:mlkem512:mlkem768:mlkem1024:p256_falcon512:p384_falcon512:p521_falcon1024" \
    -lm \
    enable-chacha \
    enable-camellia \
    enable-seed \
    enable-bf \
    enable-cast \
    enable-aria \
    enable-sm4 \
    enable-blake2 \
    enable-mdc2 \
    enable-whirlpool \
    enable-poly1305 \
    enable-sm3 \
    enable-sm2 \
    enable-siphash \
    enable-ocb \
    enable-ocsp \
    enable-zlib \
    enable-zlib-dynamic \
    enable-comp \
    enable-srp \
    enable-tfo \
    enable-tls1 \
    enable-rc5 \
    enable-tls1_1 \
    enable-tls1_2 \
    enable-tls1_3 \
    enable-cms \
    enable-rfc3779 \
    enable-nextprotoneg \
    enable-idea || {
        echo "Error: Configure failed." >&2
        exit 1
}

# Build OpenSSL
make -j"$(nproc)" || {
    echo "Error: Build failed." >&2
    exit 1
}

# Install OpenSSL
make install || {
    echo "Error: Installation failed." >&2
    exit 1
}

# Verify Installation
if [[ ! -d "/opt/qompassl/bin" ]]; then
    echo "Error: Installation directory is missing." >&2
    exit 1
fi

# Final message
echo "OpenSSL build and installation completed successfully."
