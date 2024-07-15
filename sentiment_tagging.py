import json
from bs4 import BeautifulSoup
import nltk
from nltk.sentiment import SentimentIntensityAnalyzer

# Download the VADER lexicon
nltk.download('vader_lexicon')

def clean_html(content):
    """ Clean HTML tags and remove problematic Unicode characters. """
    soup = BeautifulSoup(content, "html.parser")
    text = soup.get_text()
    # Remove surrogate pairs / problematic Unicode
    try:
        text = text.encode('utf-8', errors='ignore').decode('utf-8')
        text = ''.join(char for char in text if ord(char) < 0x10000)
    except UnicodeDecodeError:
        print("Decoding issue encountered.")
    return text

def analyze_sentiment(text):
    """ Perform sentiment analysis using VADER. """
    sia = SentimentIntensityAnalyzer()
    return sia.polarity_scores(text)

# Load the JSON
#with open('data/mastodon_data/truths.json', 'r') as file: #Uncomment to run for Mastodon
with open('data/truth_social_data/truths.json', 'r') as file:
    data = json.load(file)

# Process each entry,
processed_data = []
for i, entry in enumerate(data):
    if i >= 10000: # Subset for the evaluation run (@Prof: for the full run, comment-out this if clause)
        break
    try:
        cleaned_text = clean_html(entry['content'])
        sentiment = analyze_sentiment(cleaned_text)
        entry['sentiment'] = sentiment
        entry['cleaned_text'] = cleaned_text
        processed_data.append(entry)
    except Exception as e:
        print(f"Error processing toot_id {entry['toot_id']}: {str(e)}")
        entry['error'] = "Error in processing content"
        processed_data.append(entry)

# Save the processed data with sentiment analysis into a new JSON file

#with open('data/mastodon_data/truths.json', 'w') as file: #Uncomment to run for Mastodon
with open('data/truth_social_data/truths.json', 'w') as file:
    json.dump(processed_data, file, indent=4)

print("Data processed and saved with sentiment analysis results. Check for errors.")
