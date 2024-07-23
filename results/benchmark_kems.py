import subprocess
import csv
from prettytable import PrettyTable

def run_openssl_speed(algorithm):
    cmd = f"openssl speed -seconds 5 {algorithm}"
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.stdout

def parse_speed_output(output):
    lines = output.split('\n')
    for line in lines:
        if line.startswith(algorithm):
            parts = line.split()
            if len(parts) >= 7:
                return {
                    'keygen': float(parts[1]),
                    'encaps': float(parts[2]),
                    'decaps': float(parts[3]),
                    'keygens/s': float(parts[4]),
                    'encaps/s': float(parts[5]),
                    'decaps/s': float(parts[6])
                }
    return None

algorithms = [
    "RSA", "EC", "X25519", "X448",
    "frodo640aes", "frodo640shake", "frodo976aes", "frodo976shake", "frodo1344aes", "frodo1344shake",
    "kyber512", "kyber768", "kyber1024",
    "mlkem512", "mlkem768", "mlkem1024",
    "bikel1", "bikel3", "bikel5",
    "hqc128", "hqc192", "hqc256"
]

results = []

for algorithm in algorithms:
    print(f"Benchmarking {algorithm}...")
    output = run_openssl_speed(algorithm)
    result = parse_speed_output(output)
    if result:
        result['algorithm'] = algorithm
        results.append(result)
    else:
        print(f"Failed to benchmark {algorithm}")

# Create a pretty table
table = PrettyTable()
table.field_names = ["Algorithm", "Keygen (ms)", "Encaps (ms)", "Decaps (ms)", "Keygens/s", "Encaps/s", "Decaps/s"]
for result in results:
    table.add_row([
        result['algorithm'],
        f"{result['keygen']:.3f}",
        f"{result['encaps']:.3f}",
        f"{result['decaps']:.3f}",
        f"{result['keygens/s']:.1f}",
        f"{result['encaps/s']:.1f}",
        f"{result['decaps/s']:.1f}"
    ])

print(table)

# Save results to CSV
with open('kem_benchmark_results.csv', 'w', newline='') as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=table.field_names)
    writer.writeheader()
    writer.writerows(results)

print("Results saved to kem_benchmark_results.csv")

