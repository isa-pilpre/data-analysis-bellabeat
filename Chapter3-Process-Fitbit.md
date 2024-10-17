# Chapter 3: Process (Fitbit)

With the Fitbit dataset now organized and stored in the `Fitbit_Complete_Data` folder, the next step is to assess the data's structure, check for issues and anomalies, and clean it when necessary.


## 1) Recap of the 18 files

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


## 2) Overview of the data

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

Based on the structure and content of the files, several trends seem to emerge:

-  Activity trends: when users are more or less active (based on the `ActivityDate` and `ActivityHour` columns, for instance) in terms of steps or distance.
-  Intensity trends: variations in activity levels (i.e. with the `VeryActiveMinutes`, `FairlyActiveMinutes` columns, etc.).
-  Sleep trends: sleep patterns with `TotalMinutesAsleep` and `TotalTimeInBed` columns.
-  Calories trends: calories spent seem to be recorded daily, hourly, and even by the minute.
-  Heart rate trends: the file `combined_heartrate_seconds_merged.csv` records heart rate (`Value` column) every 5 seconds.

#### Unit issues

Many columns do not specify the units used, such as `VeryActiveDistance`, `ModeratelyActiveDistance`, etc. Further research needs to ne done to see if these distances are in meters, km, miles, or another unit. The same issue applies to the `Calories` columns (is this in Joules or else) and the `Value` column in the heart rate data (though we can assume this is BMP.) In the real world, we would ask directly the stakeholders for clarification about these numerical values without units.

#### Date and Time formatting issues

I noticed also right away that there were issues with the date and time columns. For example, the `ActivityDate` column in `combined_dailyActivity_merged.csv` is of type `chr` formatted like: "3/25/2016" "3/26/2016" "3/27/2016" "3/28/2016". Similarly, the `Time` column in `combined_heartrate_seconds_merged.csv` is also of type `chr` with values such as "4/1/2016 7:54:00 AM" "4/1/2016 7:54:05 AM" "4/1/2016 7:54:10 AM" "4/1/2016 7:54:15 AM".

These columns need to be converted into a format recognized by R and by BigQuery (from MM/DD/YYYY HH:MM:SS AM/PM to YYYY-MM-DD HH:MM:SS).


#### Column name formatting issues
Most column names are in CamelCase, but I noticed that in `combined_minuteSleep_merged.csv` the column names were all in lowercase: `date`, `value`, `logId`. I will need to fix that in my cleaning process to make sure all the column names are consistently in CamelCase. 


## 3) Data cleaning


### Step 1: Standardize column names

Sample code:

```r 

# 1 - Read and standardize column names for `combined_minuteSleep_merged.csv` 
df_sleep <- read_csv(file.path(folder, "combined_minuteSleep_merged.csv"))
df_sleep <- df_sleep %>%
  rename(Date = date, Value = value, LogId = logId)  # Fix all column names

# Replace file in the folder 
write_csv(df_sleep, file.path(folder, "combined_minuteSleep_merged.csv"))

# Show dataframe to make sure new column names are OK
# df_sleep  => OK!

```


### Step 2: Fix Date and Time formatting issues

Sample code:

``` r

# 2- Fix date and time column format
time_columns <- c("SleepDay", "ActivityHour", "ActivityMinute", "Time", "Date")  # Time-related columns
date_columns <- c("ActivityDate")  # Date-only column

# Get all CSV files from the Fitbit Complete Data folder
all_files <- list.files(folder, pattern = "*.csv", full.names = TRUE)

# Loop through files and apply time format fixes (plus remove duplicates)
for (file in all_files) {
  df <- read_csv(file)
  
  # Fix date and time formats
  for (col in time_columns) {
    if (col %in% colnames(df)) {
      df[[col]] <- mdy_hms(df[[col]])  # Convert time format using mdy_hms()
    }
  }
  
  for (col in date_columns) {
    if (col %in% colnames(df)) {
      df[[col]] <- mdy(df[[col]])  # Convert date format using mdy()
    }
  }

```

### Step 3: Remove duplicates

Sample code:

```r

# 3 - Remove duplicates
  df <- df %>% distinct()  # Remove duplicates
  
  # Save the cleaned dataframe after all cleaning is done
  cleaned_file_name <- paste0("cleaned_", basename(file))
  write_csv(df, file.path(cleaned_folder, cleaned_file_name))
}

```

### Step 4: Null values

Null values were detected only in one file:

- File `combined_weightLogInfo_merged.csv`
Column `Fat`: 96 missing values detected.

I am alway wary to delete Null values, as they can be potentially valid, so I left them for the time being. I can always filter them later on.



### Step 5: Additional cleaning

#### Outliers 

Outliers are more complex to deal with programmatically, because it's not always clear if they are actual errors or legitimate values. For example, a very high number of steps or a very low heart rate could be a real data point for an athlete. Therefore, I decided not to remove outliers programmatically at this stage. I prefer to take a conservative approach and not risk deleting any valid data. I will further review or filter the data during the analysis phase if needed.

#### Data types

I might need to change or fix data types or do further filtering during the analysis or visualization phases, so the cleaning process may continue at that point if needed.

For now on, I will work on the data stored in the `Cleaned_Fitbit` folder.

