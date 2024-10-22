#!/bin/bash
export CC=clang
export CXX=clang++
export CFLAGS="$CFLAGS -DENGINE_AFALG -DOQS_DEFAULT_SIGNATURES='dilithium2:dilithium3:dilithium5:falcon512:falcon1024:sphincssha256128frobust:sphincssha256192frobust:sphincssha256256frobust:xmss_sha256_h10:xmss_sha256_h16:xmss_sha256_h20:xmss_sha512_h10:xmss_sha512_h16:xmss_sha512_h20:xmss_shake128_h10:xmss_shake128_h16:xmss_shake128_h20:xmss_shake256_h10:xmss_shake256_h16:xmss_shake256_h20:sphincsshake128fsimple:p256_sphincsshake128fsimple:rsa3072_sphincsshake128fsimple:sphincsshake128ssimple:p256_sphincsshake128ssimple:rsa3072_sphincsshake128ssimple:sphincsshake192fsimple:p384_sphincsshake192fsimple:sphincsshake192ssimple:p384_sphincsshake192ssimple:sphincsshake256fsimple:p521_sphincsshake256fsimple:sphincsshake256ssimple:p521_sphincsshake256ssimple:mayo1:p256_mayo1:mayo2:p256_mayo2:mayo3:p384_mayo3:mayo5:p521_mayo5'"
export LDFLAGS="-fuse-ld=lld -L/opt/liboqs/lib -loqs -Wl,-rpath,/opt/liboqs/lib"
export PKG_CONFIG_PATH="/opt/qompassl/lib64/pkgconfig:/opt/liboqs/lib/pkgconfig:$PKG_CONFIG_PATH"
export OPENSSL_MODULES="/opt/qompassl/lib/ossl-modules"
export OPENSSL_TEST_EXTERNAL="1"
LIBOQS_INSTALL_DIR="/opt/liboqs"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.."

BUILD_DIR="$SCRIPT_DIR/../build"
sudo rm -rf "$BUILD_DIR"
mkdir "$BUILD_DIR"
cd "$BUILD_DIR"
printf "Configuring QompassL build with the following options...\n"
../Configure shared \
  --prefix=/opt/qompassl \
  --openssldir=/opt/qompassl/ssl \
  enable-external-tests \
  linux-x86_64 \
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
  enable-rdrand \
  -Wl,-rpath=/opt/qompassl/lib64 \
  -DOPENSSL_NO_HEARTBEATS \
  -DOPENSSL_TLS_SECURITY_LEVEL=2 \
  -DOPENSSL_USE_PKCS11 \
  enable-crypto-mdebug \
  enable-crypto-mdebug-backtrace \
  -Dliboqs_DIR=${LIBOQS_INSTALL_DIR}/lib/cmake/liboqs \
  -I${LIBOQS_INSTALL_DIR}/include \
  enable-ec \
  enable-ecdh \
  enable-dh \
  enable-psk \
  enable-dsa \
  enable-ecdsa \
  enable-gost \
  -DOQS_DEFAULT_GROUPS="p256_mlkem512:p384_mlkem768:p521_mlkem1024:mlkem512:mlkem768:mlkem1024:p256_falcon512:p384_falcon512:p521_falcon1024:falcon512:falcon1024:p256_mldsa44:p384_mldsa65:p521_mldsa87:mldsa44:mldsa65:mldsa87:p384_mceliece348864:p521_mceliece460896:mceliece348864:mceliece460896:mceliece6688128:mceliece6960119:mceliece8192128:x25519_mlkem512:x25519_mlkem768:x25519_mlkem1024:x25519_falcon512:x25519_falcon1024:x25519_mldsa44:x25519_mldsa65:x25519_mldsa87:x25519_mceliece348864:x25519_mceliece460896:x25519_mceliece6688128:x25519_mceliece6960119:x25519_mceliece8192128:frodo640aes:frodo976aes:frodo1344aes:bike1l1cpa:bike1l3cpa:bike1l5cpa:hqc128:hqc192:hqc256:sphincssha256128frobust:sphincssha256192frobust:sphincssha256256frobust:secp256k1_mlkem512:secp256k1_mlkem768:secp256k1_mlkem1024:mayo1:mayo2:mayo3:mayo5:mceliece348864_mlkem512:mceliece348864_mlkem768:mceliece348864_mlkem1024:mceliece460896_mlkem512:mceliece460896_mlkem768:mceliece460896_mlkem1024:mceliece6688128_mlkem512:mceliece6688128_mlkem768:mceliece6688128_mlkem1024:mceliece6960119_mlkem512:mceliece6960119_mlkem768:mceliece6960119_mlkem1024:mceliece8192128_mlkem512:mceliece8192128_mlkem768:mceliece8192128_mlkem1024:lightsaber:saber:firesaber:p384_falcon1024:secp256k1_falcon512:secp256k1_falcon1024:p384_mlkem768:p521_mlkem1024:secp256k1_mldsa44:secp256k1_mldsa65:secp256k1_mldsa87:falcon512:falcon1024:ntru-hps-2048-509:ntru-hps-2048-677:ntru-hps-4096-821:ntru-hrss-701:CROSSrsdp128balanced:CROSSrsdp128fast:CROSSrsdp128small:CROSSrsdp192balanced:CROSSrsdp192fast:CROSSrsdp192small:CROSSrsdp256small:CROSSrsdpg128balanced:CROSSrsdpg128fast:CROSSrsdpg128small:CROSSrsdpg192balanced:CROSSrsdpg192fast:CROSSrsdpg192small:CROSSrsdpg256balanced:CROSSrsdpg256fast:CROSSrsdpg256small" \
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
  
printf "Building QompassL with %d cores...\n" "$(nproc)"
sudo make -j$(nproc)

printf "Installing QompassL to %s...\n" "/opt/qompassl"
sudo make install 

if [ -d "/opt/qompassl/bin" ]; then
    printf "Installation completed successfully.\n"
else
    printf "Installation failed or no files installed to %s.\n" "/opt/qompassl"
    exit 1
fi
printf "Updating shared library cache...\n"
sudo ldconfig
TEST_REPORT_FILE="qompassl_test_report_$(date +'%Y%m%d_%H%M%S').txt"
printf "Running tests and saving results to %s...\n" "$TEST_REPORT_FILE"
sudo make test | tee "$TEST_REPORT_FILE" || printf "Some tests failed. Test report saved to %s\n" "$TEST_REPORT_FILE"
if command -v pandoc &> /dev/null
then
    TEST_REPORT_PDF="openssl_test_report_$(date +'%Y%m%d_%H%M%S').pdf"
    pandoc "$TEST_REPORT_FILE" -o "$TEST_REPORT_PDF"
    printf "Test report converted to PDF: %s\n" "$TEST_REPORT_PDF"
else
    printf "Pandoc not found. Test report saved as text: %s\n" "$TEST_REPORT_FILE"
fi

printf "Installation complete. The shared library cache has been updated.\n"

cat << EOF

To use this version of OpenSSL with OQS support, add the following environment variables to your shell:

export PATH="/opt/qompassl/bin:\$PATH"
export LD_LIBRARY_PATH="/opt/qompassl/lib:\$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/opt/qompassl/lib/pkgconfig:\$PKG_CONFIG_PATH"

To temporarily unset these environment variables and prevent them from affecting system tools, you can use:

unset LD_LIBRARY_PATH
unset PATH
unset PKG_CONFIG_PATH

EOF
