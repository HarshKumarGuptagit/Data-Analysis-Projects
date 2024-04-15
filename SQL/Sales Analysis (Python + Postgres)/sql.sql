--find top 10 highest revenue generating products 
SELECT PRODUCT_ID,SUM(SALE_PRICE) AS TOTAL_REVENUE
FROM ORDERS_TABLE
GROUP BY 1
ORDER BY SUM(SALE_PRICE) DESC
LIMIT 10;

--find top 5 highest selling products in each region
with cte as(
	SELECT region,product_id,SUM(sale_price),
	row_Number() Over (partition by region order by sum(sale_price) desc) as rn
	FROM orders_table		
	group by 1,2
)
select * from cte
where rn<=5
order by region,rn desc

;


select * from orders_table;
	
--find month over month growth comparision for 2022 and 2023 sales eg : jan 2022 vs jan 2023
with cte as 
	(SELECT 
		EXTRACT(month FROM order_date) as month,
		EXTRACT (Year from order_date) as year,
		sum(sale_price) as sales
	FROM orders_table
	group by 2,1
	ORDER BY 1,2),
cte2 as(
	select *,
		lag(sales,1,sales) over  (order by 1,2) as pre_sales 
	from cte
)
SELECT 
	month,
	year,
	sales,
	concat(round(((sales-pre_sales)*100/pre_sales)::numeric,2), ' %') as YoY
from cte2;


WITH cte AS (
    SELECT
        DATE_TRUNC('month', order_date) AS order_month,
        SUM(sale_price) AS sales
    FROM
        orders_table
    WHERE
        order_date >= '2022-01-01' AND order_date < '2024-01-01' -- Filter for years 2022 and 2023
    GROUP BY
        DATE_TRUNC('month', order_date)
)
SELECT
    EXTRACT(month FROM order_month) AS order_month,
    SUM(CASE WHEN EXTRACT(year FROM order_month) = 2022 THEN sales ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN EXTRACT(year FROM order_month) = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM
    cte
GROUP BY
    EXTRACT(month FROM order_month)
ORDER BY
    EXTRACT(month FROM order_month);




--for each category which month had highest sales 

--which sub category had highest growth by profit in 2023 compare to 2022
