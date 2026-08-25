#!/usr/bin/env bash
# Use sudo -E ./scripts/quickstart.sh
#export RUSTC_WRAPPER=sccache
export CC="zig cc -DOptimizeSafe"
export CXX="zig c++"
#export NVCC= "/opt/cuda/bin/nvcc"
export NVCC_PREPEND_FLAGS='-Xcompiler -fPIC'
export CFLAGS="-march=native -O3 -fPIC -D_POSIX_C_SOURCE=200809L -D_GNU_SOURCE -DENGINE_AFALG -DOQS_ALGS_ENABLED=ALL -DOQS_ENABLE_SIG_FALCON=ON -DOQS_KEM_ENCODERS=ON -DOQS_DEFAULT_SIGNATURES='falcon512:falcon1024:falconpadded512:falconpadded1024:/p521_falcon1024:p521_falconpadded1024:/rsa3072_falcon512:rsa3072_falconpadded512:/mldsa44_p256:mldsa44_bp256:mldsa44_ed25519:mldsa44_rsa2048:/mldsa65:mldsa65_p256:mldsa65_bp256:mldsa87_bp384:mldsa65_ed25519:mldsa87_ed448:mldsa44_pss2048:mldsa65_pss3072:mldsa65_rsa3072:/mldsa87:p384_mldsa65:p521_mldsa87:mldsa87_p384:/rsa3072_mldsa44:rsa3072_sphincssha2128fsimple:rsa3072_sphincssha2128ssimple:/sphincssha2128fsimple:sphincssha2128ssimple:p256_sphincssha2128fsimple:p256_sphincssha2128ssimple:/sphincssha2192fsimple:sphincssha2192ssimple:/sphincssha2256fsimple:sphincssha2256ssimple:/p384_sphincssha2192fsimple:p384_sphincssha2192ssimple:/p521_sphincssha2256fsimple:p521_sphincssha2256ssimple:/sphincsshake128fsimple:sphincsshake128ssimple:/sphincsshake192fsimple:sphincsshake192ssimple:/sphincsshake256fsimple:sphincsshake256ssimple:/p256_mayo1:p256_mayo2:p256_mldsa44:p256_falcon512:p256_falconpadded512:p256_sphincsshake128fsimple:p256_sphincsshake128ssimple:/p384_sphincsshake192fsimple:p384_sphincsshake192ssimple:/p521_sphincsshake256fsimple:p521_sphincsshake256ssimple:/rsa3072_sphincsshake128fsimple:rsa3072_sphincsshake128ssimple:/lms_sha256_h10_w1:lms_sha256_h20_w4:lms_sha256_h25_w8:/xmss_sha256_h10:xmss_sha256_h16:xmss_sha256_h20:/xmss_sha512_h10:xmss_sha512_h16:xmss_sha512_h20:/xmss_shake128_h10:xmss_shake128_h16:xmss_shake128_h20:/xmss_shake256_h10:xmss_shake256_h16:xmss_shake256_h20:/xmssmt_sha2_20_2_256:xmssmt_sha2_40_2_256:xmssmt_sha2_60_3_256:/mayo1:mayo2:mayo3:mayo5:/p384_mayo3:/p521_mayo5:/crossrsdp128balanced:crossrsdp128fast:crossrsdp128small:/crossrsdp192balanced:crossrsdp192fast:crossrsdp192small:/crossrsdp256small:/crossrsdpg128balanced:crossrsdpg128fast:crossrsdpg128small:/crossrsdpg192balanced:crossrsdpg192fast:crossrsdpg192small:/crossrsdpg256balanced:crossrsdpg256fast:crossrsdpg256small'"
export CFLAGS="${CFLAGS} -DENABLE_OQS_EXPERIMENTAL=1 -I/opt/QAI/qompassl/include/oqs-provider -I/opt/QAI/qompassl/include/openssl -I/opt/QAI/liboqs/include"
export CPLUS_INCLUDE_PATH=/opt/cuda/include:$CPLUS_INCLUDE_PATH
export CPPFLAGS="${CPPFLAGS} -I/opt/QAI/qompassl/include/oqs-provider -I/opt/QAI/qompassl/include/openssl -I/opt/QAI/liboqs/include"
export LIBRARYPATH="/opt/QAI/qompassl/lib64:/opt/QAI/liboqs/lib"
export LDFLAGS="\
  -fuse-ld=lld \
  -L/opt/QAI/liboqs/lib \
  -L/usr/lib \
  -Wl,--enable-new-dtags,-rpath,/opt/QAI/qompassl/lib64:/opt/QAI/liboqs/lib \
  -loqs \
  -ljitterentropy \
  -lbrotlienc -lbrotlidec -lbrotlicommon \
  -lm -ldl -lpthread -lc -lrt"
export LDLIBS="-lm -ldl -lpthread -lc -lrt"
export PKG_CONFIG_PATH="/opt/QAI/qompassl/lib64/pkgconfig:/opt/QAI/liboqs/lib/pkgconfig:${PKG_CONFIG_PATH}"
export OPENSSL_CONF=/opt/QAI/qompassl/ssl/openssl.cnf
export OPENSSL_MODULES=/opt/QAI/qompassl/lib64/ossl-modules
export INSTALL_PREFIX=/opt/QAI/qompassl
export LD_LIBRARY_PATH=/opt/QAI/qompassl/lib64:${LD_LIBRARY_PATH}
export LD_PRELOAD=/opt/QAI/qompassl/lib64/libcrypto.so.3:/opt/QAI/qompassl/lib64/libssl.so.3
export LIBOQS_INSTALL_DIR=/opt/QAI/liboqs
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/oqs_oid.sh"
BUILD_DIR="${SCRIPT_DIR}/../build"
export OPENSSL_TEST_EXTERNAL="1"
"$(dirname "$0")/../Configure" linux-x86_64 shared enable-buildtest-c++ enable-tfo enable-comp enable-fips-jitter enable-fips -release  \
    --prefix=/opt/QAI/qompassl \
    --openssldir=/opt/QAI/qompassl/ssl \
    -DCMAKE_INSTALL_PREFIX=/opt/QAI/qompassl \
    -DOQS_PROVIDER_MODULE_PATH=/opt/QAI/qompassl/lib64/ossl-modules \
    -DBUILD_SHARED_LIBS=ON \
    -DOQS_USE_OPENSSL3=ON \
    -DPEDANTIC \
    -lc -ldl -ljitterentropy \
    -DWITH_JITTERENTROPY=1 \
    enable-ec_nistp_64_gcc_128 \
    enable-sctp \
    tfo \
    enable-rmd160 \
    zlib-dynamic \
    egd \
    enable-ct \
    enable-engine \
    enable-ml-dsa \
    enable-ml-kem \
    enable-sslkeylog \
    enable-fuzz-libfuzzer \
    enable-fuzz-afl \
    enable-slh-dsa \
    enable-dynamic-engine \
    enable-afalgeng \
    threads \
    no-ssl3 \
    enable-ktls \
    enable-legacy \
    rdcpu \
    enable-fips \
    enable-tls1_3 \
    enable-async \
    enable-quic \
    enable-brotli \
    no-err \
    no-tls-deprecated-ec \
    enable-devcryptoeng \
    enable-acvp-tests \
    enable-asm \
    enable-unstable-qlog \
    zlib-dynamic \
    enable-zstd-dynamic \
    enable-comp \
    enable-rdrand \
    -Wl,-rpath=/opt/QAI/qompassl/lib64 \
    -DOPENSSL_NO_HEARTBEATS \
    -DOPENSSL_TLS_SECURITY_LEVEL=3 \
    -DOPENSSL_USE_PKCS11 \
    enable-crypto-mdebug \
    enable-crypto-mdebug-backtrace \
    -Dliboqs_DIR="${LIBOQS_INSTALL_DIR}"/lib/cmake/liboqs \
    -I"${LIBOQS_INSTALL_DIR}"/include \
    enable-ec \
    enable-ecdh \
    enable-md2 \
    enable-dh \
    enable-psk \
    enable-pie \
    enable-unit-test \
    enable-dsa \
    enable-ubsan \
    enable-ecdsa \
    enable-gosteng \
    enable-chacha \
    enable-camellia \
    enable-seed \
    enable-bf \
    enable-cast \
    enable-capieng \
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
    enable-srp \
    enable-tfo \
    enable-tls1 \
    enable-tls1_1 \
    enable-tls1_2 \
    enable-tls1_3 \
    enable-cms \
    enable-rfc3779 \
    enable-nextprotoneg \
    enable-idea \
    -lm
-DOQS_DEFAULT_GROUPS="'bikel1:bikel3:bikel5:/
CROSSrsdp128balanced:CROSSrsdp128fast:CROSSrsdp128small:CROSSrsdpg128balanced:/
CROSSrsdp192balanced:CROSSrsdp192fast:CROSSrsdp192small:/
CROSSrsdp256small:/
crossrsdpg128balanced:CROSSrsdpg128fast:CROSSrsdpg128small:/
CROSSrsdpg192balanced:CROSSrsdpg192fast:CROSSrsdpg192small:/
CROSSrsdpg256balanced:CROSSrsdpg256fast:CROSSrsdpg256small:/
firesaber:/
frodo640aes:frodo640shake:/
frodo976aes:frodo976shake:/
frodo1344aes:frodo1344shake:/
hqc128:p256_hqc128:x25519_hqc128:/
hqc192:/
hqc256:/
lightsaber:/
mceliece348864:mceliece348864_mlkem512:mceliece348864_mlkem768:mceliece348864_mlkem1024:/
mceliece460896:mceliece6688128:mceliece460896_mlkem512:mceliece460896_mlkem768:mceliece460896_mlkem1024:/
mceliece6960119:mceliece6960119_mlkem512:mceliece6960119_mlkem768:mceliece6960119_mlkem1024:/
mceliece8192128:/
mceliece6688128_mlkem512:mceliece6688128_mlkem768:mceliece6688128_mlkem1024:/
mceliece8192128_mlkem512:mceliece8192128_mlkem768:mceliece8192128_mlkem1024:/
mlkem512:/
mlkem768:/
mlkem1024:mlkem1024-x448:/
SecP256r1MLKEM768:/
SecP384r1MLKEM1024:/
ntru-hps-2048-509:ntru-hps-2048-677:ntru-hps-4096-821:/
ntru-hrss-701:/
ntru-prime-ntrulpr653:ntru-prime-ntrulpr857:/
OV_Ip:OV_Ip_pkc:OV_Ip_pkc_skc:/
OV_Is:OV_Is_pkc:OV_Is_pkc_skc:/
OV_III:OV_III_pkc:OV_III_pkc_skc:/
OV_V:OV_V_pkc:OV_V_pkc_skc:/
p256_bikel1:p256_frodo640aes:p256_frodo640shake:p256_mlkem512:p256_OV_Ip:p256_OV_Ip_pkc:p256_OV_Ip_pkc_skc:p256_OV_Is:p256_OV_Is_pkc:p256_OV_Is_pkc_skc:/
p384_bikel3:p384_frodo976aes:p384_frodo976shake:p384_mlkem768:p384_OV_III:p384_OV_III_pkc:p384_OV_III_pkc_skc:p384_hqc192:/
p521_bikel5:p521_frodo1344aes:p521_frodo1344shake:p521_hqc256:p521_mlkem1024:p521_OV_V:p521_OV_V_pkc:p521_OV_V_pkc_skc:/
secp256k1_falcon512:secp256k1_falcon1024:secp256k1_mldsa44:secp256k1_mldsa65:secp256k1_mldsa87:secp256k1_mlkem512:secp256k1_mlkem768:secp256k1_mlkem1024:/
saber:/
sphincssha256128frobust:sphincssha256192frobust:sphincssha256256frobust:/
X25519MLKEM768:x25519_bikel1:x25519_frodo640aes:x25519_frodo640shake:x25519_frodo976aes:x25519_frodo976shake:x25519_mceliece348864:x25519_mceliece460896:x25519_mceliece6688128:x25519_mceliece6960119:x25519_mceliece8192128:x25519_mldsa44:x25519_mldsa65:x25519_mldsa87:x25519_mlkem512:x25519_mlkem1024:x448_bikel3:x448_frodo976aes:x448_frodo976shake:x448_hqc192:x448_mlkem768'"
sudo mkdir -p "${BUILD_DIR}"
sudo chown -R "${USER}":"${USER}" "${BUILD_DIR}"
if [[ -f "/opt/QAI/qompassl/ssl/fipsmodule.cnf" ]]; then
    export OPENSSL_CONF="/opt/QAI/qompassl/ssl/fipsmodule.cnf"
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
if [[ ! -w /opt/QAI/qompassl ]]; then
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
printf "Building QompassL with %d cores...\n" "$(nproc)" || true
if ! sudo make -j"$(nproc)" VERBOSE=1; then
    printf "Build failed. Exiting...\n"
    exit 1
fi

printf "Installing QompassL to %s...\n" "/opt/QAI/qompassl"
if ! sudo make install; then
    printf "Installation failed. Exiting...\n"
    exit 1
fi

printf "Installing QompassL to %s...\n" "/opt/QAI/qompassl"
#make test VERBOSE=1 TESTS=test_external_pyca
make test VERBOSE=1 TESTS=test_external_krb5
make test VERBOSE=1 TESTS=test_external_gost_engine
make test VERBOSE=1 TESTS=test_external_oqsprovider
make test VERBOSE=1 TESTS=test_external_pkcs11_provider
if [[ -f /opt/QAI/qompassl/bin/openssl ]]; then
    sudo mv /opt/QAI/qompassl/bin/openssl /opt/QAI/qompassl/bin/qompassl
fi
#printf "Installing QompassL software binaries...\n"
#sudo make all && sudo make install
#printf "Installing SSL directories...\n"
#sudo make install_ssldirs
#printf "Installing documentation...\n"
#sudo make install_docs
#printf "Installing the FIPS provider...\n"
sudo make install_fips

OQS_PROVIDER_PATH="/opt/QAI/qompassl/lib64/ossl-modules/oqsprovider.so"
if [[ -f "$OQS_PROVIDER_PATH" ]]; then
    echo "✅ Found oqsprovider.so at $OQS_PROVIDER_PATH"
else
    echo "❌ oqsprovider.so not found! Did you build the oqs-provider module?"
    exit 1
fi
printf "Running FIPS installation...\n"
FIPS_MODULE_PATH="/opt/QAI/qompassl/lib64/ossl-modules/fips.so"
FIPS_CONFIG_PATH="/opt/QAI/qompassl/ssl/fipsmodule.cnf"
sudo qompassl fipsinstall -out "${FIPS_CONFIG_PATH}" -module "${FIPS_MODULE_PATH}"
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
/opt/QAI/qompassl/bin/qompassl list -cipher-algorithms | grep "oqs" || true
/opt/QAI/qompassl/bin/qompassl list -signature-algorithms | grep "oqs" || true
if /opt/QAI/qompassl/bin/qompassl list -cipher-algorithms | grep "oqs" || true; then
    printf "OQS algorithms appear to be properly integrated.\n"
else
    printf "Error: OQS algorithms were not found in the OpenSSL configuration.\n"
    exit 1
fi
TEST_REPORT_FILE="qompassl_test_report_$(date +'%Y%m%d_%H%M%S').txt"
printf "Running tests and saving results to %s...\n" "${TEST_REPORT_FILE}"
sudo make test | tee "${TEST_REPORT_FILE}" || printf "Some tests failed. Test report saved to %s\n" "${TEST_REPORT_FILE}" || true
if command -v pandoc &>/dev/null; then
    TEST_REPORT_PDF="qompassl_test_report_$(date +'%Y%m%d_%H%M%S').pdf"
    pandoc "${TEST_REPORT_FILE}" -o "${TEST_REPORT_PDF}"
    printf "Test report converted to PDF: %s\n" "${TEST_REPORT_PDF}"
else
    printf "Pandoc not found. Test report saved as text: %s\n" "${TEST_REPORT_FILE}"
fi

printf "Installation complete. The shared library cache has been updated.\n"
export PATH="/opt/QAI/qompassl/bin:\$PATH"
export LD_LIBRARY_PATH="/opt/QAI/qompassl/lib64:\$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/opt/QAI/qompassl/lib64/pkgconfig:/opt/liboqs/lib/pkgconfig:${PKG_CONFIG_PATH}"

unset LD_LIBRARY_PATH
unset PATH
unset PKG_CONFIG_PATH
