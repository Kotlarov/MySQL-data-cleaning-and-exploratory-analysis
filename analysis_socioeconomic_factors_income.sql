# -------------- data analysis --------------
SELECT *
FROM sgdata_modified_cleaning2;

# overview of income, age
SELECT MIN(Income), MAX(Income), AVG(Income), MIN(Age), MAX(Age), AVG(Age)
FROM sgdata_modified_cleaning2;

# income by age group
SELECT
  CASE
    WHEN Age BETWEEN 10 AND 19 THEN '0-19'
    WHEN Age BETWEEN 20 AND 29 THEN '20-29'
    WHEN Age BETWEEN 30 AND 39 THEN '30-39'
    WHEN Age BETWEEN 40 AND 49 THEN '40-49'
    WHEN Age BETWEEN 50 AND 59 THEN '50-59'
    WHEN Age BETWEEN 60 AND 69 THEN '60-69'
    WHEN Age BETWEEN 70 AND 79 THEN '70-79'
    ELSE '70+'
  END AS Age_Group,
  AVG(Income) AS Avg_Income
FROM sgdata_modified_cleaning2
GROUP BY Age_Group
ORDER BY Avg_Income;
# the income is higher for older age groups

# income by sex 0 female and 1 male
SELECT Sex, AVG(Income) AS Avg_Income
FROM sgdata_modified_cleaning2
GROUP BY Sex
ORDER BY Avg_Income DESC;
# women in this data set earn approximately 13% more than men

# income by sex and marital status
SELECT Sex, `Marital status`, AVG(Income) AS Avg_Income
FROM sgdata_modified_cleaning2
GROUP BY `Marital status`, Sex
ORDER BY Avg_Income DESC;
# single men seam to earn significantly less
# assumption: single men might be younger than non-single men and earn less because of their age, let's check this:
SELECT Sex, `Marital status`, AVG(Age) AS Avg_Age
FROM sgdata_modified_cleaning2
GROUP BY `Marital status`, Sex
ORDER BY Avg_Age DESC;
# the assumption is wrong: non-single men and women are younger on average
# single men earn less on average in this dataset

# income by occupation
SELECT Occupation, AVG(Income) AS Avg_Income
FROM sgdata_modified_cleaning2
GROUP BY Occupation
ORDER BY Avg_Income DESC;
# as expected, managers self-employed or highly qualified people earn the most

# younger people and less skilled occupations have a lower average income
# do younger people have less skilled occupations?
SELECT
  CASE
    WHEN Age BETWEEN 10 AND 19 THEN '0-19'
    WHEN Age BETWEEN 20 AND 29 THEN '20-29'
    WHEN Age BETWEEN 30 AND 39 THEN '30-39'
    WHEN Age BETWEEN 40 AND 49 THEN '40-49'
    WHEN Age BETWEEN 50 AND 59 THEN '50-59'
    WHEN Age BETWEEN 60 AND 69 THEN '60-69'
    WHEN Age BETWEEN 70 AND 79 THEN '70-79'
    ELSE '70+'
  END AS Age_Group,
  Occupation,
  COUNT(*) AS Occupation_Count
FROM sgdata_modified_cleaning2
GROUP BY Age_Group, Occupation
ORDER BY Age_Group, Occupation DESC;

# numbers are hard to compare, let's look at the percentage:
SELECT
  CASE
    WHEN Age BETWEEN 10 AND 19 THEN '0-19'
    WHEN Age BETWEEN 20 AND 29 THEN '20-29'
    WHEN Age BETWEEN 30 AND 39 THEN '30-39'
    WHEN Age BETWEEN 40 AND 49 THEN '40-49'
    WHEN Age BETWEEN 50 AND 59 THEN '50-59'
    WHEN Age BETWEEN 60 AND 69 THEN '60-69'
    WHEN Age BETWEEN 70 AND 79 THEN '70-79'
    ELSE '70+'
  END AS Age_Group,
  Occupation,
  COUNT(*) AS Occupation_Count,
  ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY 
    CASE
      WHEN Age BETWEEN 10 AND 19 THEN '0-19'
      WHEN Age BETWEEN 20 AND 29 THEN '20-29'
      WHEN Age BETWEEN 30 AND 39 THEN '30-39'
      WHEN Age BETWEEN 40 AND 49 THEN '40-49'
      WHEN Age BETWEEN 50 AND 59 THEN '50-59'
      WHEN Age BETWEEN 60 AND 69 THEN '60-69'
      WHEN Age BETWEEN 70 AND 79 THEN '70-79'
      ELSE '70+'
    END)), 2) AS Occupation_Percentage
FROM sgdata_modified_cleaning2
GROUP BY Age_Group, Occupation
ORDER BY Age_Group, Occupation DESC;
# do younger people have less skilled occupations? Not in general:
# older age groups have more management positions with one exception: to 40-49 it goes down slightly
# as a consequence, the sum of unskilled and skilled decreases, but both averages fluctuate

# lastly, let's look at the income by settlement size
SELECT `Settlement size`, AVG(Income) AS Avg_Income
FROM sgdata_modified_cleaning2
GROUP BY `Settlement size`
ORDER BY Avg_Income DESC;
# the bigger the settlement size, the bigger the average income

