# Chapter 3: Process & Clean phase (Fitbit)

With the Fitbit dataset now organized and stored in the `Fitbit_Complete_Data` folder, the next step is to assess the data's structure, check for anomalies (nulls, duplicates, out-of-range values, outliers), and clean it when necessary.

## 1) Reminder of the business task

To stay aligned with the business task, I need to address the following key questions:
   
- What are some trends in smart device usage?
- How could these trends apply to Bellabeat customers?
- How could these trends help influence Bellabeat marketing strategy?


## 2) Categorizing the 18 files

The Fitbit dataset contains the following 18 files:

combined_dailyActivity_merged.csv
combined_heartrate_seconds_merged.csv
combined_hourlyCalories_merged.csv
combined_hourlyIntensities_merged.csv
combined_hourlySteps_merged.csv
combined_minuteCaloriesNarrow_merged.csv
combined_minuteIntensitiesNarrow_merged.csv
combined_minuteMETsNarrow_merged.csv
combined_minuteSleep_merged.csv
combined_minuteStepsNarrow_merged.csv
combined_weightLogInfo_merged.csv
dailyCalories_merged.csv
dailyIntensities_merged.csv
dailySteps_merged.csv
minuteCaloriesWide_merged.csv
minuteIntensitiesWide_merged.csv
minuteStepsWide_merged.csv
sleepDay_merged.csv

To simplify the analysis, I have grouped the files into three broad categories:

### 2.1) Activity

Files related to daily and minute-level activity, such as steps, distance, and intensity.

Files:

combined_dailyActivity_merged.csv
combined_hourlyIntensities_merged.csv
combined_hourlySteps_merged.csv
combined_minuteIntensitiesNarrow_merged.csv
dailyIntensities_merged.csv
dailySteps_merged.csv
minuteIntensitiesWide_merged.csv
minuteStepsWide_merged.csv
combined_hourlyCalories_merged.csv
combined_minuteCaloriesNarrow_merged.csv
combined_minuteStepsNarrow_merged.csv
combined_weightLogInfo_merged.csv
dailyCalories_merged.csv
minuteCaloriesWide_merged.csv

### 2.2) Sleep

Files related to sleep duration and patterns.

Files:

combined_minuteSleep_merged.csv
sleepDay_merged.csv

### 2.3) Heart rate

Files related to heart rate tracking.

File:

combined_heartrate_seconds_merged.csv

    
## 3) Selection of the most relevant files

Based on the main categories (activity, heart rate, sleep), the most relevant files are as follows:

    combined_dailyActivity_merged.csv: daily activity (steps, distance, calories burned).
    combined_heartrate_seconds_merged.csv: heart rate data (fitness levels).
    sleepDay_merged.csv: sleep data (for recovery patterns).

Additional files for deeper analysis:

    combined_hourlyCalories_merged.csv: hourly calories burned (activity trends).
    combined_hourlySteps_merged.csv: hourly steps (detailed activity).
    combined_minuteSleep_merged.csv: minute-level sleep patterns (precise insights).
    combined_weightLogInfo_merged.csv: weight and BMI data (potential health trends).


## 4) Initial overview of the data

Before cleaning, I performed a basic overview of all the files to understand their structure. Here’s the R script I used to check the column names, data types, and summaries. 

Sample code:

```r
# Goal: Get basic info (structure, colnames, summary) for each file in "Fitbit_Complete_Data"
# And write all this info into text file "Recap.txt"

# Folder path using 'here()'
folder <- here("Fitbit_Complete_Data")

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




