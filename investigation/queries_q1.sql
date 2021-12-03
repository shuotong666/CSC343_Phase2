-- Does the rising number of the vaccinated population affect the number of COVID-19 cases and the case fatality rate? 
-- (The case fatality rate refers to the number of diagnosed cases over the number of deaths)

SET SEARCH_PATH TO covid19;
DROP TABLE IF exists beforeVaccination CASCADE;
DROP TABLE IF exists afterVaccination CASCADE;

CREATE TABLE beforeVaccination(
    iso_code VARCHAR(8),
    countryName TEXT,
    months TEXT,
    total_cases BIGINT,
	total_deaths BIGINT,
    fatality_rate decimal
);

CREATE TABLE afterVaccination(
    iso_code VARCHAR(8),
    countryName TEXT,
    months TEXT,
    total_cases BIGINT,
	total_deaths BIGINT,
    fatality_rate decimal
);

DROP VIEW IF EXISTS CoronaDataMonthly CASCADE;
DROP VIEW IF EXISTS vaccineStart CASCADE;
DROP VIEW IF EXISTS beforeVaccine CASCADE;
DROP VIEW IF EXISTS afterVaccine CASCADE;
DROP VIEW IF EXISTS fatalityRate CASCADE;

-- Since we only care about the monthly average create a view with the date information striped down
CREATE VIEW CoronaDataMonthly AS
    SELECT iso_code, to_char(d, 'YYYY-MM') as months, total_cases, total_deaths, reproduction_rate, total_tests, stringency_index
    FROM CoronaData;

CREATE VIEW CoronaDataPerMonth AS
    SELECT DISTINCT iso_code, months,
            max(total_cases) OVER (PARTITION BY iso_code, months) as total_cases,
            max(total_deaths) OVER (PARTITION BY iso_code, months) as total_deaths
    FROM CoronaDataMonthly;

-- find out the earlest vaccination data start data
CREATE VIEW vaccineStart AS
    SELECT DISTINCT iso_code, to_char((min(d) OVER (PARTITION BY iso_code)), 'YYYY-MM') as start_date
    FROM vaccinations
    ORDER BY iso_code;

-- use the vaccination start date as a piviot point and generate the total covid cases
-- for each country before the vaccine distribution
CREATE VIEW beforeVaccine AS
    SELECT DISTINCT c.iso_code, c.months, c.total_cases, c.total_deaths
    FROM CoronaDataPerMonth c, vaccineStart v
    WHERE c.iso_code = v.iso_code and c.months < v.start_date
    ORDER BY c.iso_code, c.months;

CREATE VIEW afterVaccine AS
    SELECT DISTINCT c.iso_code, c.months, c.total_cases, c.total_deaths
    FROM CoronaDataPerMonth c, vaccineStart v
    WHERE c.iso_code = v.iso_code and c.months >= v.start_date
    ORDER BY c.iso_code, c.months;

-- compute fatality_rate
CREATE VIEW fatalityRate AS
    SELECT DISTINCT iso_code, months, cast(total_deaths as decimal)/total_cases as fatality_rate
    FROM CoronaDataPerMonth
    ORDER BY iso_code, months;


--Use the view above to synthese the results
insert into beforeVaccination
    SELECT c.iso_code, c.countryName, b.months, b.total_cases, b.total_deaths, bf.fatality_rate
    FROM country c, beforeVaccine b, fatalityRate bf
    WHERE c.iso_code = b.iso_code and c.iso_code = bf.iso_code and b.iso_code = bf.iso_code and b.months = bf.months;

insert into afterVaccination
    SELECT c.iso_code, c.countryName, a.months, a.total_cases, a.total_deaths, af.fatality_rate
    FROM country c, afterVaccine a, fatalityRate af
    WHERE c.iso_code = a.iso_code and c.iso_code = af.iso_code and a.iso_code = af.iso_code and a.months = af.months;


--Export queries result into CSV for further analysis
\copy (select * from beforeVaccination) to 'beforeVaccination.csv' with csv Header
\copy (select * from afterVaccination) to 'afterVaccination.csv' with csv Header
