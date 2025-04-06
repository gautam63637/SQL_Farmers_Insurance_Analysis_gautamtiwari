SET GLOBAL local_infile = 1;

CREATE SCHEMA IF NOT EXISTS ndap;
USE ndap;

CREATE TABLE IF NOT EXISTS FarmersInsuranceData (
    rowID INT AUTO_INCREMENT PRIMARY KEY,
    srcYear INT,
    srcStateName VARCHAR(255),
    srcDistrictName VARCHAR(255),
    InsuranceUnits INT,
    TotalFarmersCovered INT,
    ApplicationsLoaneeFarmers INT,
    ApplicationsNonLoaneeFarmers INT,
    InsuredLandArea DECIMAL(10,2),
    FarmersPremiumAmount DECIMAL(12,2),
    StatePremiumAmount DECIMAL(12,2),
    GOVPremiumAmount DECIMAL(12,2),
    GrossPremiumAmountToBePaid DECIMAL(12,2),
    SumInsured DECIMAL(15,2),
    PercentageMaleFarmersCovered FLOAT,
    PercentageFemaleFarmersCovered FLOAT,
    PercentageOthersCovered FLOAT,
    PercentageSCFarmersCovered FLOAT,
    PercentageSTFarmersCovered FLOAT,
    PercentageOBCFarmersCovered FLOAT,
    PercentageGeneralFarmersCovered FLOAT,
    PercentageMarginalFarmers FLOAT,
    PercentageSmallFarmers FLOAT,
    PercentageOtherFarmers FLOAT,
    YearCode INT,
    Year_ VARCHAR(255),
    Country VARCHAR(255),
    StateCode INT,
    DistrictCode INT,
    TotalPopulation INT,
    TotalPopulationUrban INT,
    TotalPopulationRural INT,
    TotalPopulationMale INT,
    TotalPopulationMaleUrban INT,
    TotalPopulationMaleRural INT,
    TotalPopulationFemale INT,
    TotalPopulationFemaleUrban INT,
    TotalPopulationFemaleRural INT,
    NumberOfHouseholds INT,
    NumberOfHouseholdsUrban INT,
    NumberOfHouseholdsRural INT,
    LandAreaUrban DECIMAL(10,2),
    LandAreaRural DECIMAL(10,2),
    LandArea DECIMAL(10,2)
);

LOAD DATA LOCAL INFILE 'C:/Users/Gautamtiwari/Documents/NDAP/FarmersInsuranceData.csv'
INTO TABLE FarmersInsuranceData
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- ----------------------------------------------------------------------------------------------
-- SECTION 1. 
-- SELECT Queries [5 Marks]

-- 	Q1.	Retrieve the names of all states (srcStateName) from the dataset.
SELECT DISTINCT srcStateName 
FROM FarmersInsuranceData 
ORDER BY srcStateName;

-- 	Q2.	Retrieve the total number of farmers covered (TotalFarmersCovered) 
-- 		and the sum insured (SumInsured) for each state (srcStateName), ordered by TotalFarmersCovered in descending order.
SELECT 
    srcStateName, 
    SUM(TotalFarmersCovered) AS TotalFarmers, 
    SUM(SumInsured) AS TotalSumInsured
FROM FarmersInsuranceData
GROUP BY srcStateName
ORDER BY TotalFarmers DESC;

-- --------------------------------------------------------------------------------------
-- SECTION 2. 
-- Filtering Data (WHERE) [15 Marks]

-- 	Q3.	Retrieve all records where Year is '2020'.
SELECT * 
FROM FarmersInsuranceData
WHERE Year_ = '2020' ;

-- 	Q4.	Retrieve all rows where the TotalPopulationRural is greater than 1 million and the srcStateName is 'HIMACHAL PRADESH'.
SELECT * 
FROM FarmersInsuranceData
WHERE TotalPopulationRural > 1000000
AND srcStateName = 'HIMACHAL PRADESH';

-- 	Q5.	Retrieve the srcStateName, srcDistrictName, and the sum of FarmersPremiumAmount for each district in the year 2018, 
-- 		and display the results ordered by FarmersPremiumAmount in ascending order.
SELECT 
    srcStateName, 
    srcDistrictName, 
    SUM(FarmersPremiumAmount) AS TotalFarmersPremium
FROM FarmersInsuranceData
WHERE YearCode = 2018
GROUP BY srcStateName, srcDistrictName
ORDER BY TotalFarmersPremium ASC;

-- 	Q6.	Retrieve the total number of farmers covered (TotalFarmersCovered) and the sum of premiums (GrossPremiumAmountToBePaid) for each state (srcStateName) 
-- 		where the insured land area (InsuredLandArea) is greater than 5.0 and the Year is 2018.
SELECT 
    srcStateName, 
    SUM(TotalFarmersCovered) AS TotalFarmers, 
    SUM(GrossPremiumAmountToBePaid) AS TotalPremium
FROM FarmersInsuranceData
WHERE InsuredLandArea > 5.0 
AND YearCode = 2018
GROUP BY srcStateName
ORDER BY TotalFarmers DESC;

-- ------------------------------------------------------------------------------------------------

-- SECTION 3.
-- Aggregation (GROUP BY) [10 marks]

-- 	Q7. 	Calculate the average insured land area (InsuredLandArea) for each year (srcYear).
SELECT 
    srcYear, 
    AVG(InsuredLandArea) AS AvgInsuredLandArea
FROM FarmersInsuranceData
GROUP BY srcYear
ORDER BY srcYear ASC;

-- 	Q8. 	Calculate the total number of farmers covered (TotalFarmersCovered) for each district (srcDistrictName) where Insurance units is greater than 0.
SELECT 
    srcDistrictName, 
    SUM(TotalFarmersCovered) AS TotalFarmers
FROM FarmersInsuranceData
WHERE InsuranceUnits > 0
GROUP BY srcDistrictName
ORDER BY TotalFarmers DESC;

-- 	Q9.	For each state (srcStateName), calculate the total premium amounts (FarmersPremiumAmount, StatePremiumAmount, GOVPremiumAmount) 
-- 		and the total number of farmers covered (TotalFarmersCovered). Only include records where the sum insured (SumInsured) is greater than 500,000 (remember to check for scaling).
SELECT 
    srcStateName, 
    SUM(FarmersPremiumAmount) AS TotalFarmersPremium, 
    SUM(StatePremiumAmount) AS TotalStatePremium, 
    SUM(GOVPremiumAmount) AS TotalGovPremium, 
    SUM(TotalFarmersCovered) AS TotalFarmersCovered
FROM FarmersInsuranceData
WHERE SumInsured > 500000
GROUP BY srcStateName
ORDER BY TotalFarmersCovered DESC;

-- -------------------------------------------------------------------------------------------------
-- SECTION 4.
-- Sorting Data (ORDER BY) [10 Marks]

-- 	Q10.	Retrieve the top 5 districts (srcDistrictName) with the highest TotalPopulation in the year 2020.
SELECT 
    srcDistrictName, 
    TotalPopulation
FROM FarmersInsuranceData
WHERE YearCode = 2020
ORDER BY TotalPopulation DESC
LIMIT 5;

-- 	Q11.	Retrieve the srcStateName, srcDistrictName, and SumInsured for the 10 districts with the lowest non-zero FarmersPremiumAmount, 
-- 		ordered by insured sum and then the FarmersPremiumAmount.
SELECT 
    srcStateName, 
    srcDistrictName, 
    SumInsured, 
    FarmersPremiumAmount
FROM FarmersInsuranceData
WHERE FarmersPremiumAmount > 0 
ORDER BY SumInsured ASC, FarmersPremiumAmount ASC
LIMIT 10;

-- 	Q12. 	Retrieve the top 3 states (srcStateName) along with the year (srcYear) where the ratio of insured farmers (TotalFarmersCovered) to the total population (TotalPopulation) is highest. 
-- 		Sort the results by the ratio in descending order.
SELECT 
    srcStateName, 
    srcYear, 
    (SUM(TotalFarmersCovered) / SUM(TotalPopulation)) AS InsuredFarmersRatio
FROM FarmersInsuranceData
WHERE TotalPopulation > 0
GROUP BY srcStateName, srcYear
ORDER BY InsuredFarmersRatio DESC
LIMIT 3;

-- -------------------------------------------------------------------------------------------------

-- SECTION 5.
-- String Functions [6 Marks]

-- 	Q13. 	Create StateShortName by retrieving the first 3 characters of the srcStateName for each unique state.
SELECT 
    srcStateName, 
    LEFT(srcStateName, 3) AS StateShortName
FROM FarmersInsuranceData
GROUP BY srcStateName
ORDER BY srcStateName;

-- 	Q14. 	Retrieve the srcDistrictName where the district name starts with 'B'.
SELECT DISTINCT srcDistrictName
FROM FarmersInsuranceData
WHERE srcDistrictName LIKE 'B%';

-- 	Q15. 	Retrieve the srcStateName and srcDistrictName where the district name contains the word 'pur' at the end.
SELECT DISTINCT srcStateName, srcDistrictName
FROM FarmersInsuranceData
WHERE srcDistrictName LIKE '%pur';

-- -------------------------------------------------------------------------------------------------

-- SECTION 6.
-- Joins [14 Marks]

-- 	Q16. 	Perform an INNER JOIN between the srcStateName and srcDistrictName columns to retrieve the aggregated FarmersPremiumAmount for districts where the district’s Insurance units for an individual year are greater than 10.
SELECT 
    f1.srcStateName, 
    f1.srcDistrictName, 
    f1.YearCode, 
    SUM(f1.FarmersPremiumAmount) AS TotalFarmersPremium
FROM FarmersInsuranceData f1
INNER JOIN FarmersInsuranceData f2
    ON f1.srcStateName = f2.srcStateName 
    AND f1.srcDistrictName = f2.srcDistrictName
    AND f1.YearCode = f2.YearCode
WHERE f2.InsuranceUnits > 10
GROUP BY f1.srcStateName, f1.srcDistrictName, f1.YearCode
ORDER BY TotalFarmersPremium DESC;

-- 	Q17.	Write a query that retrieves srcStateName, srcDistrictName, Year, TotalPopulation for each district and the the highest recorded FarmersPremiumAmount for that district over all available years
-- 		Return only those districts where the highest FarmersPremiumAmount exceeds 20 crores.
SELECT 
    srcStateName, 
    srcDistrictName, 
    MAX(FarmersPremiumAmount) AS MaxFarmersPremium
FROM FarmersInsuranceData
GROUP BY srcStateName, srcDistrictName
HAVING MAX(FarmersPremiumAmount) > 20
ORDER BY MaxFarmersPremium DESC;

-- 	Q18.	Perform a LEFT JOIN to combine the total population statistics with the farmers’ data (TotalFarmersCovered, SumInsured) for each district and state. 
-- 		Return the total premium amount (FarmersPremiumAmount) and the average population count for each district aggregated over the years, where the total FarmersPremiumAmount is greater than 100 crores.
-- 		Sort the results by total farmers' premium amount, highest first.
SELECT 
    f1.srcStateName, 
    f1.srcDistrictName, 
    SUM(f1.FarmersPremiumAmount) AS TotalFarmersPremium, 
    AVG(f2.TotalPopulation) AS AvgTotalPopulation,
    SUM(f1.TotalFarmersCovered) AS TotalFarmersCovered, 
    SUM(f1.SumInsured) AS TotalSumInsured
FROM FarmersInsuranceData f1
LEFT JOIN FarmersInsuranceData f2 
    ON f1.srcStateName = f2.srcStateName AND f1.srcDistrictName = f2.srcDistrictName
GROUP BY f1.srcStateName, f1.srcDistrictName
HAVING SUM(f1.FarmersPremiumAmount) > 100
ORDER BY TotalFarmersPremium DESC;

-- -------------------------------------------------------------------------------------------------

-- SECTION 7.
-- Subqueries [10 Marks]

-- 	Q19.	Write a query to find the districts (srcDistrictName) where the TotalFarmersCovered is greater than the average TotalFarmersCovered across all records.
SELECT 
    srcStateName, 
    srcDistrictName, 
    SUM(TotalFarmersCovered) AS TotalFarmersCovered
FROM FarmersInsuranceData
GROUP BY srcStateName, srcDistrictName
HAVING TotalFarmersCovered > (
    SELECT AVG(TotalFarmersCovered) 
    FROM FarmersInsuranceData
)
ORDER BY TotalFarmersCovered DESC;

-- 	Q20.	Write a query to find the srcStateName where the SumInsured is higher than the SumInsured of the district with the highest FarmersPremiumAmount.
SELECT srcStateName, SUM(SumInsured) AS TotalSumInsured
FROM FarmersInsuranceData
GROUP BY srcStateName
HAVING TotalSumInsured > (
    SELECT SUM(SumInsured)
    FROM FarmersInsuranceData
    WHERE srcDistrictName = (
        SELECT srcDistrictName
        FROM FarmersInsuranceData
        ORDER BY FarmersPremiumAmount DESC
        LIMIT 1
    )
)
ORDER BY TotalSumInsured DESC;

-- 	Q21.	Write a query to find the srcDistrictName where the FarmersPremiumAmount is higher than the average FarmersPremiumAmount of the state that has the highest TotalPopulation.
SELECT srcDistrictName, srcStateName, SUM(FarmersPremiumAmount) AS TotalFarmersPremium
FROM FarmersInsuranceData
GROUP BY srcStateName, srcDistrictName
HAVING TotalFarmersPremium > (
    SELECT AVG(FarmersPremiumAmount)
    FROM FarmersInsuranceData
    WHERE srcStateName = (
        SELECT srcStateName
        FROM FarmersInsuranceData
        ORDER BY TotalPopulation DESC
        LIMIT 1
    )
)
ORDER BY TotalFarmersPremium DESC;

-- -------------------------------------------------------------------------------------------------

-- SECTION 8.
-- Advanced SQL Functions (Window Functions) [10 Marks]

-- 	Q22.	Use the ROW_NUMBER() function to assign a row number to each record in the dataset ordered by total farmers covered in descending order.
SELECT 
    ROW_NUMBER() OVER (ORDER BY TotalFarmersCovered DESC) AS RowNum,
    srcStateName, 
    srcDistrictName, 
    YearCode, 
    TotalFarmersCovered
FROM FarmersInsuranceData;

-- 	Q23.	Use the RANK() function to rank the districts (srcDistrictName) based on the SumInsured (descending) and partition by alphabetical srcStateName.
SELECT 
    srcStateName, 
    srcDistrictName, 
    SumInsured, 
    RANK() OVER (PARTITION BY srcStateName ORDER BY SumInsured DESC) AS RankWithinState
FROM FarmersInsuranceData
ORDER BY srcStateName ASC, RankWithinState ASC;

-- 	Q24.	Use the SUM() window function to calculate a cumulative sum of FarmersPremiumAmount for each district (srcDistrictName), ordered ascending by the srcYear, partitioned by srcStateName.
SELECT 
    srcStateName, 
    srcDistrictName, 
    srcYear, 
    FarmersPremiumAmount, 
    SUM(FarmersPremiumAmount) OVER (
        PARTITION BY srcStateName, srcDistrictName 
        ORDER BY srcYear ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS CumulativePremium
FROM FarmersInsuranceData
ORDER BY srcStateName, srcDistrictName, srcYear;

-- -------------------------------------------------------------------------------------------------

-- SECTION 9.
-- Data Integrity (Constraints, Foreign Keys) [4 Marks]

-- 	Q25.	Create a table 'districts' with DistrictCode as the primary key and columns for DistrictName and StateCode. 
-- 		Create another table 'states' with StateCode as primary key and column for StateName.
CREATE TABLE states (
    StateCode INT PRIMARY KEY,
    StateName VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE districts (
    DistrictCode INT PRIMARY KEY,
    DistrictName VARCHAR(255) NOT NULL,
    StateCode INT NOT NULL,
    FOREIGN KEY (StateCode) REFERENCES states(StateCode) ON DELETE CASCADE
);

-- 	Q26.	Add a foreign key constraint to the districts table that references the StateCode column from a states table.
ALTER TABLE districts 
ADD CONSTRAINT fk_districts_state
FOREIGN KEY (StateCode) REFERENCES states(StateCode)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- -------------------------------------------------------------------------------------------------

-- SECTION 10.
-- UPDATE and DELETE [6 Marks]

-- 	Q27.	Update the FarmersPremiumAmount to 500.0 for the record where rowID is 1.
UPDATE FarmersInsuranceData
SET FarmersPremiumAmount = 500.0
WHERE rowID = 1;

-- 	Q28.	Update the Year to '2021' for all records where srcStateName is 'HIMACHAL PRADESH'.
UPDATE FarmersInsuranceData
SET Year_ = '2021'
WHERE srcStateName = 'HIMACHAL PRADESH';

-- 	Q29.	Delete all records where the TotalFarmersCovered is less than 10000 and Year is 2020.
DELETE FROM FarmersInsuranceData
WHERE TotalFarmersCovered < 10000
AND Year_ = '2020';