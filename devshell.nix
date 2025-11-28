# devshell.nix
# Qompass AI KO Dev Shell
# Copyright (C) 2025 Qompass AI, All rights reserved
# ----------------------------------------
{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "Qompass AI KO Dev Shell";
  buildInputs = with pkgs; [
    git
    gcc
    gnumake
    cmake
    ninja
    perl
    python3
    pkg-config
    zlib
    openssl
    curl
    jq
    zig
    lld
    pandoc
    brotli
    gmp
  ];
  shellHook = ''
        set -e
        export CC="zig cc -DOptimizeSafe"
        export CXX="zig c++"
        export NVCC_PREPEND_FLAGS='-Xcompiler -fPIC'
        export CPLUS_INCLUDE_PATH=/opt/cuda/include:$CPLUS_INCLUDE_PATH
        export INSTALL_PREFIX=/opt/QAI/qompassl
        export LIBOQS_INSTALL_DIR=/opt/QAI/liboqs
        export PKG_CONFIG_PATH=$INSTALL_PREFIX/lib64/pkgconfig:$LIBOQS_INSTALL_DIR/lib/pkgconfig
    export LD_LIBRARY_PATH=$INSTALL_PREFIX/lib64:$LIBOQS_INSTALL_DIR/lib
        export OPENSSL_CONF=$INSTALL_PREFIX/ssl/openssl.cnf
        export OPENSSL_MODULES=$INSTALL_PREFIX/lib64/ossl-modules
        export PATH=$INSTALL_PREFIX/bin:$PATH
        export LIBRARYPATH="$INSTALL_PREFIX/lib64:$LIBOQS_INSTALL_DIR/lib"
        export LD_PRELOAD="$INSTALL_PREFIX/lib64/libcrypto.so.3:$INSTALL_PREFIX/lib64/libssl.so.3"
        export CFLAGS="-march=native -O3 -fPIC -D_POSIX_C_SOURCE=200809L -D_GNU_SOURCE -DENGINE_AFALG -DOQS_ALGS_ENABLED=ALL -DOQS_ENABLE_SIG_FALCON=ON -DOQS_KEM_ENCODERS=ON \
          -DENABLE_OQS_EXPERIMENTAL=1 -I$INSTALL_PREFIX/include/oqs-provider -I$INSTALL_PREFIX/include/openssl -I$LIBOQS_INSTALL_DIR/include $CFLAGS"
        export CPPFLAGS="-I$INSTALL_PREFIX/include/oqs-provider -I$INSTALL_PREFIX/include/openssl -I$LIBOQS_INSTALL_DIR/include $CPPFLAGS"
        export LDFLAGS="\
          -fuse-ld=lld \
          -L$LIBOQS_INSTALL_DIR/lib \
          -L/usr/lib \
          -Wl,--enable-new-dtags,-rpath,$INSTALL_PREFIX/lib64:$LIBOQS_INSTALL_DIR/lib \
          -loqs \
          -ljitterentropy \
          -lbrotlienc -lbrotlidec -lbrotlicommon \
          -lm -ldl -lpthread -lc -lrt"
        export LDLIBS="-lm -ldl -lpthread -lc -lrt"
        export OPENSSL_TEST_EXTERNAL="1"
        export BUILD_DIR="$PWD/build"

        echo ""
        echo "🔹 Qompass AI OQS/OpenSSL devshell loaded."
        echo "  All toolchains and environment variables are set."
        echo ""
        echo "🚀 To build all components from scratch, run:"
        echo "    bash ./scripts/build-oqs-openssl.sh"
        echo "  (Recommended: put your build logic in ./scripts/build-oqs-openssl.sh)"
        echo ""
        echo "  Or run the following, step by step, in this shell:"
        echo "    # Clone and build liboqs"
        echo "    git clone --branch 0.13.0 --depth=1 https://github.com/open-quantum-safe/liboqs.git"
        echo "    cd liboqs && mkdir -p build && cd build"
        echo "    cmake .. -GNinja -DCMAKE_INSTALL_PREFIX=$LIBOQS_INSTALL_DIR"
        echo "    ninja && ninja install"
        echo "    cd ../.."
        echo ""
        echo "    # Download and build OpenSSL 3.5.1"
        echo "    curl -LO https://www.openssl.org/source/openssl-3.5.1.tar.gz"
        echo "    tar xzf openssl-3.5.1.tar.gz"
        echo "    cd openssl-3.5.1"
        echo "    ./config --prefix=$INSTALL_PREFIX --openssldir=$INSTALL_PREFIX/ssl shared enable-ec_nistp_64_gcc_128"
        echo "    make -j\$(nproc) && make install_sw"
        echo "    cd .."
        echo ""
        echo "    # Clone and build oqs-provider"
        echo "    git clone --branch 0.9.0 --depth=1 https://github.com/open-quantum-safe/oqs-provider.git"
        echo "    cd oqs-provider && mkdir -p build && cd build"
        echo "    cmake .. -GNinja -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX -DOPENSSL_ROOT_DIR=$INSTALL_PREFIX -DOQS_DIR=$LIBOQS_INSTALL_DIR"
        echo "    ninja && ninja install"
        echo "    cd ../.."
        echo ""
        echo "💡 Reminder: To test the provider:"
        echo "    export OPENSSL_MODULES=$INSTALL_PREFIX/lib64/ossl-modules"
        echo "    openssl list -providers"
        echo ""
  '';
}
