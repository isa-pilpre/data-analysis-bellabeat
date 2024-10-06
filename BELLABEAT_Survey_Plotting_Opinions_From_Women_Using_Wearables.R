# Load necessary libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)
library(readr)
library(here)
library(stringr)  # For string manipulation

# -------------------------------------------------------------------
# Goal:
# Compare survey responses of women who use wearables (smart watches/bracelets)
# to inform Bellabeat's product strategies.
# -------------------------------------------------------------------

# Load the cleaned survey data
csv_file <- here("DATA", "Survey", "Cleaned_Survey", "cleaned_survey.csv")
survey_df <- read_csv(csv_file)

# Trim whitespace from column names for consistency
colnames(survey_df) <- trimws(colnames(survey_df))

# Define Likert statements
likert_statements <- c(
  "Q3_Positive_About_Device", "Q3_Feel_Victimized",
  "Q3_Device_Runs_Independently", "Q3_Device_Cannot_Initiate_Actions",
  "Q3_Me_The_User_In_Control", "Q3_Device_Forces_Process_On_Me",
  "Q3_Device_Cannot_Change_Task", "Q3_Device_Has_Own_Intelligence",
  "Q4_Understand_How_Device_Works", "Q4_Not_Ideal_Use",
  "Q4_Device_Active_Participant", "Q4_Device_Dependent_On_Me",
  "Q4_Freely_Choose_Tasks", "Q4_Cannot_Achieve_Things_I_Want",
  "Q4_Device_Handles_Better_Certain_Things", "Q4_Device_Not_Helpful",
  "Q5_Enjoy_Device", "Q5_Negative_Feelings_Towards_Device",
  "Q5_Miss_Device", "Q5_Device_Pleasurable",
  "Q6_Device_Has_Own_Personality", "Q6_Device_Supports_Like_Friend",
  "Q6_Consider_Naming_Device", "Q7_Device_Part_Of_Myself",
  "Q7_Dont_Like_Others_Use_My_Device", "Q7_Feel_Incomplete_Without_Device",
  "Q8_Device_Useful_For_My_Goals", "Q8_Device_Better_Than_NonSmart_Equivalent",
  "Q8_Function_Aspect_Most_Important", "Q9_Device_Important_Part_Lifestyle",
  "Q9_Device_Helps_Me_Larger_Community", "Q9_Device_Helps_Me_Social_Relations",
  "Q10_Saves_Me_Time", "Q10_Saves_Me_Money", "Q10_Price_Most_Important_Factor"
)

# Define Q16 question and its options (assuming Q16_Device_Owned is numeric)
q16_question <- "Q16_Device_Owned"
q16_options <- c(
  "1" = "Smart watches/bracelets (e.g. Polar, FitBit)",
  "2" = "Household cleaning devices (e.g. robot vacuum cleaner)",
  "3" = "Other household devices (e.g. security system, thermostat, smart bulbs)",
  "4" = "Personal hygiene devices (e.g. toothbrush)",
  "5" = "Personal health devices (e.g. blood pressure monitor, scale)",
  "6" = "Entertainment devices (e.g. smart toys such as Lego Mindstorms)",
  "7" = "Personal assistant devices (e.g. Siri, Alexa)",
  "8" = "Smart TVs and videostreaming devices (e.g. Apple TV, Nvidia shield)",
  "9" = "Computers and smartphones if you do not own any other smart device"
)

# Convert Q16 responses to factors with meaningful labels
survey_df <- survey_df %>%
  mutate(
    Q16_Device_Owned = factor(
      Q16_Device_Owned,
      levels = as.character(1:9),  # Levels as characters since Q16_Device_Owned is numeric
      labels = q16_options,
      ordered = TRUE
    )
  )

# Filter to only women who use wearables (smart watches/bracelets)
filtered_df <- survey_df %>%
  filter(Q19_Sex == 2, Q16_Device_Owned == "Smart watches/bracelets (e.g. Polar, FitBit)")

# Convert Likert responses to ordered factors with defined levels
filtered_df <- filtered_df %>%
  mutate(across(all_of(likert_statements), ~ factor(.,
                                                   levels = c("Strongly Disagree", "Somewhat Disagree", "Neutral", "Somewhat Agree", "Strongly Agree"),
                                                   ordered = TRUE)))

# Check the structure to confirm changes
str(filtered_df)

# Transform the data to long format for easier analysis and plotting
female_long <- filtered_df %>%
  select(all_of(likert_statements)) %>%  # Select only the Likert statements columns
  pivot_longer(cols = everything(), names_to = "Question", values_to = "Response") %>%  # Reshape to long format
  drop_na(Response) %>%  # Remove rows with NA responses
  mutate(
    Question = str_remove(Question, "^Q\\d+_"),       # Remove Q#_ prefix
    Question = str_replace_all(Question, "_", " ")    # Replace underscores with spaces
  )

# Check the structure of the long-format data
str(female_long)

# Clean the 'Response' column by trimming whitespace and ensuring consistent casing
female_long <- female_long %>%
  mutate(
    Response = str_to_title(trimws(Response))  # Remove leading/trailing spaces and convert to Title Case
  )

# Aggregate Likert responses into three categories: Disagree, Neutral, Agree
female_long <- female_long %>%
  mutate(
    Response_Aggregated = case_when(
      Response %in% c("Strongly Disagree", "Somewhat Disagree") ~ "Disagree",
      Response == "Neutral" ~ "Neutral",
      Response %in% c("Somewhat Agree", "Strongly Agree") ~ "Agree"
    )
  )

# Set Response_Aggregated as a factor with desired order for plotting
female_long <- female_long %>%
  mutate(
    Response_Aggregated = factor(
      Response_Aggregated,
      levels = c("Disagree", "Neutral", "Agree"),
      ordered = TRUE
    )
  )

# Verify the aggregation
table(female_long$Response_Aggregated)

# Verify there are no NAs left in 'Response_Aggregated'
na_count <- sum(is.na(female_long$Response_Aggregated))
print(paste("Number of NAs after aggregation:", na_count))

# Proceed only if there are no NAs
if(na_count == 0){
  
    # Calculate counts and percentages for all aggregated responses per question
    summary_table <- female_long %>%
      group_by(Question, Response_Aggregated) %>%
      summarise(Count = n(), .groups = 'drop') %>%                      # Count occurrences
      group_by(Question) %>%                                           # Group by question to calculate percentages
      mutate(Percentage = Count / sum(Count) * 100) %>%               # Calculate percentage within each question
      ungroup()
  
  # Identify top 5 statements where women agree
  top_agree <- summary_table %>%
    filter(Response_Aggregated == "Agree") %>%                       # Filter for 'Agree'
    arrange(desc(Percentage)) %>%                                    # Arrange in descending order
    slice_head(n = 5)                                               # Select top 5
  
  # Identify top 5 statements where women disagree
  top_disagree <- summary_table %>%
    filter(Response_Aggregated == "Disagree") %>%                    # Filter for 'Disagree'
    arrange(desc(Percentage)) %>%                                   # Arrange in descending order
    slice_head(n = 5)                                               # Select top 5
  
  # Print the results
  print("Top 5 statements with highest 'Agree' percentages:")
  print(top_agree)
  
  print("Top 5 statements with highest 'Disagree' percentages:")
  print(top_disagree)
  
  # Define groups and their corresponding statements
  groups <- list(
    Q3 = c("Positive About Device", "Feel Victimized",
           "Device Runs Independently", "Device Cannot Initiate Actions",
           "Me The User In Control", "Device Forces Process On Me",
           "Device Cannot Change Task", "Device Has Own Intelligence"),
    Q4 = c("Understand How Device Works", "Not Ideal Use",
           "Device Active Participant", "Device Dependent On Me",
           "Freely Choose Tasks", "Cannot Achieve Things I Want",
           "Device Handles Better Certain Things", "Device Not Helpful"),
    Q5 = c("Enjoy Device", "Negative Feelings Towards Device",
           "Miss Device", "Device Pleasurable"),
    Q6_Q7 = c("Device Has Own Personality", "Device Supports Like Friend",
              "Consider Naming Device", "Device Part Of Myself",
              "Dont Like Others Use My Device", "Feel Incomplete Without Device"),
    Q8_Q9 = c("Device Useful For My Goals", "Device Better Than NonSmart Equivalent",
              "Function Aspect Most Important", "Device Important Part Lifestyle",
              "Device Helps Me Larger Community", "Device Helps Me Social Relations"),
    Q10 = c("Saves Me Time", "Saves Me Money", "Price Most Important Factor")
  )
  
  # Make sure the IMAGES directory exists; if not, create it
  images_dir <- here("IMAGES")
  if(!dir.exists(images_dir)){
    dir.create(images_dir)
    print(paste("Created directory:", images_dir))
  }
  
  # Function to create and save plots for each group
  create_and_save_plot <- function(group_name, questions){
    # Filter summary_table for the current group
    group_summary <- summary_table %>%
      filter(Question %in% questions)
    
    # Check if there is data to plot
    if(nrow(group_summary) == 0){
      print(paste("No data available for group", group_name))
      return(NULL)
    }
    
    # Create the plot with side-by-side bars for Response_Aggregated
    p <- ggplot(group_summary, aes(x = reorder(Question, -Percentage), y = Percentage, fill = Response_Aggregated)) +
      geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.7) + # Side-by-side bars
      scale_y_continuous(labels = percent_format(scale = 1), limits = c(0, 100)) + # Fixed y-axis from 0% to 100%
      scale_fill_manual(
        values = c("Disagree" = "#d73027", "Neutral" = "#fdae61", "Agree" = "#4575b4"),
        name = "Response",
        labels = c("Disagree", "Neutral", "Agree"),
        breaks = c("Disagree", "Neutral", "Agree") # Ensure the order in the legend
      ) +
      labs(
        title = paste("Group", group_name, "- Women Opinions on Smart Watches/Bracelets"),
        x = "Survey Question",
        y = "Percentage of Female Respondents"
      ) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "bottom",
        plot.title = element_text(hjust = 0.5)
      )
    
    # Define the file name with "Survey_Women_" prefix
    file_name <- paste0("Survey_Women_Smart_Watches_Opinions_Group_", group_name, ".png")
    
    # Define the full file path within the IMAGES folder
    file_path <- here("IMAGES", file_name)
    
    # Save the plot as a PNG file with a white background
    ggsave(filename = file_path, plot = p, width = 14, height = 8, dpi = 300, bg = "white")
    
    print(paste("Plot saved as", file_path))
  }
  
  # Iterate over each group and create/save plots
  for(group in names(groups)){
    create_and_save_plot(group, groups[[group]])
  }
  
} else {
  print("There are still NAs in the Response_Aggregated column. Please check the data for inconsistencies.")
}
