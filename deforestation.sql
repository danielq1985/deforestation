--Create main view
CREATE VIEW forestation
AS
SELECT f.country_code AS f_country_code, f.country_name AS f_country_name, 
f.year AS f_year, f.forest_area_sqkm,
		l.country_code AS l_country_code, 
l.country_code AS l_country_name, 
l.year as l_year, 
l.total_area_sq_mi * 2.59 AS total_area_sqkm,
	             r.country_name AS r_country_name, 
r.country_code AS r_country_code, 
r.region, r.income_group,

	(f.forest_area_sqkm) / (l.total_area_sq_mi * 2.59) * 100 AS percent_forest_area

  FROM forest_area f 
  JOIN land_area l
  ON f.country_code = l.country_code AND f.year = l.year
  JOIN regions r
  ON l.country_code = r.country_code;

--What was the total forest area (in sq km) of the world in 1990? 
--Total forest area 1990
SELECT f_year, SUM(forest_area_sqkm) AS total_forest_area
FROM forestation
WHERE r_country_name = 'World' AND f_year = 1990
GROUP BY f_year;

--What was the total forest area (in sq km) of the world in 2016?
--Total forest area 2016
SELECT f_year, SUM(forest_area_sqkm) AS total_forest_area
FROM forestation
WHERE r_country_name = 'World' AND f_year = 2016
GROUP BY f_year;
 
--What was the change (in sq km) in the forest area of the world from 1990 to 2016?
SELECT a.forest_area_sqkm - b.forest_area_sqkm as diff
FROM forestation a
JOIN forestation b
ON a.f_country_name = b.f_country_name
WHERE a.region = 'World' AND b.region = 'World'
AND a.f_year = 1990 AND b.f_year = 2016;

--What was the percent change in the forest area of the world between 1990 and 2016?
--change from 1990 to 2016 in %
SELECT 
	(SELECT SUM(forest_area_sqkm) - 
    	(SELECT SUM(forest_area_sqkm)
		FROM forestation
		WHERE f_year = 2016 AND f_country_name ='World'
		) AS total_loss
	FROM forestation
	WHERE f_year = 1990 AND f_country_name ='World'
	) / SUM(forest_area_sqkm) * 100 AS percent_loss
FROM forestation
WHERE f_year = 1990 AND f_country_name ='World';

--If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to?
--find country closest to 1324449
SELECT f_country_name, total_area_sqkm
FROM forestation
WHERE total_area_sqkm BETWEEN 
	(SELECT SUM(forest_area_sqkm) - 
		(SELECT SUM(forest_area_sqkm)
		FROM forestation
		WHERE f_year = 2016 AND f_country_name ='World') AS total_loss
	FROM forestation
	WHERE f_year = 1990 AND f_country_name ='World') - 50000
AND
(SELECT SUM(forest_area_sqkm) - 
	(SELECT SUM(forest_area_sqkm)
	FROM forestation
	WHERE f_year = 2016 AND f_country_name ='World') AS total_loss
FROM forestation
WHERE f_year = 1990 AND f_country_name ='World') + 50000
AND f_year = 2016;

--What was the percent forest of the entire world in 2016? Which region had the HIGHEST percent forest in 2016, and which had the LOWEST?
SELECT ROUND((percent_forest_area):: DECIMAL, 2) forest_percent
FROM forestation
WHERE f_year = 2016 AND f_country_name = 'World';

--region with the highest forest percent in 2016
SELECT region, ROUND((SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100) :: DECIMAL, 2) AS forest_area_percent
FROM forestation
WHERE f_year = 2016
GROUP BY region
ORDER BY forest_area_percent DESC
LIMIT 1;

--region with the lowest forest percent in 2016
SELECT region, ROUND((SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100):: DECIMAL, 2) AS forest_area_percent
FROM forestation
WHERE f_year = 2016
GROUP BY region
ORDER BY forest_area_percent
LIMIT 1;

--What was the percent forest of the entire world in 1990? Which region had the HIGHEST percent forest in 1990, and which had the LOWEST?
--find the total world forest percentage in 1990
SELECT ROUND((forest_area_sqkm / total_area_sqkm * 100):: DECIMAL, 2) AS forest_percent
FROM forestation
WHERE f_country_name = 'World' AND f_year = 1990

--region with the highest forest percent in 1990
SELECT region, ROUND((SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100):: DECIMAL, 2) AS forest_area_percent
FROM forestation
WHERE f_year = 1990
GROUP BY region
ORDER BY forest_area_percent DESC
LIMIT 1;

--region with the lowest forest percent in 1990
SELECT region, ROUND((SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100)::DECIMAL, 2) AS forest_area_percent
FROM forestation
WHERE f_year = 1990
GROUP BY region
ORDER BY forest_area_percent
LIMIT 1;

--Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016?
--create a table of decreased forest area from 1990 to 2016. Add extra columns for easy filtering
WITH t1 AS 
(
SELECT region, ROUND((SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100)::DECIMAL, 2) AS forest_percent_1990
FROM forestation
WHERE f_year = 1990
GROUP BY region
),

t2 AS
(
SELECT region, ROUND((SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100)::DECIMAL, 2) AS forest_percent_2016
FROM forestation
WHERE f_year = 2016
GROUP BY region
)

SELECT t1.region, forest_percent_1990, forest_percent_2016, 
CASE WHEN forest_percent_2016 > forest_percent_1990 THEN 'Increased' 
ELSE 'Decreased' END AS inc_decr
FROM t1
JOIN t2 
ON t1.region = t2.region 
ORDER BY forest_percent_1990 DESC;

--Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each?
WITH t1 AS
(
SELECT f_country_name, f_year, region, SUM(forest_area_sqkm) AS forest_area_1990
FROM forestation
WHERE f_year = 1990
GROUP BY f_country_name, f_year, region
),

t2 AS
(
SELECT f_country_name, f_year, region, SUM(forest_area_sqkm) AS forest_area_2016
FROM forestation
WHERE f_year = 2016
GROUP BY f_country_name, f_year, region
),
t3 AS
(

SELECT t1.f_country_name, t1.region, forest_area_1990, forest_area_2016, 
	CASE WHEN forest_area_1990 > forest_area_2016 THEN
	ROUND((forest_area_1990 - forest_area_2016)::DECIMAL, 2) 
	END AS decreased_area,
	CASE WHEN forest_area_1990 > forest_area_2016 THEN
	ROUND(((forest_area_1990 -  forest_area_2016) / forest_area_1990 * 100)::DECIMAL, 2)
	END AS decreased_percent,
	CASE WHEN forest_area_1990 < forest_area_2016 THEN
	ROUND((forest_area_2016 - forest_area_1990)::DECIMAL, 2)
	END AS increased_area,
	CASE WHEN forest_area_1990 < forest_area_2016 THEN
	ROUND(((forest_area_2016 - forest_area_1990) /forest_area_1990 * 100)::DECIMAL, 2) 
	END AS increased_percent
FROM t1
JOIN t2
ON t1.f_country_name = t2.f_country_name
WHERE t1.f_country_name != 'World' AND forest_area_1990 IS NOT NULL AND forest_area_2016 IS NOT NULL
)
SELECT * FROM t3
WHERE decreased_area IS NOT NULL
ORDER BY decreased_area DESC
LIMIT 5;

--Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change?
WITH t1 AS
(
SELECT f_country_name, f_year, region, SUM(forest_area_sqkm) AS forest_area_1990
FROM forestation
WHERE f_year = 1990
GROUP BY f_country_name, f_year, region
),

t2 AS
(
SELECT f_country_name, f_year, region, SUM(forest_area_sqkm) AS forest_area_2016
FROM forestation
WHERE f_year = 2016
GROUP BY f_country_name, f_year, region
),
t3 AS
(

SELECT t1.f_country_name, t1.region, forest_area_1990, forest_area_2016, 
	CASE WHEN forest_area_1990 > forest_area_2016 THEN
	ROUND((forest_area_1990 - forest_area_2016)::DECIMAL, 2) 
	END AS decreased_area,
	CASE WHEN forest_area_1990 > forest_area_2016 THEN
	ROUND(((forest_area_1990 -  forest_area_2016) / forest_area_1990 * 100)::DECIMAL, 2)
	END AS decreased_percent,
	CASE WHEN forest_area_1990 < forest_area_2016 THEN
	ROUND((forest_area_2016 - forest_area_1990)::DECIMAL, 2)
	END AS increased_area,
	CASE WHEN forest_area_1990 < forest_area_2016 THEN
	ROUND(((forest_area_2016 - forest_area_1990) /forest_area_1990 * 100)::DECIMAL, 2) 
	END AS increased_percent
FROM t1
JOIN t2
ON t1.f_country_name = t2.f_country_name
WHERE t1.f_country_name != 'World' AND forest_area_1990 IS NOT NULL AND forest_area_2016 IS NOT NULL
)
SELECT * FROM t3
WHERE decreased_area IS NOT NULL
ORDER BY decreased_percent DESC
LIMIT 5;

--If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?
WITH t1 AS
(
SELECT f_country_name, ROUND((SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100)::DECIMAL, 2) as forest_percent
FROM forestation
WHERE f_year = '2016'
GROUP BY f_country_name

)

SELECT quartiles, COUNT(*) AS quartile_count
FROM
(
SELECT f_country_name, forest_percent, 
		CASE WHEN forest_percent <= 25 THEN 'Q1 0-25%'
		WHEN forest_percent BETWEEN 25 AND 50 THEN 'Q2 25-50%'
		WHEN forest_percent BETWEEN 50 AND 75 THEN 'Q3 50-75%'
		ELSE 'Q4 75-100%'
		END AS quartiles
FROM t1
WHERE forest_percent IS NOT NULL) AS x
GROUP BY quartiles;


--List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.
SELECT f_country_name, region, ROUND((percent_forest_area):: DECIMAL, 2) AS percent
FROM forestation
WHERE percent_forest_area > 75
AND f_year = 2016
ORDER BY percent_forest_area DESC;

--How many countries had a percent forestation higher than the United States in 2016?
WITH t1 AS
(
SELECT f_country_name, ROUND((SUM(forest_area_sqkm) / SUM(total_area_sqkm) * 100)::DECIMAL, 2) as forest_percent
FROM forestation
WHERE f_year = '2016'
GROUP BY f_country_name

)

SELECT COUNT(*)
FROM t1
WHERE forest_percent > 
	(
	SELECT forest_percent
	FROM t1
	WHERE f_country_name = 'United States'
	);
