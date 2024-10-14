#!/bin/bash

# PQC Algorithm Benchmark Script
# ------------------------------
# This script benchmarks various post-quantum cryptography (PQC) algorithms
# using OpenSSL's speed command. It measures the performance of key generation,
# encapsulation, and decapsulation operations for each algorithm.

#In cryptography, keys are essential pieces of information used to control the operation of cryptographic algorithms. They are typically large numbers or byte strings that serve as inputs to cryptographic functions. In the context of this script, we're dealing with key encapsulation mechanisms (KEMs), which are used to securely exchange symmetric keys.

#    One-way functions:
#    These are mathematical functions that are easy to compute in one direction but computationally infeasible to reverse. They form the basis of many cryptographic systems, including those benchmarked in this script.
#    Diffie-Hellman key exchange:
#    While not directly benchmarked in this script, Diffie-Hellman is a classic key exchange protocol. It uses the difficulty of the discrete logarithm problem (a type of one-way function) to allow two parties to generate a shared secret over an insecure channel.
#    Kyber/MLKEM:
#    These are post-quantum KEMs based on the hardness of lattice problems, another type of one-way function. They are designed to be secure against both classical and quantum computers.

#In the context of this benchmark script:

#    Key generation (Keygen):
#    This process creates a public-private key pair. The public key can be freely shared, while the private key must be kept secret. In lattice-based systems like Kyber/MLKEM, these keys are derived from specially constructed lattices.
#    Encapsulation (Encaps):
#    This is the process where a sender uses the recipient's public key to encrypt (or "encapsulate") a randomly generated symmetric key. This operation relies on the one-way nature of the underlying mathematical problem.
#    Decapsulation (Decaps):
#    This is the process where the recipient uses their private key to decrypt (or "decapsulate") the encapsulated symmetric key. Only the holder of the private key should be able to perform this operation successfully.

#The script benchmarks these operations for various post-quantum algorithms, including different variants of Kyber and MLKEM. It measures both the time taken for each operation (in milliseconds) and the number of operations that can be performed per second. The hybrid algorithms (e.g., p256_kyber512, x25519_kyber768) combine classical elliptic curve cryptography with post-quantum algorithms for additional security. By benchmarking these operations, the script provides insights into the practical performance of these advanced cryptographic systems, which is crucial for evaluating their suitability for real-world applications in a post-quantum computing era.
# The script performs the following tasks:
# 1. Defines an array of PQC algorithms to benchmark.
# 2. Prints a formatted header for the results table.
# 3. Iterates through each algorithm:
#    - Runs OpenSSL speed command for 1 second.
#    - Parses the output to extract performance metrics.
#    - Converts time measurements from seconds to milliseconds.
#    - Prints the formatted results for each algorithm.
# 4. If an algorithm is not supported or fails, it prints "N/A" for all metrics.
#
# Output includes:
# - Algorithm name
# - Key generation time (ms)
# - Encapsulation time (ms)
# - Decapsulation time (ms)
# - Key generations per second
# - Encapsulations per second
# - Decapsulations per second
#
# Note: This script requires OpenSSL with PQC algorithm support.

algorithms=(
    frodo640aes frodo640shake frodo976aes frodo976shake frodo1344aes frodo1344shake
    kyber512 kyber768 kyber1024 mlkem512 mlkem768 mlkem1024
    bikel1 bikel3 bikel5 hqc128 hqc192 hqc256
    p256_kyber512 p384_kyber768 p521_kyber1024
    x25519_kyber512 x25519_kyber768 x448_kyber768
)

printf "%-20s %-15s %-15s %-15s %-15s %-15s %-15s\n" "Algorithm" "Keygen (ms)" "Encaps (ms)" "Decaps (ms)" "Keygens/s" "Encaps/s" "Decaps/s"
printf "%s\n" "--------------------------------------------------------------------------------------------------------"

for algo in "${algorithms[@]}"; do
    result=$(openssl speed -seconds 1 "$algo" 2>/dev/null | grep "$algo")
    if [ -n "$result" ]; then
        read -r name keygen encaps decaps keygens_s encaps_s decaps_s <<< "$result"
        
        # Remove 's' suffix and convert to milliseconds
        keygen_ms=$(echo "$keygen" | sed 's/s$//' | awk '{print $1 * 1000}')
        encaps_ms=$(echo "$encaps" | sed 's/s$//' | awk '{print $1 * 1000}')
        decaps_ms=$(echo "$decaps" | sed 's/s$//' | awk '{print $1 * 1000}')
        
        printf "%-20s %-15.3f %-15.3f %-15.3f %-15.1f %-15.1f %-15.1f\n" \
            "${name}" "${keygen_ms}" "$encaps_ms" "$decaps_ms" "$keygens_s" "$encaps_s" "$decaps_s"
    else
        printf "%-20s %-15s %-15s %-15s %-15s %-15s %-15s\n" \
            "$algo" "N/A" "N/A" "N/A" "N/A" "N/A" "N/A"
    fi
done

