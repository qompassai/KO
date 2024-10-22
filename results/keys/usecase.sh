#!/bin/bash

# Note: This script requires OpenSSL 3.32 with Post-Quantum Cryptography algorithm support via NIST-endorsed libraries like liboqs v0.10 and oqs-provider v0.6.1.
# This script encrypts a sample PDF (`phi.pdf`) using quantum-safe public keys and decrypts it to show how data can be secured using these algorithms.

# Check if the input file (phi.pdf) exists
input_pdf="phi.pdf"
if [[ ! -f "$input_pdf" ]]; then
    echo "Error: Input file '$input_pdf' not found."
    exit 1
fi

# Directory to store output encrypted and decrypted files
mkdir -p pq_encryption_output

# Algorithms for encryption
algorithms=(
    frodo640aes frodo640shake frodo976aes frodo976shake frodo1344aes frodo1344shake
    kyber512 kyber768 kyber1024 mlkem512 mlkem768 mlkem1024
    bikel1 bikel3 bikel5 hqc128 hqc192 hqc256
    p256_kyber512 p384_kyber768 p521_kyber1024
    x25519_kyber512 x25519_kyber768 x448_kyber768
)

# Loop through each algorithm, encrypt and decrypt the input PDF
for algo in "${algorithms[@]}"; do
    # Define file names
    public_key="pq_keys/${algo}_public.pem"
    private_key="pq_keys/${algo}_private_encrypted.pem"
    encrypted_pdf="pq_encryption_output/encryptedphi_${algo}.pdf"
    decrypted_pdf="pq_encryption_output/decryptedphi_${algo}.pdf"

    # Check if the public and encrypted private keys exist
    if [[ ! -f "$public_key" || ! -f "$private_key" ]]; then
        echo "Warning: Keys for $algo not found. Skipping this algorithm."
        continue
    fi

    echo "Encrypting $input_pdf using $algo..."

    # Encrypt the input PDF using the public key
    openssl pkeyutl -encrypt -inkey $public_key -pubin -in $input_pdf -out $encrypted_pdf
    if [[ $? -ne 0 ]]; then
        echo "Error: Encryption failed for $algo."
        continue
    fi

    echo "Successfully encrypted $input_pdf to $encrypted_pdf."

    # Decrypt the private key to use for decryption
    decrypted_private_key="pq_keys/${algo}_private_decrypted.pem"
    echo "Decrypting private key for $algo..."
    openssl aes-256-cbc -d -pbkdf2 -iter 10000 -in $private_key -out $decrypted_private_key
    if [[ $? -ne 0 ]]; then
        echo "Error: Private key decryption failed for $algo."
        rm -f $decrypted_private_key
        continue
    fi

    # Decrypt the encrypted PDF using the decrypted private key
    echo "Decrypting $encrypted_pdf using $algo..."
    openssl pkeyutl -decrypt -inkey $decrypted_private_key -in $encrypted_pdf -out $decrypted_pdf
    if [[ $? -ne 0 ]]; then
        echo "Error: Decryption failed for $algo."
        rm -f $decrypted_private_key
        continue
    fi

    echo "Successfully decrypted $encrypted_pdf to $decrypted_pdf."
    echo "--------------------------------------------------------"

    # Clean up the decrypted private key for security purposes
    rm -f $decrypted_private_key
done

echo "All encryption and decryption operations completed."

