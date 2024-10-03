# Chapter 3: Process phase (Survey)

The survey dataset is stored in the `Survey_Data` folder.
It consists of one Excel file called `Anonymized_UserRelationshipWithTheirSmartDevice_Dataset.xlsx`.

## 1) Reminder of the business task

To stay aligned with the business task, I need to remember the following key questions:
   
- What are some trends in smart device usage?
- How could these trends apply to Bellabeat customers?
- How could these trends help influence Bellabeat marketing strategy?

## 2) Date structure overview

- Number of rows: 811
- Number of observations: 809
- Number of variables (columns): 52
- General description of variables: demographics info (age, sex, education), users' habits and attitudes towards their smart devices.

When opening the Excel file in Google Sheets, I found out that:
- The first row contained codes, sometimes duplicated, in no specific order (Q21, Q17, Q19, Q20, Q21, Q22, Q32, Q29, etc.).
- The second row contained survey statements and questions.
- The third row and below contained the actual answers to the survey (809 observations). 

I investigated the dataset with an R script. 

### First row (survey codes)
R sample code:
```r
install.packages("readxl")
install.packages("here")
library(readxl)
library(here)

# Goal: Overview of the Survey Excel file ("Anonymized_UserRelationshipWithTheirSmartDevice_Dataset.xlsx")

here::here()

# Define the file path using here()
excel_file <- here("DATA", "Survey", "Survey_Data", "Anonymized_UserRelationshipWithTheirSmartDevice_Dataset.xlsx") 

# 1 - Extract the first row that contains variable codes (e.g., Q21, Q17, etc.)
codes_df <- read_excel(excel_file, n_max = 1, col_names = FALSE)  # n_max = 1 reads only the first row

# Convert the first row to a character vector
codes_df <- as.character(codes_df[1, ])  # [1, ] means we select 1st (and only) line and all the columns  

# Display codes_df to make sure I got all the codes Q21, Q17, etc.
# codes_df
```

Output:
``` r
 [1] "Q21"   "Q17"   "Q19"   "Q20"   "Q21"   "Q22"   "Q32"   "Q29"   "Q30"   "Q2023" "Q2025" "Q16"   "Q2"    "Q3_1"  "Q3_2"  "Q3_3"  "Q3_4" 
[18] "Q3_5"  "Q3_6"  "Q3_7"  "Q3_8"  "Q4_1"  "Q4_2"  "Q4_3"  "Q4_4"  "Q4_5"  "Q4_6"  "Q4_7"  "Q4_8"  "Q5_1"  "Q5_2"  "Q5_3"  "Q5_4"  "Q6_1" 
[35] "Q6_2"  "Q6_3"  "Q7_1"  "Q7_2"  "Q7_3"  "Q8_1"  "Q8_2"  "Q8_3"  "Q9_1"  "Q9_2"  "Q9_3"  "Q10_1" "Q10_2" "Q10_3" "Q11"   "Q12"   "Q19"  
[52] "SC0"
```

### Second row (survey questions)

Sample code:

```r
#  2 - Extract the second row that contains the survey questions
questions_df <- read_excel(excel_file, skip = 1, n_max = 1, col_names = FALSE)

# Convert the second row to a character vector
questions_df <- as.character(questions_df[1, ])

# Display the questions dataframe to verify
questions_df
```  

Output:
``` r
> questions_df
[1] "Thanks for your interest in taking this research survey (...) contact us at \r\n\r\nf.lelli@tilburguniversity.edu"
[2] "Let's start with you telling us something about yourself. Age:"
[3] "Sex"                                                                                                                                                          [4] "Level of education"                                                                                                                                           [5] "Type of education"                                                                                                                                            [6] "Working Experience" 
(...)
[51] "(Optional) If you answered yes, or you would like to receive the outcome of this study: how can we reach you?"                                               [52] "Score"
```

## 3) Data types and conversion

The responses to the survey actually start at Row 3.
Sample code:

```r
# 3 - Read the survey data starting from the third row (skip the first two rows)
survey_df <- read_excel(excel_file, skip = 2, col_names = FALSE)

# Assign codes_df as column names to survey_df
colnames(survey_df) <- codes_df

# Verify that the column names have been assigned correctly
colnames(survey_df)

# View the structure of survey_df
str(survey_df)
```

Output:
```
> str(survey_df)
tibble [809 × 52] (S3: tbl_df/tbl/data.frame)
 $ Q21  : num [1:809] 1 1 1 1 1 1 1 1 1 1 ...
 $ Q17  : num [1:809] NA 3 2 3 3 9 5 3 9 9 ...
 $ Q19  : num [1:809] NA 1 2 1 1 1 1 1 2 1 ...
 $ Q20  : num [1:809] NA 7 2 3 3 4 4 7 2 5 ...
 $ Q21  : num [1:809] NA 8 1 7 8 8 8 7 8 7 ...
 $ Q22  : num [1:809] NA 9 1 9 9 6 2 2 7 7 ...
 $ Q32  : num [1:809] NA 1 2 1 1 2 1 1 1 1 ...
 $ Q29  : num [1:809] NA 2 1 1 1 1 2 1 2 1 ...
 $ Q30  : num [1:809] NA 2 1 2 2 2 2 2 2 2 ...
 $ Q2023: num [1:809] NA 122 122 122 122 122 122 122 187 61 ...
(...)
```

What I gathered:

- Most of the variables are numeric ('num' in R), which makes sense given that the survey responses were coded numerically.
- Some variables are strings ('chr' in R), such as Q2 and Q11, because they contain text responses.
- Problem: some columns have the same name. For example, column Q19 as num for Sex (male= 1, female=2, other=3, prefer no to say=4) and column Q19 as chr for "How do we reach you" (answser most likely email address) that contains "<removed for privacy reason>."
