select * from coviddeaths
where continent is not null
order by 3,4;


-- select data that we use

select country,date,total_cases, new_cases,total_deaths, population
from coviddeaths
order by 1,2;

-- looking at total cases vs total deaths
-- show likelihood of dying in a country
select country,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from coviddeaths
where country like '%United%'
order by 1,2;

--looking at total cases vs populations
-- what percentage of population got Covid
select country,date,total_cases,population, (total_cases/population)*100 as PercentagePopulationInfected
from coviddeaths
where country like '%States%'
order by 1,2;

-- countries with highest infections
select country,population,max(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
from coviddeaths
group by country,population
order by PercentagePopulationInfected desc;

-- Showing countries with highest death count per poulation
select country,max(total_deaths) as TotalDeathCount
from coviddeaths
where continent is not null
group by country
order by TotalDeathCount desc;

-- breaking to continent

-- showing continents with the highest death
select continent,max(total_deaths) as TotalDeathCount
from coviddeaths
where continent is not null
group by continent
order by TotalDeathCount desc;

-- Global numbers
select sum(new_cases) as total_cases,sum(new_deaths) as total_deaths,sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
from coviddeaths
where continent is not null
--group by date
order by 1,2;

--looking at total poulation vs vaccinations
select * from coviddeaths dea
join covidvaccination vac
	on dea.country=vac.country
	and dea.date=vac.date;


-- Looking at human development index vs death percentage

SELECT 
    coviddeaths.country,
    SUM(coviddeaths.new_deaths)*100/SUM(coviddeaths.new_cases) AS death_percentage,
	
    covidvaccination.human_development_index
FROM 
    coviddeaths
LEFT JOIN 
    covidvaccination
ON 
    coviddeaths.country = covidvaccination.country
WHERE 
	human_development_index is not null
	AND coviddeaths.continent = 'Europe'
	
GROUP BY 
    coviddeaths.country, covidvaccination.human_development_index
HAVING 
	SUM(coviddeaths.new_deaths)*100/SUM(coviddeaths.new_cases) IS NOT NULL
ORDER BY death_percentage DESC;

-- Looking at life expectancy vs human develpment index
SELECT
	country,
	ROUND(AVG(life_expectancy),2) AS avg_life_expectancy,
	ROUND(AVG(human_development_index),2) AS avg_human_development
FROM	covidvaccination
GROUP BY 
	country
HAVING
	AVG(life_expectancy) IS NOT NULL
	AND AVG(human_development_index) IS NOT NULL
ORDER BY avg_life_expectancy DESC;

--LOOKING AT VACCINE DISTRIBUTION AND NEW DEATH AND NEW CASES(US)
SELECT 
	coviddeaths.country,
	coviddeaths.date,
	coviddeaths.new_deaths,
	coviddeaths.new_cases,
	covidvaccination.new_vaccinations
FROM
	coviddeaths
LEFT JOIN 
	covidvaccination
ON 
	coviddeaths.country=covidvaccination.country
	AND coviddeaths.date = covidvaccination.date
WHERE 
	coviddeaths.country='United States'
	AND coviddeaths.new_deaths IS NOT NULL;


-- looking at smoking prevelance and diabetes with death rate
SELECT 
	coviddeaths.country,
	ROUND((SUM(coviddeaths.new_deaths)*100/SUM(coviddeaths.new_cases)),2) AS death_rate,
	covidvaccination.diabetes_prevalence,
	covidvaccination.female_smokers,
	covidvaccination.male_smokers
FROM
	coviddeaths
LEFT JOIN 
	covidvaccination
ON 
	coviddeaths.country=covidvaccination.country
WHERE
	coviddeaths.continent is not null
	AND coviddeaths.new_deaths IS NOT NULL
	AND coviddeaths.new_cases IS NOT NULL
    AND covidvaccination.diabetes_prevalence IS NOT NULL
    AND covidvaccination.female_smokers IS NOT NULL
    AND covidvaccination.male_smokers IS NOT NULL
GROUP BY 
 coviddeaths.country,covidvaccination.diabetes_prevalence,covidvaccination.female_smokers,covidvaccination.male_smokers;

 --Looking at countries with highest death counts
select
    country,SUM(new_deaths) as TotalDeathCount
from
    coviddeaths
where
    continent is not null
    
group by
    country
HAVING 
    max(total_deaths) IS NOT NULL
    AND max(total_deaths)>1000
order by
    TotalDeathCount desc;
--LOOKING AT VACCINE DISTRIBUTION AND NEW DEATH AND NEW CASES(Germany)
SELECT 
	coviddeaths.country,
	coviddeaths.date,
	coviddeaths.new_deaths,
	coviddeaths.new_cases,
	covidvaccination.new_vaccinations
FROM
	coviddeaths
LEFT JOIN 
	covidvaccination
ON 
	coviddeaths.country=covidvaccination.country
	AND coviddeaths.date = covidvaccination.date
WHERE 
	coviddeaths.country='Germany'
	AND coviddeaths.new_deaths IS NOT NULL;
--OOKING AT VACCINE DISTRIBUTION AND NEW DEATH AND NEW CASES(US)
SELECT 
	coviddeaths.country,
	coviddeaths.date,
	coviddeaths.new_deaths,
	coviddeaths.new_cases,
	covidvaccination.new_vaccinations
FROM
	coviddeaths
LEFT JOIN 
	covidvaccination
ON 
	coviddeaths.country=covidvaccination.country
	AND coviddeaths.date = covidvaccination.date
WHERE 
	coviddeaths.country='United States'
	AND coviddeaths.new_deaths IS NOT NULL;

--Male smoking % VS death rate
SELECT 
	coviddeaths.country,
	ROUND((SUM(coviddeaths.new_deaths)*100/SUM(coviddeaths.new_cases)),2) AS death_rate,
	covidvaccination.diabetes_prevalence,
	covidvaccination.female_smokers,
	covidvaccination.male_smokers
FROM
	coviddeaths
LEFT JOIN 
	covidvaccination
ON 
	coviddeaths.country=covidvaccination.country
WHERE
	coviddeaths.continent is not null
	AND coviddeaths.new_deaths IS NOT NULL
	AND coviddeaths.new_cases IS NOT NULL
    AND covidvaccination.diabetes_prevalence IS NOT NULL
    AND covidvaccination.female_smokers IS NOT NULL
    AND covidvaccination.male_smokers IS NOT NULL
GROUP BY 
 coviddeaths.country,covidvaccination.diabetes_prevalence,covidvaccination.female_smokers,covidvaccination.male_smokers
 HAVING 
    coviddeaths.country IN ('United States','Germany','Spain','Canada','Iran','Yemen','Japan','India','Turkey')
Order by 
    death_rate;

--Human development index greater than 0.8
WITH categorized_countries AS (
    SELECT
        country,
        CASE 
            WHEN AVG(human_development_index) > 0.8 THEN 'HDI > 0.8'
            ELSE 'HDI ≤ 0.8'
        END AS category
    FROM 
        covidvaccination
    WHERE 
        continent IS NOT NULL
        AND continent = 'Asia'
    GROUP BY 
        country
    HAVING 
        AVG(human_development_index) IS NOT NULL
)
SELECT 
    category,
    COUNT(country) AS country_count,
    ROUND(COUNT(country) * 100.0 / SUM(COUNT(country)) OVER (), 2) AS percentage
FROM 
    categorized_countries
GROUP BY 
    category;
--life expectancy greater than 75 yrs
WITH categorized_countries AS (
    SELECT
        country,
        CASE 
            WHEN AVG(life_expectancy) > 75 THEN 'Life Expectancy > 75'
            ELSE 'Life Expectancy ≤ 75'
        END AS category
    FROM 
        covidvaccination
    WHERE 
        continent IS NOT NULL
        AND continent = 'Asia'
    GROUP BY 
        country
    HAVING 
        AVG(life_expectancy) IS NOT NULL
)
SELECT 
    category,
    COUNT(country) AS country_count,
    ROUND(COUNT(country) * 100.0 / SUM(COUNT(country)) OVER (), 2) AS percentage
FROM 
    categorized_countries
GROUP BY 
    category;
--
SELECT 
	coviddeaths.country,
	coviddeaths.date,
	coviddeaths.new_deaths,
	coviddeaths.new_cases,
	covidvaccination.new_vaccinations
FROM
	coviddeaths
LEFT JOIN 
	covidvaccination
ON 
	coviddeaths.country=covidvaccination.country
	AND coviddeaths.date = covidvaccination.date
WHERE 
	coviddeaths.country='Iran'
	AND coviddeaths.new_deaths IS NOT NULL;