#!/bin/bash
# Setting environment variables for Clang/LLVM, tested on Oct 20 2024 on Arch Linux w/x86_64 processor
export CC=clang
export CXX=clang++
export CFLAGS="$CFLAGS -DENGINE_AFALG"
export LDFLAGS="-fuse-ld=lld"
export OPENSSL_MODULES="/usr/local/lib/ossl-modules"
export PATH="/usr/local/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"

# Run OpenSSL configure with Clang/LLVM
./Configure shared \
  --prefix=/usr/local \
  --openssldir=/usr/local/ssl \
  linux-x86_64 \
  enable-engine \
  enable-dynamic-engine \
  no-weak-ssl-ciphers \
  no-deprecated \
  enable-afalgeng \
  no-ssl3 \
  enable-srp \
  no-tls1 \
  no-tls1_1 \
  enable-ktls \
  enable-ssl-trace \
  enable-crypto-mdebug \
  enable-crypto-mdebug-backtrace \
  enable-fips \
  enable-tls1_3 \
  enable-sctp \
  enable-ssl-trace \
  enable-zlib \
  enable-zlib-dynamic \
  enable-tls1_2 \
  enable-cms \
  enable-rfc3779 \
  enable-ec_nistp_64_gcc_128 \
  enable-idea \
  enable-mdc2 \
  enable-rc5 \
  enable-ssl-trace \
  enable-fips \
  enable-legacy \
  -DOPENSSL_NO_HEARTBEATS \
  -DOPENSSL_TLS_SECURITY_LEVEL=2 \
  -DOQS_DEFAULT_GROUPS="p256_mlkem512:p384_mlkem768:p521_mlkem1024:mlkem512:mlkem768:mlkem1024:p256_falcon512:p384_falcon512:p521_falcon1024:falcon512:falcon1024:p256_mldsa44:p384_mldsa65:p521_mldsa87:mldsa44:mldsa65:mldsa87:p384_mceliece348864:p521_mceliece460896:mceliece348864:mceliece460896:mceliece6688128:mceliece6960119:mceliece8192128:x25519_mlkem512:x25519_mlkem768:x25519_mlkem1024:x25519_falcon512:x25519_falcon1024:x25519_mldsa44:x25519_mldsa65:x25519_mldsa87:x25519_mceliece348864:x25519_mceliece460896:x25519_mceliece6688128:x25519_mceliece6960119:x25519_mceliece8192128:frodo640aes:frodo976aes:frodo1344aes:bike1l1cpa:bike1l3cpa:bike1l5cpa:hqc128:hqc192:hqc256:sphincssha256128frobust:sphincssha256192frobust:sphincssha256256frobust:secp256k1_mlkem512:secp256k1_mlkem768:secp256k1_mlkem1024:mayo1:mayo2:mayo3:mayo5:mceliece348864_mlkem512:mceliece348864_mlkem768:mceliece348864_mlkem1024:mceliece460896_mlkem512:mceliece460896_mlkem768:mceliece460896_mlkem1024:mceliece6688128_mlkem512:mceliece6688128_mlkem768:mceliece6688128_mlkem1024:mceliece6960119_mlkem512:mceliece6960119_mlkem768:mceliece6960119_mlkem1024:mceliece8192128_mlkem512:mceliece8192128_mlkem768:mceliece8192128_mlkem1024:lightsaber:saber:firesaber:p384_falcon1024:secp256k1_falcon512:secp256k1_falcon1024:p384_mlkem768:p521_mlkem1024:secp256k1_mldsa44:secp256k1_mldsa65:secp256k1_mldsa87:falcon512:falcon1024:ntru-hps-2048-509:ntru-hps-2048-677:ntru-hps-4096-821:ntru-hrss-701" \
  -lm \
  enable-chacha \
  enable-asm \
  enable-quic \
  enable-aria \
  enable-blake2 \
  enable-async \
  enable-sm4 \
  enable-rdrand \
  enable-camellia \
  enable-seed \
  enable-whirlpool \
  enable-psk \
  enable-dsa \
  enable-dh \
  enable-ec \
  enable-ecdh \
  enable-ecdsa \
  enable-ocb \
  enable-gost \
  enable-poly1305 \
  enable-nextprotoneg \
  enable-siphash \
  enable-sm2 \
  enable-sm3 \
  enable-tfo \
  enable-comp \
  enable-dtls

# Build and install
make
sudo make install

# Update shared library cache
sudo ldconfig

echo "Installation complete. The shared library cache has been updated."

