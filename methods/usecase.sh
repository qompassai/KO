#!/bin/bash

algorithms=(
    frodo640aes frodo640shake frodo976aes frodo976shake frodo1344aes frodo1344shake
    kyber512 kyber768 kyber1024 mlkem512 mlkem768 mlkem1024
    bikel1 bikel3 bikel5 hqc128 hqc192 hqc256
    p256_kyber512 p384_kyber768 p521_kyber1024
    x25519_kyber512 x25519_kyber768 x448_kyber768
)

printf "%-20s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s\n" "Algorithm" "Keygen (ms)" "Encaps (ms)" "Decaps (ms)" "Keygens/s" "Encaps/s" "Decaps/s" "Encrypt" "Decrypt"
printf "%s\n" "------------------------------------------------------------------------------------------------------------------------------"

for algo in "${algorithms[@]}"; do
    result=$(openssl speed -seconds 1 "${algo}" 2>/dev/null | grep "${algo}")
    if [[ -n "${result}" ]]; then
        read -r name keygen encaps decaps keygens_s encaps_s decaps_s <<< "${result}"
        
        # Remove 's' suffix and convert to milliseconds
        keygen_ms=$(printf "%.3f" "$(echo "${keygen}" | sed 's/s$//' | awk '{print $1 * 1000}')")
        encaps_ms=$(printf "%.3f" "$(echo "${encaps}" | sed 's/s$//' | awk '{print $1 * 1000}')")
        decaps_ms=$(printf "%.3f" "$(echo "${decaps}" | sed 's/s$//' | awk '{print $1 * 1000}')")
        
        # Generate key pair
        openssl genpkey -algorithm "${algo}" -out private_key.pem 2>/dev/null
        openssl pkey -in private_key.pem -pubout -out public_key.pem 2>/dev/null
        
        # Display original content using bat
        printf "Original content for %s:\n" "${algo}"
        bat --paging=never --style=plain sample.txt
        printf "\n"

        # Encrypt file
        if openssl pkeyutl -encrypt -inkey public_key.pem -pubin -in sample.txt -out encrypted.bin 2>/dev/null; then
            encrypt_status="Success"
            # Convert binary to base64 for viewing
            base64 encrypted.bin > encrypted.txt
            printf "Encrypted content (base64) for %s:\n" "${algo}"
            bat --paging=never --style=plain encrypted.txt
            printf "\n"

            if openssl pkeyutl -decrypt -inkey private_key.pem -in encrypted.bin -out decrypted.txt 2>/dev/null; then
                decrypt_status="Success"
                # Display decrypted content using bat
                printf "Decrypted content for %s:\n" "${algo}"
                bat --paging=never --style=plain decrypted.txt
                printf "\n"
                # Show differences, if any
                printf "Differences between original and decrypted (should be empty):\n"
                diff sample.txt decrypted.txt
                printf "\n"
            else
                decrypt_status="Failed"
            fi
        else
            encrypt_status="Failed"
            decrypt_status="N/A"
        fi
        
        # Clean up
        rm -f private_key.pem public_key.pem encrypted.bin encrypted.txt decrypted.txt
        
        printf "%-20s %-15.3f %-15.3f %-15.3f %-15.1f %-15.1f %-15.1f %-15s %-15s\n" \
            "${name}" "${keygen_ms}" "${encaps_ms}" "${decaps_ms}" "${keygens_s}" "${encaps_s}" "${decaps_s}" "${encrypt_status}" "${decrypt_status}"
        
        printf "%s\n" "------------------------------------------------------------------------------------------------------------------------------"
    else
        printf "%-20s %-15s %-15s %-15s %-15s %-15s %-15s %-15s %-15s\n" \
            "${algo}" "N/A" "N/A" "N/A" "N/A" "N/A" "N/A" "N/A" "N/A"
    fi
done

