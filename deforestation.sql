** I highlighted everything in red that was changed. Thank you for your time! :)
Report for ForestQuery into Global Deforestation, 1990 to 2016 
ForestQuery is on a mission to combat deforestation around the world and to raise awareness about this topic and its impact on the environment. The data analysis team at ForestQuery has obtained data from the World Bank that includes forest area and total land area by country and year from 1990 to 2016, as well as a table of countries and the regions to which they belong.

The data analysis team has used SQL to bring these tables together and to query them in an effort to find areas of concern as well as areas that present an opportunity to learn from successes.

1. GLOBAL SITUATION
According to the World Bank, the total forest area of the world was _41282694.9_ in 1990. As of 2016, the most recent year for which data was available, that number had fallen to _39958245.9_, a loss of _1324449_, or _3.20824258980244_%.

The forest area lost over this time period is slightly more than the entire land area of _PERU_ listed for the year 2016 (which is _1279999.9891 sqkm_).

2. REGIONAL OUTLOOK
In 2016, the percent of the total land area of the world designated as forest was _31.38_. The region with the highest relative forestation was_Latin America & Caribbean_, with _46.16_%, and the region with the lowest relative forestation was _Middle East & North Africa_, with _2.07_% forestation.

In 1990, the percent of the total land area of the world designated as forest was _32.42_. The region with the highest relative forestation was_Latin America & Caribbean_, with _51.03_%, and the region with the lowest relative forestation was _Middle East & North Africa_, with _1.78_% forestation.







Table 2.1: Percent Forest Area by Region, 1990 & 2016:

Region
1990 Forest Percentage
2016 Forest Percentage
World
32.42
31.38
Latin America & Caribbean
51.03
46.16
Middle East & North Africa
1.78
2.07



The only regions of the world that decreased in percent forest area from 1990 to 2016 were _Latin America & Caribbean_ (dropped from _51.03_% to _46.16_%) and _Sub-Saharan Africa_ (_30.67_% to _28.79_%). All other regions actually increased in forest area over this time period. However, the drop in forest area in the two aforementioned regions was so large, the percent forest area of the world decreased over this time period from _32.42_% to _31.38_%. 

3. COUNTRY-LEVEL DETAIL
SUCCESS STORIES
There is one particularly bright spot in the data at the country level, _China_. This country actually increased in forest area from 1990 to 2016 by _527229.06_. It would be interesting to study what has changed in this country over this time to drive this figure in the data higher. The country with the next largest increase in forest area from 1990 to 2016 was the_United States_, but it only saw an increase of 79200_, much lower than the figure for _China_.

_China_ and _United States_ are of course very large countries in total land area, so when we look at the largest percent change in forest area from 1990 to 2016, we aren’t surprised to find a much smaller country listed at the top. _Iceland_ increased in forest area by _213.66_% from 1990 to 2016. 

LARGEST CONCERNS
Which countries are seeing deforestation to the largest degree? We can answer this question in two ways. First, we can look at the absolute square kilometer decrease in forest area from 1990 to 2016. The following 3 countries had the largest decrease in forest area over the time period under consideration:

Table 3.1: Top 5 Amount Decrease in Forest Area by Country, 1990 & 2016:

Country
Region
Absolute Forest Area Change
Brazil
Latin America & Caribbean
541510
Indonesia
East Asia & Pacific
282193.98
Myanmar
East Asia & Pacific
107234



The second way to consider which countries are of concern is to analyze the data by percent decrease.

Table 3.2: Top 5 Percent Decrease in Forest Area by Country, 1990 & 2016:

Country
Region
Pct Forest Area Change
Togo
Sub-Saharan Africa
75.45
Nigeria
Sub-Saharan Africa
61.8
Uganda
Sub-Saharan Africa
28092



When we consider countries that decreased in forest area percentage the most between 1990 and 2016, we find that four of the top 5 countries on the list are in the region of _Sub-Saharan Africa_. The countries are _Togo_, _Nigeria_, _Uganda_, and _Mauritania_. The 5th country on the list is _Honduras_, which is in the _Latin America & Caribbean_ region. 

From the above analysis, we see that _Nigeria_ is the only country that ranks in the top 5 both in terms of absolute square kilometer decrease in forest as well as percent decrease in forest area from 1990 to 2016. Therefore, this country has a significant opportunity ahead to stop the decline and hopefully spearhead remedial efforts.

QUARTILES




Table 3.3: Count of Countries Grouped by Forestation Percent Quartiles, 2016:

Quartile
Number of Countries
Q1 0-25%
85
Q2 25-50%
73
Q3 50-75%
38
Q4 75-100%
9


The largest number of countries in 2016 were found in the _Q1 0-25%_ quartile.

There were _9_ countries in the top quartile in 2016. These are countries with a very high percentage of their land area designated as forest. The following is a list of countries and their respective forest land denoted as a percentage.

Table 3.4: Top Quartile Countries, 2016:
 
Country
Region
Pct Designated as Forest
Suriname
Latin America & Caribbean
98.26
Micronesia, Fed. Sts.
East Asia & Pacific
91.86
Gabon
Sub-Saharan Africa
90.04


4. RECOMMENDATIONS

What I have learned from this analysis of deforestation is how quickly the forest area can decrease. On the contrary, how quickly it can recover. My recommendation is to perform a deeper investigation on the regions that are losing forest area, as well as regions that are increasing in the forest area. 
Investigate the regions with a negative loss: Latin America & Caribbean, East Asia & Pacific, and Sub-Saharan Africa.
Investigate the regions with a positive gain: East Asia & Pacific, North America, and Europe & Central Asia 
Pay special attention to Iceland for they have had a positive increase of 213% of forest area. 










5. SQL Appendix 
DISCLAIMER: The Udacity Project workspace did not work for me for the majority of this project. The workaround I used was downloading the CSV files and importing them into MS SQL Server. The syntax may be slightly off. I did my best to clean it up to Postgress SQL syntax. 

1. GLOBAL SITUATION
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

a. What was the total forest area (in sq km) of the world in 1990? Please keep in mind that you can use the country record denoted as “World" in the region table.
--Total forest area 1990
SELECT f_year, SUM(forest_area_sqkm) AS total_forest_area
FROM forestation
WHERE r_country_name = 'World' AND f_year = 1990
GROUP BY f_year;

b. What was the total forest area (in sq km) of the world in 2016? Please keep in mind that you can use the country record in the table is denoted as “World.”
--Total forest area 2016
SELECT f_year, SUM(forest_area_sqkm) AS total_forest_area
FROM forestation
WHERE r_country_name = 'World' AND f_year = 2016
GROUP BY f_year;
 

c. What was the change (in sq km) in the forest area of the world from 1990 to 2016?

--code adjusted for resubmission 
SELECT a.forest_area_sqkm - b.forest_area_sqkm as diff
FROM forestation a
JOIN forestation b
ON a.f_country_name = b.f_country_name
WHERE a.region = 'World' AND b.region = 'World'
AND a.f_year = 1990 AND b.f_year = 2016;


d. What was the percent change in the forest area of the world between 1990 and 2016?
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

e. If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to?
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



2. REGIONAL OUTLOOK
Instructions:
Answering these questions will help you add information into the template.
Use these questions as guides to write SQL queries.
Use the output from the query to answer these questions.
Create a table that shows the Regions and their percent forest area (sum of forest area divided by the sum of land area) in 1990 and 2016. (Note that 1 sq mi = 2.59 sq km).
Based on the table you created,...
a. What was the percent forest of the entire world in 2016? Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places?
--find the total world forest percentage in 2016
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



 
b. What was the percent forest of the entire world in 1990? Which region had the HIGHEST percent forest in 1990, and which had the LOWEST, to 2 decimal places?
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

 
 
 
 
 
 
 
 
c. Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016?
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


3. COUNTRY-LEVEL DETAIL
Instructions:
Answering these questions will help you add information to the template.
Use these questions as guides to write SQL queries.
Use the output from the query to answer these questions.
a. Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each?


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



b. Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change to 2 decimal places for each?
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



c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?
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


d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.
--code adjusted for resubmission 
SELECT f_country_name, region, ROUND((percent_forest_area):: DECIMAL, 2) AS percent
FROM forestation
WHERE percent_forest_area > 75
AND f_year = 2016
ORDER BY percent_forest_area DESC;

--This is so funny to me! I was WAY overthinking it, thanks for the tip!


e. How many countries had a percent forestation higher than the United States in 2016?
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







