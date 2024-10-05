# Chapter 4: Analysis phase (Survey)

Now that the survey dataset `cleaned_survey.csv` is cleaned and stored in the `Cleaned_Survey` folder, it's time to start the actual data analysis.

## 1) Reminder of the business task

To stay aligned with the business task, I need to keep in mind the following key questions:
   
- What are some trends in smart device usage?
- How could these trends apply to Bellabeat customers?
- How could these trends help influence Bellabeat marketing strategy?

## 2) Further adjustment made to make data ready for analysis

### 2.1. Filtering respondents' gender

To focus the analysis on the Bellabeat customer target group, which is 100% women, the dataset was filtered to include only female respondents. 

Also, survey respondents had to pick only one answer regarding the smart device they own, in the following list: 

- Smart watches/bracelets (e.g. Polar, FitBit) (1)
- Household cleaning devices (e.g. robot vacuum cleaner) (2)
- Other household devices (e.g. security system, thermostat, smart bulbs) (3)
- Personal hygiene devices (e.g. toothbrush) (4)
 - Personal health devices (e.g. blood pressure monitor, scale) (5)
- Entertainment devices (e.g. smart toys such Lego Mindstorm) (6)
- Personal assistant devices (e.g. Siri, Alexa) (7)
- Smart TVs and videostreaming devices (e.g. Apple TV, Nvidia shield) (8)
- Computers and smartphones (9)

Since Bellabeat sells fitness wearable devices, I filtered the dataset further to include only women who use wearables (smart watches/bracelets), i.e. answer 1 in the above question. 

With these two filterings, I made sure the insights were directly relevant to Bellabeat's customer base.

Sample code
```r
filtered_df <- survey_df %>%
  filter(Q19_Sex == 2, Q16_Device_Owned == "Smart watches/bracelets (e.g. Polar, FitBit)")
```

### 2.2 Filtering respondents' levels of reaction

From the previous step, I found out that there were many questions (Q3 thru Q10) with 5 levels of Likert-scale answers (Strongly disagree, Somewhat
disagree, Neither agree nor disagree, Somewhat agree, and Strongly agree).
To make my findings more focused and meaningful, I chose to retain only strong opinions, that is Strongly disagree and Strongly agree.

### 2.3 Data format transformation

The data was transformed from a wide format to a long format to facilitate easier analysis and plotting (required for ggplot2 functions). 

Sample code
``` r
female_long <- filtered_df %>%
  select(all_of(likert_questions)) %>%
  pivot_longer(cols = everything(), names_to = "Question", values_to = "Response") %>%
  drop_na(Response) %>%
  mutate(
    Response = factor(
      Response,
      levels = c("Strongly Disagree", "Strongly Agree"),
      ordered = TRUE
    ),
    Question = str_remove(Question, "^Q\\d+_"),
    Question = str_replace_all(Question, "_", " ")
  )

```

## 3) Exploratory Data Analysis (EDA)

### 3.1 Summary statistics

Initial exploration involved calculating the count and percentage of "Strongly Agree" and "Strongly Disagree" responses for each survey question.

Sample code

``` r
summary_table <- female_long %>%
  filter(Response %in% c("Strongly Agree", "Strongly Disagree")) %>%
  group_by(Question, Response) %>%
  summarise(Count = n(), .groups = 'drop') %>%
  group_by(Question) %>%
  mutate(Percentage = Count / sum(Count) * 100)

```

### 3.2. Top responses

The identication of the top 5 questions with the highest percentages of "Strongly Agree" and "Strongly Disagree" responses gave me targeted insights.

Sample code

``` r
# Top 5 Strongly Agree
top_agree <- summary_table %>%
  filter(Response == "Strongly Agree") %>%
  arrange(desc(Percentage)) %>%
  slice_head(n = 5)

# Top 5 Strongly Disagree
top_disagree <- summary_table %>%
  filter(Response == "Strongly Disagree") %>%
  arrange(desc(Percentage)) %>%
  slice_head(n = 5)
```


Findings:

- Strongest agreements:
  - Enjoy device: High percentage indicating satisfaction with wearables.
  - Positive about device: Reflects overall positive sentiment.

- Strongest disagreements:
  - Device has its own personality: Women do not see their device as "human".
  - Device helps me create relationships: Women do no see their device as a social tool.
 

## 4) Visualizations

Two bars were created to visualize the distribution of strong opinions ("Strongly Agree" and "Strongly Disagree") across various survey questions.

### 4.1 Bar charts to show women's strong opinions

Sample code
``` r
# Function to create and save plots for each group
create_and_save_plot <- function(group_name, questions){
  group_summary <- summary_table %>%
    filter(Question %in% questions)
  
  if(nrow(group_summary) == 0){
    print(paste("No data available for group", group_name))
    return(NULL)
  }
  
  p <- ggplot(group_summary, aes(x = Question, y = Percentage, fill = Response)) +
    geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.7) +
    scale_y_continuous(labels = percent_format(scale = 1)) +
    scale_fill_manual(
      values = c("Strongly Disagree" = "#d73027", "Strongly Agree" = "#4575b4"),
      name = "Response",
      labels = c("Strongly Disagree", "Strongly Agree")
    ) +
    labs(
      title = paste("Group", group_name, "- Women Strong Opinions on Smart Watches/Bracelets"),
      x = "Survey Question",
      y = "Percentage of Female Respondents"
    ) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      legend.position = "bottom",
      plot.title = element_text(hjust = 0.5)
    )
  
  file_name <- paste0("Survey_Women_Smart_Watches_Strong_Opinions_Group_", group_name, ".png")
  file_path <- here("IMAGES", file_name)
  
  ggsave(filename = file_path, plot = p, width = 14, height = 8, dpi = 300, bg = "white")
  
  print(paste("Plot saved as", file_path))
}

# Define groups and their corresponding questions
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

# Iterate over each group and create/save plots
for(group in names(groups)){
  create_and_save_plot(group, groups[[group]])
}
```

Plot Characteristics:

- Color coding:
  - Red (#d73027) for "Strongly Disagree"
  - Blue (#4575b4) for "Strongly Agree"

- Layout:
  - Side-by-side bars for easy comparison.
  - Clear labeling of survey questions on the x-axis.
  - Percentage values represented on the y-axis.

- Legend:
  - Positioned at the bottom for unobstructed view.
  - Clearly distinguishes between "Strongly Disagree" and "Strongly Agree" responses.

### 4.2. Sample plot

(put actual plot)

The sample plot illustrates the percentage of "Strongly Agree" and "Strongly Disagree" responses for the question "Enjoy Device." The blue bar indicates a high level of agreement, while the red bar shows a strong level of disagreement.
 


  
