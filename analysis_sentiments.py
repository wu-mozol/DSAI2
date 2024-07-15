import json
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import mannwhitneyu, iqr

def load_data(file_path):
    """Load JSON"""
    with open(file_path, 'r') as file:
        return json.load(file)

def extract_sentiments_and_text(data, min_length=20):
    """Extract compound, extremeness of sentiments, and associated text"""
    results = []
    for entry in data:
        if 'sentiment' in entry and 'cleaned_text' in entry and len(entry['cleaned_text']) >= min_length:
            compound = entry['sentiment']['compound']
            extremeness = abs(entry['sentiment']['pos']) + abs(entry['sentiment']['neg'])
            text = entry['cleaned_text']
            results.append({'compound': compound, 'extremeness': extremeness, 'text': text})
    return results

def find_outliers(data, key):
    """Identify the top 3 outliers"""
    values = [entry[key] for entry in data]
    values_sorted = np.sort(values)
    Q1, Q3 = np.percentile(values_sorted, [25, 75])
    iqr_value = Q3 - Q1
    lower_bound = Q1 - 1.5 * iqr_value
    upper_bound = Q3 + 1.5 * iqr_value
    outliers = [entry for entry in data if entry[key] < lower_bound or entry[key] > upper_bound]
    outliers_sorted = sorted(outliers, key=lambda x: abs(x[key] - np.median(values)), reverse=True)
    return outliers_sorted[:3]  # Return the top 3 most extreme outliers

def print_outliers(outliers, description):
    """Print the top outliers (for each ds)"""
    print(f"Top 3 outliers for {description}:")
    for outlier in outliers:
        print(f"Sentiment: {outlier['compound']} Extremeness: {outlier['extremeness']}, Text: {outlier['text']}")

# Load data from both JSON files
data1 = load_data('data/mastodon_data/toots.json')
data2 = load_data('data/truth_social_data/toots.json')

# Extract compound sentiments, extremeness, and texts
results1 = extract_sentiments_and_text(data1)
results2 = extract_sentiments_and_text(data2)

# Find and print outliers for compound sentiments
outliers_compound1 = find_outliers(results1, 'compound')
outliers_compound2 = find_outliers(results2, 'compound')
print_outliers(outliers_compound1, "Compound Sentiments - Mastodon")
print_outliers(outliers_compound2, "Compound Sentiments - Truth Social")

# Find and print outliers for sentiment extremeness
outliers_extremeness1 = find_outliers(results1, 'extremeness')
outliers_extremeness2 = find_outliers(results2, 'extremeness')
print_outliers(outliers_extremeness1, "Sentiment Extremeness - Mastodon")
print_outliers(outliers_extremeness2, "Sentiment Extremeness - Truth Social")
