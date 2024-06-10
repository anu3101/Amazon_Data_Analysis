CREATE TABLE amazon(
	id int,
	order_id varchar(50),
	order_date date,	
	ship_date date,	ship_mode varchar(50),
	customer_id varchar(50),
	customer_name varchar(50),
	Segment varchar(50),
	Country varchar(50),
	City varchar(50),
	State varchar(50),
	Region varchar(50),
	product_id varchar(50),	
	Category varchar(50),
	sub_category varchar(50),
	product_name varchar(250),
	Sales float,
	Quantity int,
	Profit float,
	payment_mode varchar(50)
);
#-- Import data from csv in tables.

#--Count total records/sales
SELECT COUNT(*) FROM sales_data;

#-- Total sales by states
SELECT State, SUM(sales) AS total_sales 
FROM sales_data 
GROUP BY State;

#--Calcualte average sales by state
SELECT State, AVG(sales) AS average_sales 
FROM sales_data
GROUP BY State;

#--Maximum sales 
SELECT MAX(sales) AS max_sales 
FROM sales_data;

#--Total Profit
SELECT SUM(Profit) AS total_profit 
FROM sales_data;

#--Calculate minimum profit
SELECT MIN(profit) AS min_profit 
FROM sales_data;

#--Quantity sold for each product
SELECT product_name, SUM(quantity) AS total_quantity 
FROM sales_data 
GROUP BY product_name;

#--Total sales by region
SELECT Region, SUM(Sales) AS total_sales 
FROM sales_data 
GROUP BY Region;

#--Total sales by payment method
SELECT payment_mode, SUM(Sales) AS total_sales 
FROM sales_data 
GROUP BY payment_mode;

#--Sales by category
SELECT Category, SUM(Sales) AS total_sales 
FROM sales_data 
GROUP BY Category;

#--Sales by shipping mode
SELECT ship_mode, SUM(Sales) AS total_sales 
FROM sales_data 
GROUP BY ship_mode;

#-- Profit by year
SELECT EXTRACT(YEAR FROM order_date) AS order_year, SUM(Profit) AS total_profit
FROM sales_data
GROUP BY order_year;

#--Profit by month and year
SELECT EXTRACT(YEAR FROM order_date) AS order_year, 
       EXTRACT(MONTH FROM order_date) AS order_month, 
       SUM(Profit) AS total_profit
FROM sales_data
GROUP BY order_year, order_month
ORDER BY order_year, order_month;

#--Sales gretaer than average
SELECT * FROM sales_data 
WHERE sales > (SELECT AVG(sales) FROM sales_data);

#--Sales Values
SELECT order_id, sales, 
       CASE 
           WHEN sales > 200 THEN 'High'
           WHEN sales BETWEEN 100 AND 200 THEN 'Medium'
           ELSE 'Low'
       END AS sales_category
FROM sales_data;

#--Find second highest sales
SELECT MAX(sales) AS second_highest_sales 
FROM sales_data 
WHERE sales < (SELECT MAX(sales) FROM sales_data);

#-- Calculate cumulative sales by date
SELECT order_date, sales, 
 SUM(sales) OVER (ORDER BY order_date) AS cumulative_sales 
FROM sales_data;

#--Sales between specific dates
SELECT * FROM sales_data 
WHERE order_date BETWEEN '2019-01-01' AND '2019-12-31';

#--Selecting sales between regions
SELECT customer_id, sales FROM sales_data WHERE Region = 'East'
UNION
SELECT customer_id, sales FROM sales_data WHERE Region = 'West';

#-- Sales greater than 100
SELECT State, SUM(sales) AS total_sales 
FROM sales_data 
GROUP BY State 
HAVING SUM(sales) > 1000;

#--Get previous sales
SELECT order_id, sales, 
       LAG(sales, 1) OVER (ORDER BY order_date) AS previous_sales 
FROM sales_data;

#--Customers by sales 
SELECT customer_id, SUM(sales) AS total_sales, 
       RANK() OVER (ORDER BY SUM(sales) DESC) AS sales_rank 
FROM sales_data 
GROUP BY customer_id;

#--Top 10 products by sales
SELECT product_name, SUM(sales) AS total_sales 
FROM sales_data 
GROUP BY product_name 
ORDER BY total_sales DESC 
LIMIT 10;

#--Sales by segment
SELECT Segment, 
       SUM(sales) AS total_sales, 
       AVG(sales) AS avg_sales, 
       SUM(profit) AS total_profit 
FROM sales_data 
GROUP BY Segment;

#--Profit margin by product
SELECT product_name, 
       SUM(profit) / SUM(sales) * 100 AS profit_margin 
FROM sales_data 
GROUP BY product_name 
ORDER BY profit_margin DESC;

#--Percnetage pf sales by category
SELECT Category, 
       SUM(sales) AS total_sales, 
       SUM(sales) * 100.0 / SUM(SUM(sales)) OVER () AS sales_percentage 
FROM sales_data 
GROUP BY Category;

#--Growth rate of sales
WITH SalesByMonth AS (
    SELECT DATE_TRUNC('month', order_date) AS order_month, 
           SUM(sales) AS monthly_sales 
    FROM sales_data 
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT order_month, monthly_sales, 
       (monthly_sales - LAG(monthly_sales) OVER (ORDER BY order_month)) / LAG(monthly_sales) OVER (ORDER BY order_month) AS growth_rate 
FROM SalesByMonth;

#-- Sales distribution by region
SELECT Region, 
       SUM(sales) AS total_sales, 
       PERCENT_RANK() OVER (ORDER BY SUM(sales)) AS sales_percentile 
FROM sales_data 
GROUP BY Region;

#--Average time to ship
SELECT order_id, order_date, ship_date, 
       DATEDIFF(day, order_date, ship_date) AS days_to_ship 
FROM sales_data;

#-- Customer churn analysis
WITH LastOrder AS (
    SELECT customer_id, MAX(order_date) AS last_order_date 
    FROM sales_data 
    GROUP BY customer_id
)
SELECT customer_id, last_order_date, 
       DATEDIFF(day, last_order_date, CURRENT_DATE) AS days_since_last_order 
FROM LastOrder 
WHERE DATEDIFF(day, last_order_date, CURRENT_DATE) > 180;


#--Season analysis of orders
SELECT DATE_PART('month', order_date) AS order_month, 
       SUM(sales) AS total_sales 
FROM sales_data 
GROUP BY order_month 
ORDER BY order_month;




