#include <botan/pubkey.h>
#include <botan/kem.h>
#include <botan/rng.h>
#include <iostream>
#include <vector>

int main() {
    try {
        Botan::AutoSeeded_RNG rng;
        Botan::KEM_Key_Generator keygen("Kyber-768");
        auto key_pair = keygen.generate_keypair(rng);

        std::cout << "Kyber768 keys generated successfully." << std::endl;

        // Print private key size
        std::cout << "Private key size: " << key_pair.private_key().private_key_bits() << " bits" << std::endl;

        // Print public key size
        std::vector<uint8_t> public_key_bits = key_pair.public_key().public_key_bits();
        std::cout << "Public key size: " << public_key_bits.size() * 8 << " bits" << std::endl;

    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }

    return 0;
}
