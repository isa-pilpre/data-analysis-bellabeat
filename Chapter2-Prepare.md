# Chapter 2: Prepare Phase

## 1. Data Sources

For this analysis, I am using two publicly available datasets, each providing different perspectives on user behavior with smart devices:

**FitBit Fitness Tracker Data (Kaggle)**: Available [here](https://www.kaggle.com/datasets/arashnic/fitbit), this dataset, recommended by Bellabeat’s cofounder and Chief Creative Officer, Urška Sršen, contains detailed daily activity, heart rate, and sleep patterns from 30 Fitbit users. The data is from 2016 and is valuable for understanding user behavior at a granular level, but the small sample size and dated collection period show limitations. This is why I looked for a complementary data source (see below).

**A Dataset for Studying the Relationship between Humans and Smart Devices (MDPI)**: Available [here](https://www.mdpi.com/2306-5729/9/4/56), this dataset includes survey responses from over 500 individuals, collected between May and July 2020, and provides insights into user attitudes and interactions with smart devices. This behavioral data complements the Fitbit data by adding a psychological dimension to the analysis.


## 2. Data Organization

During my exploration of the FitBit datasets, I found out that the data unzipped into 2 separate folders, called:
"Fitabase Data 3.12.16 - 4.11.16" 
and 
"Fitabase Data 4.12.16 - 5.12.16".
I noticed that many files from the first FitBit folder (containing 11 csv files) seemed to have a matching filename in the second FitBit folder (containing 18 csv files), only with different time periods. I decided to investigate further:

First, I used the command line to list the filenames from both FitBit folders and saved them into text files using the following commands:

```{}
ls > filelist_1.txt
ls > filelist_2.txt
```

Then I compared the filenames manually using Google Sheets. I imported both text files into separate columns and applied a matching formula to check for identical filenames:

```{}
=IF(ISNUMBER(MATCH(A1, B:B, 0)), "Match", "No Match")
```

*Quick reminder on how the MATCH() function works in Excel and Google Sheets:*

* MATCH() checks if the value in cell A1 exists anywhere in Column B. The 0 at the end means it looks for an exact match.

* If a match is found, MATCH() returns the row number where it found the value in Column B. If no match found, it returns an error (#N/A).

* Then ISNUMBER() checks if the return value is a number. And IF() evaluates the result of ISNUMBER() for TRUE or FALSE.

I also applied conditional formatting in Google Sheets to highlight cells with matching filenames, which confirmed that all the 11 files from the first folder had "twin" files in the second folder. The second folder contained an additional 7 files not found in the first.

Once the filenames were verified, I concatenated the matching twin files using R and stored the combined files in a new folder named "FitBit_Complete_Data". This new, unified folder contains 18 CSV files (11 combined twin files and 7 additional files from the initial folder2). 

Part of my code for file concatenation:

```{}
# List files in each folder
files1 <- list.files(folder1, pattern = "*.csv", full.names = TRUE)
files2 <- list.files(folder2, pattern = "*.csv", full.names = TRUE)

# Looping through files to look for matching filenames ("twins")
for (file in unique(c(basename(files1), basename(files2)))) {
 
  # If there are twin files in folders 1 and 2, concat files
  if (file %in% basename(files1) & file %in% basename(files2)) {
    data1 <- read_csv(file.path(folder1, file))
    data2 <- read_csv(file.path(folder2, file))
   
    # Combine the data
    combined_data <- rbind(data1, data2)
   
    # Save the combined file in the folder "FitBit_Complete_Data"
    write_csv(combined_data, here("BELLABEAT", "FitBit_Complete_Data", paste0("combined_", file)))
   
  } else {
    # Copy non-matching files to the folder "FitBit_Complete_Data" as well
    if (file %in% basename(files1)) {
      file.copy(file.path(folder1, file), here("BELLABEAT", "FitBit_Complete_Data", file))
    } else {
      file.copy(file.path(folder2, file), here("BELLABEAT", "FitBit_Complete_Data", file))
    }
  }
}

```
    
Now, the FitBit dataset is fully organized, with all the FitBit files stored in one unified folder called FitBit_Complete_Data on my local machine.
As for the Survey data, it is stored in a folder called Questionnaire_Data in the same directory as the Fitbit folder.

So we now have two unified folders for two datasets (FitBit users and Survey data):

#### A) "FitBit_Complete_Data" Folder

Contains 18 CSV files with data from March 12 to May 12, 2016. These files include minute-level and daily data, organized as follows:

* *dailyActivity_merged.csv*: Daily summary of activity levels, steps, and calories burned.
* *heartrate_seconds_merged.csv*: Second-by-second heart rate data.
* *hourlyCalories_merged.csv*: Hourly calorie data.
* *hourlyIntensities_merged.csv*: Hourly intensity data.
* *hourlySteps_merged.csv*: Hourly step data.
* *minuteCaloriesNarrow_merged.csv*: Narrow minute-level calorie data.
* *minuteIntensitiesNarrow_merged.csv*: Narrow minute-level intensity data.
* *minuteMETsNarrow_merged.csv*: Narrow minute-level MET data.
* *minuteSleep_merged.csv*: Minute-level sleep data.
* *minuteStepsNarrow_merged.csv*: Narrow minute-level step data.
* *weightLogInfo_merged.csv*: Weight log information.
* *dailyCalories_merged.csv*: Daily calorie data.
* *dailyIntensities_merged.csv*: Daily intensity data.
* *dailySteps_merged.csv*: Daily step data.
* *minuteCaloriesWide_merged.csv*: Wide minute-level calorie data.
* *minuteIntensitiesWide_merged.csv*: Wide minute-level intensity data.
* *minuteStepsWide_merged.csv*: Wide minute-level step data.
* *sleepDay_merged.csv*: Daily summary of sleep data.


#### B) "Questionnaire_Data" Folder

This folder contains a PDF of the original survey questionnaire and an Excel file named *Anonymized_UserRelationshipWithTheirSmartDevice_Dataset.xlsx*, which is the actual dataset from the survey. It contains responses from over 500 individuals, collected in 2020. The survey includes user opinions, behaviors, and interactions with their smart devices. The Excel file is in long (narrow) format.


## 3. Credibility and Limitations

While the FitBit data provides detailed minute-by-minute insights, the small sample size (30 users) makes it difficult to draw conclusions that apply to a larger population. Additionally, the data was collected in 2016, which may not reflect current trends.
In contrast, the survey dataset from MDPI includes responses from over 500 participants collected in 2020, and thus addresses the first dataset's limitations by offering a more recent and broader perspective. It also adds psychological insights on how users interact with their smart devices.
However, there are still potential biases because Fitbit users may be more active or health-conscious than the average person, and the survey respondents might represent only a specific demographic. It is also important to investigate how and where the survey was conducted to better understand the significance of the results.

To ensure data quality, I will:
- Clean the data for missing values or inconsistencies.
- Verify that all metrics (e.g., steps, heart rate) are within realistic ranges.
- Ensure GDPR compliance with anonymized responses in the survey data.

## 4. Data Integrity and Privacy

Both datasets are GDPR-compliant and do not contain personally identifiable information. They are publicly available and licensed for open use (FitBit data via Kaggle and the survey data via MDPI's open access). They have been downloaded and stored locally, to ensure the privacy and integrity of the data before proceeding to the cleaning phase.

---

*This document outlines the data preparation for the Bellabeat project, making sure the selected datasets are ready for the next phase (Process & Cleaning).*
