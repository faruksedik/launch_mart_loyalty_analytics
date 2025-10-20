
-- 1. Count the total number of customers who joined in 2023.
SELECT
	COUNT(*) AS customers_joined_2023
FROM 
	customers
WHERE 
	join_date BETWEEN '2023-01-01' AND '2023-12-31';


-- 2. For each customer return customer_id, full_name, total_revenue (sum of total_amount from orders). Sort descending.

WITH customer_total_amount_spent AS (
	SELECT
		c.customer_id,
		c.full_name,
		COALESCE(SUM(o.total_amount),0) AS total_revenue 
	FROM 
		customers c 
	LEFT JOIN 
		orders o ON c.customer_id = o.customer_id
	GROUP BY 
		c.customer_id, c.full_name
)
SELECT 
	customer_id, 
	full_name, 
	total_revenue
FROM 
	customer_total_amount_spent
ORDER BY 
	total_revenue DESC;



-- 3) Return the top 5 customers by total_revenue with their rank.

WITH customer_revenue AS (
	SELECT
    	c.customer_id,
    	c.full_name,
    	COALESCE(SUM(o.total_amount), 0) AS total_revenue
  	FROM 
  		customers c
  	LEFT JOIN 
  		orders o ON c.customer_id = o.customer_id
  	GROUP BY 
  		c.customer_id, c.full_name
),
customer_revenue_ranked AS (
  	SELECT
	    customer_id,
	    full_name,
	    total_revenue,
	    DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS spend_rank
  	FROM 
  		customer_revenue
)
SELECT 
	customer_id, 
	full_name, 
	total_revenue, 
	spend_rank
FROM 
	customer_revenue_ranked
WHERE 
	spend_rank <= 5
ORDER BY 
	total_revenue DESC;


-- 4) Produce a table with year, month, monthly_revenue for all months in 2023 ordered chronologically.

WITH calendar_year AS (
  	SELECT 
  		generate_series('2023-01-01'::date, '2023-12-01'::date, INTERVAL '1 month')::date AS month_starts
)
SELECT 
	EXTRACT(YEAR FROM cy.month_starts)::text AS YEAR,
	EXTRACT(MONTH FROM cy.month_starts) AS MONTH,
	COALESCE(SUM(o.total_amount), 0) AS monthly_revenue
FROM calendar_year cy
LEFT JOIN orders o 
	ON cy.month_starts = date_trunc('month', o.order_date) 
GROUP BY 
	cy.month_starts
ORDER BY 
	cy.month_starts;

/*
 * 5) Find customers with no orders in the last 60 days relative to 2023-12-31 
 * (i.e., consider last active date up to 2023-12-31). 
 * Return customer_id, full_name, last_order_date.
*/

WITH customer_last_order AS (
  	SELECT
	    c.customer_id,
	    c.full_name,
	    MAX(o.order_date) AS last_order_date
  	FROM 
  		customers c
  	LEFT JOIN 
  		orders o ON c.customer_id = o.customer_id
  	GROUP BY 
  		c.customer_id, c.full_name
)
SELECT 
	customer_id,
	full_name,
	last_order_date
FROM
	customer_last_order
WHERE 
	last_order_date <= '2023-12-31'::date - INTERVAL '60 day'
ORDER BY last_order_date;


/*
 * 6) Calculate average order value (AOV) 
 * for each customer: return customer_id, full_name, aov (average total_amount of their orders). 
 * Exclude customers with no orders.*/

WITH customer_average_order_value AS (
  	SELECT
	    c.customer_id,
	    c.full_name,
	    AVG(o.total_amount) AS aov,
	    COALESCE(COUNT(o.order_id), 0) AS orders_count
  	FROM 
  		customers c
  	JOIN 
  		orders o ON c.customer_id = o.customer_id
  	GROUP BY 
  		c.customer_id, c.full_name
)
SELECT 
	customer_id, 
	full_name, 
	ROUND(aov::numeric, 2) AS aov
FROM 
	customer_average_order_value
WHERE 
	orders_count > 0
ORDER BY
	aov DESC;


/*
 * 7) For all customers who have at least one order, compute customer_id, full_name, 
 * total_revenue, spend_rank where spend_rank is a dense rank, highest spender = rank 1. 
 * */

WITH customer_total_revenue AS (
	SELECT
	    c.customer_id,
	    c.full_name,
	    SUM(o.total_amount) AS total_revenue
  	FROM 
  		customers c
  	JOIN 	
  		orders o ON c.customer_id = o.customer_id
  	GROUP BY 
  		c.customer_id, c.full_name
)
SELECT
  	customer_id,
  	full_name,
  	total_revenue,
  	DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS spend_rank
FROM 
	customer_total_revenue
ORDER BY 
	spend_rank;

/*
 * 8) List customers who placed more than 1 order and show customer_id, 
 * full_name, order_count, first_order_date, last_order_date.
 * */

WITH customer_orders_count AS (
	SELECT
	    c.customer_id,
	    c.full_name,
	    COUNT(o.order_id) AS orders_count,
	    MIN(o.order_date) AS first_order_date,
	    MAX(o.order_date) AS last_order_date
  	FROM 
  		customers c
  	JOIN 
  		orders o ON c.customer_id = o.customer_id
  	GROUP BY 
  		c.customer_id, c.full_name
)
SELECT customer_id, full_name, orders_count, first_order_date, last_order_date
FROM customer_orders_count 
WHERE orders_count > 1;


-- 9) Compute total loyalty points per customer. Include customers with 0 points.

WITH total_loyalty_points_per_customer AS (
	SELECT
		c.customer_id,
	    c.full_name,
	    COALESCE(SUM(lp.points_earned), 0) AS total_points
	FROM 
		customers c
	LEFT JOIN 
		loyalty_points lp
		ON c.customer_id = lp.customer_id 
	GROUP BY 
		c.customer_id, c.full_name
)
SELECT customer_id, full_name, total_points
FROM total_loyalty_points_per_customer
WHERE total_points >= 0
ORDER BY total_points DESC;

-- 10) Loyalty tier assignment, tier counts and total points per tier

WITH customer_points AS (
  	SELECT
    	c.customer_id,
    	COALESCE(SUM(lp.points_earned), 0) AS total_points
  	FROM 
  		customers c
  	LEFT JOIN 
  		loyalty_points lp 
  		ON c.customer_id = lp.customer_id
  	GROUP BY 
  		c.customer_id
),
tier_assignment AS (
  	SELECT
    	customer_id,
    	total_points,
    CASE
      	WHEN total_points >= 500 THEN 'Gold'
      	WHEN total_points >= 100 THEN 'Silver'
      	ELSE 'Bronze'
    END AS tier
  	FROM 
  		customer_points
)
SELECT
  	tier,
  	COUNT(*)        	AS tier_count,
  	SUM(total_points) 	AS tier_total_points
FROM 
	tier_assignment
GROUP BY 
	tier
ORDER BY
  -- order tiers from highest to lowest (Gold, Silver, Bronze)
  	CASE tier WHEN 'Gold' THEN 1 WHEN 'Silver' THEN 2 WHEN 'Bronze' THEN 3 END;
 
 -- 11) Identify customers who spent more than ₦50,000 total but have less than 200 loyalty points
  
WITH customer_total_spend_and_total_points AS (
	SELECT
		c.customer_id,
	    c.full_name,
	    COALESCE(SUM(o.total_amount), 0) 	AS total_spent,
	    COALESCE(SUM(lp.points_earned), 0) 	AS total_points
	FROM 
		customers c
	LEFT JOIN 
		orders o 
		ON c.customer_id = o.customer_id
	LEFT JOIN 
		loyalty_points lp
		ON c.customer_id = lp.customer_id 
	GROUP BY 
		c.customer_id, c.full_name
)
SELECT
	customer_id,
    full_name,
    total_spent,
    total_points
FROM 
	customer_total_spend_and_total_points
WHERE 
	total_spent > 50000 AND total_points < 200;


/* 
 * 12)
 * Flag customers as churn_risk if they have no orders in the last 90 days (relative to 2023-12-31) 
 * AND are in the Bronze tier. 
 * Return customer_id, full_name, last_order_date, total_points.
 * */

WITH customer_last_order_date AS (
	SELECT
		c.customer_id,
	    c.full_name,
	    MAX(o.order_date) AS last_order_date, 
	    COALESCE(SUM(o.total_amount), 0) AS total_spent,
	    COALESCE(SUM(lp.points_earned), 0) AS total_points
	FROM 
		customers c
	LEFT JOIN 
		orders o 
		ON c.customer_id = o.customer_id
	LEFT JOIN 
		loyalty_points lp
		ON c.customer_id = lp.customer_id 
	GROUP BY 
		c.customer_id, c.full_name
)
SELECT 
	customer_id,
    full_name,
    last_order_date, 
    total_spent,
    total_points
FROM 
	customer_last_order_date
WHERE
  	-- Bronze tier
  	total_points < 100
  	-- no orders in the last 90 days (last_order_date is NULL OR last_order_date <= '2023-12-31' - 90 days)
  	AND (
    	last_order_date IS NULL
    	OR last_order_date <= ('2023-12-31'::date - INTERVAL '90 days')
 	)
ORDER BY total_points ASC, last_order_date NULLS FIRST;












