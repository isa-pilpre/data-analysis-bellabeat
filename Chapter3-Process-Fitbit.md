# Chapter 3: Process phase (Fitbit)

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

Before doing any cleaning, I performed a basic overview of all the .csv files to understand their structure, column names, data types, etc. 

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

### Observation

#### Potential trends

Based on the structure and content of the files, several trends seemed to emerge:

-  Activity trends: when users are most active based on the `ActivityDate` and `ActivityHour` columns.
-  Intensity trends: insights into activity levels using `VeryActiveMinutes`, `FairlyActiveMinutes`, etc.
-  Seep patterns: using `TotalMinutesAsleep` and `TotalTimeInBed` columns.
-  Recovery patterns: based on the heart rate date (`Value` column in the heart rate file).

#### Time format issues

Many files contained date-time columns (i.e. `SleepDay`, `ActivityHour`) that needed to be converted into a format recognized by BigQuery (from MM/DD/YYYY HH:MM:SS AM/PM to YYYY-MM-DD HH:MM:SS).


## 4) Data cleaning

### Step 1: Fix date-time formats

Many files contained date-time columns in a format inadequate for SQL analysis. I used the lubridate package in R to convert these columns to a standard format (YYYY-MM-DD HH:MM:SS).

R code to fix time formatting:

``` R
library(readr)
library(dplyr)
library(lubridate)
library(here)

# Define folder path and list all files
folder <- here("Cleaned_Fitbit")
all_files <- list.files(folder, pattern = "*.csv", full.names = TRUE)

# Define columns needing date-time fixes
time_columns <- c("SleepDay", "ActivityHour")

# Loop through files and fix time formats
for (file in all_files) {
  data <- read_csv(file)
  
  for (col in time_columns) {
    if (col %in% colnames(data)) {
      data <- data %>%
        mutate(!!col := mdy_hms(!!sym(col)))  # Convert time format
    }
  }
  
  # Save cleaned data
  cleaned_file_name <- paste0("cleaned_", basename(file))
  write_csv(data, file.path(folder, cleaned_file_name))
}

```

### Step 2: Remove duplicates

Next, I removed any duplicate records from the data, because duplicates skew analysis results.

Sample code:
```r
# Loop through all files to remove duplicates
for (file in all_files) {
  data <- read_csv(file)
  clean_data <- data %>% distinct()  # Remove duplicates
  
  # Save the cleaned data
  cleaned_file_name <- paste0("cleaned_", basename(file))
  write_csv(clean_data, file.path("Cleaned_Fitbit", cleaned_file_name))
}

```

### Step 3: Null values

Null values were detected only in one file:

- File `combined_weightLogInfo_merged.csv`
Column `Fat`: 96 missing values detected.

I am alway wary to delete Null values, as they can be potentially valid, so I left them for the time being. I can always filter them later on.



### Additional cleaning

#### Outliers 

Outliers are more complex to deal with programmatically, because it's not always clear if they are actual errors or legitimate values. For example, a very high number of steps or a very low heart rate could be a real data point for an athlete. Therefore, I decided not to remove outliers programmatically at this stage. I prefer to take a conservative approach and not risk deleting any valid data. I will further review or filter the data during the analysis phase if needed.

#### Data types

I might need to change or fix data types or do further filtering during the analysis or visualization phases, so the cleaning process may continue at that point if needed.

For now on, I will work on the data stored in the `Cleaned_Fitbit` folder.

