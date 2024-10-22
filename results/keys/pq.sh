#!/bin/bash

# Note: This script requires OpenSSL 3.32 with Post-Quantum Cryptography algorithm support via NIST-endorsed libraries like liboqs v0.10 and oqs-provider v0.6.1.
# Kyber Odyssey demonstrates how to generate quantum-safe key pairs on-device and at no cost via thoughtful alignment of hardware and software.
# Generated private keys are encrypted to prevent use for purposes outside of this Qompass solution demonstration.
# All public and private keys are stored in Privacy Enhanced Mail format, the established standard for secure email instituted by the Internet Engineering Task Force.

# Use Cases for Medicine and Education:
# ----------------------------------------
# In medicine, quantum-safe encryption is essential for securely storing and transmitting sensitive patient health information (PHI), ensuring compliance with strict regulations like HIPAA.
# In education, institutions can use quantum-safe cryptography to protect sensitive student data, research work, and communication channels, ensuring privacy and data integrity.

# Algorithms to generate keys for
algorithms=(
    frodo640aes frodo640shake frodo976aes frodo976shake frodo1344aes frodo1344shake
    kyber512 kyber768 kyber1024 mlkem512 mlkem768 mlkem1024
    bikel1 bikel3 bikel5 hqc128 hqc192 hqc256
    p256_kyber512 p384_kyber768 p521_kyber1024
    x25519_kyber512 x25519_kyber768 x448_kyber768
)

# Directory to store generated public and private keys. 
#
mkdir -p pq_keys

# Loop through each algorithm, generate key pairs, and encrypt the private key
for algo in "${algorithms[@]}"; do
    # Define file names
    private_key="pq_keys/${algo}_private.pem"
    public_key="pq_keys/${algo}_public.pem"
    encrypted_private_key="pq_keys/${algo}_private_encrypted.pem"
    
    echo "Generating key pair for $algo..."

    # Generate private key
    openssl genpkey -algorithm $algo -out $private_key

    # Extract the public key from the private key
    openssl pkey -in $private_key -pubout -out $public_key

    # Encrypt the private key using AES-256-CBC with a passphrase
    # Note: Use OpenSSL-native tool Password-Based Key Derivation Function 2 (PBKDF2) with a specified number of iterations (-pbkdf2 and -iter) 
    # for stronger key derivation security.
    # -pbkdf2: Uses PBKDF2 to derive the encryption key from the passphrase, enhancing resistance to brute-force attacks.
    # -iter: Specifies the number of iterations (e.g., -iter 10000), making the key derivation process more computationally intensive.

    echo "Encrypting private key for $algo..."
    openssl aes-256-cbc -salt -pbkdf2 -iter 10000 -in $private_key -out $encrypted_private_key

    # Remove the unencrypted private key for security
    rm $private_key
    
    echo "Key pair for $algo generated and private key encrypted."
    echo "--------------------------------------------------------"
done

echo "All keys generated and encrypted successfully."

# INSTRUCTIONS FOR DECRYPTING PRIVATE KEYS:
# ==============================================================
# If you generate your own keys locally using this script, you can decrypt the encrypted private keys
# as follows (assuming you know the passphrase used during encryption):
#
# To decrypt a private key:
# openssl aes-256-cbc -d -pbkdf2 -iter 10000 -in pq_keys/ALGORITHM_private_encrypted.pem -out pq_keys/ALGORITHM_private_decrypted.pem
#
# Replace 'ALGORITHM' with the desired algorithm name (e.g., kyber512).
#
# IMPORTANT: The keys provided in the Qompass repository have been encrypted with a passphrase
# that is not publicly shared. These private keys cannot be decrypted by third parties,
# ensuring that they cannot be used for unauthorized purposes. 
#
# The public keys are freely available to demonstrate our work, while the private keys are kept secure.
# This shows that Qompass is capable of generating these keypairs and managing them securely without
# exposing sensitive cryptographic material that could be misused.


# Use Case Examples: Medicine & Education 
# ==============================================================
# Example 1: Medicine - Secure Patient Data Transmission
# --------------------------------------------------------------
# In a hospital setting, a doctor needs to securely share a patient's medical records with a specialist.
# Using post-quantum public-key cryptography, the hospital can use a public key (e.g., kyber512_public.pem) 
# to encrypt the patient's data, ensuring that only the intended specialist (who holds the private key) 
# can decrypt and read the information. This guarantees confidentiality and privacy for sensitive health information.

# Example 2: Education - Secure Online Assessments
# --------------------------------------------------------------
# In an educational setting, universities can use post-quantum cryptographic keys to secure online exams files,
# assessments, and personnel records. By using quantum-safe algorithms, they ensure that encrypted examination papers or 
# assessment records cannot be intercepted or accessed by anyone without proper approval, even if those actors have 
# access to state-of-the-art AI models or hacking tooling. The encrypted keys can be securely distributed to the faculty
# members who are authorized to access the exam content.

# Example 3: Medicine - Securing Medical Devices
# --------------------------------------------------------------
# Medical devices often send data wirelessly to doctors for monitoring patient health.
# By using post-quantum cryptographic keys, medical device manufacturers can ensure that data from the devices
# is encrypted to prevent the "harvest now, decrypt later" strategy employed by hackers targeting sensitive patient data.

# Example 4: Education - Protecting Research Data
# --------------------------------------------------------------
# Universities and research institutions can use post-quantum encryption to secure highly sensitive research data.
# Public keys can be used to encrypt data, ensuring that only researchers with the corresponding private keys can
# access it. This prevents unauthorized access and secures the data for the long term, especially as quantum computing becomes more powerful.

