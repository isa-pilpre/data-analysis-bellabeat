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

### 2.2. Refining responses to display three types of opinions (Disagree, Neutral, Agree)

The survey included Likert-scale responses with five levels: Strongly Disagree, Somewhat Disagree, Neutral, Somewhat Agree, and Strongly Agree. However, in order to keep all the data but to simplify the visuals, I chose to aggregate Likert responses into three categories: Disagree, Neutral, and Agree.

### 2.3 Transforming data format for analysis and plotting

The data was transformed from a wide format to a long format for easier analysis and visualization using ggplot2. Additionally, question labels were cleaned by removing prefixes and replacing underscores with spaces for better readability in plots.

Sample code

``` r
# Transform the data to long format for easier analysis and plotting
female_long <- filtered_df %>%
  select(all_of(likert_questions)) %>%  # Select only the Likert question columns
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

```

## 3) Exploratory Data Analysis (EDA)

### 3.1 Summary statistics

Initial exploration involved calculating the count and percentage of "Disagree", "Neutral" and "Agree" responses for each survey statement.

Sample code

``` r
# Calculate counts and percentages for all aggregated responses per question
  summary_table <- female_long %>%
    group_by(Question, Response_Aggregated) %>%
    summarise(Count = n(), .groups = 'drop') %>%                  # Count occurrences
    group_by(Question) %>%                                        # Group by question to calculate percentages
    mutate(Percentage = Count / sum(Count) * 100) %>%             # Calculate percentage within each question
    ungroup()
```

### 3.2. Identifying top responses

Identifying the top 5 statements with the highest percentages of "Agree" and "Disagree" responses provideed targeted insights.

Sample code

``` r
# Identify top 5 statements where women agree
top_agree <- summary_table %>%
    filter(Response_Aggregated == "Agree") %>%                       # Filter for 'Agree'
    arrange(desc(Percentage)) %>%                                    # Arrange in descending order
    slice_head(n = 5)                                                # Select top 5
  

# Identify top 5 statements where women disagree
  top_disagree <- summary_table %>%
    filter(Response_Aggregated == "Disagree") %>%                    # Filter for 'Disagree'
    arrange(desc(Percentage)) %>%                                   # Arrange in descending order
    slice_head(n = 5)                                               # Select top 5
```


Findings:

- Top 5 statements with highest 'Agree' percentages from women using wearables:
  - Question                    Response_Aggregated Count Percentage
  - <chr>                       <ord>               <int>      <dbl>
  - 1 Device Useful For My Goals  Agree                  54       93.1
  - 2 Enjoy Device                Agree                  53       89.8
  - 3 Freely Choose Tasks         Agree                  53       89.8
  - 4 Understand How Device Works Agree                  52       88.1
  - 5 Positive About Device       Agree                  55       87.3
 

- Top 5 statements with highest 'Disagree' percentages from women using wearables:
  - Question                         Response_Aggregated Count Percentage
  - <chr>                            <ord>               <int>      <dbl>
  - 1 Feel Victimized                  Disagree               49       77.8
  - 2 Consider Naming Device           Disagree               45       77.6
  - 3 Device Helps Me Social Relations Disagree               43       75.4
  - 4 Device Forces Process On Me      Disagree               46       73.0
  - 5 Device Not Helpful               Disagree               41       69.5
 

## 4) Visualizations

Bar charts were created to visualize the distribution of opinions (disagree, neutral, agree) on specific statements about smart devices.

### 4.1 Bar charts displaying women's opinions about their smart device

Sample code

``` r
# Proceed only if there are no NAs
if(na_count == 0){
  
    # Calculate counts and percentages for all aggregated responses per question
    summary_table <- female_long %>%
      group_by(Question, Response_Aggregated) %>%
      summarise(Count = n(), .groups = 'drop') %>%                      # Count occurrences
      group_by(Question) %>%                                           # Group by question to calculate percentages
      mutate(Percentage = Count / sum(Count) * 100) %>%               # Calculate percentage within each question
      ungroup()
  
  # Identify top 5 questions where women agree
  top_agree <- summary_table %>%
    filter(Response_Aggregated == "Agree") %>%                       # Filter for 'Agree'
    arrange(desc(Percentage)) %>%                                    # Arrange in descending order
    slice_head(n = 5)                                               # Select top 5
  
  # Identify top 5 questions where women disagree
  top_disagree <- summary_table %>%
    filter(Response_Aggregated == "Disagree") %>%                    # Filter for 'Disagree'
    arrange(desc(Percentage)) %>%                                   # Arrange in descending order
    slice_head(n = 5)                                               # Select top 5
  
  # Print the results
  print("Top 5 Questions with Highest 'Agree' Percentages:")
  print(top_agree)
  
  print("Top 5 Questions with Highest 'Disagree' Percentages:")
  print(top_disagree)
  
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

```

Plot characteristics:

- Color coding:
  - Red (#d73027) for "Disagree"
  - Orange (#fdae61) for "Neutral"
  - Blue (#4575b4) for "Agree"

- Layout:
  - Side-by-side bars for easy comparison.
  - Clear labeling of survey questions on the x-axis.
  - Percentage values represented on the y-axis.

- Legend:
  - Positioned at the bottom for unobstructed view.
  - Clearly distinguishes between "Disagree" and "Agree" responses.

### 4.2. Sample plot

(put actual plot)

The sample plot illustrates the percentage of "Agree", "Neutral" and "Disagree" responses among women who use wearable devices such as smart watches or bracelets (Polar, Fitbit), regarding the statement "Device Useful For My Goals." 
 


  
