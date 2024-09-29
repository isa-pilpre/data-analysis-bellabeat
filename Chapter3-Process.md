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

Based on the initial overview of the Fitbit dataset, here are my key observations:

#### Potential trends

From the file structures and column names, several trends could emerge:

- Activity trends: insights into when users are most active (morning, afternoon, evening) based on the `ActivityDate` and `ActivityHour` columns.
- Intensity trends: insights into users' activity levels via the `VeryActiveMinutes`, `FairlyActiveMinutes`, and `LightlyActiveMinutes` columns.
- Sleep patterns: insights into sleep duration and habits via the `TotalMinutesAsleep` and `TotalTimeInBed` columns.
- Recovery patterns: insights into recovery patterns via the `Value` column in the heart rate file.

#### Most relevant files

After reviewing the `Overview.txt` file, I identified the following as the most relevant files for my analysis:

- `combined_dailyActivity_merged.csv`: this file provides data on users' daily activities, with columns such as `TotalSteps`, `TotalDistance`, `VeryActiveDistance`, `SedentaryMinutes`, and `Calories`. This file seems to be suited for analyzing activity and intensity trends. One limitation, however, is the missing units in some columns, such as distance (presumably km or miles) and calories (likely kcal), which will require further investigation.

- `sleepDay_merged.csv`: this file provides insight into users' sleep patterns, with columns such as `TotalMinutesAsleep` and `TotalTimeInBed`. This file seems to be suited for analyzing sleep patterns and habits. We could also add a metric such as sleep efficiency (percentage of time spent asleep relative to time in bed).

- `combined_heartrate_seconds_merged.csv`: this file provides heart rate data at a second-by-second granularity throughout the day, with the `Value` column providing heartrate values. This file seems to be valuable for analyzing recovery patterns, although no explicit units are provided (we can assume it is measured in beats per minute, BPM). It might be useful to aggregate this data at a higher level (hourly or daily) for some insights on recovery trends.
    

## 4) Data cleaning and quality checks (nulls, duplicates, range validation)

For the data cleaning process, I will focus on three key checks:

- Checking for null values (NAs)
- Removing duplicates
- Identifying and handling outliers / abnormal values


Sample code:
```r
# Loop through all .csv files and check for nulls, duplicates & outliers
for (file in all_files) {
  data <- read_csv(file)
  
  # Capture summary output
  summary_output <- capture.output({
    
    cat("File: ", basename(file), "\n")
    
    # Check for NA values and print only if they exist
    na_count <- colSums(is.na(data))
    if (any(na_count > 0)) {
      cat("Null values detected in file", basename(file), ":\n")
      print(na_count[na_count > 0])  # Print columns where NA > 0
    }
    
    # Check for duplicates and print only if they exist
    duplicate_count <- nrow(data) - nrow(data %>% distinct())
    if (duplicate_count > 0) {
      cat("Duplicates detected in file", basename(file), ":", duplicate_count, "duplicates found\n")
    }
    
    # Check for outliers in numeric data using IQR and print only if outliers exist
    numeric_columns <- sapply(data, is.numeric)
    outliers_detected <- sapply(data[, numeric_columns], detect_outliers)
    outlier_count <- colSums(outliers_detected)
    if (any(outlier_count > 0)) {
      cat("Outliers detected in file", basename(file), ":\n")
      print(outlier_count[outlier_count > 0])  # Print columns where outliers were detected
    }
    
    cat("\n---------------------------------\n")
  })
  
  # Write summary to the cleaning results file
  write(summary_output, cleaning_results_file, append = TRUE)
}


```

### What I gathered from the [`Cleaning_Results.txt` file](Overview.txt)

#### Missing values (NA)

Null values were detected only in one file:

- File `combined_weightLogInfo_merged.csv`
Column `Fat`: 96 missing values detected.

#### Duplicates

Duplicates were detected in the following files:
- File:  combined_heartrate_seconds_merged.csv 
Duplicates detected in file combined_heartrate_seconds_merged.csv : 23424 duplicates found
- File:  combined_hourlyCalories_merged.csv 
Duplicates detected in file combined_hourlyCalories_merged.csv : 175 duplicates found
- File:  combined_hourlyIntensities_merged.csv 
Duplicates detected in file combined_hourlyIntensities_merged.csv : 175 duplicates found
- File:  combined_hourlySteps_merged.csv 
Duplicates detected in file combined_hourlySteps_merged.csv : 175 duplicates found
- File:  combined_minuteCaloriesNarrow_merged.csv 
Duplicates detected in file combined_minuteCaloriesNarrow_merged.csv : 10500 duplicates found
- File:  combined_minuteIntensitiesNarrow_merged.csv 
Duplicates detected in file combined_minuteIntensitiesNarrow_merged.csv : 10500 duplicates found
- File:  combined_minuteMETsNarrow_merged.csv 
Duplicates detected in file combined_minuteMETsNarrow_merged.csv : 10500 duplicates found
- File:  combined_minuteSleep_merged.csv 
Duplicates detected in file combined_minuteSleep_merged.csv : 4300 duplicates found
- File:  combined_minuteStepsNarrow_merged.csv 
Duplicates detected in file combined_minuteStepsNarrow_merged.csv : 10500 duplicates found
- File:  combined_weightLogInfo_merged.csv 
Duplicates detected in file combined_weightLogInfo_merged.csv : 2 duplicates found
- File:  sleepDay_merged.csv 
Duplicates detected in file sleepDay_merged.csv : 3 duplicates found

#### Outliers and abnormal values



