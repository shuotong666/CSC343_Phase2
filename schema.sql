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
Drop Table if EXISTS Persons;
CREATE TABLE persons (
  id SERIAL,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  dob TIMESTAMP,
  email VARCHAR(255),
  EID float--need to find a way to convert float to int
);
--important: copy is not a SQL command and must cp in single line to the command window
\COPY persons (first_name, last_name, dob, email,eid)from 'persons.csv'DELIMITER ',' CSV HEADER

-- For the reason above, do not change this line
\COPY owid_covid_data (iso_code,continent,location,d,total_cases,new_cases,new_cases_smoothed,total_deaths,new_deaths,new_deaths_smoothed,total_cases_per_million,new_cases_per_million,new_cases_smoothed_per_million,total_deaths_per_million,new_deaths_per_million,new_deaths_smoothed_per_million,reproduction_rate,icu_patients,icu_patients_per_million,hosp_patients,hosp_patients_per_million,weekly_icu_admissions,weekly_icu_admissions_per_million,weekly_hosp_admissions,weekly_hosp_admissions_per_million,new_tests,total_tests,total_tests_per_thousand,new_tests_per_thousand,new_tests_smoothed,new_tests_smoothed_per_thousand,positive_rate,tests_per_case,tests_units,total_vaccinations,people_vaccinated,people_fully_vaccinated,total_boosters,new_vaccinations,new_vaccinations_smoothed,total_vaccinations_per_hundred,people_vaccinated_per_hundred,people_fully_vaccinated_per_hundred,total_boosters_per_hundred,new_vaccinations_smoothed_per_million,stringency_index,population,population_density,median_age,aged_65_older,aged_70_older,gdp_per_capita,extreme_poverty,cardiovasc_death_rate,diabetes_prevalence,female_smokers,male_smokers,handwashing_facilities,hospital_beds_per_thousand,life_expectancy,human_development_index,excess_mortality_cumulative_absolute,excess_mortality_cumulative,excess_mortality,excess_mortality_cumulative_per_million)from 'owid-covid-data.csv'DELIMITER ',' CSV HEADER

Drop Table if EXISTS owid_covid_data;
CREATE TABLE  owid_covid_data(
	iso_code VARCHAR(10),
	continent TEXT,
	location TEXT,
	d TIMESTAMP,
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














