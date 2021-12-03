-- What is the relationship between a country’s GDP, HDI level, coronavirus death counts? (can't find data on hospitalization for covid19 (the data provided by the set is a general hospitalization)) 
-- More developed countries usually have better healthcare systems (hospital beds, life expectancy) and easier access to personal protection equipment (PPE).

-- population density vs. total cases rising rate
-- aged_65_older vs. fatality_rate and diagnosis_rate (= total_cases/population)


SET SEARCH_PATH TO covid19;
DROP TABLE IF exists demographicVScorona CASCADE;

CREATE TABLE demographicVScorona(
    iso_code VARCHAR(8),
	countryName TEXT NOT NULL, 
    gdp_per_capita FLOAT NOT NULL,
    population BIGINT NOT NULL,
    deaths_rate decimal, -- upto the point when we downloaded the data (total_death_rate = total_death / population)
    diagnosed_rate decimal, -- diagnosed_rate = total_cases/population
    fatality_rate decimal, -- upto the point when we downloaded the data
    human_development_index FLOAT,
    aged_65_older FLOAT,
    population_density FLOAT
);

DROP VIEW IF EXISTS deathrate CASCADE;
DROP VIEW IF EXISTS diagnoserate CASCADE;
DROP VIEW IF EXISTS finalFatalityRate CASCADE;
-- DROP VIEW IF EXISTS xx CASCADE;
-- DROP VIEW IF EXISTS xx CASCADE;


-- Compute total death rate
CREATE VIEW deathRate AS
    SELECT DISTINCT c.iso_code, (cast((max(c.total_deaths) OVER (PARTITION BY c.iso_code)) as decimal) / d.population) as deaths_rate
    FROM CoronaDataPerMonth c, Country d
    WHERE c.iso_code = d.iso_code;

-- Compute diagnosed_rate = total_cases/population
CREATE VIEW diagnoserate AS
    SELECT DISTINCT c.iso_code, (cast((max(c.total_cases) OVER (PARTITION BY c.iso_code)) as decimal) / d.population) as diagnosed_rate
    FROM CoronaDataPerMonth c, Country d
    WHERE c.iso_code = d.iso_code;

-- Compute the final fatality_rate of the country
CREATE VIEW finalFatalityRate AS
    SELECT DISTINCT iso_code, (cast((max(total_deaths) OVER (PARTITION BY iso_code)) as decimal) / max(total_cases) OVER (PARTITION BY iso_code)) as fatality_rate
    FROM CoronaDataPerMonth;

insert into demographicVScorona
    SELECT DISTINCT c.iso_code, c.countryName, c.gdp_per_capita, c.population, deR.deaths_rate, 
        diaR.diagnosed_rate, fr.fatality_rate, demo.human_development_index, demo.aged_65_older, demo.population_density
    FROM country c, deathRate deR, diagnoserate diaR, finalFatalityRate fr, DemographicInfo demo
    WHERE c.iso_code = deR.iso_code and c.iso_code = diaR.iso_code and c.iso_code = fr.iso_code and c.iso_code = demo.iso_code
        and deR.iso_code = diaR.iso_code and deR.iso_code = fr.iso_code and deR.iso_code = demo.iso_code and diaR.iso_code = fr.iso_code
        and diaR.iso_code = demo.iso_code and fr.iso_code = demo.iso_code;