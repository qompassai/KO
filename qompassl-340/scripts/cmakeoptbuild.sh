sudo cmake .. \
    -DOPENSSL_USE_STATIC_LIBS=TRUE \
    -DOQS_ENABLE=ON \
    -DWITH_JITTERENTROPY=ON \
    -DBUILD_SHARED_LIBS=ON \
    -DCMAKE_INSTALL_PREFIX=/opt/qompassl