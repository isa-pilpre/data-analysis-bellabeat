# Chapter 3: Process phase (Reddit)

With the Reddit dataset stored in the `Reddit` folder, the next step is to assess the data's structure, check for anomalies, and clean it when necessary.

## 1) Reminder of the business task

To stay aligned with the business task, I need to remember the following key questions:
   
- What are some trends in smart device usage?
- How could these trends apply to Bellabeat customers?
- How could these trends help influence Bellabeat's marketing strategy?

## 2) Reminder of the 2 CSV files

The Reddit dataset contains the following 2 files:

| File                          | Description                                      |
|------------------------------|--------------------------------------------------|
| `Reddit_top_posts_smartwatch.csv`  | Most popular posts about smartwatches.           |
| `Reddit_new_posts_smartwatch.csv`  | Most recent posts about smartwatches.            |

These files store the data collected from Reddit using a Python scraping script.


## 3) Overview of the data

Before doing any cleaning, I performed a basic overview of both `.csv` files to assess their content.

Sample code:

```python
import pandas as pd

# Load the CSV files
top_posts = pd.read_csv('Reddit/Reddit_top_posts_smartwatch.csv')
new_posts = pd.read_csv('Reddit/Reddit_new_posts_smartwatch.csv')

# Display basic information about the top posts dataset
print("Top Posts Data Overview:")
print(top_posts.info())  # Shows column names, data types, and non-null counts
print(top_posts.head())  # Displays the first few rows of the dataset

# Display basic information about the new posts dataset
print("\nNew Posts Data Overview:")
print(new_posts.info())  # Shows column names, data types, and non-null counts
print(new_posts.head())  # Displays the first few rows of the dataset
```


**Data fields**: Both CSV files include the following columns:
  - `Title`: The title of the Reddit post.
  - `Score`: The number of upvotes minus downvotes.
  - `Sentiment`: The sentiment label (Positive, Neutral, Negative) based on the title.
  - `Polarity`: A numeric value indicating the sentiment polarity.
  - `URL`: The link to the post on Reddit.



## 4) Data cleaning

The following steps were taken to clean and prepare the data:

- **Remove duplicates**: Any duplicate posts (based on title and URL) were removed to avoid bias in the analysis.
- **Filter by relevance**: I made sure that all titles included the keyword "smartwatch" or related terminology.
- **Correct sentiment labels**: In some cases where the sentiment analysis was inaccurate (e.g., misclassified sarcasm), I manually reviewed and adjusted the sentiment labels.
- **Standardize formatting**: Polarity values were rounded to two decimal places for consistency.

## 5) Outcome

After cleaning, both CSV files were saved in the `Reddit` folder as:
- `Reddit_top_posts_smartwatch_cleaned.csv`
- `Reddit_new_posts_smartwatch_cleaned.csv`

These cleaned files are now ready for further analysis in the next phase.
