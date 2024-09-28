# Chapter 3: Process & Clean phase (Fitbit)

With my Fitbit dataset now well organized and stored in the "`Fitbit_Complete_Data`" folder, the next step is to get a high-level overview of the data to assess its structure and completeness, to check for anamolies (Nulls, duplicates, out-of-range date, outliers), and then to clean the data when needed.

## 1) Remembering my business task

Let's remember the main questions I need to answer:

1. What are some trends in smart device usage?
2. How could these trends apply to Bellabeat customers?
3. How could these trends help influence Bellabeat marketing strategy?Selecting the most relevant files out of the 18 files?

In the real world, I could ask questions to Bellabeat COO in order to clarify that they mean by "trends". Instead, since I cannot do that, I will have to rely on what I have at hands, that is the Fitbit dataset.

## 2) Breaking down the 18 files into wider categories

Given that the Fitbit dataset contains 18 .csv files, I need to break them down in smaller categories to make them more manageable for cleaning and future analysis. Incidentally, I notice that the filenames comply with the following syntax:

`text_text_text.csv`

Example: `dailyIntensities_merged.csv` or `combined_minuteIntensitiesNarrow_merged.csv`

To help me with creating categories, I come up with a step-by-step strategy:

- Extract the filenames and split them into individual words.
- Count the frequency of each word across the 18 filenames.
- Use the most frequent words to define categories and group similar files.

Indeed, the highest-count word will more likely be a category, which might qualify as a "trend" in my business task.

Here's the approach in R:

``` r
# Reading the filenames into R
filenames <- readLines("combined_files.txt")

# Split the filenames into individual words and remove the ".csv" extension
words <- unlist(strsplit(filenames, "[_.]"))

# Count the frequency of each word
word_count <- table(words)

# Sort the word count to see which words are most frequent
sorted_word_count <- sort(word_count, decreasing = TRUE)

# Display the top words
print(sorted_word_count)

```

## 3) Selecting the most relevant files

From these categories, the most relevant files for my business task would be the ones focused on daily habits and metrics like activity, heart rate, and sleep:

- '*combined_dailyActivity_merged.csv*': contains daily activity, including steps, distance, and calories burned, which directly relates to trends in physical activity.
- '*combined_heartrate_seconds_merged.csv*': will give me detailed heart rate data, useful for understanding user health trends and potential fitness habits.
- '*sleepDay_merged.csv*': contains sleep data, which can help reveal insights into user habits around rest and recovery.

Additional files (useful for deeper analysis, which I may do later on):

- '*combined_hourlyCalories_merged.csv*': Hourly calories burned can show more granular trends in activity throughout the day.
- '*combined_hourlySteps_merged.csv*': Hourly steps can also provide more detailed activity data.
- '*combined_minuteSleep_merged.csv*': If you want to analyze minute-level sleep patterns for more precise insights.
- '*combined_weightLogInfo_merged.csv*': Contains weight and BMI information, which could help connect physical activity with health trends.

## 4) Getting an overview of the data

I wrote an R script to get basic info (structure, column names, summary) with functions like `summary()`, `colnames()`, `str()`, and `head()`.
I saved the information to a text file for easier inspection.

Sample code:

```r
# Goal: Get basic info (structure, colnames, summary) for each file in "FitBit_Complete_Data"
# And write all this info into text file "Recap.txt"

# Folder path using 'here()'
folder <- here("FitBit_Complete_Data")

# Get all CSV files from the FitBit folder
all_files <- list.files(folder, pattern = "*.csv", full.names = TRUE)

# Path to save the summary file
recap_file <- here("Recap.txt")

# Create text file (overwrites if it exists)
file.create(recap_file)

# Turn off scientific notation globally (especially for ID values)
options(scipen = 999)

# Loop through all CSV files and save summaries to the recap file
for (file in all_files) {
  data <- read_csv(file)
  
  # Capture summary output
  summary_output <- capture.output({
    cat("File: ", basename(file), "\n")
    str(data)      # Prints structure of data, with column types
    cat("Column names: ", colnames(data), "\n")
    print(summary(data))
    cat("\n---------------------------------\n")
  })
  
  # Write summary to text file
  write(summary_output, recap_file, append = TRUE)
}

```

## 5) Data cleaning and quality checks (nulls, duplicates, range validation)

The following R script focuses specifically on:
- Checking NAs
- Removing duplicates
- Identifying and handling outliers


Sample code:
```r
# Goal: Check for NAs, duplicates, outliers

# Loop through all CSV files and clean data
for (file in all_files) {
  data <- read_csv(file)

  # Count missing (NA) values for each column
  na_count <- colSums(is.na(data))
  print(paste("Missing values in file", basename(file), ":"))
  print(na_count)

  # Check for duplicates based on relevant columns
  data <- data %>% distinct()  # Remove any duplicate rows
  
  # Add outlier detection here if necessary

  # Save the cleaned data or output cleaning info as needed
}

```

## 6) Double-checking and validation




