#!/usr/bin/env python3

import subprocess
import time
import statistics
import sys
import os

def check_botan_installation():
    try:
        result = subprocess.run(["botan", "version"], capture_output=True, text=True, check=True)
        print(f"Botan version: {result.stdout.strip()}")
    except subprocess.CalledProcessError:
        print("Error: Botan is not installed or not in PATH")
        sys.exit(1)

def run_botan_command(command):
    try:
        full_command = f"botan {command}"
        result = subprocess.run(full_command, shell=True, check=True, capture_output=True, text=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Error running command '{full_command}':")
        print(f"Exit code: {e.returncode}")
        print(f"stdout: {e.stdout}")
        print(f"stderr: {e.stderr}")
        return None

def generate_keys(algorithm):
    run_botan_command(f"keygen --algo={algorithm} --output={algorithm}_privkey.pem")
    run_botan_command(f"pkcs8 --pub-out --output={algorithm}_pubkey.pem {algorithm}_privkey.pem")

def benchmark(algorithm, operation, iterations=10):
    times = []
    for _ in range(iterations):
        start_time = time.time()
        if operation == "keygen":
            result = run_botan_command(f"keygen --algo={algorithm}")
        elif operation == "encrypt":
            result = run_botan_command(f"pk_encrypt {algorithm}_pubkey.pem plaintext.txt")
        elif operation == "decrypt":
            result = run_botan_command(f"pk_decrypt {algorithm}_privkey.pem ciphertext.bin")
        elif operation == "sign":
            result = run_botan_command(f"sign {algorithm}_privkey.pem message.txt")
        elif operation == "verify":
            result = run_botan_command(f"verify {algorithm}_pubkey.pem message.txt signature.bin")
        else:
            print(f"Unknown operation: {operation}")
            return None
        
        if result is None:
            return None
        end_time = time.time()
        times.append(end_time - start_time)
    
    if times:
        avg_time = statistics.mean(times)
        return avg_time
    return None

def create_dummy_files():
    with open("plaintext.txt", "w") as f:
        f.write("This is a test message")
    with open("message.txt", "w") as f:
        f.write("This is a message to sign")

def main():
    check_botan_installation()
    create_dummy_files()

    algorithms = [
        "ECDSA",
        "RSA",
        "ECDH",
        "SM2"
    ]

    print("\nBenchmarking results:")
    print("---------------------")

    for algo in algorithms:
        print(f"\nAlgorithm: {algo}")
        
        generate_keys(algo)
        
        key_gen_time = benchmark(algo, "keygen")
        if key_gen_time:
            print(f"Key Generation: {key_gen_time:.6f} seconds")
        
        if algo in ["RSA", "SM2"]:
            encrypt_time = benchmark(algo, "encrypt")
            decrypt_time = benchmark(algo, "decrypt")
            if encrypt_time:
                print(f"Encryption: {encrypt_time:.6f} seconds")
            if decrypt_time:
                print(f"Decryption: {decrypt_time:.6f} seconds")
        
        if algo in ["ECDSA", "RSA", "SM2"]:
            sign_time = benchmark(algo, "sign")
            verify_time = benchmark(algo, "verify")
            if sign_time:
                print(f"Signing: {sign_time:.6f} seconds")
            if verify_time:
                print(f"Verification: {verify_time:.6f} seconds")
        
        print("---------------------")

if __name__ == "__main__":
    main()