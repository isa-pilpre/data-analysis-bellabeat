# Chapter 3: Process & Clean phase (Fitbit)

With the Fitbit dataset now organized and stored in the `Fitbit_Complete_Data` folder, the next step is to assess the data's structure, check for anomalies (nulls, duplicates, out-of-range values, outliers), and clean it when necessary.

## 1) Reminder of the business task

To stay aligned with the business task, I need to remember the following key questions:
   
- What are some trends in smart device usage?
- How could these trends apply to Bellabeat customers?
- How could these trends help influence Bellabeat marketing strategy?


## 2) Reminder of the 18 files

The Fitbit dataset contains the following 18 files:

* `combined_dailyActivity_merged.csv`
* `combined_heartrate_seconds_merged.csv`
* `combined_hourlyCalories_merged.csv`
* `combined_hourlyIntensities_merged.csv`
* `combined_hourlySteps_merged.csv`
* `combined_minuteCaloriesNarrow_merged.csv`
* `combined_minuteIntensitiesNarrow_merged.csv`
* `combined_minuteMETsNarrow_merged.csv`
* `combined_minuteSleep_merged.csv`
* `combined_minuteStepsNarrow_merged.csv`
* `combined_weightLogInfo_merged.csv`
* `dailyCalories_merged.csv`
* `dailyIntensities_merged.csv`
* `dailySteps_merged.csv`
* `minuteCaloriesWide_merged.csv`
* `minuteIntensitiesWide_merged.csv`
* `minuteStepsWide_merged.csv`
* `sleepDay_merged.csv`


## 3) Overview of the data

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

### What I gathered after reviewing the [`Overview.txt` file](Overview.txt)

#### Potential trends

From the tibbles, structures, summaries and column names of the 18 files, several trends seem to emerge:

- Activity trends: insights into when users are most active (morning, afternoon, evening) based on the `ActivityDate` and `ActivityHour` columns.
- Intensity trends: insights into users' activity levels via the `VeryActiveMinutes`, `FairlyActiveMinutes`, and `LightlyActiveMinutes` columns.
- Sleep patterns: insights into sleep duration and habits via the `TotalMinutesAsleep` and `TotalTimeInBed` columns.
- Recovery patterns: insights into recovery patterns via the `Value` column in the heart rate file.

#### Most relevant files

- `combined_dailyActivity_merged.csv`: this file provides data on users' daily activities, with columns such as `TotalSteps`, `TotalDistance`, `VeryActiveDistance`, `SedentaryMinutes`, and `Calories`. Suited for analyzing activity and intensity trends. One limitation, however, is the missing units in some columns, such as distance (presumably km or miles) and calories (likely kcal), which will require further investigation.

- `sleepDay_merged.csv`: this file provides insight into users' sleep patterns, with columns such as `TotalMinutesAsleep` and `TotalTimeInBed`. Suited for analyzing sleep patterns and habits. I might also add a metric such as sleep efficiency (percentage of time spent asleep / time in bed).

- `combined_heartrate_seconds_merged.csv`: this file provides heart rate data at a second-by-second granularity throughout the day, with the `Value` column providing heartrate values. Suited for analyzing recovery patterns. Again, no unit is provided for `Value`, but we can assume it is measures in beats per minute, BPM. I might aggregate this data at a higher level (hourly or daily) for insights on recovery trends.
    

## 4) Data cleaning and quality checks

### Check for nulls and duplicates

For the data cleaning process, I started with:

- Checking for null values (NAs)
- Removing duplicates

Sample code:
```r
# Loop through all .csv files and check for nulls and duplicates
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
   
    cat("\n---------------------------------\n")
  })
  
  # Write summary to the cleaning results file
  write(summary_output, cleaning_results_file, append = TRUE)
}


```

### What I gathered after reviewing the [`Cleaning_Results.txt` file](Overview.txt)

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


The cleaned data (without duplicates) was saved in a new folder called `Cleaned_Fitbit`, while I kept the original dataset in the `Fitbit_Complete_Data` folder.

Sample code:
```r
# Save data without duplicates to 'Cleaned_Fitbit' folder
# Folder path for cleaned data
cleaned_folder <- here("Cleaned_Fitbit")

# Create the new folder for cleaned data (if it doesn't already exist)
if (!dir.exists(cleaned_folder)) {
  dir.create(cleaned_folder)
}

# Loop through all files to clean and save
for (file in all_files) {
  data <- read_csv(file)
  clean_data <- data %>% distinct()  # Remove duplicates
  
  # Save cleaned data to new folder
  write_csv(clean_data, file.path(cleaned_folder, basename(file)))
}
```

### Verifying that duplicates were correctly removed

After the removal of the duplicate, I needed to mo make sure that the data integrity was preserved, meaning no extra rows were removed or left behind. To verify this, I compared the row counts before and after duplicate removal for each file.

Sample code:
```r
# Compare row counts before and after duplicate removal
for (i in seq_along(files_with_duplicates)) {
  file <- files_with_duplicates[i]
  expected_removal <- duplicate_counts[i]
  
  # Read original and cleaned data
  combined_data <- read_csv(file.path(combined_folder, file))
  cleaned_data <- read_csv(file.path(cleaned_folder, file))
  
  # Get row counts
  combined_row_count <- nrow(combined_data)
  cleaned_row_count <- nrow(cleaned_data)
  
  # Calculate expected row count after duplicates removal
  expected_cleaned_count <- combined_row_count - expected_removal
  
  # Compare actual cleaned row count with expected
  diff <- cleaned_row_count - expected_cleaned_count
  
  # Output the results
  cat("File:", file, "\n")
  cat("Original Row Count:", combined_row_count, "\n")
  cat("Expected Row Count after duplicates removed:", expected_cleaned_count, "\n")
  cat("Actual Cleaned Row Count:", cleaned_row_count, "\n")
  if (diff == 0) {
    cat("✅ Cleaned row count matches the expected count.\n")
  } else {
    cat("❌ Mismatch: Difference of", diff, "rows.\n")
  }
  cat("----------------------------\n")
}

```


### Additional cleaning

#### Outliers 

Outliers are more complex to deal with programmatically, because it's not always clear if they are actual errors or legitimate values. For example, a very low heart rate could be a real data point for an athlete. Therefore, I decided not to remove outliers programmatically at this stage. I prefer to take a conservative approach and not risk deleting any valid data. I will further review or filter the data during the analysis phase if needed.

#### Data types

I might need to change or fix data types or do further filtering during the analysis or visualization phases, so the cleaning process may continue at that point if needed.

For now on, I will work on the data stored in the `Cleaned_Fitbit` folder.

