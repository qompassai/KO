#!/bin/bash

# Check if enscript and ps2pdf are installed
if ! command -v enscript &> /dev/null || ! command -v ps2pdf &> /dev/null; then
    echo "enscript and ps2pdf are required. Please install them using:"
    echo "sudo pacman -S enscript ghostscript"
    exit 1
fi

algorithms=(
    frodo640aes frodo640shake frodo976aes frodo976shake frodo1344aes frodo1344shake
    kyber512 kyber768 kyber1024 mlkem512 mlkem768 mlkem1024
    bikel1 bikel3 bikel5 hqc128 hqc192 hqc256
    p256_kyber512 p384_kyber768 p521_kyber1024
    x25519_kyber512 x25519_kyber768 x448_kyber768
)

# Create a temporary file for results
temp_file=$(mktemp)

# Record start time
start_time=$(date "+%Y-%m-%d %H:%M:%S")

# Write header to the temporary file
echo "Kyber Odyssey KEM Benchmark Results" >> "$temp_file"
echo "Start time: $start_time" >> "$temp_file"
echo "" >> "$temp_file"
printf "+------------------+---------------+---------------+---------------+---------------+---------------+---------------+\n" >> "$temp_file"
printf "| %-16s | %-13s | %-13s | %-13s | %-13s | %-13s | %-13s |\n" "Algorithm" "Keygen (ms)" "Encaps (ms)" "Decaps (ms)" "Keygens/s" "Encaps/s" "Decaps/s" >> "$temp_file"
printf "+------------------+---------------+---------------+---------------+---------------+---------------+---------------+\n" >> "$temp_file"

for algo in "${algorithms[@]}"; do
    result=$(openssl speed -seconds 1 "$algo" 2>/dev/null | grep "$algo")
    if [ -n "$result" ]; then
        read -r name keygen encaps decaps keygens_s encaps_s decaps_s <<< "$result"

        # Remove 's' suffix and convert to milliseconds
        keygen_ms=$(echo "$keygen" | sed 's/s$//' | awk '{print $1 * 1000}')
        encaps_ms=$(echo "$encaps" | sed 's/s$//' | awk '{print $1 * 1000}')
        decaps_ms=$(echo "$decaps" | sed 's/s$//' | awk '{print $1 * 1000}')

        printf "| %-16s | %13.3f | %13.3f | %13.3f | %13.1f | %13.1f | %13.1f |\n" \
            "$name" "$keygen_ms" "$encaps_ms" "$decaps_ms" "$keygens_s" "$encaps_s" "$decaps_s" >> "$temp_file"
    else
        printf "| %-16s | %13s | %13s | %13s | %13s | %13s | %13s |\n" \
            "$algo" "N/A" "N/A" "N/A" "N/A" "N/A" "N/A" >> "$temp_file"
    fi
    printf "+------------------+---------------+---------------+---------------+---------------+---------------+---------------+\n" >> "$temp_file"
done

# Record end time
end_time=$(date "+%Y-%m-%d %H:%M:%S")
echo "" >> "$temp_file"
echo "End time: $end_time" >> "$temp_file"

# Convert the text file to PostScript using enscript with adjusted parameters
enscript -B -f Courier8 -M A4 -r -j --margins=20:20:20:20 -o - "$temp_file" | \
ps2pdf -dPDFFitPage -dCompatibilityLevel=1.4 - kem_benchmark_results.pdf

# Clean up the temporary file
rm "$temp_file"

echo "Results have been saved to kem_benchmark_results.pdf"
