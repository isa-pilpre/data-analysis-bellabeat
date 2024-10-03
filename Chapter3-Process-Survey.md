# Chapter 3: Process phase (Survey)

The survey dataset is stored in the `Survey_Data` folder.
It consists of one Excel file called `Anonymized_UserRelationshipWithTheirSmartDevice_Dataset.xlsx`.


## 1) Reminder of the business task

To stay aligned with the business task, I need to remember the following key questions:
   
- What are some trends in smart device usage?
- How could these trends apply to Bellabeat customers?
- How could these trends help influence Bellabeat marketing strategy?


## 2) Overview of the data

Before doing any cleaning, I performed a basic overview on the Excel file with R. 

Sample:

```r
library(readxl)
library(here)

# Define the file path using here()
excel_file <- here("DATA", "Survey", "Survey_Data", "Anonymized_UserRelationshipWithTheirSmartDevice_Dataset.xlsx") 

# Read the Excel file
survey_data <- read_excel(excel_file)

# View the first few rows and get a glimpse of the data
head(survey_data)
glimpse(survey_data)
}


```

### Observation

#### Potential trends

Based on the structure and content of the file, several trends seemed to emerge:

-  

#### Time format issues
