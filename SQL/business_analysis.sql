-- q1. how many customers does the company have?
select
    count(*) as total_customers
from customers;


-- q2. how many products are being sold?
select
    count(*) as total_products
from products;


-- q3. how many orders have been placed?
select
    count(*) as total_orders
from orders;


-- q4. how many units have been sold?
select
    sum(quantity) as total_units_sold
from order_items;


-- q5. what is the total revenue?
select
    round(sum(sales_amount), 2) as total_revenue
from order_items;


-- q6. what is the total profit?
select
    round(sum(profit_amount), 2) as total_profit
from order_items;


-- q7. what is the overall profit margin?
select
    round(
        sum(profit_amount) / sum(sales_amount) * 100,
        2
    ) as profit_margin
from order_items;


-- q8. what is the average order value?
select
    round(
        sum(sales_amount) / count(distinct order_id),
        2
    ) as average_order_value
from order_items;


-- q9. which category generates the most revenue?
select
    p.category,
    round(sum(oi.sales_amount), 2) as revenue
from order_items oi
join products p
    on oi.product_id = p.product_id
group by p.category
order by revenue desc;


-- q10. which category generates the most profit?
select
    p.category,
    round(sum(oi.profit_amount), 2) as profit
from order_items oi
join products p
    on oi.product_id = p.product_id
group by p.category
order by profit desc;


-- q11. which category has the highest profit margin?
select
    p.category,
    round(
        sum(oi.profit_amount) / sum(oi.sales_amount) * 100,
        2
    ) as profit_margin
from order_items oi
join products p
    on oi.product_id = p.product_id
group by p.category
order by profit_margin desc;


-- q12. what are the top 10 products by revenue?
select
    p.product_id,
    p.product_name,
    p.category,
    round(sum(oi.sales_amount), 2) as revenue
from order_items oi
join products p
    on oi.product_id = p.product_id
group by
    p.product_id,
    p.product_name,
    p.category
order by revenue desc
limit 10;


-- q13. what are the top 10 products by profit?
select
    p.product_id,
    p.product_name,
    p.category,
    round(sum(oi.profit_amount), 2) as profit
from order_items oi
join products p
    on oi.product_id = p.product_id
group by
    p.product_id,
    p.product_name,
    p.category
order by profit desc
limit 10;


-- q14. which regions generate the most revenue?
select
    o.shipping_region as region,
    round(sum(oi.sales_amount), 2) as revenue
from orders o
join order_items oi
    on o.order_id = oi.order_id
group by o.shipping_region
order by revenue desc;


-- q15. which states generate the most revenue?
select
    o.shipping_state as state,
    round(sum(oi.sales_amount), 2) as revenue
from orders o
join order_items oi
    on o.order_id = oi.order_id
group by o.shipping_state
order by revenue desc;


-- q16. which customer segment generates the most revenue?
select
    c.customer_segment,
    count(distinct c.customer_id) as customers,
    round(sum(oi.sales_amount), 2) as revenue,
    round(sum(oi.profit_amount), 2) as profit
from customers c
join orders o
    on c.customer_id = o.customer_id
join order_items oi
    on o.order_id = oi.order_id
group by c.customer_segment
order by revenue desc;


-- q17. which payment method generates the most revenue?
select
    p.payment_method,
    count(distinct p.order_id) as orders,
    round(sum(p.transaction_amount), 2) as revenue
from payments p
group by p.payment_method
order by revenue desc;


-- q18. what is the monthly revenue trend?
select
    year(o.order_date) as year,
    month(o.order_date) as month,
    round(sum(oi.sales_amount), 2) as revenue
from orders o
join order_items oi
    on o.order_id = oi.order_id
group by
    year(o.order_date),
    month(o.order_date)
order by
    year,
    month;


-- q19. what are the most common return reasons?
select
    return_reason,
    count(*) as return_count,
    round(
        count(*) * 100.0 /
        (select count(*) from returns),
        2
    ) as return_percentage
from returns
group by return_reason
order by return_count desc;


-- q20. which categories have the highest return rates?
select
    p.category,
    count(distinct oi.order_id) as total_orders,
    count(distinct r.return_id) as total_returns,
    round(
        count(distinct r.return_id) * 100.0 /
        count(distinct oi.order_id),
        2
    ) as return_rate
from order_items oi
join products p
    on oi.product_id = p.product_id
left join returns r
    on oi.order_id = r.order_id
    and oi.product_id = r.product_id
group by p.category
order by return_rate desc;