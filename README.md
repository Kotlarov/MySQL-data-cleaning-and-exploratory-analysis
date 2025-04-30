# MySQL data cleaning and exploratory analysis

Data cleaning and exploratory analysis using the [socioeconomic factors and income dataset](
https://www.kaggle.com/datasets/aldol07/socioeconomic-factors-and-income-dataset?resource=download
) from kaggle.

Cleaning 
1. removing duplicates
2. standardize
3. remove or populate null and blank values
4. remove rows and columns

Explorative analysis, results for the above dataset:

- **older age** groups (0-19, 20-29, ... 70-79) have a **higher average income**
- **women** earn approximately **13% more** than men
- single men have the lowest average income even though they are not younger on average
- lowest average income: unemployed/unskilled, then skilled employee/official, then management/self-employed/highly qualified employee/officer
- **older age** groups have **more management positions** with one exception: from 30-39 to 40-49 it goes down by 1.5%
- the bigger the settlement size, the bigger the average income


I modified the dataset slightly to include missing values and duplicates.
