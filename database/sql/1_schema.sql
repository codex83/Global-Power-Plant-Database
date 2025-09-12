/***********************************************
**                MSc ANALYTICS 
**     DATA ENGINEERING PLATFORMS (MSADS 31012)
** File:   Final Project - Global Power Plant Database
** Desc:   Creating Global Power Plant Database
** Auth:   Aarav Vishesh Dewangan, Bruna Medeiros, Halleluya Mengesha, Hritik Jhaveri, Veera Anand
** Date:   11/22/2024
************************************************/

-- Step 1: Create Database
CREATE DATABASE IF NOT EXISTS globalpowerplant;

-- Step 2: Use the Created Database
USE globalpowerplant;

-- Step 3: Create Tables

-- Create Country Table
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_code VARCHAR(3) NOT NULL UNIQUE,
    country_name VARCHAR(100) NOT NULL
);

-- Create Fuel Type Table
CREATE TABLE fuel_type (
    fuel_type_id INT AUTO_INCREMENT PRIMARY KEY,
    fuel_type VARCHAR(100) NOT NULL UNIQUE
);

-- Create Power Plant Table
CREATE TABLE power_plant (
    power_plant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    gppd_idnr VARCHAR(50) NOT NULL UNIQUE,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    commissioning_year VARCHAR(10),  -- Import as string
    capacity_mw DECIMAL(12,4),
    owner VARCHAR(255),
    source VARCHAR(255),
    url VARCHAR(500),
    geolocation_source VARCHAR(255),
    wepp_id VARCHAR(50),
    year_of_capacity_data VARCHAR(10),  -- Import as string
    country_id INT NOT NULL,
    fuel_type_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (fuel_type_id) REFERENCES fuel_type(fuel_type_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create Employee Table
CREATE TABLE employee (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    average_hourly_earnings VARCHAR(20),
    total_employees INT,
    total_women_employees INT,
    fuel_type_id INT NOT NULL,
    FOREIGN KEY (fuel_type_id) REFERENCES fuel_type(fuel_type_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create CO2 Emissions Table
CREATE TABLE co2_emissions (
    emission_id INT AUTO_INCREMENT PRIMARY KEY,
    fuel_type_id INT NOT NULL,
    kg_CO2_per_mmBtu DECIMAL(12,4),
    kg_CO2_per_gwh DECIMAL(12,4),
    FOREIGN KEY (fuel_type_id) REFERENCES fuel_type(fuel_type_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create Electricity Generation Table
CREATE TABLE electricity_generation (
    generation_id INT AUTO_INCREMENT PRIMARY KEY,
    power_plant_id INT NOT NULL,
    generation_year VARCHAR(4) NOT NULL,
    actual_generation_gwh VARCHAR(20),
    estimated_generation_gwh VARCHAR(20),
    generation_note VARCHAR(255),
    FOREIGN KEY (power_plant_id) REFERENCES power_plant(power_plant_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
