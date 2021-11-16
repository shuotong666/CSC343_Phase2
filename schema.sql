--Schema for CSC343h Phase 2

/*
To do:
We'll need to dig into the data more deeply to decide 
the use of NOT NULL constrain
*/


DROP SCHEMA IF EXISTS COVID19 CASCADE;
CREATE SCHEMA COVID19;
SET SEARCH_PATH TO COVID19;
	
--Complete
CREATE TABLE Continent (
	continentName TEXT,
	countryName TEXT NOT NULL UNIQUE, --Unique Needed for setting foreign key
	PRIMARY KEY (continentName)
);

--Complete
CREATE TABLE Country (
	iso_code VARCHAR(3), --3 length fixed string?
	countryName TEXT NOT NULL UNIQUE, --The ISO CODE is sufficient as a primary key
	population INT,
	gdp_per_capita FLOAT,
	PRIMARY KEY(iso_code),
	FOREIGN KEY (countryName) REFERENCES Continent(countryName)
);

--Complete
--As many data may be missing, the NOT NULL constrain is not used here
CREATE TABLE CoronaData (
	iso_code VARCHAR(3),
	d TIMESTAMP, --cannot use data as this is a keyword in sql
	total_cases INT,
	total_deaths INT,
	reproduction_rate INT,
	total_tests INT ,
	total_vaccination INT,
	peope_vaccinated INT ,
	people_fully_vaccinated INT ,
	stringency_index FLOAT ,
	PRIMARY KEY (iso_code,d),
	FOREIGN KEY (iso_code) REFERENCES Country(iso_code)
);

--Complete
--Variable type is checked
CREATE TABLE MedicalInfo (
	iso_code VARCHAR(3),
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
--Variable type is checked
CREATE TABLE DemographicInfo (
	iso_code VARCHAR(3),
	population_density FLOAT,
	median_age FLOAT,
	aged_65_old FLOAT,
	aged_70_old FLOAT,
	mortality_rate FLOAT,
	human_development_index FLOAT,
	PRIMARY KEY (iso_code),
	FOREIGN KEY (iso_code) REFERENCES Country(iso_code)
);


