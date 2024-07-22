# Post-Quantum Cryptography References

## FAQ

### What is Asymmetric Cryptography?
Asymmetric cryptography, also known as public-key cryptography, uses a pair of mathematically related keys: a public key and a private key. The public key can be freely shared, while the private key is kept secret. Data encrypted with the public key can only be decrypted with the corresponding private key, and vice versa. This allows for secure communication without the need to exchange secret keys.

### What is Diffie-Hellman?
Diffie-Hellman is a key exchange protocol that allows two parties to establish a shared secret key over an insecure channel. It's widely used in internet protocols to set up secure communications. The most common variant used today is Elliptic Curve Diffie-Hellman (ECDH), with X25519 being a popular implementation.

### What is Kyber?
Kyber is a post-quantum key encapsulation mechanism (KEM) selected by NIST as part of its post-quantum cryptography standardization process. It's designed to be secure against attacks by both classical and quantum computers, making it a candidate for future-proofing cryptographic systems.

### What are OpenSSL and TLS?
OpenSSL is an open-source software library that implements cryptographic protocols, including TLS. TLS (Transport Layer Security) is a protocol that provides privacy and data integrity between two communicating applications. It's the most widely used security protocol on the internet, forming the basis of HTTPS.

### What organizations use TLS 1.3 with Diffie-Hellman and Kyber currently?
As of 2023, TLS 1.3 with Diffie-Hellman (specifically X25519) is widely adopted by major tech companies and internet services. However, Kyber, being a post-quantum algorithm, is still in the testing and integration phase. Some organizations experimenting with post-quantum TLS include:

1. Google (in Chrome browser)
2. Cloudflare (in their CDN services)
3. Amazon Web Services (in their KMS service)
4. Microsoft (in their Azure quantum-safe VPN)

Note that full integration of Kyber into TLS is still ongoing and not yet standardized for widespread use.

## Post-Quantum Cryptography and Generative AI

The intersection of post-quantum cryptography (PQC) and generative AI (genAI) presents both challenges and opportunities in the field of cybersecurity.

### Use Cases

1. **Enhanced Cryptographic Systems**: Quantum computing combined with AI can potentially create more sophisticated cryptographic systems that are resistant to both classical and quantum attacks[4](https://www.digicert.com/insights/post-quantum-cryptography)

2. **Threat Identification**: AI, especially when powered by quantum computing, can help identify new threat vectors and patterns, enhancing proactive security measures[4](https://www.digicert.com/insights/post-quantum-cryptography).

3. **AI-Assisted Cryptanalysis**: While AI can be used to strengthen cryptography, it also poses potential threats. Researchers have demonstrated that AI techniques can be used to break certain post-quantum encryption algorithms[2](https://www.securityweek.com/ai-helps-crack-a-nist-recommended-post-quantum-encryption-algorithm/).

### AI Hackers and Post-Quantum Encryption

Recent developments have shown that AI can pose significant threats to current and even post-quantum encryption methods:

- Researchers from KTH Royal Institute of Technology in Stockholm used deep learning analysis combined with side-channel attacks to break the CRYSTALS-Kyber encryption mechanism, which was recommended by NIST for post-quantum cryptography[2](https://www.securityweek.com/ai-helps-crack-a-nist-recommended-post-quantum-encryption-algorithm/).

- This breakthrough suggests that AI-based attacks might pose a more imminent threat to encryption than quantum computers themselves[2](https://www.securityweek.com/ai-helps-crack-a-nist-recommended-post-quantum-encryption-algorithm/).

- The approach used is not specific to CRYSTALS-Kyber and could potentially be applied to other post-quantum encryption schemes[2](https://www.securityweek.com/ai-helps-crack-a-nist-recommended-post-quantum-encryption-algorithm/).


# Post-Quantum Cryptography References

## Diffie-Hellman X25519

- [Curve25519: new Diffie-Hellman speed records](https://cr.yp.to/ecdh/curve25519-20060209.pdf) - Original paper by Daniel J. Bernstein
- [RFC 7748: Elliptic Curves for Security](https://datatracker.ietf.org/doc/html/rfc7748) - IETF specification for X25519
- [NIST SP 800-186: Recommendations for Discrete Logarithm-Based Cryptography: Elliptic Curve Domain Parameters](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-186.pdf) - NIST guidelines on elliptic curve cryptography


## Kyber

- [CRYSTALS-Kyber Algorithm Specifications and Supporting Documentation](https://pq-crystals.org/kyber/data/kyber-specification-round3-20210804.pdf)
- [NIST IR 8413: Status Report on the Third Round of the NIST Post-Quantum Cryptography Standardization Process](https://nvlpubs.nist.gov/nistpubs/ir/2022/NIST.IR.8413.pdf)
- [Draft FIPS 203: Module-Lattice-Based Key-Encapsulation Mechanism Standard](https://csrc.nist.gov/pubs/fips/203/ipd)
## NIST Post-Quantum Cryptography Standardization

- [NIST Post-Quantum Cryptography Standardization](https://csrc.nist.gov/projects/post-quantum-cryptography/post-quantum-cryptography-standardization)
- [NIST Announces First Four Quantum-Resistant Cryptographic Algorithms](https://www.nist.gov/news-events/news/2022/07/nist-announces-first-four-quantum-resistant-cryptographic-algorithms)
- [Status Report on the Third Round of the NIST Post-Quantum Cryptography Standardization Process](https://nvlpubs.nist.gov/nistpubs/ir/2022/NIST.IR.8413.pdf)

## Educational Videos

- [Quantum Computers Explained – Limits of Human Technology](https://www.youtube.com/watch?v=JhHMJCUmq28) by Kurzgesagt – In a Nutshell
- [How will quantum computing change the world?](https://www.youtube.com/watch?v=kEJBxotcxRw) by The Economist
- [Quantum Computing: Top Players 2021](https://www.youtube.com/watch?v=2UQ8J2aPz5o) by Anastasia Marchenkova
- [What is Post-Quantum Cryptography?](https://www.youtube.com/watch?v=6H_9l9N3IXU) by Computerphile

## U.S. Government Guidance and Legislation

- [National Security Memorandum on Promoting United States Leadership in Quantum Computing While Mitigating Risks to Vulnerable Cryptographic Systems](https://www.whitehouse.gov/briefing-room/statements-releases/2022/05/04/national-security-memorandum-on-promoting-united-states-leadership-in-quantum-computing-while-mitigating-risks-to-vulnerable-cryptographic-systems/) (May 4, 2022)
- [Executive Order on Enhancing the National Quantum Initiative Advisory Committee](https://www.whitehouse.gov/briefing-room/presidential-actions/2022/05/04/executive-order-on-enhancing-the-national-quantum-initiative-advisory-committee/) (May 4, 2022)
- [Quantum Computing Cybersecurity Preparedness Act](https://www.congress.gov/bill/117th-congress/house-bill/7535/text) (Signed into law December 21, 2022)
- [CHIPS and Science Act of 2022](https://www.congress.gov/bill/117th-congress/house-bill/4346/text) (Signed into law August 9, 2022)

## NIST Post-Quantum Cryptography Standardization Timeline

- July 2022: NIST announces selection of first group of quantum-resistant algorithms
- August 2023 - November 2023: Public comment period for draft standards of FIPS 203, 204, and 205
- 2024: 
  - Expected publication of final FIPS standards for CRYSTALS-Kyber, CRYSTALS-Dilithium, and SPHINCS+
  - Draft standards for FALCON to be released for public comments
- 2024-2025: FIPS 140-3 Cryptographic Modules can deploy the FIPS PQC algorithms as "FIPS Allowed"
- 2025-2026: FIPS certification for the PQC algorithms becomes available
- Post 2026: NIST continues investigating other PQC algorithms for potential standardization

Note: This timeline is based on current NIST projections and may be subject to change.
