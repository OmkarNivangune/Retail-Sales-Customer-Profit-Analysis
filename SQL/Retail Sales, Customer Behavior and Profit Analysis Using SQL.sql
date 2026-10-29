CREATE DATABASE retail_analysis;
USE retail_analysis;

-- Retail Sales, Customer Behavior and Profit Analysis Using SQL
-- Database: retail_analysis
-- Table: sales
-- Tool: MySQL Workbench

USE retail_analysis;


-- 1. Check total number of records
SELECT COUNT(*) AS total_records
FROM sales;


-- 2. Check table structure
DESCRIBE sales;


-- 3. Check missing values
SELECT
    SUM(`Order ID` IS NULL) AS missing_order_id,
    SUM(`Customer ID` IS NULL) AS missing_customer_id,
    SUM(`Order Date` IS NULL) AS missing_order_date,
    SUM(Sales IS NULL) AS missing_sales,
    SUM(Profit IS NULL) AS missing_profit
FROM sales;


-- 4. Check duplicate order and product combinations
SELECT
    `Order ID`,
    `Product ID`,
    COUNT(*) AS row_count
FROM sales
GROUP BY `Order ID`, `Product ID`
HAVING COUNT(*) > 1;


-- 5. Find the first and last order dates
SELECT
    MIN(`Order Date`) AS first_order_date,
    MAX(`Order Date`) AS last_order_date
FROM sales;


-- 6. Calculate total sales, profit, and profit margin
SELECT
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(
        SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2
    ) AS profit_margin_pct
FROM sales;


-- 7. Calculate total orders, customers, and units sold
SELECT
    COUNT(DISTINCT `Order ID`) AS total_orders,
    COUNT(DISTINCT `Customer ID`) AS total_customers,
    SUM(Quantity) AS total_units_sold
FROM sales;


-- 8. Analyze sales and profit by category
SELECT
    Category,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY Category
ORDER BY total_profit DESC;


-- 9. Find loss-making subcategories
SELECT
    Category,
    `Sub-Category`,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY Category, `Sub-Category`
HAVING SUM(Profit) < 0
ORDER BY total_profit;


-- 10. Analyze regional performance
SELECT
    Region,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(
        SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2
    ) AS profit_margin_pct
FROM sales
GROUP BY Region
ORDER BY total_profit DESC;


-- 11. Find the 10 least profitable products
SELECT
    `Product ID`,
    `Product Name`,
    SUM(Quantity) AS units_sold,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY `Product ID`, `Product Name`
ORDER BY total_profit ASC
LIMIT 10;


-- 12. Analyze discount levels and profitability
SELECT
    Discount,
    COUNT(*) AS total_rows,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(Profit), 2) AS avg_profit_per_row
FROM sales
GROUP BY Discount
ORDER BY Discount;


-- 13. Find high-discount products with negative profit
SELECT
    `Product Name`,
    Category,
    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY `Product Name`, Category
HAVING AVG(Discount) >= 0.30
   AND SUM(Profit) < 0
ORDER BY total_profit ASC;


-- 14. Calculate total losses on loss-making rows
SELECT
    COUNT(*) AS loss_making_rows,
    ROUND(SUM(Sales), 2) AS sales_on_loss_rows,
    ROUND(SUM(Profit), 2) AS net_profit_on_loss_rows,
    ROUND(SUM(-Profit), 2) AS gross_loss_amount
FROM sales
WHERE Profit < 0;


-- 15. Compare profit margins across categories
SELECT
    Category,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(
        SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2
    ) AS profit_margin_pct
FROM sales
GROUP BY Category
ORDER BY profit_margin_pct ASC;


-- 16. Analyze profitability by shipping mode
SELECT
    `Ship Mode`,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY `Ship Mode`
ORDER BY total_profit ASC;


-- 17. Find the top 10 customers by sales
SELECT
    `Customer ID`,
    `Customer Name`,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY `Customer ID`, `Customer Name`
ORDER BY total_sales DESC
LIMIT 10;


-- 18. Identify repeat customers
SELECT
    `Customer ID`,
    `Customer Name`,
    COUNT(DISTINCT `Order ID`) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales
FROM sales
GROUP BY `Customer ID`, `Customer Name`
HAVING COUNT(DISTINCT `Order ID`) > 1
ORDER BY total_orders DESC;


-- 19. Find customers with the lowest profit margins
SELECT
    `Customer ID`,
    `Customer Name`,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(
        SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2
    ) AS profit_margin_pct
FROM sales
GROUP BY `Customer ID`, `Customer Name`
HAVING SUM(Sales) > 0
ORDER BY profit_margin_pct ASC
LIMIT 10;


-- 20. Analyze customer segment performance
SELECT
    Segment,
    COUNT(DISTINCT `Customer ID`) AS total_customers,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(
        SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2
    ) AS profit_margin_pct
FROM sales
GROUP BY Segment
ORDER BY total_profit DESC;


-- 21. Rank the top 10 customers by profit
WITH customer_profit AS (
    SELECT
        `Customer ID`,
        `Customer Name`,
        SUM(Profit) AS total_profit
    FROM sales
    GROUP BY `Customer ID`, `Customer Name`
)
SELECT
    `Customer ID`,
    `Customer Name`,
    ROUND(total_profit, 2) AS total_profit,
    RANK() OVER (ORDER BY total_profit DESC) AS profit_rank
FROM customer_profit
ORDER BY profit_rank
LIMIT 10;


-- 22. Analyze monthly sales and profit trends
SELECT
    DATE_FORMAT(`Order Date`, '%Y-%m') AS order_month,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY DATE_FORMAT(`Order Date`, '%Y-%m')
ORDER BY order_month;


-- 23. Compare monthly profit with the previous month
WITH monthly_profit AS (
    SELECT
        DATE_FORMAT(`Order Date`, '%Y-%m') AS order_month,
        SUM(Profit) AS total_profit
    FROM sales
    GROUP BY DATE_FORMAT(`Order Date`, '%Y-%m')
),
profit_comparison AS (
    SELECT
        order_month,
        total_profit,
        LAG(total_profit) OVER (
            ORDER BY order_month
        ) AS previous_month_profit
    FROM monthly_profit
)
SELECT
    order_month,
    ROUND(total_profit, 2) AS total_profit,
    ROUND(previous_month_profit, 2) AS previous_month_profit,
    ROUND(total_profit - previous_month_profit, 2) AS profit_change
FROM profit_comparison
ORDER BY order_month;


-- 24. Find the top five profitable products in each category
WITH product_profit AS (
    SELECT
        Category,
        `Product Name`,
        SUM(Profit) AS total_profit
    FROM sales
    GROUP BY Category, `Product Name`
),
ranked_products AS (
    SELECT
        Category,
        `Product Name`,
        total_profit,
        RANK() OVER (
            PARTITION BY Category
            ORDER BY total_profit DESC
        ) AS product_rank
    FROM product_profit
)
SELECT
    Category,
    `Product Name`,
    ROUND(total_profit, 2) AS total_profit,
    product_rank
FROM ranked_products
WHERE product_rank <= 5
ORDER BY Category, product_rank;


-- 25. Compare state-wise sales and profit
SELECT
    State,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY State
ORDER BY total_profit ASC;


-- 26. Calculate average order value and profit per order
WITH order_totals AS (
    SELECT
        `Order ID`,
        SUM(Sales) AS order_sales,
        SUM(Profit) AS order_profit
    FROM sales
    GROUP BY `Order ID`
)
SELECT
    COUNT(*) AS total_orders,
    ROUND(AVG(order_sales), 2) AS average_order_value,
    ROUND(AVG(order_profit), 2) AS average_profit_per_order
FROM order_totals;


-- 27. Identify high-sales products with low profit margins
SELECT
    `Product Name`,
    Category,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(
        SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2
    ) AS profit_margin_pct
FROM sales
GROUP BY `Product Name`, Category
HAVING SUM(Sales) > 0
ORDER BY total_sales DESC, profit_margin_pct ASC
LIMIT 20;


-- 28. Compare average order value by customer segment
WITH order_totals AS (
    SELECT
        Segment,
        `Order ID`,
        SUM(Sales) AS order_sales
    FROM sales
    GROUP BY Segment, `Order ID`
)
SELECT
    Segment,
    COUNT(*) AS total_orders,
    ROUND(AVG(order_sales), 2) AS average_order_value
FROM order_totals
GROUP BY Segment
ORDER BY average_order_value DESC;


-- 29. Compare average discounts by customer segment
SELECT
    Segment,
    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY Segment
ORDER BY avg_discount_pct DESC;


-- 30. Flag products that need profitability investigation
SELECT
    `Product Name`,
    Category,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct,
    CASE
        WHEN SUM(Profit) < 0 AND AVG(Discount) >= 0.30
            THEN 'High Priority: Loss and High Discount'
        WHEN SUM(Profit) < 0
            THEN 'Review: Negative Profit'
        WHEN SUM(Profit) > 0
             AND SUM(Profit) / NULLIF(SUM(Sales), 0) < 0.05
            THEN 'Review: Low Profit Margin'
        ELSE 'No Immediate Flag'
    END AS investigation_status
FROM sales
GROUP BY `Product Name`, Category
ORDER BY
    CASE
        WHEN SUM(Profit) < 0 AND AVG(Discount) >= 0.30 THEN 1
        WHEN SUM(Profit) < 0 THEN 2
        WHEN SUM(Profit) > 0
             AND SUM(Profit) / NULLIF(SUM(Sales), 0) < 0.05 THEN 3
        ELSE 4
    END,
    total_profit ASC;
