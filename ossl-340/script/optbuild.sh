#!/usr/bin/env bash
# Use sudo -E ./scripts/optbuild.sh
export CC=clang
export CXX=clang++
export CFLAGS="${CFLAGS} -DENGINE_AFALG -DOQS_DEFAULT_SIGNATURES='dilithium2:dilithium3:dilithium5:falcon512:falcon1024:sphincssha256128frobust:sphincssha256192frobust:sphincssha256256frobust:xmss_sha256_h10:xmss_sha256_h16:xmss_sha256_h20:xmss_sha512_h10:xmss_sha512_h16:xmss_sha512_h20:xmss_shake128_h10:xmss_shake128_h16:xmss_shake128_h20:xmss_shake256_h10:xmss_shake256_h16:xmss_shake256_h20:sphincsshake128fsimple:p256_sphincsshake128fsimple:rsa3072_sphincsshake128fsimple:sphincsshake128ssimple:p256_sphincsshake128ssimple:rsa3072_sphincsshake128ssimple:sphincsshake192fsimple:p384_sphincsshake192fsimple:sphincsshake192ssimple:p384_sphincsshake192ssimple:sphincsshake256fsimple:p521_sphincsshake256fsimple:sphincsshake256ssimple:p521_sphincsshake256ssimple:mayo1:p256_mayo1:mayo2:p256_mayo2:mayo3:p384_mayo3:mayo5:p521_mayo5:dilithium2:p256_dilithium2:rsa3072_dilithium2:dilithium3:p384_dilithium3:dilithium5:p521_dilithium5:falcon512:p256_falcon512:rsa3072_falcon512:falcon1024:p521_falcon1024:sphincssha2128fsimple:p256_sphincssha2128fsimple:rsa3072_sphincssha2128fsimple:sphincssha2128ssimple:p256_sphincssha2128ssimple:rsa3072_sphincssha2128ssimple:sphincssha2192fsimple:p384_sphincssha2192fsimple:sphincssha2192ssimple:p384_sphincssha2192ssimple:sphincssha2256fsimple:p521_sphincssha2256fsimple:sphincssha2256ssimple:p521_sphincssha2256ssimple:crossrsdp128balanced:crossrsdp128fast:crossrsdp128small:crossrsdp192balanced:crossrsdp192fast:crossrsdp192small:crossrsdp256small:crossrsdpg128balanced:crossrsdpg128fast:crossrsdpg128small:crossrsdpg192balanced:crossrsdpg192fast:crossrsdpg192small:crossrsdpg256balanced:crossrsdpg256fast:crossrsdpg256small:xmss_sha256_h10:xmss_sha256_h16:xmss_sha256_h20:xmss_shake128_h10:xmss_shake128_h16:xmss_shake128_h20:xmssmt_sha2_20_2_256:xmssmt_sha2_40_2_256:xmssmt_sha2_60_3_256:lms_sha256_h10_w1:lms_sha256_h20_w4:lms_sha256_h25_w8:Classic-McEliece-348864:Classic-McEliece-348864f:Classic-McEliece-460896:Classic-McEliece-460896f'"
export CFLAGS="${CFLAGS} -DENABLE_OQS_EXPERIMENTAL=1 -I/opt/qompassl/include/oqs-provider -I/opt/qompassl/include/openssl -I/opt/liboqs/include"
export CPPFLAGS="${CPPFLAGS} -I/opt/qompassl/include/oqs-provider -I/opt/qompassl/include/openssl -I/opt/liboqs/include"
export LDFLAGS="-fuse-ld=lld -L/opt/liboqs/lib -loqs -Wl,-rpath,/opt/liboqs/lib"
export PKG_CONFIG_PATH="/opt/qompassl/lib64/pkgconfig:/opt/liboqs/lib/pkgconfig:${PKG_CONFIG_PATH}"
export OPENSSL_MODULES="/opt/qompassl/lib64/ossl-modules"
export LD_LIBRARY_PATH=/opt/qompassl/lib64:${LD_LIBRARY_PATH}
export LD_PRELOAD=/opt/qompassl/lib64/libcrypto.so.3:/opt/qompassl/lib64/libssl.so.3
LIBOQS_INSTALL_DIR="/opt/liboqs"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/../build"
export OPENSSL_TEST_EXTERNAL="1"
"$(dirname "$0")/../Configure" linux-x86_64 shared \
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
    -Dliboqs_DIR="${LIBOQS_INSTALL_DIR}"/lib/cmake/liboqs \
    -I"${LIBOQS_INSTALL_DIR}"/include \
    enable-ec \
    enable-ecdh \
    enable-dh \
    enable-psk \
    enable-dsa \
    enable-ecdsa \
    enable-gost \
    -DOQS_DEFAULT_GROUPS="kyber512:kyber768:kyber1024:mlkem512:mlkem768:mlkem1024:p256_mlkem512:p384_mlkem768:p521_mlkem1024:mlkem512:mlkem768:mlkem1024:p256_falcon512:p384_falcon512:p521_falcon1024:falcon512:falcon1024:p256_mldsa44:p384_mldsa65:p521_mldsa87:mldsa44:mldsa65:mldsa87:p384_mceliece348864:p521_mceliece460896:mceliece348864:mceliece460896:mceliece6688128:mceliece6960119:mceliece8192128:x25519_mlkem512:x25519_mlkem768:x25519_mlkem1024:x25519_falcon512:x25519_falcon1024:x25519_mldsa44:x25519_mldsa65:x25519_mldsa87:mldsa87_ed448:x25519_mceliece348864:x25519_mceliece460896:x25519_mceliece6688128:x25519_mceliece6960119:x25519_mceliece8192128:frodo640aes:frodo976aes:frodo1344aes:bike1l1cpa:bike1l3cpa:bike1l5cpa:hqc128:hqc192:hqc256:sphincssha256128frobust:sphincssha256192frobust:sphincssha256256frobust:secp256k1_mlkem512:secp256k1_mlkem768:secp256k1_mlkem1024:mayo1:mayo2:mayo3:mayo5:mceliece348864_mlkem512:mceliece348864_mlkem768:mceliece348864_mlkem1024:mceliece460896_mlkem512:mceliece460896_mlkem768:mceliece460896_mlkem1024:mceliece6688128_mlkem512:mceliece6688128_mlkem768:mceliece6688128_mlkem1024:mceliece6960119_mlkem512:mceliece6960119_mlkem768:mceliece6960119_mlkem1024:mceliece8192128_mlkem512:mceliece8192128_mlkem768:mceliece8192128_mlkem1024:lightsaber:saber:firesaber:p384_falcon1024:secp256k1_falcon512:secp256k1_falcon1024:p384_mlkem768:p521_mlkem1024:secp256k1_mldsa44:secp256k1_mldsa65:secp256k1_mldsa87:falcon512:falcon1024:ntru-hps-2048-509:ntru-hps-2048-677:ntru-hps-4096-821:ntru-hrss-701:CROSSrsdp128balanced:CROSSrsdp128fast:CROSSrsdp128small:CROSSrsdp192balanced:CROSSrsdp192fast:CROSSrsdp192small:CROSSrsdp256small:CROSSrsdpg128balanced:CROSSrsdpg128fast:CROSSrsdpg128small:CROSSrsdpg192balanced:CROSSrsdpg192fast:CROSSrsdpg192small:CROSSrsdpg256balanced:CROSSrsdpg256fast:CROSSrsdpg256small:bikel1:p256_bikel1:x25519_bikel1:bikel3:p384_bikel3:x448_bikel3:bikel5:p521_bikel5:kyber512:p256_kyber512:x25519_kyber512:kyber768:p384_kyber768:x448_kyber768:x25519_kyber768:kyber1024:p521_kyber1024:frodo640shake:p256_frodo640shake:x25519_kyber1024:kyber1024-x448:p256_dilithium2_rsa3072:x448_falcon1024:ntru-prime-ntrulpr653:ntru-prime-ntrulpr857" \
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
    enable-idea
sudo mkdir -p "${BUILD_DIR}"
sudo chown -R "${USER}":"${USER}" "${BUILD_DIR}"
if [[ -f "/opt/qompassl/ssl/fipsmodule.cnf" ]]; then
    export OPENSSL_CONF="/opt/qompassl/ssl/fipsmodule.cnf"
else
    printf "Warning: FIPS module configuration file not found at /opt/qompassl/ssl/fipsmodule.cnf.\n"
fi
cd "${BUILD_DIR}" || {
    printf "Error: Failed to change to build directory.\n"
    exit 1
}
cd "${SCRIPT_DIR}/.." || {
    printf "Error: Failed to change to script parent directory.\n"
    exit 1
}
if [[ ! -w /opt/qompassl ]]; then
    printf "Error: Installation directory /opt/qompassl is not writable. Please check permissions.\n"
    exit 1
fi
if [[ ! -w "${BUILD_DIR}" ]]; then
    printf "Error: Build directory %s is not writable. Please check permissions.\n" "${BUILD_DIR}"
    exit 1
fi
mkdir -p "${BUILD_DIR}" || {
    printf "Error: Failed to create build directory %s.\n" "${BUILD_DIR}"
    exit 1
}
printf "Configuring QompassL build with the following options...\n"
cores=$(nproc)
printf "Building QompassL with %d cores...\n" "$(nproc)" || true
if ! sudo make -j"$(nproc)" VERBOSE=1; then
    printf "Build failed. Exiting...\n"
    exit 1
fi
printf "Installing QompassL to %s...\n" "/opt/qompassl"
sudo make install

if [[ -d "/opt/qompassl/bin" ]]; then
    printf "Installation completed successfully.\n"
else
    printf "Installation failed or no files installed to %s.\n" "/opt/qompassl"
    exit 1
fi
printf "Installing QompassL software binaries...\n"
sudo make install_sw
printf "Installing SSL directories...\n"
sudo make install_ssldirs
printf "Installing documentation...\n"
sudo make install_docs
printf "Installing the FIPS provider...\n"
sudo make install_fips

# Run the FIPS installation
printf "Running FIPS installation...\n"
FIPS_MODULE_PATH="/opt/qompassl/lib64/ossl-modules/fips.so"
FIPS_CONFIG_PATH="/opt/qompassl/ssl/fipsmodule.cnf"
sudo openssl fipsinstall -out "${FIPS_CONFIG_PATH}" -module "${FIPS_MODULE_PATH}"
printf "Updating shared library cache...\n"
sudo ldconfig
printf "Testing shared library linking...\n"
if ! ldconfig -p | grep -q "libcrypto.so" || true; then
    printf "Warning: libcrypto not found in shared library cache.\n"
fi
if ! ldconfig -p | grep -q "libcrypto.so"; then
    printf "Warning: libcrypto not found in shared library cache. Ensure the library path is correctly set.\n"
fi
printf "Testing OpenSSL with OQS algorithms...\n"
/opt/qompassl/bin/openssl list -cipher-algorithms | grep "oqs" || true
/opt/qompassl/bin/openssl list -signature-algorithms | grep "oqs" || true
if /opt/qompassl/bin/openssl list -cipher-algorithms | grep "oqs" || true; then
    printf "OQS algorithms appear to be properly integrated.\n"
else
    printf "Error: OQS algorithms were not found in the OpenSSL configuration.\n"
    exit 1
fi
TEST_REPORT_FILE="qompassl_test_report_$(date +'%Y%m%d_%H%M%S').txt"
printf "Running tests and saving results to %s...\n" "${TEST_REPORT_FILE}"
sudo make test | tee "${TEST_REPORT_FILE}" || printf "Some tests failed. Test report saved to %s\n" "${TEST_REPORT_FILE}" || true
if command -v pandoc &>/dev/null; then
    TEST_REPORT_PDF="openssl_test_report_$(date +'%Y%m%d_%H%M%S').pdf"
    pandoc "${TEST_REPORT_FILE}" -o "${TEST_REPORT_PDF}"
    printf "Test report converted to PDF: %s\n" "${TEST_REPORT_PDF}"
else
    printf "Pandoc not found. Test report saved as text: %s\n" "${TEST_REPORT_FILE}"
fi

printf "Installation complete. The shared library cache has been updated.\n"

cat <<EOF

To use this version of OpenSSL with OQS support, add the following environment variables to your shell:

export PATH="/opt/qompassl/bin:\$PATH"
export LD_LIBRARY_PATH="/opt/qompassl/lib64:\$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/opt/qompassl/lib64/pkgconfig:/opt/liboqs/lib/pkgconfig:${PKG_CONFIG_PATH}"

To temporarily unset these environment variables and prevent them from affecting system tools, you can use:

unset LD_LIBRARY_PATH
unset PATH
unset PKG_CONFIG_PATH

EOF