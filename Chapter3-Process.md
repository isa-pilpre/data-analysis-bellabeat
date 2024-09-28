# Chapter 3: Process & Clean phase (Fitbit)

With my Fitbit dataset now organized and stored in the `Fitbit_Complete_Data` folder, the next step is to get a high-level overview of the data, to check for anomalies (nulls, duplicates, out-of-range values, outliers), and then to clean the data when needed.

## 1) Reminder of the business task

Let's remember that I need to answer the following key questions:
   
- What are some trends in smart device usage?
- How could these trends apply to Bellabeat customers?
- How could these trends help influence Bellabeat marketing strategy?


## 2) Breaking down the 18 files into categories

So the 18 Fitbit files are the following:

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

To make the dataset more manageable, I categorized the 18 files into 3 categories:

- Activity: daily and minute-level activity data like steps, distance, intensity.
- Heart rate: users' heart rate data.
- Sleep: sleep duration.

Daily activity
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

Sleep
combined_minuteSleep_merged.csv
sleepDay_merged.csv

Heart rate
combined_heartrate_seconds_merged.csv

When addressing the business task, I will analyze the trends regarding activity, sleep and heart rate.

    
## 3) Selecting the most relevant files

Based on the three main categories (activity, heart rate, sleep), the following three files will be the core focus of my analysis:

    combined_dailyActivity_merged.csv: Daily activity (steps, calories burned, and distance).
    combined_heartrate_seconds_merged.csv: Heart rate data (fitness levels).
    sleepDay_merged.csv: Sleep data (user recovery and rest).

Additional files for deeper analysis:

    combined_hourlyCalories_merged.csv: Hourly calories burned (activity trends).
    combined_hourlySteps_merged.csv: Hourly steps (detailed activity).
    combined_minuteSleep_merged.csv: Minute-level sleep patterns (precise insights).
    combined_weightLogInfo_merged.csv: Weight and BMI data (potential health trends).


## 4) Overview of the data

I performed an overview of all the files to make sure I didn't miss anything important and to assess the general structure. 

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




