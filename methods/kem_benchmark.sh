#!/bin/bash

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
            "$name" "$keygen_ms" "$encaps_ms" "$decaps_ms" "$keygens_s" "$encaps_s" "$decaps_s"
    else
        printf "%-20s %-15s %-15s %-15s %-15s %-15s %-15s\n" \
            "$algo" "N/A" "N/A" "N/A" "N/A" "N/A" "N/A"
    fi
done
