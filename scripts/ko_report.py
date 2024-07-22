import pandas as pd
import numpy as np
import requests
from bs4 import BeautifulSoup

# Read the CSV file
df = pd.read_csv('pq_stress_results.csv')

# Group by Algorithm and calculate mean performance under different loads
summary = df.groupby(['Algorithm', 'Load']).agg({
    'KeyGen(op/s)': 'mean',
    'Encap/Sign(op/s)': 'mean',
    'Decap/Verify(op/s)': 'mean'
}).reset_index()

# Pivot the table to have loads as columns
summary_table = summary.pivot(index='Algorithm', columns='Load', 
                              values=['KeyGen(op/s)', 'Encap/Sign(op/s)', 'Decap/Verify(op/s)'])

# Flatten column names
summary_table.columns = [f'{col[0]}_{col[1]}' for col in summary_table.columns]

# Reset index to make Algorithm a column
summary_table = summary_table.reset_index()

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
for index, row in summary_table.iterrows():
    info = get_algorithm_info(row['Algorithm'])
    summary_table.at[index, 'NIST Security Level'] = info['NIST Security Level']
    summary_table.at[index, 'Public Key (bytes)'] = info['Public Key (bytes)']
    summary_table.at[index, 'Private Key (bytes)'] = info['Private Key (bytes)']
    summary_table.at[index, 'Ciphertext/Signature (bytes)'] = info['Ciphertext/Signature (bytes)']

# Save to CSV
summary_table.to_csv('pq_comparison_table.csv', index=False)

print(summary_table)
