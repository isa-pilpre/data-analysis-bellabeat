# Chapter 3: Process Phase

## 1) Folder Organization

I noticed that many files had the same exact name in both Fitbit folder 1 and folder 2. When opening these "twin" files, I realized they have the same structure, except they have different dates.
So I will combine the twin files into a new folder called Recap. That reorganization will make the cleaning and analysis process much easier in the future.

### Objective: Combine twin files and check file integrity.
Steps:
- Moved all files to a single folder named "Recap".
- Verified that the files were correctly combined by counting the number of files in the folder and ensuring each file was processed without errors.
        
Example Code:
```{}
# Verify file count
recap_files <- list.files(here("BELLABEAT", "Recap"), full.names = TRUE)
length(recap_files)
```

## 2) File Concatenation

### Objective: Make sure the "twin" files were concatenated correctly.

Steps:
- Loop through the files in the "Recap" folder, check for twin files, and concatenate their content.
- Verified the number of rows in each combined file matched the total number of rows from the original twin files.

Example Code:
```{}
# Check the number of rows in each file
for (file in recap_files) {
  data <- read_csv(file)
  cat("File:", basename(file), "- Number of rows:", nrow(data), "\n")
}
```

## 3) Summarize and Save File Information

### Objective: Get an overview of the structure of each file, including column names, number of rows, and other useful details.

Steps:
- Generated a summary of each file using functions like summary(), colnames(), and str().
- Saved the information to a text file for easier inspection and future reference.

Example Code:
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
## 4) Data Quality Checks (Nulls, Range Validation):

### Objective: Check for null values and validate the data ranges (e.g., ensuring TotalSteps is within a realistic range).

Steps:
- Used R functions to detect missing values in each file and ensure numeric values fell within the expected ranges.
- Documented any issues and steps to clean or address the data.

Example Code:
```{}
for (file in recap_files) {
  data <- read_csv(file)
  nulls <- sapply(data, function(x) sum(is.na(x)))
  cat("File:", basename(file), "- Null values per column:", nulls, "\n")
}
```
