# Key Encapsulation Mechanism Cryptography Benchmarking

We built an evaluation script to execute a comprehensive benchmarking post-quantum cryptographic algorithms using OpenSSL with Open Quantum Safe (OQS) support.

##Key Features:
- **Algorithm Coverage**: Tests a wide range of classical, post-quantum, and hybrid KEM algorithms including Frodo, Kyber, MLKEM, BIKE, HQC, and hybrid schemes with elliptic curve cryptography.
- **Performance Metrics**: Measures key performance indicators for each algorithm:
- Key Generation time (in milliseconds)
- Encapsulation time (in milliseconds)
- Decapsulation time (in milliseconds)
- Operations per second for Key Generation, Encapsulation, and Decapsulation
- **Formatted Output**: Presents results in a clear, tabular format for easy reading and analysis.
- **Automatic Handling**: Gracefully handles cases where an algorithm is not supported by the installed OpenSSL version.
## Usage:
Simply run the script in a bash environment. Use 'chmod +x' or 'sudo chmod +x' to make executable:

```bash
sudo ./kem_benchmark.sh
```

## For report:
Simply run the script in a bash environment. Use 'chmod +x' or 'sudo chmod +x' to make executable:
```bash
sudo ./kbr.sh
```

Prerequisites:
- **OpenSSL with Open Quantum Safe (OQS) support**
- **Bash shell environment**
- **Build tools (Make/CMake/Ninja)**
- **Linux/Windows Subsystem for Linux or Mac equivalent (Arch Linux 6.10 and Ubuntu 24.04 5.15 Tegra tested)**
- Output:
The script generates a formatted table with the following columns:
Algorithm name
Key Generation time (ms)
Encapsulation time (ms)
Decapsulation time (ms)
Key Generations per second
Encapsulations per second
Decapsulations per second
This tool provides quality access for a quick and efficient way to compare the performance of various post-quantum algorithms, aiding in the selection and analysis of suitable algorithms for different applications.


# Post-Quantum Cryptography Setup Guide

This guide provides instructions for setting up and using post-quantum cryptography tools on x86_64 Linux (Arch) and aarch64 (Ubuntu) systems.

## Relevant GitHub Repositories
- [OpenSSL](https://github.com/openssl/openssl)
- [Open Quantum Safe (OQS)](https://github.com/open-quantum-safe/liboqs)
- [OQS-OpenSSL](https://github.com/open-quantum-safe/openssl)
- [OQS-Provider](https://github.com/open-quantum-safe/oqs-provider)

## Installation Instructions

### For x86_64 Linux (Arch)

1. Install dependencies:
```bash
sudo pacman -S gcc make cmake ninja openssl
```

2. Clone and build liboqs:
```bash
git clone https://github.com/open-quantum-safe/liboqs.git
cd liboqs
mkdir build && cd build
cmake -GNinja ..
sudo ninja
sudo ninja install
```

3. Clone and build OQS-OpenSSL:
```bash
git clone https://github.com/open-quantum-safe/openssl.git
cd openssl
./config --prefix=/usr/local/oqs-openssl
sudo make
sudo make install
```

4. Set up environment variables:
```bash
export PATH="/usr/local/oqs-openssl/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/oqs-openssl/lib:$LD_LIBRARY_PATH"
```

### For aarch64 (Ubuntu 24.04/24.10)

1. Install dependencies:
```bash
sudo apt update
sudo apt install gcc make cmake ninja-build libssl-dev
```

2. Clone and build liboqs:
```bash
git clone https://github.com/open-quantum-safe/liboqs.git
cd liboqs
mkdir build && cd build
cmake -GNinja ..
ninja
sudo ninja install
```

3. Clone and build OpenSSL (Release version 3.3.1):
```bash
git clone https://github.com/openssl/openssl
cd openssl
./Configure shared linux-aarch64 no-weak-ssl-ciphers no-deprecated no-ssl3 no-tls1 no-tls1_1 enable-tls1_3 -DOPENSSL_NO_HEARTBEATS -DOQS_DEFAULT_GROUPS=\"p256_kyber512:p384_kyber768:p521_kyber1024:kyber512:kyber768:kyber1024:p256_falcon512:p384_falcon512:p521_falcon1024:falcon512:falcon1024:p256_dilithium2:p384_dilithium3:p521_dilithium5:dilithium2:dilithium3:dilithium5:p384_mceliece348864:p521_mceliece460896:mceliece348864:mceliece460896:mceliece6688128:mceliece6960119:mceliece8192128:x25519_kyber512:x25519_kyber768:x25519_kyber1024:x25519_falcon512:x25519_falcon1024:x25519_dilithium2:x25519_dilithium3:x25519_dilithium5:x25519_mceliece348864:x25519_mceliece460896:x25519_mceliece6688128:x25519_mceliece6960119:x25519_mceliece8192128:frodo640aes:frodo976aes:frodo1344aes:bike1l1cpa:bike1l3cpa:bike1l5cpa:hqc128:hqc192:hqc256:sphincssha256128frobust:sphincssha256192frobust:sphincssha256256frobust:secp256k1_kyber512:secp256k1_kyber768:secp256k1_kyber1024:sntrup761:ntrulpr761:x25519_sphincssha256128frobust:x25519_frodo640aes:x25519_bike1l1cpa:x25519_hqc128:sphincsshake256128frobust:sphincssha256128ssimple:sphincsshake256128ssimple:x448_kyber768:x448_dilithium3:frodo640shake:frodo976shake:frodo1344shake\" -lm enable-chacha enable-aria enable-blake2 enable-sm4 enable-ec_nistp_64_gcc_128 enable-camellia enable-seed enable-whirlpool enable-ocb enable-gost enable-sm2 enable-sm3 enable-dtls enable-ktls no-dynamic-engine enable-fips
make
sudo make install
```

4. Set up environment variables:
```bash
export PATH="/usr/local/"what_you_name_openssl"/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/"what_you_name_openssl"/lib:$LD_LIBRARY_PATH"
source ~/.bashrc
```

## Generating Keys

### Post-Quantum Keys

Generate a post-quantum key pair (e.g., using Kyber):
```bash
sudo openssl genpkey -algorithm kyber512 -out kyber_private_key.pem
sudo openssl pkey -in kyber_private_key.pem -pubout -out kyber_public_key.pem
```

### Classical Keys

Generate a classical key pair (e.g., RSA):
```bash
sudo openssl genpkey -algorithm RSA -out rsa_private_key.pem
sudo openssl rsa -pubout -in rsa_private_key.pem -out rsa_public_key.pem
```

### Hybrid Keys

Generate a hybrid key pair (e.g., ECDSA with Kyber):
```bash
sudo openssl genpkey -algorithm p256_kyber512 -out hybrid_private_key.pem
sudo openssl pkey -in hybrid_private_key.pem -pubout -out hybrid_public_key.pem
```

## Verifying Installation

To verify that OQS-OpenSSL is working correctly:
```bash
sudo openssl list -providers
```
This should list the OQS provider among the available providers.

For a list of supported algorithms:
```bash
sudo openssl list -signature-algorithms
sudo openssl list -key-exchange-algorithms
```

## Additional Resources

- [OQS-OpenSSL Documentation](https://github.com/open-quantum-safe/openssl/wiki)
- [liboqs Documentation](https://openquantumsafe.org/liboqs/documentation.html)

Note: This is Kernel level code implementation and should NOT be used without an understanding of kernel operations and/or a willingness to have to reconfigure your system a few times.
