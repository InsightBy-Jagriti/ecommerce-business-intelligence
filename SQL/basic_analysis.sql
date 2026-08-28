-- 1. total customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- 2. total products
SELECT COUNT(*) AS total_products
FROM products;

-- 3. total orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- 4. total revenue
SELECT
    ROUND(SUM(sales_amount), 2) AS total_revenue
FROM order_items;

-- 5. total profit
SELECT
    ROUND(SUM(profit_amount), 2) AS total_profit
FROM order_items;

-- 6. total units sold
SELECT
    SUM(quantity) AS total_units
FROM order_items;

-- 7. average order value
SELECT
    ROUND(
        SUM(sales_amount) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM order_items;

-- 8. revenue by category
SELECT
    p.category,
    ROUND(SUM(oi.sales_amount), 2) AS revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- 9. profit by category
SELECT
    p.category,
    ROUND(SUM(oi.profit_amount), 2) AS profit
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY profit DESC;

-- 10. revenue by region
SELECT
    o.shipping_region,
    ROUND(SUM(oi.sales_amount), 2) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.shipping_region
ORDER BY revenue DESC;