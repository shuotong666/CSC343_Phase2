
--psql csc343h-<utorid> -f 'question3.sql'
SET SEARCH_PATH TO covid19;
drop view if exists smoking_rate CASCADE;
drop view if exists death_rate CASCADE;


--smoking rate 
--population distribution across genders are usually 49.5/50.5 (male/female)
--this distribution is close enough to treat the population of male and female are same
CREATE VIEW smoking_rate as 
select iso_code, countryName, gdp_per_capita, cardiovasc_death_rate, diabetes_prevalence,(female_smokers + male_smokers)/2 as smoking_rate 
from country natural join medicalinfo 
where gdp_per_capita > 0; --limit gdp here to constrain health care

--death rate from latest data (2021-09-27 for this project database)
CREATE VIEW death_rate as 
select latest.iso_code, round(total_deaths / cast(total_cases as decimal)*100,5) as death_rate
from (select max(d) as d, iso_code from CoronaData group by iso_code) as latest 
left join CoronaData on latest.d=CoronaData.d and latest.iso_code=CoronaData.iso_code
where total_cases >1000 and total_deaths is not null;--limit total case here to get non-trivial data

--group the above two data together
CREATE VIEW q3 as select * from smoking_rate natural join death_rate;

\copy (select * from q3) to 'q3.csv' with csv Header