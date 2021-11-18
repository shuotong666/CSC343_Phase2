--Schema for CSC343h Phase 2
--to initialize this schema, use the following command in dbsrv1:
--Note: owid-covid-data.csv must also be present in the same directory
--psql csc343h-<utorid> -f 'schema.ddl'



DROP SCHEMA IF EXISTS COVID19 CASCADE;
CREATE SCHEMA COVID19;
SET SEARCH_PATH TO COVID19; /*Name of searchpath*/
	
/*Relation Continent
data from OWID-COVID-data.csv contains covid data for entire continents, EU, and world
and in such case, the location has a name but the continent is null, we'll be using this
relation to enforce our database only contains country data.
*/
/*
CREATE TABLE Continent (
	continentName TEXT,
	countryName TEXT NOT NULL UNIQUE, --Unique Needed for setting foreign key
	PRIMARY KEY (continentName, countryName)
);
*/
/*Relation Country
This relation contrains the basic information for each country. Including:
ISO_Code, which is the foreign key for other relations
Name of the country, Population, and GDP per capita.
Although this database only includes countries, use BIGINT is for futureproof.
It also enables the possibility of importing continent or world data in the future if necessary.
*/

CREATE TABLE Country (
	iso_code VARCHAR(8), --Some region have OWID_ prefix
	countryName TEXT NOT NULL, 
	continentName TEXT NOT NULL,
	population BIGINT, 
	gdp_per_capita FLOAT,
	PRIMARY KEY(iso_code)
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

/*Relation DemographicInfo
This relation reports the demographic info of a certain country 
and they are not time sensitive from the original CSV file.
For the same reasons, due to lack of availability of data inputs, 
the NOT NULL constrain is difficult to enforce
*/
CREATE TABLE DemographicInfo (
	iso_code VARCHAR(8),
	population_density FLOAT,
	median_age FLOAT,
	aged_65_older FLOAT,
	aged_70_older FLOAT,
	mortality_rate FLOAT,
	human_development_index FLOAT,
	PRIMARY KEY (iso_code),
	FOREIGN KEY (iso_code) REFERENCES Country(iso_code)
);




