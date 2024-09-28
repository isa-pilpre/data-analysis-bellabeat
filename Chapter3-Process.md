# Chapter 3: Process & Clean phase (Fitbit)

With my Fitbit dataset now organized and stored in the "`Fitbit_Complete_Data`" folder, the next step is to get a high-level overview of the data to assess its structure and completeness, to check for anomalies (nulls, duplicates, out-of-range values, outliers), and then to clean the data when needed.

## 1) Reminder of the business task

Let's remember that I need to answer the following key questions:
   
- What are some trends in smart device usage?
- How could these trends apply to Bellabeat customers?
- How could these trends help influence Bellabeat marketing strategy?


## 2) Breaking down the 18 files into 3 main categories

To make the dataset more manageable, I categorized the 18 files into 3 categories:

- Activity: Includes daily and minute-level activity data like steps, distance, and intensity.
- Heart Rate: Tracks users' heart rate data, which provides insights into health and fitness levels.
- Sleep: Covers sleep duration and quality, essential for understanding user recovery and wellness.
    
    Given that the Fitbit dataset contains 18 .csv files, this number is not easily manageable to make sense of the data.
I need to put the files into categories to make them more manageable for cleaning and future analysis. Incidentally, I notice that the filenames comply with the following syntax (CamelCase and underscores):

`textTextText_text.csv`

Example: `dailyIntensities_merged.csv` or `combined_minuteIntensitiesNarrow_merged.csv`

To help me with creating categories, I come up with a step-by-step strategy:

- Extract the filenames and split them into individual words.
- Count the frequency of each word across the 18 filenames.
- Use the most frequent words to define categories and group similar files.

Indeed, the highest-count word will more likely be a category, which might qualify as a "trend" in my business task.

Here's my approach in R:

``` r
# Reading the filenames into R from the text file 'combined_files.txt'
filenames <- readLines("combined_files.txt")

# Function to split CamelCase (e.g., dailyActivity -> daily, Activity)
split_camel_case <- function(x) {
  # Split the string where a lowercase letter is followed by an uppercase letter
  # and also split on underscores and periods.
  # Explanation of the regex:
  # "(?<!^)" ensures that it does not split at the start of the string.
  # "(?=[A-Z])" matches the position right before an uppercase letter (used to split CamelCase).
  # "[_\\.]" splits on underscores (_) or periods (.) in the string.
  unlist(strsplit(x, "(?<!^)(?=[A-Z])|[_\\.]", perl=TRUE))
}

# lapply applies the 'split_camel_case' function to each element (filename) in the 'filenames' list
# It returns a list of the split words from each filename, which is then flattened into a single vector using unlist()
words <- unlist(lapply(filenames, split_camel_case))

# Remove unnecessary words like "csv", "merged", "combined", "wide", and "narrow" from the list
words <- words[!tolower(words) %in% c("csv", "merged", "combined", "wide", "narrow")]

# Count the frequency of each word and convert all to lowercase to avoid case-sensitive duplicates
word_count <- table(tolower(words))

# Sort the word count in descending order (most frequent words first)
sorted_word_count <- sort(word_count, decreasing = TRUE)

# Display the top words and their frequencies
print(sorted_word_count)

```

## 3) Selecting the most relevant files

The results from my R script show:

     minute    calories       daily intensities       steps      hourly       sleep 
          8           4           4           4           4           3           2 
   activity         day           e       files   heartrate        info         log 
          1           1           1           1           1           1           1 
          m     seconds          ts         txt      weight 
          1           1           1           1           1 
          

From these categories, the most relevant files for my business task are those related to daily activity, health/weight, heart rate, and sleep.  
Here's how I'll categorize them:

    Activity: 
        combined_dailyActivity_merged.csv
        dailySteps_merged.csv
        combined_hourlySteps_merged.csv

    Calories & Weight:
        combined_hourlyCalories_merged.csv
        combined_weightLogInfo_merged.csv

    Heart Rate: 
        combined_heartrate_seconds_merged.csv

    Sleep: 
        sleepDay_merged.csv
        combined_minuteSleep_merged.csv


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




