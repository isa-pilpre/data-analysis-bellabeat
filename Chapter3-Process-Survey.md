# Chapter 3: Process (Survey)

The survey dataset is stored in the `Survey_Data` folder.
It consists of one Excel file called `Anonymized_UserRelationshipWithTheirSmartDevice_Dataset.xlsx`.


## 1) Overview of the dataset

These are my first observations after I opened the Excel file in Google Sheets:

- Number of rows: 811
- Number of observations: 809
- Number of variables (columns): 52
- General description of variables: demographics info (age, sex, education), users' habits and attitudes towards their smart devices.

Furthermore, I found out that:

- The first row contains codes, in no specific order (Q21, Q17, Q19, Q20, Q21, Q22, Q32, Q29, etc.).
- There are duplicated codes. Ex. column Q19 as num for Sex (male= 1, female=2, other=3, prefer no to say=4) and column Q19 as chr for "How do we reach you" (answer most likely email address).
- The second row contains survey questions.
- The third row and below contain the actual answers to the survey (809 observations). 


Then I investigated the dataset with R.


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
codes_df

# Identify duplicate codes
duplicate_codes <- codes_df[duplicated(codes_df)]
duplicate_codes
```

Output:
``` r
> # Display codes_df to make sure I got all the codes Q21, Q17, etc.
> codes_df
 [1] "Q21"   "Q17"   "Q19"   "Q20"   "Q21"   "Q22"   "Q32"   "Q29"   "Q30"   "Q2023" "Q2025" "Q16"   "Q2"    "Q3_1"  "Q3_2"  "Q3_3"  "Q3_4" 
[18] "Q3_5"  "Q3_6"  "Q3_7"  "Q3_8"  "Q4_1"  "Q4_2"  "Q4_3"  "Q4_4"  "Q4_5"  "Q4_6"  "Q4_7"  "Q4_8"  "Q5_1"  "Q5_2"  "Q5_3"  "Q5_4"  "Q6_1" 
[35] "Q6_2"  "Q6_3"  "Q7_1"  "Q7_2"  "Q7_3"  "Q8_1"  "Q8_2"  "Q8_3"  "Q9_1"  "Q9_2"  "Q9_3"  "Q10_1" "Q10_2" "Q10_3" "Q11"   "Q12"   "Q19"  
[52] "SC0"

> # Identify duplicate codes
> duplicate_codes <- codes_df[duplicated(codes_df)]
> duplicate_codes
[1] "Q21" "Q19"
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
[3] "Sex"                                                                                                                                                   [4] "Level of education"                                                                                                                                    [5] "Type of education"                                                                                                                                     [6] "Working Experience" 
(...)
[51] "(Optional) If you answered yes, or you would like to receive the outcome of this study: how can we reach you?"                                        [52] "Score"
```

## 2) Handling duplicate survey codes

The data contained duplicate survey codes ("Q21" and "Q19"). To solve this, I updated the Q21 and Q19 codes by adding descriptive suffixes based on their survey questions:

- Q21 became Q21_Intro and Q21_EduType.
- Q19 became Q19_Sex and Q19_Contact.

Sample code:
``` r
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
codes_df[indices_Q21[2]] <- "Q21_EduType"

# Update Q19 codes
codes_df[indices_Q19[1]] <- "Q19_Sex"
codes_df[indices_Q19[2]] <- "Q19_Contact"

# Check for duplicates
any(duplicated(codes_df))  # Should return FALSE : OK no more duplicates

# Assign new codes_df as column names to survey_df
colnames(survey_df) <- codes_df

# Verify that the column names have been assigned correctly
colnames(survey_df)

# View the structure of survey_df
str(survey_df)
```

## 3) Simplifying and filtering the dataset

To make the dataset more readable and manageable:

- I removed unnecessary columns that were not relevant to the analysis (ex. introductory text and contact information).
- I combined the survey codes with brief descriptive names to create meaningful variable names (ex. Q17_Age, Q19_Sex).
- I removed the second row that contained the actual survey questions. Instead, I created a separate file (`full_text_question.csv`) that maps the survey codes to the full survey question text for easy reference.

 ``` r
# Identify columns to remove
# Q21_Intro = Intro
# Q19_Contact = "how can we reach you?""
# Q12 = "would you be available for half an hour interview?"
# Q11 = open question, very interesting, but for a first-round data analysis I will remove it for now 
# SC0 = "Score" (only containing Nulls avec 1s)
cols_to_remove <- c("Q21_Intro", "Q19_Contact", "Q12", "Q11", "SC0")

# Remove these not-relevant columns from data frame
survey_df <- survey_df[ , !(colnames(survey_df) %in% cols_to_remove)]

# Check column results
str(survey_df)

# Create var called "cols_to_keep" to make my life easier
cols_to_keep <- !(codes_df %in% cols_to_remove)

# Keep the code line and the question line updated
# Subset codes_df and questions_df
codes_df <- codes_df[cols_to_keep]
questions_df <- questions_df[cols_to_keep]

# Check column results
str(codes_df)                # 1 x 47 OK
str(questions_df)            # 1 x 47  OK

# Create meaningful variable names such as Q17_Age, Q19_Sex
# Use the updated column names (stripped off the non-relevant columns)
variable_names <- colnames(survey_df)
str (variable_names)        # 1 x 47 OK

# Manually update variable_names with brief descriptions
variable_names[variable_names == "Q17"] <- "Q17_Age"
variable_names[variable_names == "Q19_Sex"] <- "Q19_Sex"
variable_names[variable_names == "Q20"] <- "Q20_EduLevel"
variable_names[variable_names == "Q21_EduType"] <- "Q21_EduType"
variable_names[variable_names == "Q22"] <- "Q22_WorkExperience"
variable_names[variable_names == "Q32"] <- "Q32_CurrentSituation"
variable_names[variable_names == "Q29"] <- "Q29_Prof_Knowledge"
variable_names[variable_names == "Q30"] <- "Q30_Involvement"
variable_names[variable_names == "Q2023"] <- "Q2023_Country_Residence"
variable_names[variable_names == "Q2025"] <- "Q2023_Country_Origin"
variable_names[variable_names == "Q16"] <- "Q16_Device_Owned"
variable_names[variable_names == "Q2"] <- "Q2_Device_In_Mind"
variable_names[variable_names == "Q3"] <- "Q3_Feelings_Towards_Device"
variable_names[variable_names == "Q4"] <- "Q4_Feelings_Towards_Device"
variable_names[variable_names == "Q5"] <- "Q5_Feelings_Towards_Device"
variable_names[variable_names == "Q6"] <- "Q6_Feelings_Towards_Device"
variable_names[variable_names == "Q7"] <- "Q7_Feelings_Towards_Device"
variable_names[variable_names == "Q8"] <- "Q8_Feelings_Towards_Device"
variable_names[variable_names == "Q9"] <- "Q9_Feelings_Towards_Device"
variable_names[variable_names == "10"] <- "Q10_Feelings_Towards_Device"

# Assign the updated variable names as column names to survey_df
colnames(survey_df) <- variable_names

# Check column results
str(survey_df)

# Keep the question full text in a separate data frame, with survey code mapping
full_text_question_df <- data.frame(
  VariableName = variable_names,
  QuestionFullText = questions_df,
  stringsAsFactors = FALSE #  Keeps text as character strings (do not automatically convert into factors)
)

# Define the file path using here()
file_path <- here("DATA", "Survey", "Cleaned_Survey", "full_text_questions.csv")

# Save the CSV file
write.csv(full_text_question_df, file = file_path, row.names = FALSE)


```

Output
```
> str(survey_df)
str(survey_df)
tibble [809 × 46] (S3: tbl_df/tbl/data.frame)
 $ Q17_Age                : num [1:809] NA 1 2 1 1 1 1 1 2 1 ...
 $ Q19_Sex                : num [1:809] NA 7 2 3 3 4 4 7 2 5 ...
 $ Q20_EduLevel           : num [1:809] NA 8 1 7 8 8 8 7 8 7 ...
 $ Q21_EduType            : num [1:809] NA 9 1 9 9 6 2 2 7 7 ...
 $ Q22_WorkExperience     : num [1:809] NA 1 2 1 1 2 1 1 1 1 ...
 $ Q32_CurrentSituation   : num [1:809] NA 2 1 1 1 1 2 1 2 1 ...
 $ Q29_Prof_Knowledge     : num [1:809] NA 2 1 2 2 2 2 2 2 2 ...
 $ Q30_Involvement        : num [1:809] NA 122 122 122 122 122 122 122 187 61 ...
 $ Q2023_Country_Residence: num [1:809] NA 122 122 122 122 122 138 122 187 187 ...
 $ Q2023_Country_Origin   : num [1:809] 7 8 1 7 8 1 3 4 8 8 ...
 $ Q16_Device_Owned       : chr [1:809] NA "Apple TV" "Apple Watch series 5" "Google home" ...
 $ Q2_Device_In_Mind      : num [1:809] 2 4 5 5 5 5 5 5 5 4 ...
 $ Q3_1                   : num [1:809] 3 1 4 4 2 1 1 1 1 5 ...
 $ Q3_2                   : num [1:809] 4 2 4 1 2 4 1 1 1 3 ...
 $ Q3_3                   : num [1:809] 3 4 1 2 5 5 1 5 4 1 ...
 $ Q3_4                   : num [1:809] 2 4 4 1 5 5 2 5 5 2 ...
 $ Q3_5                   : num [1:809] 3 2 4 2 4 1 1 5 2 4 ...
 $ Q3_6                   : num [1:809] 4 4 3 4 5 5 2 5 5 2 ...

```

## 4) Handling null values

Some users did not answer questions in the first part of the questionnaire, which were personal questions (sex, age, education etc.)
Keeping in mind my business task and remembering that Bellabeat is a company focused on women's wellness, I feel it is important that the survey data contains demographic information such as sex and age. If some users did not fill out this information, I choose to remove their data (for now) in order to stay focused on my busuness task.

Sample code
``` r
# Identify participants with complete age and sex data
complete_demographics <- !is.na(survey_df$Q17_Age) & !is.na(survey_df$Q19_Sex)

# Create a subset of the data
survey_df_complete <- survey_df[complete_demographics, ]

# Check the number of observations before and after
total_observations <- nrow(survey_df)
complete_observations <- nrow(survey_df_complete)

cat("Total observations:", total_observations, "\n")
cat("Observations with complete demographics:", complete_observations, "\n")

```

Output
``` r
> cat("Total observations:", total_observations, "\n")
Total observations: 809 
> cat("Observations with complete demographics:", complete_observations, "\n")
Observations with complete demographics: 786
```

So there were only (809 - 786) = 23 people that did not answer demographical information such as age and sex.
For now on I will work with the survey_df_complete dataset because I want to be able to get insights based on gender in the analysis phase.


## 5) Handling Likert-scale items

I have noticed that questions like Q3 have multiple sub-questions (i.e. Q3_1, Q3_2), each representing a statement rated on a Likert scale.
Participants rated their agreement from 1 (Strongly Disagree) to 5 (Strongly Agree).

### Assigning descriptive names

I assigned descriptive names to the sub-questions in order to make the dataset more understandable.

Sample code
```

# Assigning meaningful names to Q3 thru Q10 columns
variable_names[variable_names == "Q3_1"] <- "Q3_Positive_About_Device"
variable_names[variable_names == "Q3_2"] <- "Q3_Feel_Victimized"
variable_names[variable_names == "Q3_3"] <- "Q3_Device_Runs_Independently"
variable_names[variable_names == "Q3_4"] <- "Q3_Device_Cannot_Initiate_Actions"
variable_names[variable_names == "Q3_5"] <- "Q3_Me_The_User_In_Control"
variable_names[variable_names == "Q3_6"] <- "Q3_Device_Forces_Process_On_Me "
variable_names[variable_names == "Q3_7"] <- "Q3_Device_Cannot_Change_Task"
variable_names[variable_names == "Q3_8"] <- "Q3_Device_Has_Own_Intelligence"
variable_names[variable_names == "Q4_1"] <- "Q4_Understand_How_Device_Works"
variable_names[variable_names == "Q4_2"] <- "Q4_Not_Ideal_Use"
variable_names[variable_names == "Q4_3"] <- "Q4_Device_Active_Participant"
variable_names[variable_names == "Q4_4"] <- "Q4_Device_Dependent_On_Me"
variable_names[variable_names == "Q4_5"] <- "Q4_Freely_Choose_Tasks"
variable_names[variable_names == "Q4_6"] <- "Q4_Cannot_Achieve_Things_I_Want"
variable_names[variable_names == "Q4_7"] <- "Q4_Device_Handles_Better_Certain_Things"
variable_names[variable_names == "Q4_8"] <- "Q4_Device_Not_Helpful"
variable_names[variable_names == "Q5_1"] <- "Q5_Enjoy_Device"
variable_names[variable_names == "Q5_2"] <- "Q5_Negative_Feelings_Towards_Device"
variable_names[variable_names == "Q5_3"] <- "Q5_Miss_Device"
variable_names[variable_names == "Q5_4"] <- "Q5_Device_Pleasurable"
variable_names[variable_names == "Q6_1"] <- "Q6_Device_Has_Own_Personality"
variable_names[variable_names == "Q6_2"] <- "Q6_Device_Supports_Like_Friend"
variable_names[variable_names == "Q6_3"] <- "Q6_Consider_Naming_Device"
variable_names[variable_names == "Q7_1"] <- "Q7_Device_Part_Of_Myself"
variable_names[variable_names == "Q7_2"] <- "Q7_Dont_Like_Others_Use_My_Device"
variable_names[variable_names == "Q7_3"] <- "Q7_Feel_Incomplete_Without_Device"
variable_names[variable_names == "Q8_1"] <- "Q8_Device_Useful_For_My_Goals"
variable_names[variable_names == "Q8_2"] <- "Q8_Device_Better_Than_NonSmart_Equivalent"
variable_names[variable_names == "Q8_3"] <- "Q8_Function_Aspect_Most_Important"
variable_names[variable_names == "Q9_1"] <- "Q9_Device_Important_Part_Lifestyle"
variable_names[variable_names == "Q9_2"] <- "Q9_Device_Helps_Me_Larger_Community"
variable_names[variable_names == "Q9_3"] <- "Q9_Device_Helps_Me_Social_Relations"
variable_names[variable_names == "Q10_1"] <- "Q10_Saves_Me_Time"
variable_names[variable_names == "Q10_2"] <- "Q10_Saves_Me_Money"
variable_names[variable_names == "Q10_3"] <- "Q10_Price_Most_Important_Factor"


# Update the column names in the data frame
colnames(survey_df_complete) <- variable_names

# Check df to make sure column names were updated
str(survey_df_complete)

```

### Converting Likert-scale responses to ordered factors

I made sure the responses were treated as ordinal data.

Sample code
``` r
# Handling Likert scale dor Questions 3 thru 10 included
# Create a vector of Likert scale variable names
likert_variables <- c(
  # Q3 variables
  "Q3_Positive_About_Device",
  "Q3_Feel_Victimized",
  "Q3_Device_Runs_Independently",
  "Q3_Device_Cannot_Initiate_Actions",
  "Q3_Me_The_User_In_Control",
  "Q3_Device_Forces_Process_On_Me",
  "Q3_Device_Cannot_Change_Task",
  "Q3_Device_Has_Own_Intelligence",
  
  # Q4 variables
  "Q4_Understand_How_Device_Works",
  "Q4_Not_Ideal_Use",
  "Q4_Device_Active_Participant",
  "Q4_Device_Dependent_On_Me",
  "Q4_Freely_Choose_Tasks",
  "Q4_Cannot_Achieve_Things_I_Want",
  "Q4_Device_Handles_Better_Certain_Things",
  "Q4_Device_Not_Helpful",
  
  # Q5 variables
  "Q5_Enjoy_Device",
  "Q5_Negative_Feelings_Towards_Device",
  "Q5_Miss_Device",
  "Q5_Device_Pleasurable",
  
  # Q6 variables
  "Q6_Device_Has_Own_Personality",
  "Q6_Device_Supports_Like_Friend",
  "Q6_Consider_Naming_Device",
  
  # Q7 variables
  "Q7_Device_Part_Of_Myself",
  "Q7_Dont_Like_Others_Use_My_Device",
  "Q7_Feel_Incomplete_Without_Device",
  
  # Q8 variables
  "Q8_Device_Useful_For_My_Goals",
  "Q8_Device_Better_Than_NonSmart_Equivalent",
  "Q8_Function_Aspect_Most_Important",
  
  # Q9 variables
  "Q9_Device_Important_Part_Lifestyle",
  "Q9_Device_Helps_Me_Larger_Community",
  "Q9_Device_Helps_Me_Social_Relations",
  
  # Q10 variables
  "Q10_Saves_Me_Time",
  "Q10_Saves_Me_Money",
  "Q10_Price_Most_Important_Factor"
)

# Define Likert scale levels and labels
likert_levels <- 1:5
likert_labels <- c("Strongly Disagree", "Somewhat Disagree", "Neutral", "Somewhat Agree", "Strongly Agree")

# Loop through each Likert variable and convert to ordered factor
for (var in likert_variables) {
  survey_df_complete[[var]] <- factor(
    survey_df_complete[[var]],
    levels = likert_levels,
    labels = likert_labels,
    ordered = TRUE
  )
}

# Check the structure of one of the variables
str(survey_df_complete$Q3_Positive_About_Device)

# View the levels of the factor
levels(survey_df_complete$Q3_Positive_About_Device)
```

Output
``` r
# Check the structure of one of the variables
> str(survey_df_complete$Q3_Positive_About_Device)
 Ord.factor w/ 5 levels "Strongly Disagree"<..: 4 5 5 5 5 5 5 5 4 4 ...
> # View the levels of the factor
> levels(survey_df_complete$Q3_Positive_About_Device)
[1] "Strongly Disagree" "Somewhat Disagree" "Neutral"  "Somewhat Agree" "Strongly Agree"
```

Now that my survey dataset is cleaned, filtered and organized in the `Cleaned_Survey` folder, it is ready for analysis.
