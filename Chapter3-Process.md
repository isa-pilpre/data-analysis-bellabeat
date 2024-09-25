# Chapter 3: Process Phase

## 1) Transforming the data so I can work with it effectively

I noticed that many files had the same exact name in both Fitbit folder 1 and folder 2. When opening these "twin" files, I realized they have the same structure, except they have different dates.
So I combined the twin files into a new folder called Recap. That reorganization will make the cleaning and analysis process much easier in the future.

Steps:
- Created a new folder named "Recap".
- Looped through the files in the Fitbit folders 1 and 2, checked for twin files. If they existed, concatenated their content and saved the combined file to the Recap folder.
- Saved the remaining files to the Recap folder as well, in order to have the entire dataset in one folder.
- Checked if the process went well: verified if the number of rows in each combined file matched the total number of rows from the original twin files.
- Results: now my Fitbit dataset is stored in one single folder, "Recap", which contains 18 csv files.

Example Code:
```{}
# Check the number of rows in each file
for (file in recap_files) {
  data <- read_csv(file)
  cat("File:", basename(file), "- Number of rows:", nrow(data), "\n")
}
```

## 2) Getting an overview of the data

Steps:
- Generated a summary and a glimpse of each file with functions like summary(), colnames(), str(), glimpse() and head().
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

## 3) Data Cleaning and Quality Checks (Nulls, Range Validation)

Steps:
- Checked for missing values in each file.
- Verified if all numeric values fell within the expected ranges.
- Documented any issues and steps to clean or address the data.

Example Code:
```{}
for (file in recap_files) {
  data <- read_csv(file)
  nulls <- sapply(data, function(x) sum(is.na(x)))
  cat("File:", basename(file), "- Null values per column:", nulls, "\n")
}
```
