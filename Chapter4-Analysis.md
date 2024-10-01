# Chapter 4: Analysis phase (Fitbit)

Now that the Fitbit dataset is cleaned and stored in the `Cleaned_Fitbit` folder, it's time to start the actual data analysis.

## 1) Reminder of the business task

To stay aligned with the business task, I need to keep in mind the following key questions:
   
- What are some trends in smart device usage?
- How could these trends apply to Bellabeat customers?
- How could these trends help influence Bellabeat marketing strategy?

## 2) Approach to the analysis

From the last step (Process phase), after I reviewed the tibbles, structures, summaries and column names of the 18 files, I found several possible trends that could emerge from the dataset:

- Activity trends: when users are most active (morning, afternoon, evening) based on the `ActivityHour` column.
- Intensity trends: users' activity levels based on `VeryActiveMinutes`, `FairlyActiveMinutes`, `LightlyActiveMinutes` and `SedentaryMinutes`.
- Sleep patterns: sleep duration and habits based on the `TotalMinutesAsleep` and `TotalTimeInBed` columns.
- Recovery patterns: heart rates / recovery patterns based on `Value` column in the heart rate file.

Let's upload the 18 files to BigQuery and run SQL queries to explore the files there.

## 3) First steps in BigQuery

After accessing BigQuery, I select my working project (`alien-oarlock-428016-f3`) in the left-hand navigation panel.
On the right of the project name, I click on the 3 dots and select `Create Dataset`.
In the dialog box that appears, I type `bellabeat` in the `Dataset ID`, choose `Multi-region EU` for the `Location`, leave the other settings at their default values, then click `Create Dataset`.

Once my dataset bellabeat is created, I upload my 18 CSV files and create tables in BigQuery.

## 4) Querying specific trends

   

