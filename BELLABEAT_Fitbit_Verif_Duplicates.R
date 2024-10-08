install.packages("readr")
install.packages("here")
library(readr)
library(here)


# Goal: Verify if duplicates were correctly removed
# Compare the row counts before and after duplicate cleaning

# Define folders
combined_folder <- here("Fitbit_Complete_Data")
cleaned_folder <- here("Cleaned_Fitbit")

# List of files with detected duplicates
files_with_duplicates <- c(
  "combined_heartrate_seconds_merged.csv",
  "combined_hourlyCalories_merged.csv",
  "combined_hourlyIntensities_merged.csv",
  "combined_hourlySteps_merged.csv",
  "combined_minuteCaloriesNarrow_merged.csv",
  "combined_minuteIntensitiesNarrow_merged.csv",
  "combined_minuteMETsNarrow_merged.csv",
  "combined_minuteSleep_merged.csv",
  "combined_minuteStepsNarrow_merged.csv",
  "combined_weightLogInfo_merged.csv",
  "sleepDay_merged.csv"
)

# Corresponding number of duplicates for each file
duplicate_counts <- c(
  23424, 175, 175, 175, 10500, 10500, 10500, 4300, 10500, 2, 3
)

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

