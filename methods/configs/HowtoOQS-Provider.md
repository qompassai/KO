# HowTOOQS-Provider

```bash
git clone https://github.com/open-quantum-safe/oqs-provider
cd oqs-provider
```
- # The following variables influence the operation of this build script:
- # Argument -f: Soft clean, ensuring re-build of oqs-provider binary
- # Argument -F: Hard clean, ensuring checkout and build of all dependencies
- # EnvVar MAKE_PARAMS: passed to invocations of make; sample value: "-j"
- # EnvVar OQSPROV_CMAKE_PARAMS: passed to invocations of oqsprovider cmake
- # EnvVar LIBOQS_BRANCH: Defines branch/release of liboqs; default value "main"
- # EnvVar OQS_ALGS_ENABLED: If set, defines OQS algs to be enabled, e.g., "STD"
- # EnvVar OPENSSL_INSTALL: If set, defines (binary) OpenSSL installation to use
- # EnvVar OPENSSL_BRANCH: Defines branch/release of openssl; if set, forces source-build of OpenSSL3
- # EnvVar liboqs_DIR: If set, needs to point to a directory where liboqs has been installed to

```bash
sudo scripts/fullbuild.sh -F OQSPROV_CMAKE_PARAMS LIBOQS_BRANCH OQS_ALGS_ENABLED
mkdir _build && cd _build
sudo cmake -GNinja \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  -DUSE_ENCODING_LIB=ON \
  -DOQS_KEM_ENCODERS=ON \
  -DOQS_ALGS_ENABLED=All \
  ..
sudo ninja
sudo ninja install
```
