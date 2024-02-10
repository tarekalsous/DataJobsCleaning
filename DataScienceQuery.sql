-- Link to the dataset: https://www.kaggle.com/datasets/rashikrahmanpritom/data-science-job-posting-on-glassdoor?select=Uncleaned_DS_jobs.csv
------------------------------------------------------------------------------------------------------------------------

-- Cleaning Data

 SELECT *
 FROM Data_Science_Jobs..Data_Science_UNC

------------------------------------------------------------------------------------------------------------------------

-- Clean salary estimate

SELECT REPLACE([Salary Estimate], '(Glassdoor est.)', '')
FROM Data_Science_Jobs..Data_Science_UNC

UPDATE Data_Science_UNC
SET [Salary Estimate] = REPLACE([Salary Estimate], '(Glassdoor est.)', '')

------------------------------------------------------------------------------------------------------------------------

-- Remove newline and special characters from job description

SELECT REPLACE(REPLACE([Job Description], '\n', ''), '’', '')
FROM Data_Science_Jobs..Data_Science_UNC

UPDATE Data_Science_UNC
SET [Job Description] = REPLACE(REPLACE([Job Description], '\n', ''), '’', '')

------------------------------------------------------------------------------------------------------------------------

-- Standardize text in columns

SELECT TRIM(Location),
    TRIM(Headquarters),
    TRIM(Size),
    TRIM([Type of ownership]),
    TRIM(Industry),
	TRIM(Sector),
    TRIM(Revenue)
FROM Data_Science_Jobs..Data_Science_UNC

UPDATE Data_Science_UNC
SET Location = TRIM(Location),
    Headquarters = TRIM(Headquarters),
    Size = TRIM(Size),
    [Type of ownership] = TRIM([Type of ownership]),
    Industry = TRIM(Industry),
	Sector = TRIM(Sector),
    Revenue = TRIM(Revenue)

------------------------------------------------------------------------------------------------------------------------

-- Remove the rating from the company name column

SELECT TRIM(SUBSTRING([Company Name], 1, LEN([Company Name]) - 3))
FROM Data_Science_Jobs..Data_Science_UNC

UPDATE Data_Science_UNC
SET [Company Name] = TRIM(SUBSTRING([Company Name], 1, LEN([Company Name]) - 3))

------------------------------------------------------------------------------------------------------------------------

-- Replacing unknown values with NULL instead of -1

UPDATE Data_Science_UNC
SET Rating = NULL
WHERE Rating = -1

UPDATE Data_Science_UNC
SET Headquarters = NULL
WHERE Headquarters = '-1'

UPDATE Data_Science_UNC
SET Size = NULL
WHERE Size = '-1'

UPDATE Data_Science_UNC
SET Founded = NULL
WHERE Founded = -1

UPDATE Data_Science_UNC
SET [Type of ownership] = NULL
WHERE [Type of ownership] = '-1'

UPDATE Data_Science_UNC
SET Industry = NULL
WHERE Industry = '-1'

UPDATE Data_Science_UNC
SET Sector = NULL
WHERE Sector = '-1'

------------------------------------------------------------------------------------------------------------------------

-- Separating address city and state

ALTER TABLE Data_Science_UNC
ADD JobLocationState Nvarchar(255);

UPDATE Data_Science_UNC
SET JobLocationState = PARSENAME(REPLACE(Location, ',', '.') , 1)

ALTER TABLE Data_Science_UNC
ADD JobLocationCity Nvarchar(255);

UPDATE Data_Science_UNC
SET JobLocationCity = PARSENAME(REPLACE(Location, ',', '.') , 2)

ALTER TABLE Data_Science_UNC
ADD HeadquartersState Nvarchar(255);

UPDATE Data_Science_UNC
SET HeadquartersState = PARSENAME(REPLACE(Location, ',', '.') , 1)

ALTER TABLE Data_Science_UNC
ADD HeadquartersCity Nvarchar(255);

UPDATE Data_Science_UNC
SET HeadquartersCity = PARSENAME(REPLACE(Location, ',', '.') , 2)

------------------------------------------------------------------------------------------------------------------------

-- Remove unused columns

ALTER TABLE Data_Science_UNC
DROP COLUMN [index], Location, Headquarters, Competitors
