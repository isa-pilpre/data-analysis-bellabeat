# Chapter 3: Process & Clean phase (Fitbit)

With the Fitbit dataset now organized and stored in the `Fitbit_Complete_Data` folder, the next step is to assess the data's structure, check for anomalies (nulls, duplicates, out-of-range values, outliers), and clean it when necessary.

## 1) Reminder of the business task

To stay aligned with the business task, I need to remember the following key questions:
   
- What are some trends in smart device usage?
- How could these trends apply to Bellabeat customers?
- How could these trends help influence Bellabeat marketing strategy?


## 2) Reminder of the 18 files

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


## 3) Initial overview of the data

Before cleaning, I performed a basic overview of all the .csv files to understand their structure, column names, data types, etc. 

Sample code of my [R script](BELLABEAT_Overview_Data):

```r
# Loop through all .csv files and save summaries to the overview file
for (file in all_files) {
  data <- read_csv(file)
 
  # Capture summary output
  summary_output <- capture.output({
   
    cat("File: ", basename(file), "\n")
    print((head(data)))                          # displays a tibble (first few lines & columns)
    print(str(data))                             # structure with data types
    cat("Column names: ", colnames(data), "\n")  # column names
    print(summary(data))                         # summary w/ min, max, mean, median & quartiles
    cat("\n---------------------------------\n")
  })
 
  # Write summary to the overview file
  write(summary_output, overview_file, append = TRUE)
}

```

### What I gathered from the [`Overview.txt` file](Overview.txt)

Based on the initial overview of the Fitbit dataset, here are my first impressions:

#### Potential trends

Based on the file structures and column names, I can hypothesize that key trends that will likely emerge might be:

- Activity trends: when users are most active (morning, afternoon, evening) based on the `ActivityDate` and `ActivityHour` columns.
- Intensity trends: through `VeryActiveMinutes`, `FairlyActiveMinutes`, and `LightlyActiveMinutes` columns.
- Sleep patterns: through `TotalMinutesAsleep` and `TotalTimeInBed` columns.
- Recovery patterns: through the `Value` column in the file dedicated to heart rates.

#### Most relevant files

After reviewing the `Overview.txt` file, I conclude that the most relevant files for my analysis are:

- `combined_dailyActivity_merged.csv`: this file provides a comprehensive overview of users' daily activities, with columns such as `TotalSteps`, `TotalDistance`, `VeryActiveDistance`, `SedentaryMinutes`, and `Calories`. This file will be great for addressing the activity and intensity trends. One limitation though: units are missing in some columns, such as distance (presumably kilometers or miles) and calories (presumably kilocalories). I will need to investigate this further.

- `sleepDay_merged.csv`: this file provides insight into users' sleep patterns, with columns such as `TotalMinutesAsleep` and `TotalTimeInBed`. This file will be great for addressing sleep patterns. We could also derive a metric such as sleep efficiency (i.e. percentage of time spent asleep while in bed) from this data.

- `combined_heartrate_seconds_merged.csv`: this file provides heart rate data at a second-by-second granularity throughout the day. The `Value` column represents the heart rate. This file will be great for addressing recovery patterns. Again, no units are provided but we can assume it is in beats per minute (BPM). It might be useful to aggregate this data to a higher level (i.e. hourly or daily) for recovery trend analysis.

    

## 4) Data cleaning and quality checks (nulls, duplicates, range validation)

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




