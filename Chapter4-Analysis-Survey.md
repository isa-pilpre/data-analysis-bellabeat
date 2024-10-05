# Chapter 4: Analysis phase (Survey)

Now that the survey dataset `cleaned_survey.csv` is cleaned and stored in the `Cleaned_Survey` folder, it's time to start the actual data analysis.

## 1) Reminder of the business task

To stay aligned with the business task, I need to keep in mind the following key questions:
   
- What are some trends in smart device usage?
- How could these trends apply to Bellabeat customers?
- How could these trends help influence Bellabeat marketing strategy?

## 2) Further data preparation for analysis

### 2.1. Filtering respondents by gender and device ownership

To focus the analysis on Bellabeat's target customer group (i.e. 100% women who use wearables), the dataset was filtered accordingly. Specifically, only female respondents (`Q19_Sex == 2`) who own smart watches or bracelets (`Q16_Device_Owned == "Smart watches/bracelets (e.g. Polar, FitBit)"`) were included in the analysis.

Sample code
```r
filtered_df <- survey_df %>%
  filter(Q19_Sex == 2, Q16_Device_Owned == "Smart watches/bracelets (e.g. Polar, FitBit)")
```

### 2.2. Refining responses to capture strong opinions

The survey included Likert-scale responses with five levels: Strongly Disagree, Somewhat Disagree, Neutral, Somewhat Agree, and Strongly Agree. To focus on more definitive opinions, only "Strongly Disagree" and "Strongly Agree" responses were retained.

### 2.3 Transforming data format for analysis and plotting

The data was transformed from a wide format to a long format for easier analysis and visualization using ggplot2. Additionally, question labels were cleaned by removing prefixes and replacing underscores with spaces for better readability in plots.

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
    Question = str_remove(Question, "^Q\\d+_"),     # remove Q[number] code
    Question = str_replace_all(Question, "_", " ")  # replace underscore with a space
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

### 3.2. Identifying top responses

Identifying the top 5 questions with the highest percentages of "Strongly Agree" and "Strongly Disagree" responses provideed targeted insights.

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
  - Device has its own personality: Women do not perceive their device as "human".
  - Device helps me create relationships: Wearables are not seen as social tools by women.
 

## 4) Visualizations

Bar charts were created to visualize the distribution of strong opinions.

### 4.1 Bar charts for women's strong opinions

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

The sample plot illustrates the percentage of "Strongly Agree" and "Strongly Disagree" responses among women who use wearable devices such as smart watches or bracelets (Polar, Fitbit), regarding the statement "Enjoy Device." 
 


  
