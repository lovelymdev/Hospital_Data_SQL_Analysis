-- Create Database
CREATE DATABASE HospitalData;

-- Switch to the database
\c HospitalData;

-- Create Tables
DROP TABLE IF EXISTS HospitalData ;

CREATE TABLE HospitalData (
    hospital_id SERIAL PRIMARY KEY,
    hospital_name VARCHAR(100),
    location VARCHAR(50),
    department VARCHAR(50) NOT NULL,
    doctors_count INT,
    patients_count INT,
    admission_date DATE,
    discharge_date DATE,
    medical_expenses NUMERIC(10,2)
);

SELECT * FROM hospitaldata;

--Import Data into hospitaldata table:
COPY hospitaldata(Hospital_Id, Hospital_Name, Location, Department, 
     Doctors_Count, Patients_Count, Admission_Date, Discharge_Date, Medical_Expenses)
FROM 'D:\Assignment\Hospital_Data.csv'	 
DELIMITER','
CSV HEADER;

--Assignment:
--1) Find the total number of patients across all hospitals:

SELECT SUM(patients_count) AS Total_patients
FROM hospitaldata;

--2) Retrieve the average count of doctors available in each hospital:

SELECT AVG(doctors_count) AS avearge_doctors
FROM hospitaldata;

--3) Find the top 3 hospital departments that have the highest number of patients:

SELECT department, SUM(patients_count) AS total_patients
FROM hospitaldata
GROUP BY department
ORDER BY total_patients DESC;

--4) Identify the hospital that recorded the highest medical expenses:
SELECT hospital_name, medical_expenses
FROM hospitaldata
ORDER BY medical_expenses DESC LIMIT 1;

--5) Calculate the average medical expenses per day for each hospital:

SELECT hospital_name, ROUND(AVG(medical_expenses/(discharge_date-admission_date+1)),2) AS avg_medicalexp_per_day
FROM hospitaldata
GROUP BY hospital_name;

--6) Find the patient with the longest stay by calculating the difference between 
-----Discharge Date and Admission Date.
SELECT hospital_name, department, admission_date, discharge_date,
       (discharge_date-admission_date) AS Stay_days
FROM hospitaldata
ORDER BY Stay_days DESC LIMIT 1;

--7) Count the total number of patients treated in each city.

SELECT DISTINCT location, SUM(patients_count) AS treated_patients
FROM hospitaldata
GROUP BY location
ORDER BY treated_patients;

--8) Calculate the average number of days patients spend in each department.

SELECT DISTINCT department, ROUND( AVG(discharge_date-admission_date+1), 2) AS Avg_stay
FROM hospitaldata
GROUP BY department
ORDER BY Avg_stay;

--9) Find the department with the least number of patients.

SELECT DISTINCT department, patients_count AS least_patients
FROM hospitaldata
ORDER BY least_patients ASC;

--10) Group the data by month and calculate the total medical expenses for each month.

SELECT DATE_TRUNC('month', admission_date) AS month,
      SUM(medical_expenses) AS Total_medical_exp
FROM hospitaldata
GROUP BY DATE_TRUNC('month', admission_date)
ORDER BY month;