# Key Encapsulation Mechanism Cryptography Benchmarking

We built an evaluation script to execute a comprehensive benchmarking post-quantum cryptographic algorithms using OpenSSL with Open Quantum Safe (OQS) support.
Key Features:
Algorithm Coverage: Tests a wide range of classical, post-quantum, and hybrid KEM algorithms including Frodo, Kyber, MLKEM, BIKE, HQC, and hybrid schemes with elliptic curve cryptography.
Performance Metrics: Measures key performance indicators for each algorithm:
Key Generation time (in milliseconds)
Encapsulation time (in milliseconds)
Decapsulation time (in milliseconds)
Operations per second for Key Generation, Encapsulation, and Decapsulation
Formatted Output: Presents results in a clear, tabular format for easy reading and analysis.
Automatic Handling: Gracefully handles cases where an algorithm is not supported by the installed OpenSSL version.
Usage:
Simply run the script in a bash environment. Use chmod +x/ sudo chmod +x to make executable:
text
./kem_benchmark.sh

Prerequisites:
OpenSSL with Open Quantum Safe (OQS) support
Bash shell environment
Output:
The script generates a formatted table with the following columns:
Algorithm name
Key Generation time (ms)
Encapsulation time (ms)
Decapsulation time (ms)
Key Generations per second
Encapsulations per second
Decapsulations per second
This tool provides quality access for a quick and efficient way to compare the performance of various post-quantum algorithms, aiding in the selection and analysis of suitable algorithms for different applications.
