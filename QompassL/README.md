QompassL: A Qompass Fork of OpenSSL for  
==============================


OpenSSL is a robust, commercial-grade, full-featured Open Source Toolkit
for the TLS (formerly SSL), DTLS and QUIC (currently client side only)
protocols. It is with great respect to their work that we public-source this code base
as part of our Kyber Odyssey to make reliable security available for all.


The official Home Page of the OpenSSL Project is [www.openssl.org]. We are grateful to stand on the 
shoulders of these giants.

Documentation
=============

- We've built build scripts tested on Arch Linux x86_64 that compile and install to the /opt
directory to **prevent inteference with system openssl.

- Compiling and building these libraries from source comes with risk in the absence of thoughtful alignment
of operating system, dependencies, cryptographic libraries, and hardware. 
- All materials falls within the purview of the dual-license on the main KO github page.

## Option 1: Copy/Paste

```
git clone --recursive https://github.com/qompassai/KO.git
cd KO/liboqs
./scripts/optbuild.sh
cd ..
cd QompassL
./scripts/optbuild.sh

```

README Files
------------

There are some README.md from the great folks at OpenSSL on add-ons for building out OpenSSL. 

 * [Information about the OpenSSL QUIC protocol implementation](README-QUIC.md)
 * [Information about the OpenSSL Provider architecture](README-PROVIDERS.md)
 * [Information about using the OpenSSL FIPS validated module](README-FIPS.md)
 * [Information about the legacy OpenSSL Engine architecture](README-ENGINES.md)


