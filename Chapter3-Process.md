# Chapter 3: Process & Clean Phase

With my datasets now well organized and stored in the "`FitBit_Complete_Data`" folder and the "`Questionnaire_Data`" folder, the next step is to get a high-level overview of the data to assess its structure and completeness, and to clean the data when needed.
Let's start with the FitBit dataset in the first section below, as it was recommended by the BELLABEAT cofounder.
Then I will process and clean the Survey dataset in the second section.

## 1) FitBit Dataset
### 1.1) Selecting the most relevant files out of the 18 files

Very important point, let's remember what the business task is:
The BELLABEAT cofounder asked me "to analyze smart device usage data in order to gain insight into how consumers use non-Bellabeat smart
devices." She then wants me "to select one Bellabeat product to apply these insights to in your presentation."
The main questions are: What are some trends in smart device usage? How could these trends apply to Bellabeat customers? How could these trends help influence Bellabeat marketing strategy?"

Given that, the most relevant files for my business task would be the ones focused on daily habits and metrics like activity, heart rate, and sleep:

- '*combined_dailyActivity_merged.csv*': contains daily activity, including steps, distance, and calories burned, which directly relates to trends in physical activity.
- '*combined_heartrate_seconds_merged.csv*': will give me detailed heart rate data, useful for understanding user health trends and potential fitness habits.
- '*sleepDay_merged.csv*': contains sleep data, which can help reveal insights into user habits around rest and recovery.

Additional files (useful for deeper analysis, which I may do later on):

- '*combined_hourlyCalories_merged.csv*': Hourly calories burned can show more granular trends in activity throughout the day.
- '*combined_hourlySteps_merged.csv*': Hourly steps can also provide more detailed activity data.
- '*combined_minuteSleep_merged.csv*': If you want to analyze minute-level sleep patterns for more precise insights.
- '*combined_weightLogInfo_merged.csv*': Contains weight and BMI information, which could help connect physical activity with health trends.

### 1.2) Getting an overview of the data

I wrote an R script to get basic info (structure, column names, summary, NA counts) with functions like `summary()`, `colnames()`, `str()`, and `head()`.
I saved the information to a text file for easier inspection and future reference.

Sample Code:

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

### 1.3) Data cleaning and quality checks (nulls, duplicates, range validation)

The following R script focuses specifically on:
- Checking NAs
- Removing duplicates
- Identifying and handling outliers


Sample Code:
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

## 2) Survey Dataset

### 2.2) Getting an overview of the data

### 2.3) Data cleaning and quality checks (nulls, duplicates, range validation)


