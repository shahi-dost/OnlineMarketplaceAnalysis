-- Calculate the total number of successful campaign responses across all campaigns (1 to 6),
-- and sum the success count for each individual campaign (1 to 6).
SELECT 
    SUM(acceptedcmp1 + acceptedcmp2 + acceptedcmp3 + acceptedcmp4 + acceptedcmp5 + response) AS total,
    SUM(acceptedcmp1) AS campaign1_success,
    SUM(acceptedcmp2) AS campaign2_success,
    SUM(acceptedcmp3) AS campaign3_success,
    SUM(acceptedcmp4) AS campaign4_success,
    SUM(acceptedcmp5) AS campaign5_success,
    SUM(response) AS campaign6_success
FROM
    customer_info;

-- Calculate the average success rate (in percentage) for each campaign (1 to 6).
SELECT 
    AVG(acceptedcmp1) * 100 AS campaign1_succ_rate,
    AVG(acceptedcmp2) * 100 AS campaign2_succ_rate,
    AVG(acceptedcmp3 * 100) AS campaign3_succ_rate,
    AVG(acceptedcmp4) * 100 AS campaign4_succ_rate,
    AVG(acceptedcmp5) * 100 AS campaign5_succ_rate,
    AVG(response) * 100 AS campaign6_succ_rate
FROM
    customer_info;

-- Calculate the total number of successful campaigns and the number of customers 
-- grouped by their education level.
SELECT 
    education,
    SUM(acceptedcmp1 + acceptedcmp2 + acceptedcmp3 + acceptedcmp4 + acceptedcmp5 + response) AS total_succ_campaigns,
    COUNT(id) AS total_num_of_customers
FROM
    customer_info
GROUP BY education;

-- Calculate the total number of successful campaigns and the number of customers 
-- grouped by their marital status.
SELECT 
    marital_status,
    SUM(acceptedcmp1 + acceptedcmp2 + acceptedcmp3 + acceptedcmp4 + acceptedcmp5 + response) AS total_succ_campaigns,
    COUNT(id) AS total_num_of_customers
FROM
    customer_info
GROUP BY marital_status;

-- Calculate the total number of customers, the number of successful responses for campaign 6, 
-- and the proportion of positive responses for campaign 6 grouped by customer age.
SELECT 
    age,
    COUNT(id) AS total_num_of_customers,
    SUM(response) AS successful_campaign_6,
    SUM(response) / COUNT(id) AS proportion_yes
FROM
    customer_info
GROUP BY age
ORDER BY age;

-- Calculate the number of successful responses for campaign 6, total number of customers, 
-- and the proportion of positive responses for campaign 6 grouped by age group.
SELECT 
    age_group,
    SUM(response) AS successful_campaign_6,
    COUNT(id) AS total_per_age_group,
    SUM(response) / COUNT(id) AS proportion_yes
FROM
    customer_info
GROUP BY age_group
ORDER BY age_group;

-- Count the total number of customers joining each month, and count the number of customers joining 
-- grouped by their education level (Bachelors, PhD, Master, Basic) for each month.
SELECT 
    join_year_month,
    SUM(education = 'Bachelors') AS bachelors_joining_app,
    SUM(education = 'PhD') AS phd_joining_app,
    SUM(education = 'Master') AS master_joining_app,
    SUM(education = 'Basic') AS basic_joining_app,
    COUNT(id) AS total_joins
FROM
    customer_info
GROUP BY join_year_month
ORDER BY join_year_month;

-- Calculate the cumulative number of customers joining each month, grouped by education level (Bachelors, PhD, Master, Basic) 
-- with a cumulative count for each education group and total joins, using window functions for cumulative sum.
SELECT DISTINCT join_year_month,
    SUM(CASE WHEN education = 'Bachelors' THEN 1 ELSE 0 END) OVER (ORDER BY join_year_month) AS bachelors_joining_app,
    SUM(CASE WHEN education = 'PhD' THEN 1 ELSE 0 END) OVER (ORDER BY join_year_month) AS phd_joining_app,
    SUM(CASE WHEN education = 'Master' THEN 1 ELSE 0 END) OVER (ORDER BY join_year_month) AS master_joining_app,
    SUM(CASE WHEN education = 'Basic' THEN 1 ELSE 0 END) OVER (ORDER BY join_year_month) AS basic_joining_app,
    COUNT(id) OVER (ORDER BY join_year_month) AS total_joins
FROM customer_info ci
ORDER BY join_year_month;

-- Calculate the month-over-month growth rate for the number of customers joining, grouped by education level 
-- and total joins. The growth rate is calculated by comparing the current month 
-- to the previous month using the LAG() function.
SELECT DISTINCT join_year_month,
    ((bachelors_joining_app - lag(bachelors_joining_app,1) OVER (ORDER BY join_year_month))*100) / lag(bachelors_joining_app,1) OVER (ORDER BY join_year_month) AS bachelors_growth_rate,
    ((phd_joining_app - lag(phd_joining_app,1) OVER (ORDER BY join_year_month))*100) / lag(phd_joining_app,1) OVER (ORDER BY join_year_month) AS phd_growth_rate,
    ((master_joining_app - lag(master_joining_app,1) OVER (ORDER BY join_year_month))*100) / lag(master_joining_app,1) OVER (ORDER BY join_year_month) AS masters_growth_rate,
    ((basic_joining_app - lag(basic_joining_app,1) OVER (ORDER BY join_year_month))*100) / lag(basic_joining_app,1) OVER (ORDER BY join_year_month) AS basic_growth_rate,
    ((total_joins - lag(total_joins,1) OVER (ORDER BY join_year_month))*100) / lag(total_joins,1) OVER (ORDER BY join_year_month) AS total_growth_rate
FROM cumm_sum_Customers ci
ORDER BY join_year_month;
