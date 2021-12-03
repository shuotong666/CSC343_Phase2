#command list for generating a demo terminal output file
#this files contains both UNIX command and SQL



/*Connect to CS TEACHING LAB*/
#ssh <utorid>@dbsrv1.teach.cs.toronto.edu
ssh lishuoto@dbsrv1.teach.cs.toronto.edu

#For readability purpose, dropping the COVID VIEW is recommended:
psql csc343h-lishuoto
DROP SCHEMA if exists COVID19 CASCADE;

#Load Database
cd ~/CSC343_Phase2
psql csc343h-lishuoto -f 'schema.ddl'
psql csc343h-lishuoto -f 'load_data.sql'
#Load investigation query
cd ~/CSC343_Phase2/investigation
psql csc343h-lishuoto -f 'queries_q1.sql'
psql csc343h-lishuoto -f 'queries_q2.sql'
psql csc343h-lishuoto -f 'queries_q3.sql'
#Start psql
psql csc343h-lishuoto
--SQL Commend below
SET SEARCH_PATH to COVID19;
\d
--Tables From Phase2: Country, CoronaData, MedicalInfo, DemographicInfo, Vaccinations
-------------------- Investigative Question 1: ------------------ 
--Q1: Relationships between COVID-19 infections and vaccinations
--The helper view used in this investigation: CoronaDataMonthly, vaccineStart, beforeVaccine, afterVaccine, fatalityRate
--The result tables are: beforeVaccination,afterVaccination
--Sample data of result tables: 
select * from beforeVaccination where iso_code='CAN' or iso_code='USA' or iso_code='MEX';
select * from afterVaccination where iso_code='CAN' or iso_code='USA' or iso_code='MEX';
-------------------- Investigative Question 2: ------------------ 
--Q2: Relationships between GDP, HDI level, COVID-19 death and hospitalization rate
--The helper view used in this investigation: deathrate, diagnoserate, finalFatalityRate
--The result tables is: demographicVScorona
--Sample data of result tables: 
select * from demographicVScoronawhere iso_code='CAN' or iso_code='USA' or iso_code='MEX';
-------------------- Investigative Question 3: ------------------
--Q3: Relationships between Smoking rate, cardiovascular death rate, diabetes prevalance and COVID-19 death rate
--The helper view used in this investigation: health_info, COVID_fatality_rate
--The result tables is: HealthCOVIDInfo
--Sample data of result tables: 
select * from HealthCOVIDInfo where iso_code='CAN' or iso_code='USA' or iso_code='MEX';


