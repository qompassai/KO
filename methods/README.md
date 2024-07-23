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
./kem_benchmark.sh

Prerequisites:
OpenSSL with Open Quantum Safe (OQS) support
Bash shell environment
Output:
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

- [Open Quantum Safe (OQS)](https://github.com/open-quantum-safe/liboqs)
- [OQS-OpenSSL](https://github.com/open-quantum-safe/openssl)
- [OQS-Provider](https://github.com/open-quantum-safe/oqs-provider)

## Installation Instructions

### For x86_64 Linux (Arch)

1. Install dependencies:

sudo pacman -S gcc make cmake ninja openssl
text

2. Clone and build liboqs:

git clone https://github.com/open-quantum-safe/liboqs.git
cd liboqs
mkdir build && cd build
cmake -GNinja ..
ninja
sudo ninja install
text

3. Clone and build OQS-OpenSSL:

git clone https://github.com/open-quantum-safe/openssl.git
cd openssl
./config --prefix=/usr/local/oqs-openssl
make
sudo make install
text

4. Set up environment variables:

export PATH="/usr/local/oqs-openssl/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/oqs-openssl/lib:$LD_LIBRARY_PATH"
text

### For aarch64 (Ubuntu)

1. Install dependencies:

sudo apt update
sudo apt install gcc make cmake ninja-build libssl-dev
text

2. Clone and build liboqs:

git clone https://github.com/open-quantum-safe/liboqs.git
cd liboqs
mkdir build && cd build
cmake -GNinja ..
ninja
sudo ninja install
text

3. Clone and build OQS-OpenSSL:

git clone https://github.com/open-quantum-safe/openssl.git
cd openssl
./config --prefix=/usr/local/oqs-openssl
make
sudo make install
text

4. Set up environment variables:

export PATH="/usr/local/oqs-openssl/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/oqs-openssl/lib:$LD_LIBRARY_PATH"
text

## Generating Keys

### Post-Quantum Keys

Generate a post-quantum key pair (e.g., using Kyber):

openssl genpkey -algorithm kyber512 -out kyber_private_key.pem
openssl pkey -in kyber_private_key.pem -pubout -out kyber_public_key.pem
text

### Classical Keys

Generate a classical key pair (e.g., RSA):

openssl genpkey -algorithm RSA -out rsa_private_key.pem
openssl rsa -pubout -in rsa_private_key.pem -out rsa_public_key.pem
text

### Hybrid Keys

Generate a hybrid key pair (e.g., ECDSA with Kyber):

openssl genpkey -algorithm p256_kyber512 -out hybrid_private_key.pem
openssl pkey -in hybrid_private_key.pem -pubout -out hybrid_public_key.pem
text

## Verifying Installation

To verify that OQS-OpenSSL is working correctly:

openssl list -providers
text
This should list the OQS provider among the available providers.

For a list of supported algorithms:

openssl list -signature-algorithms
openssl list -key-exchange-algorithms
text

## Additional Resources

- [OQS-OpenSSL Documentation](https://github.com/open-quantum-safe/openssl/wiki)
- [liboqs Documentation](https://openquantumsafe.org/liboqs/documentation.html)

Note: Always ensure you're using the latest versions of these libraries and follow best practices for key management and cryptographic operations.
