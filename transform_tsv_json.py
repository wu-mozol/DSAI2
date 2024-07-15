import csv
import json
from datetime import datetime

# output_file = "data/mastodon_data/truths.json" #Uncomment to run for Mastodon
output_file = "data/truth_social_data/truths.json" #Truth Social

# Open and read-in the input TSV file
# with open("data/mastodon_data/truths.tsv", "r") as tsv_file: #Uncomment to run for Mastodon
with open("data/truth_social_data/truths.tsv", "r") as tsv_file:
    reader = csv.DictReader(tsv_file, delimiter="\t", lineterminator="\n", quoting=csv.QUOTE_NONE)
    data = list(reader)

# Transform data
output_data = []
for row in data:
    try:
        created_at = datetime.strptime(row["timestamp"], "%Y-%m-%d %H:%M:%S").strftime("%Y-%m-%d %H:%M:%S")
    except ValueError:
        try:
            created_at = datetime.strptime(row["timestamp"], "%Y-%m-%d").strftime("%Y-%m-%d %H:%M:%S")
        except ValueError:
            continue

    toot = {
        "user_id": str(row["author"]),
        "toot_id": str(row["external_id"]),
        "content": row["text"],
        "created_at": created_at
    }
    output_data.append(toot)

# Write the JSON data
with open(output_file, "w") as json_file:
    json.dump(output_data, json_file, indent=2)

print(f"Output written to {output_file}")
