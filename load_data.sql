--Note: all numeric in original CSV file is float, even though decimal numbers 
--are impossible to present in such data, like number of total cases, population etc.
Set Search_Path to COVID19;
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

/*
--Continent Load data
insert into Continent (continentName, countryName)
select distinct continent as continentName, location as countryName 
from owid_covid_data where continent is not NULL;
*/
/* --The following continent, EU, World data is not included and can be access as
select distinct continent as continentName, location as countryName 
from owid_covid_data where continent is NULL
ORDER BY countryName;*/
/*Some location have ISO_CODE length greater than 3, access as 
select distinct iso_code, continent, location 
from owid_covid_data where length(iso_code)>3
ORDER BY LOCATION;*/

--Country Load data
insert into Country(iso_code, countryName, continentName, population, gdp_per_capita)
select distinct iso_code, 
	location as countryName, 
	continent as continentName,
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


--MedicalInfo Load Data
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


--DemographicInfo Load Data
insert into DemographicInfo (
	iso_code,
	population_density,
	median_age,
	aged_65_older,
	aged_70_older,
	human_development_index
)
Select distinct 	
	iso_code,
	population_density,
	median_age,
	aged_65_older,
	aged_70_older,
	human_development_index
from owid_covid_data where continent is not NULL;


--After processing the data, we can drop this table as it is no longer required anymore
Drop table owid_covid_data;