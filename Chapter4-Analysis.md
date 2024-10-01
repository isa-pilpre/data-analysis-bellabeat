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

### Creating a dataset

After accessing BigQuery, I selected my working project (`alien-oarlock-428016-f3`) in the left-hand navigation panel.
On the right of the project name, I clicked on the 3 dots and select `Create dataset`.
In the dialog box that appeared, I typed `bellabeat` in the `Dataset ID`, chose `Multi-region EU` for the `Location`, left the other settings at their default values, and then clicked `Create Dataset`.

### Creating tables

Once my dataset bellabeat was created, right on the dataset name, I clicked the three dots again and selected `Create table`. I began uploading the CSV files from my local `Cleaned_Fitbit` folder to BigQuery, one file at a time. The uploads for the daily activity, daily steps, and daily intensity files went smoothly. However, I encountered an error for the heart rate file (exceeded 100MB, so I need to upload it via Google Cloud Storage first). 

## 4) Querying specific trends

### Daily steps according to the time of the day
```sql
SELECT
  Id,
  DATE(TIMESTAMP(ActivityHour)) AS ActivityDate,  -- Extract the day
  CASE
    WHEN EXTRACT(HOUR FROM TIMESTAMP(ActivityHour)) BETWEEN 6 AND 11 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM TIMESTAMP(ActivityHour)) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN EXTRACT(HOUR FROM TIMESTAMP(ActivityHour)) BETWEEN 18 AND 23 THEN 'Evening'
    ELSE 'Night'
  END AS PeriodOfDay,
  SUM(StepTotal) AS TotalSteps
FROM
  `alien-oarlock-428016-f3.bellabeat.hourly_steps`
GROUP BY
  Id, ActivityDate, PeriodOfDay
ORDER BY
  Id, ActivityDate, PeriodOfDay;
```

### Sleep efficiency versus steps and intensity during the day
``` sql
SELECT 
    steps.Id, 
    steps.ActivityDay, 
    steps.StepTotal, 
    sleep.TotalMinutesAsleep, 
    sleep.TotalTimeInBed, 
    (sleep.TotalMinutesAsleep / sleep.TotalTimeInBed) * 100 AS Sleep_Efficiency_Percent
FROM 
    `alien-oarlock-428016-f3.bellabeat.daily_steps` AS steps
JOIN 
    `alien-oarlock-428016-f3.bellabeat.sleep_day` AS sleep
ON 
    steps.Id = sleep.Id 
AND 
    DATE(steps.ActivityDay) = DATE(sleep.SleepDay)  -- Join sur la même journée
ORDER BY 
    steps.Id, steps.ActivityDay;

```

   

