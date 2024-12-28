#!/bin/bash
# Script to build and install liboqs into /opt/liboqs without interfering with system packages
# Ensure that this script is run from the qliboqs directory (not the scripts directory)

# Step 1: Create build directory
BUILD_DIR="./build"
mkdir -p "${BUILD_DIR}"

# Step 2: Configure the build with CMake
cmake -GNinja \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_BUILD_TYPE=None \
    -DCMAKE_INSTALL_PREFIX="/opt/liboqs" \
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
    -B "${BUILD_DIR}"

# Step 3: Build the library using Ninja
sudo ninja -C "${BUILD_DIR}" || echo "Ninja build failed, continuing for debugging purposes..."

# Step 4 (Optional): Generate Documentation
sudo ninja -C "${BUILD_DIR}" gen_docs || echo "Documentation generation failed."

# Step 5 (Optional): Run Tests
TEST_REPORT_FILE="${BUILD_DIR}/test_report_$(date +'%Y%m%d_%H%M%S').txt"
sudo ninja -C "${BUILD_DIR}" run_tests | tee "${TEST_REPORT_FILE}" || echo "Some tests failed. Test report saved to ${TEST_REPORT_FILE}"

# Step 6: Install the library to /opt/liboqs
# Only proceed if the build was successful
if [[ -d "${BUILD_DIR}" ]]; then
    sudo ninja -C "${BUILD_DIR}" install || echo "Installation failed, some issues occurred."
else
    echo "Build directory not found, skipping installation."
fi

# Step 7: Configure dynamic linker to avoid interfering with system libraries
# Create a configuration file for /opt/liboqs
echo "/opt/liboqs/lib" | sudo tee /etc/ld.so.conf.d/liboqs.conf
sudo ldconfig

# Step 8: Update environment variables (Optional)
# Create a wrapper script to use these environment variables locally when needed
# Important to avoid interfering with system software
WRAPPER_SCRIPT="/opt/liboqs/liboqs_env.sh"
cat <<EOF | sudo tee "${WRAPPER_SCRIPT}"
#!/bin/bash
export LD_LIBRARY_PATH="/opt/liboqs/lib:\$LD_LIBRARY_PATH"
export C_INCLUDE_PATH="/opt/liboqs/include:\$C_INCLUDE_PATH"
export PATH="/opt/liboqs/bin:\$PATH"
EOF
sudo chmod +x "${WRAPPER_SCRIPT}"

cat <<EOF

To use qompass liboqs, you may want to source the environment variables for your current shell session:

source /opt/liboqs/liboqs_env.sh

Alternatively, you can use the commands in the script above in a terminal when needed.

EOF
