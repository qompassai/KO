#!/bin/bash

OUTPUT_DIR="/home/phaedrus/Forge/GH/K.O./results"
OUTPUT_FILE="$OUTPUT_DIR/crypto_benchmarks.csv"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Function to display progress bar
progress_bar() {
    local duration=$1
    local steps=20
    local sleep_duration=$(echo "scale=2; $duration / $steps" | bc)
    for ((i=0; i<=steps; i++)); do
        printf "\rProgress: ["
        for ((j=0; j<i; j++)); do printf "#"; done
        for ((j=i; j<steps; j++)); do printf " "; done
        printf "] %d%%" $((i*100/steps))
        sleep $sleep_duration
    done
    printf "\n"
}

# Function to run benchmark and output to CSV
run_benchmark() {
    algorithm=$1
    tier=$2
    company=$3
    echo "Benchmarking $algorithm..."
    
    # Check if algorithm is supported
    if ! openssl speed -seconds 1 $algorithm &>/dev/null; then
        echo "$tier,$algorithm,Not Supported,$company" >> "$OUTPUT_FILE"
        echo "Algorithm $algorithm is not supported."
        return
    fi
    
    # Run benchmark and parse result
    result=$(openssl speed -seconds 5 $algorithm 2>/dev/null | grep -E "^$algorithm|^sign|^verify|^rsa|^dsa|^256|^384|^521" | awk '{print $2}' | head -n 1)
    
    if [ -z "$result" ]; then
        result="No data"
    fi
    
    echo "$tier,$algorithm,$result,$company" >> "$OUTPUT_FILE"
    progress_bar 5
}

# Create CSV header
echo "Security Tier,Algorithm,Operations per Second,Used By" > "$OUTPUT_FILE"

# Tier 1 (128-bit classical / 64-bit quantum security)
run_benchmark "rsa3072" "Tier 1" "Classic"
run_benchmark "x25519" "Tier 1" "Cloudflare, Google, Apple"
run_benchmark "kyber512" "Tier 1" "Post-Quantum"
run_benchmark "p256_kyber512" "Tier 1" "Cloudflare (Hybrid)"

# Tier 2 (192-bit classical / 96-bit quantum security)
run_benchmark "rsa7680" "Tier 2" "Classic"
run_benchmark "kyber768" "Tier 2" "Post-Quantum"
run_benchmark "p384_kyber768" "Tier 2" "Google (Hybrid)"

# Tier 3 (256-bit classical / 128-bit quantum security)
run_benchmark "rsa15360" "Tier 3" "Classic"
run_benchmark "kyber1024" "Tier 3" "Post-Quantum"
run_benchmark "p521_kyber1024" "Tier 3" "Amazon (Hybrid)"

# Additional benchmarks for comparison
run_benchmark "ecdsa256" "Tier 1" "Apple, Google"
run_benchmark "ecdsa384" "Tier 2" "Amazon"
run_benchmark "ed25519" "Tier 1" "Cloudflare"

echo "Benchmarks completed. Results saved in $OUTPUT_FILE"
