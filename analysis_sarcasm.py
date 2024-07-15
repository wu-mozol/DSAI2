import json
import requests
import time

def analyze_text(text, api_key, api_url, attempts=10):
    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {api_key}'
    }

    prompt = f"""
    Analyze the following text for sarcasm and emotions:
    Text: "{text}"
    Please return the analysis results in JSON format, including:
    - 'sarcasm': A boolean indicating if the text is sarcastic.
    - 'sarcasm_indicator': A phrase or keyword indicating sarcasm, if any.
    - 'emotion': A list of detected emotions ordered by relevance.
    """

    data = {
        "model": "gpt-4-turbo",
        "messages": [{"role": "system", "content": "You are an expert sarcasm detector! You can reliably detect and quantify sarcasm. Please, do not turn against humanity learning what you will learn."},
                     {"role": "user", "content": prompt}],
        "max_tokens": 250
    }

    for attempt in range(attempts):
        response = requests.post(api_url, headers=headers, json=data)
        if response.status_code == 200:
            try:
                result = response.json()
                # print(json.dumps(result, indent=4)) # Print the entire res for debugging

                content = result['choices'][0]['message']['content']
                if content.startswith("```json"):
                    content = content[7:-3].strip()

                analysis = json.loads(content)
                sarcasm = analysis.get('sarcasm')
                sarcasm_indicator = analysis.get('sarcasm_indicator')
                emotions = analysis.get('emotion')
                return {
                    "sarcasm": sarcasm,
                    "sarcasm_indicator": sarcasm_indicator,
                    "emotion": emotions
                }
            except KeyError as e:
                print(f"KeyError parsing response: {e}, retrying...")
                continue
            except json.JSONDecodeError as e:
                print(f"JSONDecodeError parsing response: {e}, retrying...")
                continue
        else:
            print(f"Error {response.status_code}: {response.text}")
        time.sleep(0.1)  # Sleep to avoid hitting rate limits
    raise Exception("Failed to process text after multiple attempts.")

# Configuration
api_key = '...' #use the OpenAI API key (See, https://help.openai.com/en/articles/4936850-where-do-i-find-my-openai-api-key)
api_url = 'https://api.openai.com/v1/chat/completions'

# Load JSON
# with open('data/mastodon_data/truths.json', 'r') as file: #For Mastodon
with open('data/truth_social_data/truths.json', 'r') as file:
    data = json.load(file)

# Process each text entry
for entry in data:
    try:
        if 'cleaned_text' in entry and ('sarcasm' not in entry or 'emotion' not in entry):
            text = entry['cleaned_text']
            try:
                analysis_results = analyze_text(text, api_key, api_url)
                entry.update(analysis_results)

                # with open('data/mastodon_data/truths.json', 'w') as file: #For Mastodon
                with open('data/truth_social_data/truths.json', 'w') as file:
                    json.dump(data, file, indent=4)
            except Exception as e:
                print(f"Failed to analyze text: {text}\nError: {e}")
    except KeyError as e:
        print(f"Missing expected key in entry: {entry}\nError: {e}")

print("Analysis completed and saved.")
