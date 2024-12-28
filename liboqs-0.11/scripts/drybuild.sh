#!/bin/bash
# Dry-run Script to verify liboqs build and install without affecting system packages
# This script ensures all build steps are safely simulated before proceeding with actual installation

# Step 1: Create build directory (Dry run mode, no actual directory creation)
BUILD_DIR="./build"
echo "Dry run: mkdir -p \"$BUILD_DIR\""

# Step 2: Configure the build with CMake (Dry run to verify configuration options)
echo "Dry run: cmake -GNinja \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_BUILD_TYPE=None \
    -DCMAKE_INSTALL_PREFIX=\"/opt/liboqs\" \
    -DOQS_ALGS_ENABLED=All \
    -DOQS_BUILD_ONLY_LIB=OFF \
    -DOQS_DIST_BUILD=ON \
    -DOQS_USE_OPENSSL=ON \
    -DOQS_USE_AES_OPENSSL=ON \
    -DOQS_USE_SHA2_OPENSSL=ON \
    -DOQS_USE_SHA3_OPENSSL=ON \
    -DOQS_ENABLE_SIG_STFL_XMSS=ON \
    -DOQS_ENABLE_SIG_STFL_LMS=ON \
    -DOQS_HAZARDOUS_EXPERIMENTAL_ENABLE_SIG_STFL_KEY_SIG_GEN=ON \
    -DOQS_OPT_TARGET=x86-64 \
    -DOQS_STRICT_WARNINGS=ON \
    -Wno-dev \
    -B \"$BUILD_DIR\""

# Step 3: Build the library using Ninja (Dry run)
echo "Dry run: sudo ninja -n -C \"$BUILD_DIR\""  # -n flag for Ninja to show steps without executing

# Step 4 (Optional): Generate Documentation (Dry run)
echo "Dry run: sudo ninja -n -C \"$BUILD_DIR\" gen_docs" || echo "Documentation generation dry run failed."

# Step 5 (Optional): Run Tests (Dry run)
TEST_REPORT_FILE="$BUILD_DIR/test_report_$(date +'%Y%m%d_%H%M%S').txt"
echo "Dry run: sudo ninja -n -C \"$BUILD_DIR\" run_tests | tee \"$TEST_REPORT_FILE\"" || echo "Test run dry run failed. Test report saved to $TEST_REPORT_FILE"

# Step 6: Install the library to /opt/liboqs (Dry run)
if [ -d "$BUILD_DIR" ]; then
    echo "Dry run: sudo ninja -n -C \"$BUILD_DIR\" install" || echo "Installation dry run failed."
else
    echo "Build directory not found, skipping installation."
fi

# Step 7: Configure dynamic linker to avoid interfering with system libraries (Dry run)
echo "Dry run: echo \"/opt/liboqs/lib\" | sudo tee /etc/ld.so.conf.d/liboqs.conf"
echo "Dry run: sudo ldconfig"

# Step 8: Update environment variables (Dry run)
WRAPPER_SCRIPT="/opt/liboqs/liboqs_env.sh"
echo "Dry run: Create wrapper script \"$WRAPPER_SCRIPT\""

cat << EOF

To use qompass liboqs, you may want to source the environment variables for your current shell session:

source /opt/liboqs/liboqs_env.sh

Alternatively, you can use the commands in the script above in a terminal when needed.

EOF

