# Chapter 2: Prepare Phase

## 1. Data Sources

For this analysis, I am using two publicly available datasets, each providing different perspectives on user behavior with smart devices:

**FitBit Fitness Tracker Data (Kaggle)**: Available [here](https://www.kaggle.com/datasets/arashnic/fitbit), this dataset, recommended by Bellabeat’s cofounder and Chief Creative Officer, Urška Sršen, contains detailed daily activity, heart rate, and sleep patterns from 30 Fitbit users. The data is from 2016 and is valuable for understanding user behavior at a granular level, but the small sample size and dated collection period show limitations. This is why I looked for a complementary data source (see below).

**A Dataset for Studying the Relationship between Humans and Smart Devices (MDPI)**: Available [here](https://www.mdpi.com/2306-5729/9/4/56), this dataset includes survey responses from over 500 individuals, collected between May and July 2020, and provides insights into user attitudes and interactions with smart devices. This behavioral data complements the Fitbit data by adding a psychological dimension to the analysis.


## 2. Data Organization

These datasets are stored in three main folders on my local machine, structured as follows:

### Fitabase Data 3.12.16 - 4.11.16

Contains 11 CSV files with data from March 12 to April 11, 2016. These files include minute-level and daily data, organized as follows:

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


### Fitabase Data 4.12.16 - 5.12.16

Contains 18 CSV files with data from April 12 to May 12, 2016. The data structure is similar to the first folder but with additional files:

* *dailyActivity_merged.csv*: Daily summary of activity levels, steps, and calories burned.
* *dailyCalories_merged.csv*: Daily calorie data.
* *dailyIntensities_merged.csv*: Daily intensity data.
* *dailySteps_merged.csv*: Daily step data.
* *heartrate_seconds_merged.csv*: Second-by-second heart rate data.
* *hourlyCalories_merged.csv*: Hourly calorie data.
* *hourlyIntensities_merged.csv*: Hourly intensity data.
* *hourlySteps_merged.csv*: Hourly step data.
* *minuteCaloriesNarrow_merged.csv*: Narrow minute-level calorie data.
* *minuteCaloriesWide_merged.csv*: Wide minute-level calorie data.
* *minuteIntensitiesNarrow_merged.csv*: Narrow minute-level intensity data.
* *minuteIntensitiesWide_merged.csv*: Wide minute-level intensity data.
* *minuteMETsNarrow_merged.csv*: Narrow minute-level MET data.
* *minuteSleep_merged.csv*: Minute-level sleep data.
* *minuteStepsNarrow_merged.csv*: Narrow minute-level step data.
* *minuteStepsWide_merged.csv*: Wide minute-level step data.
* *sleepDay_merged.csv*: Daily summary of sleep data.
* *weightLogInfo_merged.csv*: Weight log information.


### Questionnaire Data

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

*This document outlines the data preparation for the Bellabeat project, making sure the selected datasets are ready for cleaning phase.*
