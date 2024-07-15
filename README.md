# Data Science and Artificial Intelligence II - Project of Team 13

The repository can be found at [this site](https://github.com/).

## Goal
The goal of this project is to create a comparative analysis between Truth Social and Mastodon.social. The project involves two main steps: data mining for Mastodon.social, followed by a comprehensive analysis of both platforms.

## Usage of notebooks
The following three notebooks have three differently labelled chunks:
- `mastodon_analysis comparison.Rmd`
- `mastodon_scrape.Rmd`
- `ts_analysis comparison.Rmd`

The chunk labels have the following meaning:
- **Run**
- **Read before run**: `reason` (Generation chunks, that don't need to be run again as the generated artifact has been stored)
- **Don't run**: `reason` (Either outdated or only required in case of hard reset)

## Contents
The repository is organized as follows:
- `data/`: Contains the data for the Truth Social dataset (source: [insert source link]) and continuous mining results from the Mastodon scrape notebook (source: [insert source link]).
- `functions/`: Includes helper functions used throughout the project.
  - `functions_scrape.R`: Script containing functions used in the Mastodon scraping process.
  - `functions_analysis.R`: Script containing functions used in the analysis comparison notebooks.
- `graph/`: Contains `.csv` edgelists of the datasets.
- `layouts/`: Holds layout files for visualizations and reports.
- `model_graphs/`: Contains stochastic graphs edgelists for faster data loading, as they are already processed and generated.
- `plots/`: Stores generated plots and visualizations.
- `.REnviron`: Environment variables for the project.
- `.gitignore`: Specifies files and directories to be ignored by git.
- `Project.Rproj`: R project file for the project.
- `mastodon_analysis comparison.Rmd`: RMarkdown file for the comparative analysis of Mastodon.social.
- `mastodon_scrape.Rmd`: RMarkdown file for the basic data mining process of Mastodon.social.
- `mastodon_scrape_toots.Rmd`:  RMarkdown file for additional fetching of Mastodon.social toots.
- `transform_tsv_json.py`:  Python script to transform the .tsv files containing toots into JSON.
- `sentiment_tagging.py`:  Python script to perform sentiment tagging.
- `ts_analysis comparison.Rmd`: RMarkdown file for the comparative analysis of Truth Social.
- `ts_analysis initial.Rmd` (unused): Initial RMarkdown file for Truth Social analysis.
- `ts_analysis initial.nb.html` (unused): HTML file generated from the initial Truth Social analysis notebook.
- `analysis_sentiments.py`:  Python script to perform basic analysis on sentiment tagging results.
- `analysis_sarcasm.py`:  Python script for exprimental LLM-supported emotion tagging and sarcasm analysis.
- `analysis_emotions.py`:  Python script to analyse emotional composition of tweets.

## Methodology
The project methodology is divided into two main phases:

1. **Data Mining**:
    - Collecting data from Mastodon.social using web scraping and API access.
    - Cleaning and preprocessing the data to ensure quality and consistency.
    - The scraping process is dependent on the `functions_scrape.R` script.
    - The scraping of articles

2. **Analysis**:
    - Performing exploratory data analysis (EDA) to understand the characteristics of the data.
    - Using statistical and machine learning techniques to draw comparisons between Truth Social and Mastodon.social.
    - Visualizing the findings through charts and graphs to highlight key insights.
    - The analysis/comparison notebooks assume the directory structure provided.

## Dependencies
To run the code and reproduce the results, the following R libraries are required:

- ggraph
- igraph
- dplyr
- rtoot
- lubridate
- tibble
- data.table
- usethis
- renv
- purrr

You can install the required R packages using install.packages():

```R
install.packages(c("ggraph", "igraph", "dplyr", "rtoot", "lubridate", "tibble", "data.table", "usethis", "renv", "purrr"))
```

To run the Python code, the following (standard) packages are required:

- csv
- bs4
- nltk
- numpy
- matplotlib
- scipy
- wordcloud
- requests

You can install the required Python libraries with pip:

```Console
pip install csv bs4 nltk numpy matplotlib scipy wordcloud requests
```
