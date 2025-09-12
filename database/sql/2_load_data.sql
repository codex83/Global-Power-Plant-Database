/***********************************************
**                MSc ANALYTICS 
**     DATA ENGINEERING PLATFORMS (MSADS 31012)
** File:   Final Project - Global Power Plant Database
** Desc:   Manipulating Global Power Plant Database
** Auth:   Aarav Vishesh Dewangan, Bruna Medeiros, Halleluya Mengesha, Hritik Jhaveri, Veera Anand
** Date:   11/22/2024
************************************************/

-- Use  globalpowerplant database
USE globalpowerplant;

-- Testing 

-- Select all from each table
SELECT * 
FROM co2_emissions;

SELECT * 
FROM country;

SELECT * 
FROM electricity_generation LIMIT 10;

SELECT * 
FROM employee;

SELECT * 
FROM fuel_type;

SELECT * 
FROM power_plant;

-- Count all from each table
SELECT COUNT(*) AS co2_emissions_total_rows 
FROM co2_emissions;

SELECT COUNT(*) AS country_total_rows 
FROM country;

SELECT COUNT(*) AS electricity_generation_total_rows 
FROM electricity_generation;

SELECT COUNT(*) AS employee_total_rows 
FROM employee;

SELECT COUNT(*) AS fuel_type_total_rows 
FROM fuel_type;

SELECT COUNT(*) AS power_plant_total_rows 
FROM power_plant;

-- Check columns and data types for each table
SHOW COLUMNS FROM co2_emissions;
SHOW COLUMNS FROM country;
SHOW COLUMNS FROM electricity_generation; ###
SHOW COLUMNS FROM employee; ###
SHOW COLUMNS FROM fuel_type;
SHOW COLUMNS FROM power_plant; ###

-- Fix column data type in power_plant table: commissioning_year and year_of_capacity
--   Create temporary columns 
ALTER TABLE power_plant
ADD COLUMN temp_year_of_capacity_data INT,
ADD COLUMN temp_commissioning_year INT;

--   Extracts the first 4 characters from the non-empty value or from NULL
--   Covert extracted value to integer
--   Assign to temporary columns
UPDATE power_plant
SET temp_year_of_capacity_data = CAST(LEFT(NULLIF(year_of_capacity_data, ''), 4) AS UNSIGNED),
    temp_commissioning_year = CAST(LEFT(NULLIF(commissioning_year, ''), 4) AS UNSIGNED);

--   Drop original columns
ALTER TABLE power_plant 
DROP COLUMN year_of_capacity_data;

ALTER TABLE power_plant 
DROP COLUMN commissioning_year;

--   Change name of temporary columns
ALTER TABLE power_plant 
CHANGE temp_year_of_capacity_data year_of_capacity_data INT;

ALTER TABLE power_plant 
CHANGE temp_commissioning_year commissioning_year INT;

--  Move columns to original places
ALTER TABLE power_plant
MODIFY commissioning_year INT AFTER longitude;

ALTER TABLE power_plant
MODIFY year_of_capacity_data INT AFTER wepp_id;

-- Fix column data type in employee table: average_hourly_earnings
--   Check non-numerical values (2 decimal points)
SELECT average_hourly_earnings
FROM employee
WHERE average_hourly_earnings NOT REGEXP '^[0-9]+(\.[0-9]{1,2})?$'; -- 2 decimal points

--   Change non-numerical values to NULL
UPDATE employee
SET average_hourly_earnings = NULL
WHERE average_hourly_earnings NOT REGEXP '^[0-9]+(\.[0-9]{1,2})?$'; -- 2 decimal points

--   Change data type
ALTER TABLE employee
MODIFY average_hourly_earnings DECIMAL(10,2); -- 2 decimal points

-- Fix column data type in electricity_generation table: generation_year, actual_generation_gwh and estimated_generation_gwh 
--   Fix generation_year
--      Create temporary column for generation_year
ALTER TABLE electricity_generation
ADD COLUMN temp_generation_year INT;

--   Extracts the first 4 characters from the non-empty value or from NULL
--   Covert extracted value to integer
--   Assign to temporary column
UPDATE electricity_generation
SET temp_generation_year = CAST(LEFT(NULLIF(generation_year, ''), 4) AS UNSIGNED);

--   Drop original column
ALTER TABLE electricity_generation 
DROP COLUMN generation_year;

--   Change name of temporary column
ALTER TABLE electricity_generation 
CHANGE temp_generation_year generation_year INT;

--   Move column to original places
ALTER TABLE electricity_generation
MODIFY generation_year INT AFTER power_plant_id;

-- Fix actual_generation_gwh
--   Check non-numerical values (4 decimal points)
SELECT actual_generation_gwh
FROM electricity_generation
WHERE actual_generation_gwh NOT REGEXP '^[0-9]+(\.[0-9]{1,4})?$'; -- 4 decimal points

--   Count non-numerical values
SELECT count(*)
FROM electricity_generation
WHERE actual_generation_gwh NOT REGEXP '^[0-9]+(\.[0-9]{1,4})?$'; -- 4 decimal points

--   Change non-numerical values to null
UPDATE electricity_generation
SET actual_generation_gwh = NULL
WHERE actual_generation_gwh NOT REGEXP '^[0-9]+(\.[0-9]{1,4})?$'; -- 4 decimal points

--   Change data type
ALTER TABLE electricity_generation
MODIFY actual_generation_gwh DECIMAL(10,4); -- 4 decimal points


-- Fix estimated_generation_gwh
--   Check non-numerical values (4 decimal points)
SELECT estimated_generation_gwh
FROM electricity_generation
WHERE estimated_generation_gwh NOT REGEXP '^[0-9]+(\.[0-9]{1,2})?$'; -- 2 decimal points

--   Count non-numerical values
SELECT count(*)
FROM electricity_generation
WHERE estimated_generation_gwh NOT REGEXP '^[0-9]+(\.[0-9]{1,2})?$'; -- 2 decimal points

--   Change non-numerical values to null
UPDATE electricity_generation
SET estimated_generation_gwh = NULL
WHERE estimated_generation_gwh NOT REGEXP '^[0-9]+(\.[0-9]{1,4})?$'; -- 2 decimal points

--   Change data type
ALTER TABLE electricity_generation
MODIFY estimated_generation_gwh DECIMAL(10,4); -- 2 decimal points




-- Random : Queries
--   Count the Total Rows in Each Table
SELECT 'power_plant' AS table_name, COUNT(*) AS total_rows FROM power_plant
UNION ALL
SELECT 'electricity_generation', COUNT(*) FROM electricity_generation
UNION ALL
SELECT 'employee', COUNT(*) FROM employee
UNION ALL
SELECT 'co2_emissions', COUNT(*) FROM co2_emissions
UNION ALL
SELECT 'country', COUNT(*) FROM country
UNION ALL
SELECT 'fuel_type', COUNT(*) FROM fuel_type;

--   Count the Rows with NULL Values
SELECT COUNT(*) AS null_commissioning_year 
FROM power_plant 
WHERE commissioning_year IS NULL;

SELECT COUNT(*) AS null_actual_generation 
FROM electricity_generation 
WHERE actual_generation_gwh IS NULL;

SELECT COUNT(*) AS null_country_id 
FROM power_plant 
WHERE country_id IS NULL;

--   Find Rows with Negative Values
SELECT * 
FROM electricity_generation 
WHERE actual_generation_gwh < 0 OR estimated_generation_gwh < 0;

--   Get Top 10 Records from Each Table
SELECT * 
FROM power_plant LIMIT 10;

SELECT * 
FROM electricity_generation LIMIT 10;

SELECT * 
FROM employee LIMIT 10;

SELECT * 
FROM co2_emissions LIMIT 10;


-- Test Join Between Tables
SELECT pp.name AS power_plant_name, eg.actual_generation_gwh, ft.fuel_type
FROM power_plant pp
JOIN electricity_generation eg ON pp.power_plant_id = eg.power_plant_id
JOIN fuel_type ft ON pp.fuel_type_id = ft.fuel_type_id
LIMIT 10;

-- Find Top 5 Power Plants by Capacity
SELECT name, capacity_mw
FROM power_plant
ORDER BY capacity_mw DESC
LIMIT 5;

-- Find the Average Generation (Actual and Estimated) Per Year
SELECT generation_year, 
       AVG(actual_generation_gwh) AS avg_actual_generation,
       AVG(estimated_generation_gwh) AS avg_estimated_generation
FROM electricity_generation
GROUP BY generation_year
ORDER BY generation_year;

-- Count Power Plants by Country
SELECT c.country_name, COUNT(pp.power_plant_id) AS total_power_plants
FROM power_plant pp
JOIN country c ON pp.country_id = c.country_id
GROUP BY c.country_name
ORDER BY total_power_plants DESC
LIMIT 10;

--  Check Employees by Fuel Type
SELECT ft.fuel_type, SUM(e.total_employees) AS total_employees, AVG(e.average_hourly_earnings) AS avg_hourly_earnings
FROM employee e
JOIN fuel_type ft ON e.fuel_type_id = ft.fuel_type_id
GROUP BY ft.fuel_type
ORDER BY total_employees DESC;

-- Check for Duplicates in Key Columns
SELECT gppd_idnr, COUNT(*) AS count 
FROM power_plant 
GROUP BY gppd_idnr 
HAVING count > 1;

SELECT generation_id, COUNT(*) AS count 
FROM electricity_generation 
GROUP BY generation_id 
HAVING count > 1;
