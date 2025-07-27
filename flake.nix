# flake.nix
# Qompass AI 
# Copyright (C) 2025 Qompass AI, All rights reserved
# ----------------------------------------
{
  description = "Qompass AI KO Dev Shell (OQS/OpenSSL)";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        name = "Qompass AI KO Dev Shell";
        buildInputs = with pkgs; [
          git gcc gnumake cmake ninja perl python3
          pkg-config zlib openssl curl jq
          zig
          lld
          perl
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
          # ... echo instructions as before ...
        '';
      };
    };
}

