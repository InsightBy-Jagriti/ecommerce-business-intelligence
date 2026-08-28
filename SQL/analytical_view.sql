drop view if exists vw_ecommerce_analysis;

create view vw_ecommerce_analysis as
select
o.order_id,
oi.order_item_id,o.order_date,
year(o.order_date) as order_year,
month(o.order_date) as order_month,
monthname(o.order_date) as order_month_name,

o.customer_id,
concat(
    c.first_name,
    ' ',
    c.last_name
) as customer_name,

c.gender,
c.age,
c.customer_segment,

c.city as customer_city,
c.state as customer_state,
c.region as customer_region,

o.shipping_city,
o.shipping_state,
o.shipping_region,

oi.product_id,
p.product_name,
p.category,
p.subcategory,
p.brand,

oi.quantity,
oi.unit_price,
oi.discount_percent,

round(
    oi.unit_price * oi.quantity,
    2
) as gross_sales,

round(oi.sales_amount, 2) as sales_amount,

round(oi.cost_amount, 2) as cost_amount,

round(oi.profit_amount, 2) as profit_amount,

round(
    oi.profit_amount
    / nullif(oi.sales_amount, 0) * 100,
    2
) as profit_margin,

o.order_status,
o.delivery_date,

case
    when o.delivery_date is not null
    then datediff(
        o.delivery_date,
        o.order_date
    )
    else null
end as delivery_days,

case
    when o.delivery_date is null
        then 'not delivered'
    when datediff(
        o.delivery_date,
        o.order_date
    ) <= 3
        then 'fast'
    when datediff(
        o.delivery_date,
        o.order_date
    ) <= 7
        then 'standard'
    else 'delayed'
end as delivery_category,

pmt.payment_method,
pmt.payment_status,

case
    when r.return_id is not null
        then 'returned'
    else 'not returned'
end as return_status,

r.return_reason,

round(
    coalesce(r.refund_amount, 0),
    2
) as refund_amount
from orders o
join order_items oi
on o.order_id = oi.order_id
join customers c
on o.customer_id = c.customer_id
join products p
on oi.product_id = p.product_id
left join payments pmt
on o.payment_id = pmt.payment_id
left join returns r
on oi.order_id = r.order_id
and oi.product_id = r.product_id;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';

SELECT *
FROM vw_ecommerce_analysis
LIMIT 20;

-- rows check
SELECT COUNT(*) AS analytical_rows
FROM vw_ecommerce_analysis;


-- revenue
select
round(sum(sales_amount), 2) as total_revenue
from vw_ecommerce_analysis
where order_status != 'cancelled';

-- profit
select
round(sum(profit_amount), 2) as total_profit
from vw_ecommerce_analysis
where order_status != 'cancelled';

-- units
select
sum(quantity) as total_units
from vw_ecommerce_analysis
where order_status != 'cancelled';

-- orders
select
count(distinct order_id) as total_orders
from vw_ecommerce_analysis
where order_status != 'cancelled';

-- customers
select
count(distinct customer_id) as active_customers
from vw_ecommerce_analysis
where order_status != 'cancelled';


-- revenue, profit and margin by category

select
category,
round(sum(sales_amount), 2) as revenue,
round(sum(profit_amount), 2) as profit,
round(
sum(profit_amount)
/ sum(sales_amount) * 100,
2
) as profit_margin
from vw_ecommerce_analysis
where order_status != 'cancelled'
group by category
order by revenue desc;

-- q102. create a monthly sales summary view

drop view if exists vw_monthly_sales;

create view vw_monthly_sales as

select
order_year,
order_month,
order_month_name,
count(distinct order_id) as total_orders,
count(distinct customer_id) as active_customers,
sum(quantity) as units_sold,
round(sum(sales_amount), 2) as revenue,
round(sum(profit_amount), 2) as profit,
round(
sum(profit_amount)
/ nullif(sum(sales_amount), 0) * 100,
2
) as profit_margin
from vw_ecommerce_analysis
where order_status != 'cancelled'
group by
order_year,
order_month,
order_month_name;

SELECT *
FROM vw_monthly_sales
ORDER BY
    order_year,
    order_month;
    