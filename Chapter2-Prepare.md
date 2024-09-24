# Chapter 2: Prepare Phase

## 1. Data Sources

For this analysis, I will be using two datasets:

1. **FitBit Fitness Tracker Data (Kaggle)** (<https://www.kaggle.com/datasets/arashnic/fitbit>): This dataset, recommended by Bellabeat’s cofounder and Chief Creative Officer, Urška Sršen, includes data from 30 Fitbit users, detailing daily steps, activity levels, heart rate, and sleep patterns. The dataset is publicly available under the CC0 license. While valuable, its small sample size (30 participants) and collection date (2016) pose some limitations, motivating the search for additional data sources.

2. **A Dataset for Studying the Relationship between Humans and Smart Devices (MDPI)** (<https://www.mdpi.com/2306-5729/9/4/56>): Published in 2024, this dataset includes survey responses from over 500 individuals, collected between May and July 2020. It provides insights into user attitudes, expectations, and interactions with smart devices, adding a behavioral and psychological dimension to the analysis that complements the FitBit data.

Both datasets are stored locally and have been uploaded to the GitHub repository for this project.

## 2. Data Organization

The FitBit dataset is organized in **wide format**, where each row represents a daily summary for each user, with columns for metrics like steps, calories burned, and heart rate. 
The survey dataset from MDPI is also in wide format, with each row representing one respondent’s answers.

## 3. Credibility and Limitations

While the FitBit data offers detailed, minute-level insights, its small sample size (30 users) limits its generalizability, and the data was collected in 2016. The survey dataset from MDPI, published in 2024 with over 500 respondents, helps address these limitations by providing a broader, more recent perspective on how users interact with their smart devices. However, potential biases remain: Fitbit users might be more active or health-conscious than the average population, and survey respondents may represent a specific demographic.

To ensure data quality, I will:
- Clean the data for missing values or inconsistencies.
- Verify that all metrics (e.g., steps, heart rate) are within realistic ranges.
- Ensure GDPR compliance with anonymized responses in the survey data.

## 4. Data Integrity and Privacy

Both datasets are GDPR-compliant and do not contain personally identifiable information. They are publicly available and licensed for open use (FitBit data via Kaggle and the survey data via MDPI's open access). Data integrity will be verified by checking for missing or erroneous entries and addressing them during the cleaning process.

---

*This document outlines the data preparation for the Bellabeat project, ensuring the selected datasets are ready for analysis in the next phase.*
