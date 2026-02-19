-- Sql Retail Slaes Analysis- P1
CREATE DATABASE Retail_Sales;
USE Retail_Sales;

-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
						transactions_id	INT PRIMARY KEY,
 						sale_date	DATE,
						sale_time	TIME,
						customer_id	INT,
						gender	VARCHAR(20),
						age	INT,
						category VARCHAR(20),	
 						quantiy	FLOAT,
 						price_per_unit	INT,
					    cogs  FLOAT,
						total_sale INT
 )

SELECT * 
FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;-- 

SELECT * 
FROM retail_sales;

-- HOW MANY RECORDS WE HAVE	 
SELECT COUNT(*) as total_sale FROM retail_sales;

-- HOW MANY UNIQUE CUSTOMERS WE HAVE	 
SELECT COUNT(DISTINCT customer_id) as UNIQUE_CUSTOMERS FROM retail_sales;

-- HOW MANY UNIQUE CATEGORIES WE HAVE	 
SELECT DISTINCT category as UNIQUE_CATEGORY FROM retail_sales;

-- DATA ANALYSIS AND BUISNESS KEY PROBLEMS AND ANS

-- 1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
SELECT * FROM retail_sales WHERE sale_date= '2022-11-05';

-- 2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
--  ```sql
SELECT * FROM retail_sales 
WHERE 
	category= 'Clothing' 
    AND 
    quantiy>=4
    AND
    date_format(sale_date, '%Y-%m')= '2022-11';
    
-- 3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
-- ```sql
SELECT
category, SUM(total_sale) AS net_sale,
COUNT(*) AS total_orders
FROM retail_sales
group by category;

-- 4**Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
SELECT 
	category, avg(age) AS AVG_AGE 
FROM retail_sales
WHERE category='Beauty' ;

-- 5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
SELECT * FROM retail_sales WHERE total_sale> 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
select 
gender, count(transactions_id) AS TOTAL_TRANSACTIONS
FROM retail_sales
group by gender;

-- --- - 7. Write a SQL query to calculate the average sale for each month. 
-- Find out best selling month in each year**:

SELECT *
FROM (
    SELECT 
        year,
        month,
        avg_sale,
        RANK() OVER(ORDER BY avg_sale DESC) AS rnk
    FROM (
        SELECT 
            YEAR(sale_date) AS year,
            MONTH(sale_date) AS month,
            AVG(total_sale) AS avg_sale
        FROM retail_sales
        GROUP BY year, month
    ) t
) x
WHERE rnk = 1
ORDER BY year, avg_sale DESC;

-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales **:

SELECT
	customer_id, SUM(total_sale) as total_sales
FROM retail_sales
	GROUP BY customer_id
	order by total_sales DESC
	limit 5; 

-- 8.Write a SQL query to find the number of unique customers who purchased items from each category.
select 
	category, COUNT(DISTINCT customer_id) AS unique_customers
    FROM retail_sales
GROUP BY category;

--  10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
-- ```sql

WITH hourly_sale
AS
(
SELECT *,
CASE
		WHEN hour(sale_time) < 12 THEN 'Morning_Shift'
		WHEN hour(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon_shift'
		ELSE 'Evening_shift'
		END as shift
FROM retail_sales
)
SELECT 
shift, count(*) as Total_orders
FROM hourly_sale
GROUP BY shift;

-- END OF PROJECT
