#!/bin/bash
##First, ensure you have the latest version of OpenSSL with Open Quantum Safe(OQS) support installed.
ALGORITHMS="kyber512 kyber768 kyber1024 frodo640aes frodo976aes frodo1344aes dilithium2 dilithium3 dilithium5 falcon512 falcon1024 p256_kyber512 x25519_kyber768 p384_kyber768 p521_kyber1024"
ITERATIONS=5
DURATION=10

echo "Algorithm,Iteration,Load,KeyGen(op/s),Encap/Sign(op/s),Decap/Verify(op/s)"

for alg in $ALGORITHMS; do
    for i in $(seq 1 $ITERATIONS); do
        for load in 1 2 4 8; do
            result=$(openssl speed -mr -seconds $DURATION -multi $load $alg | grep -v 'version')
            if [ -n "$result" ]; then
                echo "$alg,$i,$load,$result" | sed 's/:/,/g'
            fi
        done
    done
done
