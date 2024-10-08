install.packages("readxl")
install.packages("here")
library(readxl)
library(here)
library(dplyr) # Load dplyr for glimpse()

# Goal: Initial data overview 
# Survey Excel file: "Anonymized_UserRelationshipWithTheirSmartDevice_Dataset.xlsx"

# Define the file path using here()
excel_file <- here("DATA", "Survey", "Survey_Data", "Anonymized_UserRelationshipWithTheirSmartDevice_Dataset.xlsx") 

# 1 - Extract the first row that contains variable codes (e.g., Q21, Q17, etc.)
codes_df <- read_excel(excel_file, n_max = 1, col_names = FALSE)  # n_max = 1 reads only the first row

# Convert the first row to a character vector
codes_df <- as.character(codes_df[1, ])  # [1, ] means we select 1st (and only) line and all the columns  

# Display codes_df to make sure I got all the codes Q21, Q17, etc.
codes_df

# Identify duplicate codes
duplicate_codes <- codes_df[duplicated(codes_df)]
duplicate_codes  # Output: 2 duplicates, Q21 and Q19

# Find indices of duplicate codes
indices_Q21 <- which(codes_df == "Q21")
indices_Q19 <- which(codes_df == "Q19")

# Display the positions
indices_Q21  # Positions where "Q21" appears   # Output: positions 1 and 5
indices_Q19  # Positions where "Q19" appears   # Output: positions 3 and 51

# Examine questions
# For "Q21"
questions_df[indices_Q21]  # Output: 'Intro' (not a question) and 'Type of education'

# For "Q19"
questions_df[indices_Q19]  # Output: 'Sex' and '(Optional) How can we reach you?'

# Create new variable names to remove duplicates
# Update Q21 codes
codes_df[indices_Q21[1]] <- "Q21_Intro"
codes_df[indices_Q21[2]] <- "Q21_TypeEdu"

# Update Q19 codes
codes_df[indices_Q19[1]] <- "Q19_Sex"
codes_df[indices_Q19[2]] <- "Q19_Contact"

# Check for duplicates
any(duplicated(codes_df))  # Should return FALSE : OK no more duplicates


#  2 - Extract the second row that contains the survey questions
questions_df <- read_excel(excel_file, skip = 1, n_max = 1, col_names = FALSE)

# Convert the second row to a character vector
questions_df <- as.character(questions_df[1, ])

# Display the questions dataframe to verify
questions_df

# 3 - Read the survey data starting from the third row (skip the first two rows)
survey_df <- read_excel(excel_file, skip = 2, col_names = FALSE)

# Assign new codes_df as column names to survey_df
colnames(survey_df) <- codes_df

# Verify that the column names have been assigned correctly
colnames(survey_df)

# View the structure of survey_df
str(survey_df)