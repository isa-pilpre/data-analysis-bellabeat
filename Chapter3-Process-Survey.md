# Chapter 3: Process phase (Survey)

The survey dataset is stored in the `Survey_Data` folder.
It consists of one Excel file called `Anonymized_UserRelationshipWithTheirSmartDevice_Dataset.xlsx`.

## 1) Reminder of the business task

To stay aligned with the business task, I need to remember the following key questions:
   
- What are some trends in smart device usage?
- How could these trends apply to Bellabeat customers?
- How could these trends help influence Bellabeat marketing strategy?

## 2) Overview of the data

When opening the Excel file in Google Sheets, I found out that the first row consists of codes in no specific order (Q21, Q17, Q19, Q20, Q21, Q22, Q32, Q29, etc.) The second row contains the survey statements and questions.
The third row and above contain the actual answers to the survey. 

I investigated the dataset further with an R script:

```r
install.packages("readxl")
install.packages("here")
library(readxl)
library(here)

# Goal: Overview of the Survey Excel file ("Anonymized_UserRelationshipWithTheirSmartDevice_Dataset.xlsx")

here::here()

# Define the file path using here()
excel_file <- here("DATA", "Survey", "Survey_Data", "Anonymized_UserRelationshipWithTheirSmartDevice_Dataset.xlsx") 

# 1 - Dealing with the first row that contains codes such as Q21, Q17, etc.
# Read only the first row without treating it as column names
# n_max = 1 reads only the first row
# col_names = FALSE tells read_excel() not to treat the first row as column names
codes_df <- read_excel(excel_file, n_max = 1, col_names = FALSE) 

# dataframe codes_df contains 1 row and multiple columns
# Convert the first row to a character vector
# [1, ] meaning we select 1st line and all the columns
codes_df <- as.character(codes_df[1, ])   

# Display codes_df to make sure I got all the codes Q21, Q17, etc.
codes_df

```

Output:
``` r
 [1] "Q21"   "Q17"   "Q19"   "Q20"   "Q21"   "Q22"   "Q32"   "Q29"   "Q30"   "Q2023" "Q2025" "Q16"   "Q2"    "Q3_1"  "Q3_2"  "Q3_3"  "Q3_4" 
[18] "Q3_5"  "Q3_6"  "Q3_7"  "Q3_8"  "Q4_1"  "Q4_2"  "Q4_3"  "Q4_4"  "Q4_5"  "Q4_6"  "Q4_7"  "Q4_8"  "Q5_1"  "Q5_2"  "Q5_3"  "Q5_4"  "Q6_1" 
[35] "Q6_2"  "Q6_3"  "Q7_1"  "Q7_2"  "Q7_3"  "Q8_1"  "Q8_2"  "Q8_3"  "Q9_1"  "Q9_2"  "Q9_3"  "Q10_1" "Q10_2" "Q10_3" "Q11"   "Q12"   "Q19"  
[52] "SC0"
```

### Observation

