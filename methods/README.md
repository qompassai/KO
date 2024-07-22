# Post-Quantum Cryptography Benchmarking

Kyber Odyssey contains  tools for benchmarking post-quantum cryptographic algorithms using OpenSSL with Open Quantum Safe (OQS) support.

## Prerequisites

- Latest version of OpenSSL with Open Quantum Safe (OQS) support installed
- Python 3.x
- Polars library
- Requests library
- BeautifulSoup library

## Benchmarking Script

The `ko_stress_test.sh` script performs the following operations:

1. Defines a set of algorithms to test, including variants of Kyber, Frodo, Dilithium, Falcon, and hybrid schemes.
2. Sets the number of iterations (5) and duration (10 seconds) for each test.
3. Runs OpenSSL speed tests for each algorithm under different thread loads (1, 2, 4, and 8 threads).
4. Collects performance metrics: Key Generation, Encapsulation/Signing, and Decapsulation/Verification speeds.
5. Outputs results in CSV format.

### Usage

```bash
./ko_stress_test.sh > pq_stress_results.csv
