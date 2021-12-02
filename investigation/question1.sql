-- Does the rising number of the vaccinated population affect the number of COVID-19 cases and the case fatality rate? 

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
DROP VIEW IF EXISTS afterVaccineFata CASCADE;
DROP VIEW IF EXISTS beforeVaccineFata CASCADE;

-- Since we only care about the monthly average create a view with the date information striped down
CREATE VIEW CoronaDataMonthly AS
    SELECT iso_code, to_char(d, 'YYYY-MM') as months, total_cases, total_deaths, reproduction_rate, total_tests, stringency_index
    FROM CoronaData;

-- find out the earlest vaccination data start data
CREATE VIEW vaccineStart AS
    SELECT DISTINCT iso_code, to_char((min(d) OVER (PARTITION BY iso_code)), 'YYYY-MM') as start_date
    FROM vaccinations
    ORDER BY iso_code;

-- use the vaccination start date as a piviot point and generate the total covid cases
-- for each country before the vaccine distribution

CREATE VIEW beforeVaccine AS
    SELECT DISTINCT c.iso_code, c.months,
            max(c.total_cases) OVER (PARTITION BY c.iso_code, c.months) as total_cases, 
            max(c.total_deaths) OVER (PARTITION BY c.iso_code, c.months) as total_deaths
    FROM CoronaDataMonthly c, vaccineStart v
    WHERE c.iso_code = v.iso_code and c.months < v.start_date
    ORDER BY c.iso_code, c.months;

CREATE VIEW afterVaccine AS
    SELECT DISTINCT c.iso_code, c.months,
            max(c.total_cases) OVER (PARTITION BY c.iso_code, c.months) as total_cases, 
            max(c.total_deaths) OVER (PARTITION BY c.iso_code, c.months) as total_deaths
    FROM CoronaDataMonthly c, vaccineStart v
    WHERE c.iso_code = v.iso_code and c.months >= v.start_date
    ORDER BY c.iso_code, c.months;

CREATE VIEW afterVaccineFata AS
    SELECT DISTINCT iso_code, months, cast(total_deaths as decimal)/total_cases as fatality_rate
    FROM afterVaccine
    ORDER BY iso_code, months;

CREATE VIEW beforeVaccineFata AS
    SELECT DISTINCT iso_code, months, cast(total_deaths as decimal)/total_cases as fatality_rate
    FROM beforeVaccine
    ORDER BY iso_code, months;

insert into beforeVaccination
    SELECT c.iso_code, c.countryName, b.months, b.total_cases, b.total_deaths, bf.fatality_rate
    FROM country c, beforeVaccine b, beforeVaccineFata bf
    WHERE c.iso_code = b.iso_code and c.iso_code = bf.iso_code and b.iso_code = bf.iso_code and b.months = bf.months;

insert into afterVaccination
    SELECT c.iso_code, c.countryName, a.months, a.total_cases, a.total_deaths, af.fatality_rate
    FROM country c, afterVaccine a, afterVaccineFata af
    WHERE c.iso_code = a.iso_code and c.iso_code = af.iso_code and a.iso_code = af.iso_code and a.months = af.months;