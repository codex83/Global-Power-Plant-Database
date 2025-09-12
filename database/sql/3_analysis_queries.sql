## Query 1
# Identifying Renewable Energy Hotspots
SELECT
   c.country_name,
   p.name AS power_plant_name,
   ft.fuel_type,
   p.capacity_mw,
   p.latitude,
   p.longitude
FROM
   power_plant p
JOIN
   fuel_type ft ON p.fuel_type_id = ft.fuel_type_id
JOIN
   country c ON p.country_id = c.country_id
WHERE
   ft.fuel_type IN ('solar', 'wind', 'hydro')
ORDER BY
   p.capacity_mw DESC;

## Query 2
# CO2 Emissions trend
SELECT
   pp.power_plant_id,
   c.country_code,
   eg.generation_year,
   ft.fuel_type,
   ROUND(ce.kg_CO2_per_gwh * eg.actual_generation_gwh, 4) AS emmisions
FROM
 co2_emissions ce
   JOIN
 fuel_type ft ON ft.fuel_type_id = ce.fuel_type_id
       JOIN
   power_plant pp ON pp.fuel_type_id = ft.fuel_type_id
   JOIN
   country c ON c.country_id = pp.country_id
   JOIN
 electricity_generation eg ON pp.power_plant_id = eg.power_plant_id
WHERE
 c.country_code = 'USA'
   AND ROUND(ce.kg_CO2_per_gwh * eg.actual_generation_gwh, 4) != 0
ORDER BY
 emmisions DESC;

## Query 3
# Total employees for different fuel types each year in the US
SELECT
 YEAR(e.date) AS year,
 SUM(e.total_employees) AS total_employees_per_fuel_type,
 ft.fuel_type
FROM
 employee e
JOIN
 fuel_type ft
ON
 ft.fuel_type_id = e.fuel_type_id
GROUP BY
 year,
 ft.fuel_type
ORDER BY
 year DESC;

## Query 4
# Comparision of Male and Female Empployees based on fuel type
SELECT
 SUM(e.total_women_employees) AS total_women_by_fuel_type,
 (SUM(e.total_women_employees) / SUM(e.total_employees)) * 100
 AS percentage_female_employees,
 100-(SUM(e.total_women_employees) / SUM(e.total_employees)) * 100
 AS percentage_male_employees,
 f.fuel_type
FROM
 employee e
INNER JOIN
 fuel_type f
ON
 e.fuel_type_id = f.fuel_type_id
GROUP BY
 e.fuel_type_id,
 f.fuel_type
ORDER BY
 total_women_by_fuel_type DESC;
