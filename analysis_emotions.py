import json
from collections import Counter
import matplotlib.pyplot as plt
from wordcloud import WordCloud, get_single_color_func

class GroupedColorFunc(object):
    """A color function object to assigns colors (based on the palette, see below)."""
    def __init__(self, color_to_words, default_color):
        self.color_to_words = color_to_words
        self.default_color = default_color

    def __call__(self, word, **kwargs):
        for color, words in self.color_to_words.items():
            if word in words:
                return color
        return self.default_color

# Load the JSON data
# with open('data/mastodon_data/toots.json', 'r') as file: #Uncomment for Mastodon
with open('data/truth_social_data/toots.json', 'r') as file:
    data = json.load(file)

# Extract emotions
emotions = []
for entry in data:
    if entry.get('emotion') is not None:
        emotions.extend(entry['emotion'])

# Determine color scheme based on user input or a condition
color_choice = input("Choose a color theme (red or blue): ").strip().lower()
color_scheme = {
    'red': '#ff0000',  #Shades of red (TS)
    'blue': '#0000ff'  #Shades of blue (Mastodon)
}
default_color = 'grey'

color_to_words = {color_scheme.get(color_choice, default_color): emotions}
def get_color_func(color_base):
    """Returns a color function that will emit lighter or darker shades of the given base color."""
    if color_base == 'red':
        base_color = [255, 0, 0]  # RGB for red (TS)
    elif color_base == 'blue':
        base_color = [0, 0, 255]  # RGB for blue (Mastodon)
    else:
        base_color = [150, 150, 150]  # Default grey (boring)

    def color_func(word, font_size, position, orientation, random_state=None, **kwargs):
        return "hsl({}, {}%, {}%)".format(
            base_color[0] if color_base == 'blue' else 0,  # Hue: blue or red
            random_state.randint(30, 70),  # Saturation
            random_state.randint(40, 90)  # Lightness
        )
    return color_func

# Load the JSON
with open('all_toots_anal_2.json', 'r') as file:
    data = json.load(file)

# Extract emotions
emotions = []
for entry in data:
    if entry.get('emotion') is not None:
        emotions.extend(entry['emotion'])

# Count the frequency
emotion_counts = Counter(emotions)

# Prompt for color choice
color_choice = input("Choose a color theme (red or blue): ").strip().lower()

# Generate a word cloud with a dynamic color function
wordcloud = WordCloud(
    width=1600,
    height=800,
    background_color='white',
    color_func=get_color_func(color_choice),
    random_state=42  # Ensures reproducibility :)
).generate(' '.join(emotions))

# Display the gen. cloud
plt.figure(figsize=(20, 10))
plt.imshow(wordcloud, interpolation='bilinear')
plt.axis('off')
plt.title('Most Common Emotions in ' + color_choice.capitalize() + ' Tones', fontsize=24)
plt.show()

total_posts = len(data)
emotion_percentage = {emotion: (count / total_posts) * 100 for emotion, count in top_emotions}

# A log-scaled bar chart:
plt.figure(figsize=(14, 8))
plt.bar(emotion_percentage.keys(), emotion_percentage.values(), color=get_color_func(color_choice))
plt.xlabel('Emotions')
plt.ylabel('Proportion of Posts (Log Scale)')
plt.title('Top 10 Emotions by Percentage of Posts (Log Scale)', fontsize=20)
plt.yscale('log')
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.show()

# A normal bar chart:
plt.figure(figsize=(14, 8))
plt.bar(emotion_percentage.keys(), emotion_percentage.values(), color=get_color_func(color_choice))
plt.xlabel('Emotions')
plt.ylabel('Proportion of Posts')
plt.title('Top 10 Emotions by Percentage of Posts', fontsize=20)
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
