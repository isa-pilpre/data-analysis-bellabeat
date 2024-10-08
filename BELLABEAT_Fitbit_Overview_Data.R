# Load required packages
install.packages("tidyverse")
install.packages("readr")
install.packages("here")
library(tidyverse)
library(readr)
library(here)

# Goal: Get basic overview (tibble, structure, colnames, summary) for each 18 files from folder "Fitbit_Complete_Data"
# And write all this info into text file "Overview.txt"

# Folder path using 'here()'
folder <- here("Fitbit_Complete_Data")

# To know where I am
here::here()

# Get all CSV files from the Fitbit folder
all_files <- list.files(folder, pattern = "*.csv", full.names = TRUE)
# print(all_files)

# Path to save the Overview file
overview_file <- here("Overview.txt")

# Create recap overview text file (overwrites if it exists)
file.create(overview_file)

# Turn off scientific notation globally (especially for ID values)
options(scipen = 999)

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

