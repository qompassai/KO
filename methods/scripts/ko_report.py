import polars as pl
import requests
from bs4 import BeautifulSoup

# Read the CSV file from the specified location
df = pl.read_csv('/home/phaedrus/Forge/GH/K.O./results/x86_64_archlinux_results/pq_stress_results.csv')

# Group by Algorithm and calculate mean performance under different loads
summary = df.group_by(['Algorithm', 'Load']).agg([
    pl.col('KeyGen(op/s)').mean(),
    pl.col('Encap/Sign(op/s)').mean(),
    pl.col('Decap/Verify(op/s)').mean()
]).sort(['Algorithm', 'Load'])

# Pivot the table to have loads as columns
summary_table = summary.pivot(
    index='Algorithm',
    columns='Load',
    values=['KeyGen(op/s)', 'Encap/Sign(op/s)', 'Decap/Verify(op/s)'],
    aggregate_function='first',
    sort_columns=True
)

# Flatten and rename columns to ensure uniqueness
summary_table.columns = [f'{col[1]}_{col[0]}' if col[1] else col[0] for col in summary_table.columns]

# Function to make column names unique
def make_unique(columns):
    seen = set()
    result = []
    for item in columns:
        counter = 1
        new_item = item
        while new_item in seen:
            new_item = f"{item}_{counter}"
            counter += 1
        seen.add(new_item)
        result.append(new_item)
    return result

summary_table.columns = make_unique(summary_table.columns)

# Function to get NIST security level and key sizes
def get_algorithm_info(algorithm):
    # This is a simplified example. You'd need to expand this with actual data sources.
    url = "https://csrc.nist.gov/projects/post-quantum-cryptography/round-3-submissions"
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')

    # This is a placeholder. You'd need to implement actual parsing logic.
    # For demonstration, we're returning dummy data
    return {
        'NIST Security Level': 'Level 1',
        'Public Key (bytes)': 1024,
        'Private Key (bytes)': 2048,
        'Ciphertext/Signature (bytes)': 512
    }

# Add columns for security levels and key sizes
for algorithm in summary_table['Algorithm']:
    info = get_algorithm_info(algorithm)
    new_columns = [
        pl.lit(info['NIST Security Level']).alias('NIST Security Level'),
        pl.lit(info['Public Key (bytes)']).alias('Public Key (bytes)'),
        pl.lit(info['Private Key (bytes)']).alias('Private Key (bytes)'),
        pl.lit(info['Ciphertext/Signature (bytes)']).alias('Ciphertext/Signature (bytes)')
    ]
    summary_table = summary_table.with_columns(new_columns)

# Save to CSV
summary_table.write_csv('pq_comparison_table.csv')

print(summary_table)
