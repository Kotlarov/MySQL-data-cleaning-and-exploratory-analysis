# -------------- data cleaning --------------
# see the raw data
SELECT *
FROM sgdata_modified;

# create a duplicate table to work with 
CREATE TABLE sgdata_modified_cleaning
LIKE sgdata_modified;

SELECT *
FROM sgdata_modified_cleaning;

INSERT sgdata_modified_cleaning
SELECT *
FROM sgdata_modified;

# -------------- remove duplicates --------------
# create a cte (common table expression) as a temporary table, partitioning by the ID
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ID ORDER BY ID) AS row_num
    FROM sgdata_modified_cleaning
)
# see duplicates
SELECT * FROM duplicate_cte
WHERE row_num > 1;
#to delete duplicates a new table is necessary because we cant delete from the cte

# create a new table with row_num column
# (right click table, copy to clipboard, create statement, add row_num)
CREATE TABLE `sgdata_modified_cleaning2` (
  `ID` int DEFAULT NULL,
  `Sex` int DEFAULT NULL,
  `Marital status` text,
  `Age` int DEFAULT NULL,
  `Education` text,
  `Income` text,
  `Occupation` text,
  `Settlement size` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

#see duplicates in new table
SELECT *
FROM sgdata_modified_cleaning2
WHERE row_num > 1;

INSERT INTO sgdata_modified_cleaning2
SELECT *,
ROW_NUMBER() OVER (PARTITION BY ID ORDER BY ID) AS row_num
FROM sgdata_modified_cleaning;

# remove rows with duplicate ID
DELETE
FROM sgdata_modified_cleaning2
WHERE row_num > 1;

SELECT *
FROM sgdata_modified_cleaning2;

# this methond also works without a unique ID column by including all columns in the PARTITION BY
# an easier method here would be to create a new table with SELECT DISTINCT 

# -------------- standardize data --------------
# check each column to spot any problems
SELECT DISTINCT `Marital status`
FROM sgdata_modified_cleaning2;

SELECT DISTINCT Education
FROM sgdata_modified_cleaning2;

# the data set was stadardized already but lets look at some common methods 
# remove white spaces at the beginning and end
#UPDATE sgdata_modified_cleaning2
#SET Education = TRIM(Education);

# remove dots at the end
#UPDATE sgdata_modified_cleaning2
#SET Education = TRIM(TRAILING '.' FROM Education)
#WHERE Education = '%.';

# group differently written education types if for example you have a `technical university `
#UPDATE sgdata_modified_cleaning2
#SET Education = `university`
#WHERE Education LIKE '%university';

# format a date column
#UPDATE sgdata_modified_cleaning2
#SET `date` = STR_TO_DATE(`date`, '%d/%m/%Y');

# -------------- null blank values --------------
SELECT *
FROM sgdata_modified_cleaning2;

# check all columns for nulls or blanks
SELECT *
FROM sgdata_modified_cleaning2
WHERE Income IS NULL
OR Income = '';

# populate data where possible, here the missing income can not be populated
# delete the row since the income is a key element in the following analysis 
DELETE
FROM sgdata_modified_cleaning2
WHERE Income IS NULL
OR Income = '';


# -------------- remove colums if nececary --------------
#remove row_num that was used to remove duplicates
ALTER TABLE sgdata_modified_cleaning2
DROP COLUMN row_num;

#final clean data
SELECT *
FROM sgdata_modified_cleaning2;