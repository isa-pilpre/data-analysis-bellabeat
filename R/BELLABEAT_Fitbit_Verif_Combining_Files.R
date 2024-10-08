install.packages("readr")
install.packages("here")
library(readr)
library(here)

# Goal: Verify that the Fitbit file combination/concatenation went well
# By making sure that the combined nrows =  nrows1 + nrows2

# Directories
dir1 <- "Fitabase Data 3.12.16-4.11.16"
dir2 <- "Fitabase Data 4.12.16-5.12.16"
combined_dir <- "Fitbit_Complete_Data"

# Get the list of combined files (only those starting with "combined_")
combined_files <- list.files(combined_dir, pattern = "^combined.*csv$", full.names = TRUE)


# Loop through combined files and check row counts
for (file in combined_files) {
  basefile <- basename(file)
  
  # Remove "combined_" prefix to match files in dir1 and dir2
  basefile_no_combined <- sub("combined_", "", basefile)
  
  # Read files from both directories and the combined directory
  data_combined <- read.csv(file)
  data_dir1 <- read.csv(file.path(dir1, basefile_no_combined))
  data_dir2 <- read.csv(file.path(dir2, basefile_no_combined))
  
  # Get row counts
  count_combined <- nrow(data_combined)
  count_dir1 <- nrow(data_dir1)
  count_dir2 <- nrow(data_dir2)
  
  # Calculate the expected total 
  expected_total <- count_dir1 + count_dir2
  
  # Calculate the difference
  diff <- expected_total - count_combined
  
  if (diff != 0) {
    cat("ERROR in count!")
  }
  
  # Output results
  cat("File:", basefile, "\n")
  cat("Dir 1 Count:", count_dir1, "\n")
  cat("Dir 2 Count:", count_dir2, "\n")
  cat("Expected total: ", expected_total, "\n")
  cat("Combined Count:", count_combined, "\n")
  cat("Difference in count is", diff, "\n")
  cat("----------------------------\n")
}
