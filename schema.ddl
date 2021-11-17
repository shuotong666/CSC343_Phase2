--Schema for CSC343h Phase 2
--to initialize this schema, use the following command in dbsrv1:
--Note: owid-covid-data.csv must also be present in the same directory
--psql csc343h-<utorid> -f 'schema.ddl'



/*------------------------Schema------------------------*/
DROP SCHEMA IF EXISTS COVID19 CASCADE;
CREATE SCHEMA COVID19;
SET SEARCH_PATH TO COVID19; /*Name of searchpath*/
	
--Complete
CREATE TABLE Continent (
	continentName TEXT,
	countryName TEXT NOT NULL UNIQUE, --Unique Needed for setting foreign key
	PRIMARY KEY (continentName, countryName)
);

--Complete
--BIGINT: Some continent / world data have population greater than 2.1 billion (range of int)
--But this table only includes countries, use BIGINT is only for futureproof
CREATE TABLE Country (
	iso_code VARCHAR(8), --Some region have OWID_ prefix
	countryName TEXT NOT NULL, --The ISO CODE is sufficient as a primary key
	population BIGINT, 
	gdp_per_capita FLOAT,
	PRIMARY KEY(iso_code),
	FOREIGN KEY (countryName) REFERENCES Continent(countryName)
);

--Complete
--As many data may be missing, the NOT NULL constrain is not used here
--BIGINT: some value can easily exceed 2.1 billion
CREATE TABLE CoronaData (
	iso_code VARCHAR(8),
	d DATE, --cannot use 'date' as this is a keyword in sql
	total_cases BIGINT,
	total_deaths BIGINT,
	reproduction_rate FLOAT,
	total_tests BIGINT ,
	total_vaccinations BIGINT,
	people_vaccinated BIGINT ,
	people_fully_vaccinated BIGINT ,
	stringency_index FLOAT ,
	PRIMARY KEY (iso_code,d),
	FOREIGN KEY (iso_code) REFERENCES Country(iso_code)
);

--Complete
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
	FOREIGN KEY (iso_code) REFERENCES Country(iso_code) --Country table is more appropiate
);

--Complete
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




