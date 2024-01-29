import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

import argparse

parser = argparse.ArgumentParser(prog='normalization_and_visualization.py', formatter_class=argparse.RawDescriptionHelpFormatter,
                                     epilog=""" """)

parser.add_argument('-f', '--file', help='counts file', type=str, required=False)
parser.add_argument('-o', '--output', help='normalized counts output', type=str, required=True)
args = parser.parse_args()

def rpm_normalization(counts_df):
    # Calculate the total number of reads in each sample
    counts_df_noId = counts_df.drop(columns='miRNA')
    total_reads_per_sample = counts_df_noId.sum(axis=0)

    # Calculate the scaling factor (reads per million)
    scaling_factor = 1e6 / total_reads_per_sample

    # Normalize counts to RPM
    normalized_counts = counts_df_noId.divide(total_reads_per_sample) * scaling_factor

    return normalized_counts


def create_heatmap(dataframe):
    # Set 'miRNA' column as the index
    dataframe.set_index('miRNA', inplace=True)

    # Create a heatmap
    plt.figure(figsize=(10, 6))
    sns.heatmap(dataframe, cmap='viridis', annot=True, fmt=".2f", cbar_kws={'label': 'Normalized Counts'})
    plt.title('Heatmap of Normalized Counts')
    plt.xlabel('Samples')
    plt.ylabel('miRNA')
    plt.savefig(f'{args.output}/heatmap.png', bbox_inches='tight')
    plt.show()


if __name__ == "__main__":
    file_path = args.file

    # Read the count table into a DataFrame
    counts_df_raw = pd.read_csv(file_path, sep='\t')
    counts_df = counts_df_raw.iloc[:, [2] + list(range(12, counts_df_raw.shape[1]))]

    normalized_sample1 = rpm_normalization(counts_df.iloc[:, [0,1]])
    normalized_sample2 = rpm_normalization(counts_df.iloc[:, [0,2]])

    # Create a new DataFrame with the normalized values
    normalized_df =pd.concat([counts_df['miRNA'], normalized_sample1, normalized_sample2], axis=1)

    normalized_df.to_csv(f'{args.output}/normalized_counts.tsv', index=False)

    # Create and display heatmaps
    create_heatmap(normalized_df)
