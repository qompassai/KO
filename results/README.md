# Post-Quantum Key Encapsulation Mechanisms (KEMs) in OpenSSL

This document provides an overview of the Key Encapsulation Mechanisms (KEMs) available in OpenSSL with OQS (Open Quantum Safe) support, including their NIST security levels, current adoption, and potential use cases.

## Supported KEM Algorithms

| Algorithm | NIST Security Level | Adoption | Use Cases |
|-----------|---------------------|----------|-----------|
| RSA | Classical | Widespread | 1. Secure email (S/MIME) <br> 2. HTTPS/TLS <br> 3. Code signing |
| EC (Elliptic Curve) | Classical | Widespread | 1. Mobile device security <br> 2. Blockchain <br> 3. Secure messaging apps |
| X25519 | Classical | Growing | 1. Signal Protocol <br> 2. Tor network <br> 3. SSH key exchange |
| X448 | Classical | Limited | 1. Long-term data protection <br> 2. High-security government comms <br> 3. Financial transaction systems |
| Frodo640AES | Level 1 | Experimental | 1. IoT device security <br> 2. Secure firmware updates <br> 3. Low-power sensor networks |
| Frodo640SHAKE | Level 1 | Experimental | 1. Smart home systems <br> 2. Wearable tech security <br> 3. Industrial IoT |
| Frodo976AES | Level 3 | Experimental | 1. Healthcare data exchange <br> 2. Satellite communications <br> 3. Autonomous vehicle systems |
| Frodo976SHAKE | Level 3 | Experimental | 1. Smart city infrastructure <br> 2. Power grid security <br> 3. Financial services |
| Frodo1344AES | Level 5 | Experimental | 1. Military communications <br> 2. Nuclear facility systems <br> 3. Long-term government archives |
| Frodo1344SHAKE | Level 5 | Experimental | 1. Quantum key distribution networks <br> 2. Space exploration data security <br> 3. Critical infrastructure protection |
| Kyber512 | Level 1 | Growing | 1. Secure messaging apps <br> 2. VPN services <br> 3. E-commerce platforms |
| Kyber768 | Level 3 | Growing | 1. Banking systems <br> 2. Cloud storage services <br> 3. Secure video conferencing |
| Kyber1024 | Level 5 | Growing | 1. Government classified comms <br> 2. Aerospace industry data <br> 3. Quantum-resistant blockchains |
| MLKEM512 | Level 1 | Experimental | 1. Smart home devices <br> 2. Personal health monitors <br> 3. Retail point-of-sale systems |
| MLKEM768 | Level 3 | Experimental | 1. Telemedicine platforms <br> 2. Autonomous drones <br> 3. Smart grid systems |
| MLKEM1024 | Level 5 | Experimental | 1. Satellite control systems <br> 2. Nuclear power plant security <br> 3. National defense networks |
| BIKE-L1 | Level 1 | Experimental | 1. IoT sensor networks <br> 2. Smart city infrastructure <br> 3. Consumer electronics |
| BIKE-L3 | Level 3 | Experimental | 1. Autonomous vehicle communications <br> 2. Industrial control systems <br> 3. Financial transaction verification |
| BIKE-L5 | Level 5 | Experimental | 1. High-security government communications <br> 2. Long-term data archiving <br> 3. Quantum-resistant voting systems |
| HQC-128 | Level 1 | Experimental | 1. Smart home security <br> 2. Wearable tech <br> 3. Retail inventory systems |
| HQC-192 | Level 3 | Experimental | 1. Healthcare data exchange <br> 2. Autonomous vehicle networks <br> 3. Smart grid communication |
| HQC-256 | Level 5 | Experimental | 1. Military satellite communications <br> 2. Nuclear facility control systems <br> 3. Long-term government data storage |

## Notes on Adoption and Use

- **Classical algorithms** (RSA, EC, X25519, X448) are widely used in current systems.
- **Post-quantum algorithms** are mostly in experimental stages, with some (like Kyber) gaining traction.
- Many algorithms offer hybrid options (e.g., p256_kyber512) combining classical and post-quantum security.
- Actual adoption in healthcare and other industries is limited but growing as quantum threats become more recognized.

## Implementation Considerations

- When implementing these algorithms, especially in containerized environments, ensure proper key management and secure configuration.
- Regular updates and security audits are crucial, especially for experimental algorithms.
- Consider hybrid approaches for a balance of current compatibility and future-proofing against quantum threats.

## Further Reading

- [NIST Post-Quantum Cryptography Standardization](https://csrc.nist.gov/projects/post-quantum-cryptography)
- [Open Quantum Safe Project](https://openquantumsafe.org/)
- [OpenSSL Documentation](https://www.openssl.org/docs/)

# Post-Quantum Key Encapsulation Mechanisms (KEMs) in OpenSSL for Healthcare

This document provides an overview of the Key Encapsulation Mechanisms (KEMs) available in OpenSSL with OQS (Open Quantum Safe) support, including their NIST security levels, current adoption, and potential healthcare use cases.

## Supported KEM Algorithms

| Algorithm | NIST Security Level | Adoption | Healthcare Use Cases |
|-----------|---------------------|----------|----------------------|
| [RSA](https://en.wikipedia.org/wiki/RSA_(cryptosystem)) | Classical | Widespread | 1. Secure email for patient records <br> 2. HTTPS for healthcare portals <br> 3. Digital signatures on e-prescriptions |
| [EC (Elliptic Curve)](https://en.wikipedia.org/wiki/Elliptic-curve_cryptography) | Classical | Widespread | 1. Securing wearable medical devices <br> 2. Blockchain for medical supply chain <br> 3. Secure messaging in telemedicine apps |
| [X25519](https://en.wikipedia.org/wiki/Curve25519) | Classical | Growing | 1. Secure key exchange in health information systems <br> 2. VPN for remote healthcare access <br> 3. Encrypted communication in medical IoT devices |
| [X448](https://datatracker.ietf.org/doc/html/rfc7748#section-5) | Classical | Limited | 1. Long-term storage of genomic data <br> 2. Secure communication for clinical trials <br> 3. High-security health insurance transactions |
| [Frodo](https://frodokem.org/) (640AES, 640SHAKE, 976AES, 976SHAKE, 1344AES, 1344SHAKE) | 1, 3, 5 | Experimental | 1. Quantum-resistant IoT medical devices <br> 2. Secure updates for implantable medical devices <br> 3. Future-proofing electronic health records (EHR) systems |
| [Kyber](https://pq-crystals.org/kyber/) (512, 768, 1024) | 1, 3, 5 | Growing | 1. Post-quantum secure telemedicine platforms <br> 2. Encrypted health data exchanges <br> 3. Quantum-resistant e-prescription systems |
| [MLKEM](https://csrc.nist.gov/Projects/post-quantum-cryptography/selected-algorithms-2022) (512, 768, 1024) | 1, 3, 5 | Experimental | 1. Securing next-gen medical imaging transfers <br> 2. Quantum-safe health monitoring systems <br> 3. Long-term protection of sensitive patient data |
| [BIKE](https://bikesuite.org/) (L1, L3, L5) | 1, 3, 5 | Experimental | 1. Post-quantum secure medical sensor networks <br> 2. Future-proofing hospital information systems <br> 3. Quantum-resistant health insurance claim processing |
| [HQC](https://pqc-hqc.org/) (128, 192, 256) | 1, 3, 5 | Experimental | 1. Long-term security for genomic databases <br> 2. Quantum-safe telesurgery communications <br> 3. Future-proof encryption for health research data |

Note: The NIST Security Levels correspond to the following:
- Level 1: At least as hard to break as AES-128
- Level 3: At least as hard to break as AES-192
- Level 5: At least as hard to break as AES-256

## Real-World Examples of AES Encryption Usage in Healthcare

### AES-128
- **Electronic Health Records (EHR)**: Many EHR systems use AES-128 for data at rest.
- **Medical Device Communication**: Some medical devices use AES-128 for secure data transmission.

### AES-192
- **Health Information Exchanges (HIE)**: Some HIEs use AES-192 for data transfer between healthcare providers.
- **Pharmaceutical Research**: Used in securing less sensitive research data.

### AES-256
- **Genomic Data Storage**: Often used for long-term storage of sensitive genomic information.
- **Telesurgery Systems**: High-security telesurgery platforms may use AES-256 for critical communications.
- **Mental Health Records**: Due to their sensitivity, mental health records often use AES-256 encryption.

## Notes on Adoption and Use in Healthcare

- **Classical algorithms** (RSA, EC, X25519, X448) are currently the backbone of healthcare cybersecurity.
- **Post-quantum algorithms** are being researched for future implementation in healthcare to protect against quantum threats.
- Hybrid approaches combining classical and post-quantum algorithms are being considered for a smooth transition.
- Adoption in healthcare is cautious due to regulatory compliance needs and the critical nature of medical data.

## Implementation Considerations for Healthcare

- Ensure compliance with healthcare regulations (e.g., HIPAA) when implementing new cryptographic algorithms.
- Regular security audits are crucial, especially when adopting experimental post-quantum algorithms.
- Consider the long-term storage needs of healthcare data (often decades) when choosing encryption methods.
- Balance the need for quantum-resistance with performance requirements in real-time healthcare applications.

## Further Reading

- [NIST Post-Quantum Cryptography Standardization](https://csrc.nist.gov/projects/post-quantum-cryptography)
- [Open Quantum Safe Project](https://openquantumsafe.org/)
- [OpenSSL Documentation](https://www.openssl.org/docs/)
- [HealthIT.gov Encryption Guidelines](https://www.healthit.gov/topic/privacy-security-and-hipaa/encryption)

