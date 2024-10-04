install.packages("readxl")
install.packages("here")
library(readxl)
library(here)
library(dplyr) # Load dplyr for glimpse()

# Goal: Simplify dataset to make future analysis easier 
# Survey Excel file: "Anonymized_UserRelationshipWithTheirSmartDevice_Dataset.xlsx"

# Define the file path using here()
excel_file <- here("DATA", "Survey", "Survey_Data", "Anonymized_UserRelationshipWithTheirSmartDevice_Dataset.xlsx") 

# Read first row to get the variable codes
codes_df <- read_excel(excel_file, n_max = 1, col_names = FALSE)
codes_df <- as.character(codes_df[1, ])

# Create new variable names to remove duplicates
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

# Read survey data starting from third row (skip first two rows)
survey_df <- read_excel(excel_file, skip = 2, col_names = FALSE)
# updated codes as column names
colnames(survey_df) <- codes_df

str(survey_df)

# survey_df$SC0 # position 52
# Get the question text for 'SC0'
# sc0_question <- questions_df[52]
# print(sc0_question)  # Output: "Score"

# Identify columns to remove
# Q21_Intro = Intro
# Q19_Contact = "how can we reach you?""
# Q12 = "would you be available for half an hour interview?"
# Q11 = open question, very interesting, but for a first-round data analysis I will remove it for now 
# Q11 = "if (..) you want to further describe your relationship with your device, (...) write a couple of lines"
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

# Save the CSV file containing the full text of the survey questions
write.csv(full_text_question_df, file = file_path, row.names = FALSE)

  
# Identify participants with complete age and sex data
complete_demographics <- !is.na(survey_df$Q17_Age) & !is.na(survey_df$Q19_Sex)

# Create a subset of the data
survey_df_complete <- survey_df[complete_demographics, ]

# Check the number of observations before and after
total_observations <- nrow(survey_df)
complete_observations <- nrow(survey_df_complete)

cat("Total observations:", total_observations, "\n")
cat("Observations with complete demographics:", complete_observations, "\n")


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
variable_names <- trimws(variable_names)
colnames(survey_df_complete) <- variable_names

# Check df to make sure column names were updated
str(survey_df_complete)

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
# str(survey_df_complete$Q3_Positive_About_Device) -> OK

# View the levels of the factor
# levels(survey_df_complete$Q3_Positive_About_Device) -> OK

# Now that my dataset is cleaner and well organized, I will save it to Cleaned_Survey folder
# Define the file path using here()
file_path <- here("DATA", "Survey", "Cleaned_Survey", "cleaned_survey.csv")

# Save the cleaned file as "cleaned_survey.csv"
write.csv(survey_df_complete, file = file_path, row.names = FALSE)

