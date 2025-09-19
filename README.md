## Workforce-Demographics
### Problem Statement: 
This dataset contains employee demographic and employment information, including personal details , job-related attributes and employment history.The project aims to analyze workforce distribution, diversity, tenure, turnover, and geographic spread, in order to uncover key insights that support HR decision-making and organizational planning. 

### Data and tools used: 
- HR Data with over 22000 rows from the year 2000 to 2020
- Data cleaning and analysis : PostgreSQL
- Data visualization : PowerBI
### Questions : 
1. What is the gender breakdown of employees in the company?
2. What is the race/ethnicity breakdown of employees in the company?
3. What is the age distribution of employees in the company?
4. How many employees work at headquarters versus remote locations?
5. What is the average length of employment for employees who have been terminated?
6. How does the gender distribution vary across departments?
7. What is the distribution of job titles across the company?
8. Which department has the highest turnover rate?
9. What is the distribution of employees across locations by state?
10. What is the net change over years between hired_employee's and terminated_employee's counts ?
11. What is the average tenure distribution for each department?
### Findings and Insights summary: 
- The number of male employees is higher than female, but the difference is not too much (11288 vs 10321)
- White people are the majority in the company. In contrast, Native Hawaiians and Pacific Islanders are the least numerous
- The majority of employees in the company are between 30 and 39 years old
- The number of employees working directly at the headquarters is about 3 times higher than the number working remotely
- The average length of service of employees is about 7.68 years
- The gender distribution between men and women in different departments is quite even, with men tending to be slightly more numerous
- The jobs in the Assistant or Analyst positions have the largest number of employees
- The department with the highest turnover rate is Auditing. On the contrary, the lowest is Marketing
- Ohio is the state with the most employees with 18,025, far ahead of the second-placed Pennsylvania (1,115). Wisconsin is the state with the fewest employees (382).
- The difference (net change) between the number of new employees hired and the number of employees leaving, has generally increased steadily over the years. There was a slight decrease from 2000 to 2005, but then it increased steadily again
- The average tenure in most departments is over 9 years. Of which, the longest is the Sales department with about over 11 years.
### Dashboard (Using DAX to help build dashboard): 
[image3.bmp](https://github.com/user-attachments/files/22425038/image3.bmp)


