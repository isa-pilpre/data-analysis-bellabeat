# Chapter 3: Process & Clean Phase

## 1) Getting an overview of the data

With my datasets now well organized in the "FitBit_Complete_Data" folder and the "Questionnaire_Date" folder, the next step is to get a high-level overview of the data to assess its structure and completeness.

Steps:
- Generated a summary and a glimpse of each file with functions like summary(), colnames(), str(), glimpse() and head().
- Saved the information to a text file for easier inspection and future reference.

Sample Code:
```{}
# Capture file summaries
summary_file <- here("BELLABEAT", "Recap_summary.txt")
for (file in recap_files) {
  data <- read_csv(file)
  summary_info <- capture.output({
    cat("File:", basename(file), "\n")
    cat("Number of rows:", nrow(data), "\n")
    cat("Column names:", colnames(data), "\n")
    str(data)
    cat("\n---------------------------\n")
  })
  writeLines(summary_info, summary_file, append = TRUE)
}

```

## 2) Data Cleaning and Quality Checks (Nulls, Range Validation)

Steps:
- Checked for missing (null) values in each file and documented any nulls found.
- Verified that all numeric values fell within expected ranges for columns like TotalSteps, Calories, etc.
- Documented any outliers or potential issues that needed to be addressed in the cleaning phase.


Sample Code:
```{}
for (file in recap_files) {
  data <- read_csv(file)
  
  # Check for null values
  nulls <- sapply(data, function(x) sum(is.na(x)))
  cat("File:", basename(file), "- Null values per column:", nulls, "\n")
  
  # Check if numeric values are within a valid range (example for steps)
  if ("TotalSteps" %in% colnames(data)) {
    invalid_steps <- data %>% filter(TotalSteps < 0 | TotalSteps > 50000)
    cat("File:", basename(file), "- Invalid steps entries:", nrow(invalid_steps), "\n")
  }
}

```

## 3) Final Review Before Moving to the Analysis Phase

Once the data was cleaned and issues were documented, I reviewed the data structure and quality to ensure it was ready for analysis. This included reviewing the column names, data types, and potential issues with missing or invalid values.
