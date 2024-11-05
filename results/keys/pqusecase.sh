#!/usr/bin/env bash

#!/bin/bash

# First, check for OpenSSL and OQS provider
if ! openssl list -providers -provider default -provider oqsprovider | grep -q "oqsprovider"; then
    echo "Error: oqsprovider not installed or loaded"
    exit 1
fi

# Function to encrypt
encrypt_file() {
    local input_file="$1"
    local output_file="$2"
    local algo="$3"

    # Generate keys with both providers explicitly enabled
    openssl genpkey -provider default -provider oqsprovider \
        -algorithm "${algo}" \
        -out "${algo}_private.pem"

    openssl pkey -provider default -provider oqsprovider \
        -in "${algo}_private.pem" \
        -pubout -out "${algo}_public.pem"

    # Encrypt with both providers enabled
    openssl pkeyutl -provider default -provider oqsprovider \
        -encrypt \
        -pubin -inkey "${algo}_public.pem" \
        -in "${input_file}" \
        -out "${output_file}"
}

# Function to decrypt
decrypt_file() {
    local input_file="$1"
    local output_file="$2"
    local algo="$3"

    openssl pkeyutl -provider default -provider oqsprovider \
        -decrypt \
        -inkey "${algo}_private.pem" \
        -in "${input_file}" \
        -out "${output_file}"
}

# Main script
case "$1" in
"encrypt")
    if [[ "$#" -ne 4 ]]; then
        echo "Usage: $0 encrypt input_file output_file algorithm"
        exit 1
    fi
    encrypt_file "$2" "$3" "$4"
    ;;
"decrypt")
    if [[ "$#" -ne 4 ]]; then
        echo "Usage: $0 decrypt input_file output_file algorithm"
        exit 1
    fi
    decrypt_file "$2" "$3" "$4"
    ;;
*)
    echo "Usage: $0 {encrypt|decrypt} input_file output_file algorithm"
    exit 1
    ;;
esac
