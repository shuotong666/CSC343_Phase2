--Schema for CSC343h Phase 2
--to initialize this database, use the following command in dbsrv1:
--Note: owid-covid-data must also be present in the same directory
--psql csc343h-<utorid> -f 'work.sql'





/*------------------------Schema------------------------*/
DROP SCHEMA IF EXISTS COVID19 CASCADE;
CREATE SCHEMA COVID19;
SET SEARCH_PATH TO COVID19; /*Name of searchpath*/
	
/*Relation Continent
data from OWID-COVID-data.csv contains covid data for entire continents, EU, and world
and in such case, the location has a name but the continent is null, we'll be using this
relation to enforce our database only contains country data.
*/
CREATE TABLE Continent (
	continentName TEXT,
	countryName TEXT NOT NULL UNIQUE, --Unique Needed for setting foreign key
	PRIMARY KEY (continentName, countryName)
);

/*Relation Country
This relation contrains the basic information for each country. Including:
ISO_Code, which is the foreign key for other relations
Name of the country, Population, and GDP per capita.
Although this database only includes countries, use BIGINT is for futureproof.
It also enables the possibility of importing continent or world data in the future if necessary.
*/

CREATE TABLE Country (
	iso_code VARCHAR(8), --Some region have OWID_ prefix
	countryName TEXT NOT NULL, --The ISO CODE is sufficient as a primary key
	population BIGINT, 
	gdp_per_capita FLOAT,
	PRIMARY KEY(iso_code),
	FOREIGN KEY (countryName) REFERENCES Continent(countryName)
);

/*Relation CoronaData
This relation reports daily data of COVID-19 for a given country by ISO code and date.
For optimization purposes, the derived data from the original CSV file is not included, 
for example, new cases over a certain amount of time (per day, week, month) 
can be calculated by comparing the total cases of two given time.
As many data may be missing due to lack of such report or unable to update on a daily basis,
NOT NULL constrain is difficult to enforce here without giving up datas from developing countries.
*/
CREATE TABLE CoronaData (
	iso_code VARCHAR(8),
	d DATE, --cannot use 'date' as this is a keyword in sql
	total_cases BIGINT,
	total_deaths BIGINT,
	reproduction_rate FLOAT,
	total_tests BIGINT,
	total_vaccinations BIGINT,
	people_vaccinated BIGINT,
	people_fully_vaccinated BIGINT,
	stringency_index FLOAT,
	PRIMARY KEY (iso_code,d),
	FOREIGN KEY (iso_code) REFERENCES Country(iso_code)
);

/*Relation MedicalInfo
This relation reports the medical info of a certain country 
and they are not time sensitive from the original CSV file.
For the same reasons, due to lack of availability of data inputs, 
the NOT NULL constrain is difficult to enforce
*/
CREATE TABLE MedicalInfo (
	iso_code VARCHAR(8),
	cardiovasc_death_rate FLOAT,
	diabetes_prevalence FLOAT,
	hospital_beds_per_thousand FLOAT,
	life_expectancy FLOAT,
	female_smokers FLOAT,
	male_smokers FLOAT,
	handwashing_facilities FLOAT,
	PRIMARY KEY(iso_code),
	FOREIGN KEY (iso_code) REFERENCES Country(iso_code) 
);

/*Relation MedicalInfo
This relation reports the demographic info of a certain country 
and they are not time sensitive from the original CSV file.
For the same reasons, due to lack of availability of data inputs, 
the NOT NULL constrain is difficult to enforce
*/
CREATE TABLE DemographicInfo (
	iso_code VARCHAR(8),
	population_density FLOAT,
	median_age FLOAT,
	aged_65_old FLOAT,
	aged_70_old FLOAT,
	mortality_rate FLOAT,
	human_development_index FLOAT,
	PRIMARY KEY (iso_code),
	FOREIGN KEY (iso_code) REFERENCES Country(iso_code)
);
/*----------------------Schema END----------------------*/



/*----------------------Load Data-----------------------*/
--Note: all numeric in original CSV file is float, even though decimal numbers 
--are impossible to present in such data, like number of total cases, population etc.
CREATE TABLE  owid_covid_data(
	iso_code VARCHAR(8),
	continent TEXT,
	location TEXT,
	d DATE,
	total_cases FLOAT,
	new_cases FLOAT,
	new_cases_smoothed FLOAT,
	total_deaths FLOAT,
	new_deaths FLOAT,
	new_deaths_smoothed FLOAT,
	total_cases_per_million FLOAT,
	new_cases_per_million FLOAT,
	new_cases_smoothed_per_million FLOAT,
	total_deaths_per_million FLOAT,
	new_deaths_per_million FLOAT,
	new_deaths_smoothed_per_million FLOAT,
	reproduction_rate FLOAT,
	icu_patients FLOAT,
	icu_patients_per_million FLOAT,
	hosp_patients FLOAT,
	hosp_patients_per_million FLOAT,
	weekly_icu_admissions FLOAT,
	weekly_icu_admissions_per_million FLOAT,
	weekly_hosp_admissions FLOAT,
	weekly_hosp_admissions_per_million FLOAT,
	new_tests FLOAT,
	total_tests FLOAT,
	total_tests_per_thousand FLOAT,
	new_tests_per_thousand FLOAT,
	new_tests_smoothed FLOAT,
	new_tests_smoothed_per_thousand FLOAT,
	positive_rate FLOAT,
	tests_per_case FLOAT,
	tests_units VARCHAR(20),
	total_vaccinations FLOAT,
	people_vaccinated FLOAT,
	people_fully_vaccinated FLOAT,
	total_boosters FLOAT,
	new_vaccinations FLOAT,
	new_vaccinations_smoothed FLOAT,
	total_vaccinations_per_hundred FLOAT,
	people_vaccinated_per_hundred FLOAT,
	people_fully_vaccinated_per_hundred FLOAT,
	total_boosters_per_hundred FLOAT,
	new_vaccinations_smoothed_per_million FLOAT,
	stringency_index FLOAT,
	population FLOAT,
	population_density FLOAT,
	median_age FLOAT,
	aged_65_older FLOAT,
	aged_70_older FLOAT,
	gdp_per_capita FLOAT,
	extreme_poverty FLOAT,
	cardiovasc_death_rate FLOAT,
	diabetes_prevalence FLOAT,
	female_smokers FLOAT,
	male_smokers FLOAT,
	handwashing_facilities FLOAT,
	hospital_beds_per_thousand FLOAT,
	life_expectancy FLOAT,
	human_development_index FLOAT,
	excess_mortality_cumulative_absolute FLOAT,
	excess_mortality_cumulative FLOAT,
	excess_mortality FLOAT,
	excess_mortality_cumulative_per_million FLOAT
);

--important: copy is not a SQL command and must cp in single line to the command window
\COPY owid_covid_data (iso_code,continent,location,d,total_cases,new_cases,new_cases_smoothed,total_deaths,new_deaths,new_deaths_smoothed,total_cases_per_million,new_cases_per_million,new_cases_smoothed_per_million,total_deaths_per_million,new_deaths_per_million,new_deaths_smoothed_per_million,reproduction_rate,icu_patients,icu_patients_per_million,hosp_patients,hosp_patients_per_million,weekly_icu_admissions,weekly_icu_admissions_per_million,weekly_hosp_admissions,weekly_hosp_admissions_per_million,new_tests,total_tests,total_tests_per_thousand,new_tests_per_thousand,new_tests_smoothed,new_tests_smoothed_per_thousand,positive_rate,tests_per_case,tests_units,total_vaccinations,people_vaccinated,people_fully_vaccinated,total_boosters,new_vaccinations,new_vaccinations_smoothed,total_vaccinations_per_hundred,people_vaccinated_per_hundred,people_fully_vaccinated_per_hundred,total_boosters_per_hundred,new_vaccinations_smoothed_per_million,stringency_index,population,population_density,median_age,aged_65_older,aged_70_older,gdp_per_capita,extreme_poverty,cardiovasc_death_rate,diabetes_prevalence,female_smokers,male_smokers,handwashing_facilities,hospital_beds_per_thousand,life_expectancy,human_development_index,excess_mortality_cumulative_absolute,excess_mortality_cumulative,excess_mortality,excess_mortality_cumulative_per_million)from 'owid-covid-data.csv'DELIMITER ',' CSV HEADER


--Continent Load data
insert into Continent (continentName, countryName)
select distinct continent as continentName, location as countryName 
from owid_covid_data where continent is not NULL;

/* --The following continent, EU, World data is not included and can be access as
select distinct continent as continentName, location as countryName 
from owid_covid_data where continent is NULL
ORDER BY countryName;*/
/*Some location have ISO_CODE length greater than 3, access as 
select distinct iso_code, continent, location 
from owid_covid_data where length(iso_code)>3
ORDER BY LOCATION;*/

--Country Load data
insert into Country(iso_code, countryName, population, gdp_per_capita)
select distinct iso_code, 
	location as countryName, 
	cast(population as BIGINT),
	gdp_per_capita
	from owid_covid_data where continent is not NULL;

--CoronaData Load data
insert into CoronaData(
	iso_code, d, total_cases, total_deaths, reproduction_rate, total_tests,
	total_vaccinations,people_vaccinated, people_fully_vaccinated, stringency_index)
select 
	iso_code, 
	d, 
	cast(total_cases as BIGINT), 
	cast(total_deaths as BIGINT), 
	reproduction_rate, 
	cast(total_tests as BIGINT), 
	cast(total_vaccinations as BIGINT), 
	cast(people_vaccinated as BIGINT), 
	cast(people_fully_vaccinated as BIGINT), 
	stringency_index
from owid_covid_data where continent is not NULL;


--MedicalInfo
--The insertion is successful and satisfying all key constrains, 
--therefore the following data were never updated by OWID
--In another word, they're not associated with d(date)
insert into MedicalInfo (
	iso_code,
	cardiovasc_death_rate,
	diabetes_prevalence,
	hospital_beds_per_thousand,
	life_expectancy,
	female_smokers,
	male_smokers,
	handwashing_facilities)
Select distinct 	
	iso_code,
	cardiovasc_death_rate,
	diabetes_prevalence,
	hospital_beds_per_thousand,
	life_expectancy,
	female_smokers,
	male_smokers,
	handwashing_facilities 
from owid_covid_data where continent is not NULL;
/*---------------------Load Data END--------------------*/

/*--------------------------Demo------------------------*/











