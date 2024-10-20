# Load necessary libraries
library(dplyr)   # for glimpse()
library(tidyr)   # for drop_na()
library(ggplot2)
library(scales)
library(readr)
library(here)
library(stringr)  # For string manipulation

# -------------------------------------------------------------------
# Goal:
# Analyze and plot demographics (age and employment status) from women who use wearables (smart watches/bracelets)
# to provide insights to Bellabeat marketing team.
# -------------------------------------------------------------------

here::here()

# Load the cleaned survey data
csv_file <- here("DATA", "Survey", "Cleaned_Survey", "cleaned_survey.csv")
survey_df <- read_csv(csv_file)

str(survey_df)
glimpse(survey_df)

# Define Q16 question and its options 
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
#survey_df <- survey_df %>%
#  mutate(
#    Q16_Device_Owned = factor(
#      Q16_Device_Owned,
#      levels = as.character(1:9),  # make levels as characters since Q16_Device_Owned is numeric
#      labels = q16_options,
#       ordered = TRUE
#    )
#  )

# To match Bellabeat's target customer base
# Filter to: a) women b) who use "Smart watches/bracelets (e.g. Polar, FitBit)" type of devices
filtered_df <- survey_df %>%
  filter(Q19_Sex == 2, Q16_Device_Owned == 1)


# Check the structure to confirm changes
glimpse(filtered_df) 
# OK: col Q19_Sex contains only "2" (women)
# OK: col Q16_Device_Owned contains only "1" (using smart watches/bracelets)

# 1 - Plotting age distribution (Q17_Age) as percentages

# Define age group labels
age_labels <- c(
  "1" = "20 or younger",
  "2" = "21-25",
  "3" = "26-30",
  "4" = "31-35",
  "5" = "36-40",
  "6" = "41-45",
  "7" = "46-50",
  "8" = "51-55",
  "9" = "56-60",
  "10" = "61-65",
  "11" = "66 or older"
)

# Calculate counts and percentages
age_distribution <- filtered_df %>%
  # Remove NA values in Q17_Age
  filter(!is.na(Q17_Age)) %>%
  # Group by age and calculate counts
  group_by(Q17_Age) %>%
  summarise(Count = n()) %>%
  ungroup() %>%
  # Calculate percentage
  mutate(Percentage = (Count / sum(Count)) * 100) %>%
  # Convert Q17_Age to a factor with labels
  mutate(Age_Group = factor(Q17_Age, levels = 1:11, labels = age_labels))

# Verify that percentages sum to 100%
total_percentage <- sum(age_distribution$Percentage)
print(paste("Total Percentage:", round(total_percentage, 2), "%"))

# Create the plot
ggplot(age_distribution, aes(x = Age_Group, y = Percentage)) +
  geom_col(fill = "#F4ACA1") +
  geom_text(aes(label = paste0(round(Percentage, 1), "%")),
            vjust = -0.5, size = 3) +
  labs(
    title = "Age Distribution Among Women Respondents",
    subtitle = "Who Use Smart Watches/Bracelets",
    x = "Age Group",
    y = "Percentage of Respondents"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, size = 12),
    axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
    axis.text.y = element_text(size = 12),
    axis.title = element_text(size = 12)
  ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05)))  # Add some space above bars for labels



# 2) Plottting employment distribution (Q32_CurrentSituation)

# Calculate counts and percentages, including NAs labeled as "Others"
work_distribution <- filtered_df %>%
  mutate(Q32_CurrentSituation = if_else(is.na(Q32_CurrentSituation), 5, Q32_CurrentSituation)) %>%
  group_by(Q32_CurrentSituation) %>%
  summarise(Count = n()) %>%
  mutate(Percentage = (Count / sum(Count)) * 100) %>%
  mutate(Work_Situation = factor(Q32_CurrentSituation, levels = 1:5, 
                                 labels = c("Full-time employment", "Part-time employment", "Retired", 
                                            "Not working at the moment", "Others")))

# Plotting with different colors including "Others"
ggplot(work_distribution, aes(x = Work_Situation, y = Percentage, fill = Work_Situation)) +
  geom_col() +
  geom_text(aes(label = paste0(round(Percentage, 1), "%")), 
            vjust = -0.5, size = 3) +
  labs(
    title = "Employment Status Among Women Respondents",
    subtitle = "Who Use Smart Watches or Bracelets",
    x = "Current Work Situation",
    y = "Percentage of Respondents"
  ) +
  scale_fill_manual(values = c(
    "Full-time employment" = "#A78682",   # hex colors from Bellabeat color theme
    "Part-time employment" = "#F4ACA1",
    "Retired" = "#FDDAC5",
    "Not working at the moment" = "#6D8372",
    "Other" = "purple"
  )) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  ) +
  scale_y_continuous(labels = scales::percent_format(scale = 1), 
                     expand = expansion(mult = c(0, 0.05)))


