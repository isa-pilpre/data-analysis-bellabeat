install.packages("readr")
install.packages("here")
library(readr)
library(here)

# Goal: Combine files with the exact same filename ("twins") from FitBit folders 1 and 2
# And send combined files to new folder "FitBit_Complete_Data" (along with remaining single files) 

# Folder paths using 'here()'
folder1 <- here("BELLABEAT", "Fitabase_Data_3.12.16-4.11.16")
folder2 <- here("BELLABEAT", "Fitabase_Data_4.12.16-5.12.16")

# List files in each folder
files1 <- list.files(folder1, pattern = "*.csv", full.names = TRUE)
files2 <- list.files(folder2, pattern = "*.csv", full.names = TRUE)

#Making sure I got all the required files in both lists files1 and files2
length(files1)
length(files2)

# Creating a folder called "FitBit_Complete_Data" where I will write (all the combined files + the remaining single files)
if (!dir.exists(here("BELLABEAT", "FitBit_Complete_Data")))  {
  dir.create(here("BELLABEAT", "FitBit_Complete_Data"))
}

# Looping through files to look for matching filenames ("twins")
for (file in unique(c(basename(files1), basename(files2)))) {
  
  #If there are twin files in folders 1 and 2, concat files 
  if (file %in% basename(files1) & file %in% basename(files2)) {
    data1 <- read_csv(file.path(folder1, file))
    data2 <- read_csv(file.path(folder2, file))
    
    # Combine the data
    combined_data <- rbind(data1, data2)
    
    # Save the combined file in the folder "FitBit_Complete_Data"
    write_csv(combined_data, here("BELLABEAT", "FitBit_Complete_Data", paste0("combined_", file)))
    
  } else {
    # Copy non-matching files to the folder "FitBit_Complete_Data" as well
    if (file %in% basename(files1)) {
      file.copy(file.path(folder1, file), here("BELLABEAT", "FitBit_Complete_Data", file))
    } else {
      file.copy(file.path(folder2, file), here("BELLABEAT", "FitBit_Complete_Data", file))
    }
  }
}
