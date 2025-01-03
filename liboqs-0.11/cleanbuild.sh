#In qliboqs directory, run the following commands

#Step 1

cmake -GNinja \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_BUILD_TYPE=None \
    -DCMAKE_INSTALL_PREFIX=/usr \
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
    -B build

Step 2:

sudo ninja -C build

step 3

