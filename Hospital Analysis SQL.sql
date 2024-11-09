-- 1. Extracting Details of all patients admitted in a specific month?
select *
from healthcare
where Month(admission_date) = "05" and year(admission_date) = "2024" ;

select min(admission_date),max(admission_date)
from healthcare;
-- 2. Counting the total nummber of admission in a year .
select year(admission_date)as admission_year,count(admission_date) as total_admission
from healthcare
where admission_date between '2021-01-01'and '2024-12-31'
group by year(admission_date)
order by admission_year;

-- 3. Finding all patients diagnosed with a specific condition( heart attack )
select Patient_Name,diagnosis,Patient_Age ,count(diagnosis)
from healthcare
where diagnosis = "Heart attack"
group by Patient_Name,diagnosis,Patient_Age
order by Patient_Age;
-- 3a.Finding all Female patients diagnosed with a specific condition(e.g. Anemia,anxiety)
select *
from healthcare
where diagnosis in("Pregnancy", "Depression") and Gender = "Female"; 
-- 4. Listing patients sorted by age
select Patient_Name,Patient_age
from healthcare 
order by Patient_Age asc;

-- 5. Calculating the average length of stay for patients.
select Patient_Name,Patient_age,avg(Avg_Length_of_Stay)
from healthcare
group by Patient_Name,Patient_age
order by Patient_Name;

-- Intermediate Problems
-- 6. Finding patients who were readmitted within 30 days.
select Patient_Name,admission_date,Readmission_Date,Hospital_Name,datediff(Readmission_Date,admission_date) as days_between,diagnosis
from healthcare
where Readmission_Date != 0;

select datediff(Readmission_Date,admission_date) as days_between
from healthcare
where Readmission_Date != 0;
-- 6a write a query will return a list of patients who have had more than one admission.
select patient_name ,count(*) as admission_count 
from healthcare
group by Patient_Name
having admission_count > 1;

-- Update contact information for a specific patient."Becky Lopez" ,"James johnson".

select * from healthcare;
alter table healthcare
add column Contact_info  decimal(10);
update healthcare
set Contact_info = 1234567890
where patient_name = "Heather Jackson";
  
select * from healthcare
where patient_name in ("Heather Jackson", "james johnson")  ;

-- To delete patient records from the table where patients have been admitted only once.
-- Method 1
delete from healthcare where Patient_Name in(select Patient_Name from healthcare group by Patient_Name having max(admission_date) < date_sub(curdate(),interval 3 year));

-- Method 2
delete h 
from healthcare h
join (
	select Patient_Name from healthcare
    group by Patient_Name
    having max(admission_date) < curdate() - interval 3 year) as subquery on h.Patient_Name = subquery.Patient_Name;
 
-- creating a simplified view for frequently accessed pattient admission data;

create view patientadmissionview as select patient_name,Patient_age,Admission_date,diagnosis,hospital_name from healthcare;
select * from patientadmissionview;


-- Advanced Problems
-- Calculating the percentage of patients readmitted within 30 days.        
WITH Readmissions AS (
    SELECT Patient_Name,
        Admission_Date,Readmission_Date,
        CASE 
            WHEN Readmission_Date IS NOT NULL AND DATEDIFF(Readmission_Date, Admission_Date) <= 30 
            THEN 1 else 0 END AS Is_Readmitted
    FROM healthcare
),
Summary AS (
    SELECT 
        COUNT(DISTINCT Patient_Name) AS Total_Patients,
        SUM( Is_Readmitted) AS Total_Readmitted
    FROM Readmissions
)
SELECT 
    Total_Patients,
    Total_Readmitted,
    (Total_Readmitted * 100.0 / Total_Patients) AS Readmission_Percentage
FROM 
    Summary;
    
select department,count(Department) from healthcare
group by department;
-- Summarizing admissions by department in a pivot format.
select year(admission_date)as admission_year,sum(case when department = "cardiologist" then 1 else 0 end) as cardiology_admission,
sum(case when department = "gynaecologist" then 1 else 0 end) as gynaecology_admission,
sum(case when department = "neurologist" then 1 else 0 end) as neurology_admission,
sum(case when department = "oncologist" then 1 else 0 end) as oncology_admission
from healthcare
where admission_date between '2021-01-01'and '2024-12-31'
group by year(admission_date)
order by admission_year;


-- write a Query to Generate Monthly Admission Report

SELECT
    YEAR(admission_date) AS admission_year,
    MONTH(admission_date) AS admission_month,
    COUNT(*) AS total_admissions,
    COUNT(DISTINCT patient_name) AS unique_patients,
    SUM(Revenue) AS total_revenue
FROM healthcare
GROUP BY YEAR(admission_date), MONTH(admission_date)
ORDER BY admission_year DESC, admission_month DESC;







