#!/bin/bash

# The following variables influence the operation of this build script:
# Argument -f: Soft clean, ensuring re-build of oqs-provider binary
# Argument -F: Hard clean, ensuring checkout and build of all dependencies
# EnvVar CMAKE_PARAMS: passed to cmake
# EnvVar MAKE_PARAMS: passed to invocations of make; sample value: "-j"
# EnvVar OQSPROV_CMAKE_PARAMS: passed to invocations of oqsprovider cmake
# EnvVar LIBOQS_BRANCH: Defines branch/release of liboqs; default value "main"
# EnvVar OQS_ALGS_ENABLED: If set, defines OQS algs to be enabled, e.g., "STD"
# EnvVar OPENSSL_INSTALL: If set, defines (binary) OpenSSL installation to use
# EnvVar OPENSSL_BRANCH: Defines branch/release of openssl; if set, forces source-build of OpenSSL3
# EnvVar liboqs_DIR: If set, needs to point to a directory where liboqs has been installed to

# Set default values
LIBOQS_INSTALL_DIR="/opt/liboqs"
OPENSSL_INSTALL_DIR="/opt/qompassl"

# Determine shared library extensions based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
   SHLIBEXT="dylib"
   STATLIBEXT="dylib"
else
   SHLIBEXT="so"
   STATLIBEXT="a"
fi

# Handle clean flags (-f for soft clean, -F for hard clean)
if [ $# -gt 0 ]; then
   if [ "$1" == "-f" ]; then
      rm -rf _build
   fi
   if [ "$1" == "-F" ]; then
      rm -rf _build openssl liboqs .local
   fi
fi

# Set LIBOQS_BRANCH if not defined
if [ -z "$LIBOQS_BRANCH" ]; then
   export LIBOQS_BRANCH=main
fi

# Handle OQS_ALGS_ENABLED, if specified
if [ -z "$OQS_ALGS_ENABLED" ]; then
   export DOQS_ALGS_ENABLED=""
else
   export DOQS_ALGS_ENABLED="-DOQS_ALGS_ENABLED=$OQS_ALGS_ENABLED"
fi

# Check if OPENSSL_INSTALL_DIR is defined or needs a build
if [ -z "$OPENSSL_INSTALL" ]; then
  if [ ! -d "$OPENSSL_INSTALL_DIR" ]; then
    echo "OpenSSL installation directory not found at $OPENSSL_INSTALL_DIR. Exiting."
    exit 1
  else
    export OPENSSL_INSTALL="$OPENSSL_INSTALL_DIR"
  fi
fi

# Check whether liboqs is built or already configured
if [ -z $liboqs_DIR ]; then
  if [ ! -f "$LIBOQS_INSTALL_DIR/lib/liboqs.$STATLIBEXT" ]; then
    echo "liboqs not found at $LIBOQS_INSTALL_DIR. Please make sure liboqs is properly built and installed to $LIBOQS_INSTALL_DIR."
    exit 1
  fi
  export liboqs_DIR="$LIBOQS_INSTALL_DIR"
fi

# Ensure correct OpenSSL is found by CMake
export CMAKE_OPENSSL_LOCATION="-DOPENSSL_ROOT_DIR=$OPENSSL_INSTALL"

# Check whether provider is built:
if [ ! -f "_build/lib/oqsprovider.$SHLIBEXT" ]; then
   echo "oqsprovider (_build/lib/oqsprovider.$SHLIBEXT) not built: Building..."
   # Set up build configuration flags
   BUILD_TYPE="" # Add -DCMAKE_BUILD_TYPE=Debug if needed

   # Run CMake to configure the oqsprovider build
   cmake $CMAKE_PARAMS \
         $CMAKE_OPENSSL_LOCATION \
         -Dliboqs_DIR="$liboqs_DIR/lib/cmake/liboqs" \
         $BUILD_TYPE \
         $OQSPROV_CMAKE_PARAMS \
         -S . -B _build

   # Build the oqsprovider
   cmake --build _build
   if [ $? -ne 0 ]; then
     echo "Provider build failed. Exiting."
     exit -1
   fi
fi

# Set environment variables to use custom libraries
export PATH="$OPENSSL_INSTALL_DIR/bin:$PATH"
export LD_LIBRARY_PATH="$OPENSSL_INSTALL_DIR/lib:$LIBOQS_INSTALL_DIR/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="$OPENSSL_INSTALL_DIR/lib/pkgconfig:$LIBOQS_INSTALL_DIR/lib/pkgconfig:$PKG_CONFIG_PATH"

echo "oqs-provider build and setup complete."

cat << EOF

To use oqs-provider with OpenSSL, use the following environment variables:

export PATH="$OPENSSL_INSTALL_DIR/bin:\$PATH"
export LD_LIBRARY_PATH="$OPENSSL_INSTALL_DIR/lib:$LIBOQS_INSTALL_DIR/lib:\$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="$OPENSSL_INSTALL_DIR/lib/pkgconfig:$LIBOQS_INSTALL_DIR/lib/pkgconfig:\$PKG_CONFIG_PATH"

EOF

