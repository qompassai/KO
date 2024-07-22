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

# Check for null values in the 'Load' column
print(summary['Load'].null_count())

# If there are null values, you might want to replace them
summary = summary.with_columns(pl.col('Load').fill_null('unknown'))

# Pivot the table to have loads as columns
summary_table = summary.pivot(
    index='Algorithm',
    columns='Load',
    values=['KeyGen(op/s)', 'Encap/Sign(op/s)', 'Decap/Verify(op/s)'],
    aggregate_function='first',
    maintain_order=True,
    sort_columns=True
)

# Flatten and rename columns to ensure uniqueness
summary_table.columns = [f'{col[0]}_{col[1]}' if isinstance(col, tuple) else col for col in summary_table.columns]

# Function to make column names unique and replace null with a placeholder
def make_unique(columns):
    seen = set()
    result = []
    for item in columns:
        if item is None or item == 'null':
            item = 'unknown'
        counter = 1
        new_item = item
        while new_item in seen:
            new_item = f"{item}_{counter}"
            counter += 1
        seen.add(new_item)
        result.append(new_item)
    return result

summary_table.columns = make_unique(summary_table.columns)

# ... rest of your code remains the same

# Save to CSV
summary_table.write_csv('pq_comparison_table.csv')

print(summary_table)
