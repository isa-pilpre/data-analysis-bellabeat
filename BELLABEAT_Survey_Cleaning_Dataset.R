install.packages("readxl")
install.packages("here")
library(readxl)
library(here)
library(dplyr)  # for glimpse()
library(tidyr)  # for drop_na()

# Goal: Clean and simplify dataset to make future analysis and plotting easier 
# Survey Excel file: "Anonymized_UserRelationshipWithTheirSmartDevice_Dataset.xlsx"

# Define the file path using here()
excel_file <- here("DATA", "Survey", "Survey_Data", "Anonymized_UserRelationshipWithTheirSmartDevice_Dataset.xlsx") 

# CONTEXT: Original file is structured the following way: 
# First row = Survey question codes, such as Q17, Q19 etc.
# Second row = Survey questions & statement in full text. Ex: "Let's start with you telling us something about yourself. Age:"
# Third row = Actual responses from survey participants (mostly numeric values matching to a pre-defined response)

# Read first row to get the variable codes
codes_df <- read_excel(excel_file, n_max = 1, col_names = FALSE)
codes_df <- as.character(codes_df[1, ])
str(codes_df)

# Check for duplicates
has_duplicates <- any(duplicated(codes_df)) 
print(paste("Are there duplicates?", has_duplicates))
# Returns TRUE -> Indeed there are code duplicates 

# Print which are the duplicates
print(codes_df[duplicated(codes_df)])
# Outout: "Q21" "Q19"

# Remove duplicates and create meaningful variable names
# Update Q21 codes
codes_df[indices_Q21[1]] <- "Q21_Intro"
codes_df[indices_Q21[2]] <- "Q21_EduType"

# Update Q19 codes
codes_df[indices_Q19[1]] <- "Q19_Sex"
codes_df[indices_Q19[2]] <- "Q19_Contact"

# Check for duplicates
any(duplicated(codes_df))  # Should return FALSE : OK no more duplicates

# Read second row to get the survey questions
questions_df <- read_excel(excel_file, skip = 1, n_max = 1, col_names = FALSE)
questions_df <- as.character(questions_df[1, ])
str(questions_df)

# Read survey data starting from third row (skip first two rows to keep only the respondents' answers)
survey_df <- read_excel(excel_file, skip = 2, col_names = FALSE)
# Make the updated codes as column names
colnames(survey_df) <- codes_df

str(survey_df)

# survey_df$SC0 # position 52
# Get the question text for 'SC0'
# sc0_question <- questions_df[52]
# print(sc0_question)  # Output: "Score"

# Identify columns to remove, that is:
# Q21_Intro = Intro
# Q19_Contact = "how can we reach you?""
# Q12 = "would you be available for half an hour interview?"
# Q11 = open question, very interesting, but for a first-round data analysis I will remove it for now 
# Q11 = "if (..) you want to further describe your relationship with your device, (...) write a couple of lines"
# SC0 = "Score" (only containing Nulls avec 1s)
cols_to_remove <- c("Q21_Intro", "Q19_Contact", "Q12", "Q11", "SC0")  

# Remove these not-relevant columns from data frame
cleaned_survey_df <- survey_df[ , !(colnames(survey_df) %in% cols_to_remove)]

# Check the cleaned dataset 
str(cleaned_survey_df)

# Create var called "cols_to_keep" to make my life easier below
cols_to_keep <- !(codes_df %in% cols_to_remove)

# Keep the code line and the question line updated
# Subset codes_df and questions_df
codes_df <- codes_df[cols_to_keep]
questions_df <- questions_df[cols_to_keep]

# Check column results
str(codes_df)                # 1 x 47 OK
str(questions_df)            # 1 x 47  OK


# Update column names with meaningful descriptions (ex Q17 becomes Q17_Age)
codes_df[codes_df == "Q17"] <- "Q17_Age"
codes_df[codes_df == "Q19"] <- "Q19_Sex"
codes_df[codes_df == "Q20"] <- "Q20_EduLevel"
codes_df[codes_df == "Q21"] <- "Q21_EduType"
codes_df[codes_df == "Q22"] <- "Q22_WorkExperience"
codes_df[codes_df == "Q32"] <- "Q32_CurrentSituation"
codes_df[codes_df == "Q29"] <- "Q29_Prof_Knowledge"
codes_df[codes_df == "Q30"] <- "Q30_Involvement"
codes_df[codes_df == "Q2023"] <- "Q2023_Country_Residence"
codes_df[codes_df == "Q2025"] <- "Q2025_Country_Origin"
codes_df[codes_df == "Q16"] <- "Q16_Device_Owned"
codes_df[codes_df == "Q2"] <- "Q2_Device_In_Mind"
codes_df[codes_df == "Q3"] <- "Q3_Feelings_Towards_Device"
codes_df[codes_df == "Q4"] <- "Q4_Feelings_Towards_Device"
codes_df[codes_df == "Q5"] <- "Q5_Feelings_Towards_Device"
codes_df[codes_df == "Q6"] <- "Q6_Feelings_Towards_Device"
codes_df[codes_df == "Q7"] <- "Q7_Feelings_Towards_Device"
codes_df[codes_df == "Q8"] <- "Q8_Feelings_Towards_Device"
codes_df[codes_df == "Q9"] <- "Q9_Feelings_Towards_Device"
codes_df[codes_df == "10"] <- "Q10_Feelings_Towards_Device"


# Assign the updated variable names as column names to survey_df
colnames(cleaned_survey_df) <- codes_df

# Check column results
str(cleaned_survey_df)

# Keep the question full text in a separate data frame, with survey code mapping
full_text_question_df <- data.frame(
  VariableName = codes_df,
  QuestionFullText = questions_df,
  stringsAsFactors = FALSE #  Keeps text as character strings (do not automatically convert into factors)
)

# Define the file path using here()
file_path <- here("DATA", "Survey", "Cleaned_Survey", "Survey_full_text_questions.csv")

# Save the CSV file containing the full text of the survey questions
write.csv(full_text_question_df, file = file_path, row.names = FALSE)


# Gender data is important for Bellabeat (company focused on women)
# So make sure we keep only participants with complete sex data 
complete_gender <- !is.na(cleaned_survey_df$Q19_Sex)
cleaned_gender_survey_df <- cleaned_survey_df[complete_gender, ]

# Check the number of observations before and after
total_observations <- nrow(cleaned_survey_df)
complete_observations <- nrow(cleaned_gender_survey_df)

cat("Total observations:", total_observations, "\n")
cat("Observations with complete gender data:", complete_observations, "\n")

# OK, not many rows lost (from 809 to 786), so keep that df as the main cleaned_survey_df
cleaned_survey_df <- cleaned_gender_survey_df

# Assigning meaningful names to Q3 thru Q10 columns
codes_df[codes_df == "Q3_1"] <- "Q3_Positive_About_Device"
codes_df[codes_df == "Q3_2"] <- "Q3_Feel_Victimized"
codes_df[codes_df == "Q3_3"] <- "Q3_Device_Runs_Independently"
codes_df[codes_df == "Q3_4"] <- "Q3_Device_Cannot_Initiate_Actions"
codes_df[codes_df == "Q3_5"] <- "Q3_Me_The_User_In_Control"
codes_df[codes_df == "Q3_6"] <- "Q3_Device_Forces_Process_On_Me"
codes_df[codes_df == "Q3_7"] <- "Q3_Device_Cannot_Change_Task"
codes_df[codes_df == "Q3_8"] <- "Q3_Device_Has_Own_Intelligence"

codes_df[codes_df == "Q4_1"] <- "Q4_Understand_How_Device_Works"
codes_df[codes_df == "Q4_2"] <- "Q4_Not_Ideal_Use"
codes_df[codes_df == "Q4_3"] <- "Q4_Device_Active_Participant"
codes_df[codes_df == "Q4_4"] <- "Q4_Device_Dependent_On_Me"
codes_df[codes_df == "Q4_5"] <- "Q4_Freely_Choose_Tasks"
codes_df[codes_df == "Q4_6"] <- "Q4_Cannot_Achieve_Things_I_Want"
codes_df[codes_df == "Q4_7"] <- "Q4_Device_Handles_Better_Certain_Things"
codes_df[codes_df == "Q4_8"] <- "Q4_Device_Not_Helpful"

codes_df[codes_df == "Q5_1"] <- "Q5_Enjoy_Device"
codes_df[codes_df == "Q5_2"] <- "Q5_Negative_Feelings_Towards_Device"
codes_df[codes_df == "Q5_3"] <- "Q5_Miss_Device"
codes_df[codes_df == "Q5_4"] <- "Q5_Device_Pleasurable"

codes_df[codes_df == "Q6_1"] <- "Q6_Device_Has_Own_Personality"
codes_df[codes_df == "Q6_2"] <- "Q6_Device_Supports_Like_Friend"
codes_df[codes_df == "Q6_3"] <- "Q6_Consider_Naming_Device"

codes_df[codes_df == "Q7_1"] <- "Q7_Device_Part_Of_Myself"
codes_df[codes_df == "Q7_2"] <- "Q7_Dont_Like_Others_Use_My_Device"
codes_df[codes_df == "Q7_3"] <- "Q7_Feel_Incomplete_Without_Device"

codes_df[codes_df == "Q8_1"] <- "Q8_Device_Useful_For_My_Goals"
codes_df[codes_df == "Q8_2"] <- "Q8_Device_Better_Than_NonSmart_Equivalent"
codes_df[codes_df == "Q8_3"] <- "Q8_Function_Aspect_Most_Important"

codes_df[codes_df == "Q9_1"] <- "Q9_Device_Important_Part_Lifestyle"
codes_df[codes_df == "Q9_2"] <- "Q9_Device_Helps_Me_Larger_Community"
codes_df[codes_df == "Q9_3"] <- "Q9_Device_Helps_Me_Social_Relations"

codes_df[codes_df == "Q10_1"] <- "Q10_Saves_Me_Time"
codes_df[codes_df == "Q10_2"] <- "Q10_Saves_Me_Money"
codes_df[codes_df == "Q10_3"] <- "Q10_Price_Most_Important_Factor"

# Trim whitespaces that I may have added when typing
codes_df <- trimws(codes_df)

# Assign the updated codes as column names to cleaned_survey_df
colnames(cleaned_survey_df) <- codes_df

# Check for duplicates to confirm
any(duplicated(codes_df))  # Should return FALSE

# Check df to make sure column names were updated
str(cleaned_survey_df)

# Dropping rows which contain Null values
# no_null_survey_df <- cleaned_survey_df %>% drop_na()
# nrow(cleaned_survey_df)
# nrow(no_null_survey_df)
# Output
# > nrow(cleaned_survey_df)
# [1] 786
# > nrow(no_null_survey_df)
# [1] 437
# So I will be losing almost half the rows! Deciding to keep all rows with Null values then

# Handling Likert scale responses to Questions 3 thru 10 included
# Create a vector of Likert scale variable names
likert_variables <- c(
  
  "Q3_Positive_About_Device",
  "Q3_Feel_Victimized",
  "Q3_Device_Runs_Independently",
  "Q3_Device_Cannot_Initiate_Actions",
  "Q3_Me_The_User_In_Control",
  "Q3_Device_Forces_Process_On_Me",
  "Q3_Device_Cannot_Change_Task",
  "Q3_Device_Has_Own_Intelligence",
  
  "Q4_Understand_How_Device_Works",
  "Q4_Not_Ideal_Use",
  "Q4_Device_Active_Participant",
  "Q4_Device_Dependent_On_Me",
  "Q4_Freely_Choose_Tasks",
  "Q4_Cannot_Achieve_Things_I_Want",
  "Q4_Device_Handles_Better_Certain_Things",
  "Q4_Device_Not_Helpful",
  
  "Q5_Enjoy_Device",
  "Q5_Negative_Feelings_Towards_Device",
  "Q5_Miss_Device",
  "Q5_Device_Pleasurable",
  
  "Q6_Device_Has_Own_Personality",
  "Q6_Device_Supports_Like_Friend",
  "Q6_Consider_Naming_Device",
  
  "Q7_Device_Part_Of_Myself",
  "Q7_Dont_Like_Others_Use_My_Device",
  "Q7_Feel_Incomplete_Without_Device",
  
  "Q8_Device_Useful_For_My_Goals",
  "Q8_Device_Better_Than_NonSmart_Equivalent",
  "Q8_Function_Aspect_Most_Important",
  
  "Q9_Device_Important_Part_Lifestyle",
  "Q9_Device_Helps_Me_Larger_Community",
  "Q9_Device_Helps_Me_Social_Relations",
  
  "Q10_Saves_Me_Time",
  "Q10_Saves_Me_Money",
  "Q10_Price_Most_Important_Factor"
)

# Define Likert scale levels and labels
likert_levels <- 1:5
likert_labels <- c("Strongly Disagree", "Somewhat Disagree", "Neutral", "Somewhat Agree", "Strongly Agree")

# Loop through each Likert variable and convert to ordered factor
for (var in likert_variables) {
  cleaned_survey_df[[var]] <- factor(
    cleaned_survey_df[[var]],
    levels = likert_levels,
    labels = likert_labels,
    ordered = TRUE
  )
}

# Check the structure of one of the variables
str(cleaned_survey_df$Q3_Positive_About_Device) 

# View the levels of the factor
levels(cleaned_survey_df$Q3_Positive_About_Device) 

str(cleaned_survey_df)
glimpse(cleaned_survey_df)

# Now that my dataset is cleaner and well organized, I will save it to Cleaned_Survey folder
# Define the file path using here()
file_path <- here("DATA", "Survey", "Cleaned_Survey", "cleaned_survey.csv")

# Save the cleaned file as "cleaned_survey.csv"
write.csv(cleaned_survey_df, file = file_path, row.names = FALSE)
