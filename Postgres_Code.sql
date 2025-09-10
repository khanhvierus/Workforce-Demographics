SET search_path TO hr;
create table hr.human_resources(
 id text , 
 first_name text,
 last_name text,
 birthdate text,
 gender text,
 race text,
 department text,
 jobtitle text,
 location text,
 hire_date text,
 termdate text,
 location_city text,
 location_state text
); 
SELECT * FROM hr.human_resources
LIMIT 100 

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'hr' AND table_name = 'human_resources';

drop table  if exists  human_resources 
-- 1. DATA CLEANING 
-- clean column 'birthdate' 
/*
Vấn đề : Có 2 kiểu format date cho cột này 
- Kiểu thứ nhất có dạng 'm/d/y' 
- kiểu thứ hai có dạng 'm-d-y' 
- Riêng với kiểu thứ hai , phần 'year' chỉ lấy 2 số cuối xy . Nếu xy > 25 (2025) , thì ta sẽ chuyển nó thành 19xy . 
Ngược lại , ta chuyển thành 20xy 
-> Ta chuyển hết sang định dạng 'y-m-d'
*/
-- Cập nhật lần 1 : Đổi hết về format đã quy định 
update human_resources 
set birthdate = case 
  when birthdate like '%/%' then TO_CHAR(TO_DATE(birthdate, 'MM/DD/YYYY') , 'YYYY-MM-DD')
  when birthdate like '%-%' then TO_CHAR(TO_DATE(birthdate, 'MM-DD-YY'), 'YYYY-MM-DD')
end ; 
-- Ép kiểu date 
alter table human_resources 
alter column birthdate type date
USING birthdate::date; 
-- Cập nhật lần 2 : Trừ 100 năm cho những date có year > 2025 (ví dụ : 2066 -> 1966)
update human_resources
set birthdate = case 
  when extract(year from birthdate) > 2025 then birthdate - interval '100 years'
  else birthdate
end;
-- Xem kết quả 
SELECT * FROM hr.human_resources
LIMIT 100 




-- clean column 'hire_date'

-- Xử lý tương tự như cột 'birthdate' 
-- Cập nhật lần 1 : Đổi hết sang format quy định 
update human_resources 
set hire_date = case 
  when hire_date like '%/%' then to_char(to_date(hire_date , 'MM/DD/YYYY') , 'YYYY-MM-DD')
  when hire_date like '%-%' then to_char(to_date(hire_date , 'MM/DD/YY') , 'YYYY-MM-DD')
end ; 
-- Ép kiểu date 
alter table human_resources 
alter column hire_date type date 
using hire_date::date ; 
-- Cập nhật lần 2 : Trừ 100 năm cho những date có year > 2025 (ví dụ : 2066 -> 1966)
update human_resources 
set hire_date = case 
  when extract(year from hire_date) > 2025 then hire_date - interval '100 years'
  else hire_date
end; 
-- Kiểm tra 
select hire_date from human_resources
limit 100 ; 



-- clean column 'termdate'
select termdate from human_resources ;
-- Chuyển từ dạng timestamp sang format quy định 
update human_resources 
set termdate = to_char(to_timestamp(termdate, 'YYYY-MM-DD HH24:MI:SS UTC') , 'YYYY-MM-DD')
where termdate is not null and termdate != ' '; 
-- Ép lại kiểu 
alter table human_resources 
alter column termdate type date 
using termdate::date ; 
-- Kiểm tra 
select * from human_resources 


--2. QUERIES 

-- 1. What is the gender breakdown of employees in the company?
select count(id) as number_of_employees , gender
from human_resources 
group by gender ; 

-- 2. What is the race/ethnicity breakdown of employees in the company?
select count(id) as number_of_employees , race 
from human_resources 
group by race
order by count(id) asc ; 

-- 3. What is the age distribution of employees in the company?
-- Đầu tiên , tạo thêm cột 'age'
alter table human_resources
add column age integer ; 

update human_resources 
set age = extract(year from age(now() , birthdate));
-- Kế tiếp , thực hiện query 
select concat(floor(age/10)* 10 , '-' , floor(age/10)*10 + 9)as age_range , count(id) as number_of_employees
from human_resources 
group by age_range 
order by age_range asc ;

-- 4. How many employees work at headquarters versus remote locations?
select location ,  count(id) as number_of_employees 
from human_resources 
group by location  ;

-- 5. What is the average length of employment for employees who have been terminated?
select round( avg( extract (year from age(termdate, hire_date))) , 2) as average_length_of_employment
from human_resources 
where termdate is not null and termdate < now() ; 

-- 6. How does the gender distribution vary across departments?
select department , gender , count(id) as number_of_employees
from human_resources 
group by  department , gender
order by department asc ; 

-- 7. What is the distribution of job titles across the company?
select jobtitle , count(id)as number_of_employees 
from human_resources 
group by jobtitle 
order by jobtitle asc ; 

-- 8. Which department has the highest turnover rate?
/*"Turnover rate" typically refers to the rate at which employees leave a company or department and need to be replaced. 
It can be calculated as the number of employees who leave over a given time period divided by the average number of employees 
in the company or department over that same time period. */
select department , count(id) as total_employees , 
  sum(case when termdate is null then 1 else 0 end ) as total_active_employees ,
  sum(case when  termdate is not null and termdate < now() then 1 else 0 end ) as total_terminated_employees ,
  round( (sum(case when  termdate is not null and termdate < now() then 1 else 0 end )::decimal /count(id))  , 3 ) as turnover_rate
from human_resources 
group by department 
order by turnover_rate desc ; 

-- 9. What is the distribution of employees across locations by state?
select location_state , count(id) as number_of_employees 
from human_resources 
group by location_state 
order by count(id) asc ;

--10. What is the net change over years between hired_employee's and terminated_employee's counts  
select 
    years, 
    hires, 
    terminations, 
    (hires - terminations) AS net_change,
    ROUND(((hires - terminations) / hires::float * 100)::numeric, 2) AS net_change_percent
from (
    select 
         extract(year from hire_date ) AS years, 
        count(*) as hires, 
        SUM(CASE WHEN termdate is not null AND termdate <= now() THEN 1 ELSE 0 END) AS terminations
    from 
        human_resources
    group by 
        years
) subquery
order by years asc;

-- 11. What is the average tenure distribution for each department?
select department , round(  avg( (termdate - hire_date)::float /365 )::numeric  , 3) as avg_tenure 
from human_resources 
where termdate is not null 
group by department 
order by department asc ; 










