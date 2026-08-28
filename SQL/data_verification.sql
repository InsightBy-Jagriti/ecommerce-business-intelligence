# data verification

-- customers
select
    count(*) as total_customers,
    count(distinct customer_id) as unique_customers
from customers;


-- products
select
    count(*) as total_products,
    count(distinct product_id) as unique_products
from products;

-- orders
select
    count(*) as total_orders,
    count(distinct order_id) as unique_orders
from orders;

-- order items
select
    count(*) as total_items,
    count(distinct order_item_id) as unique_items
from order_items;

-- payments
select
    count(*) as total_payments,
    count(distinct payment_id) as unique_payments
from payments;

-- returns
select
    count(*) as total_returns,
    count(distinct return_id) as unique_returns
from returns;


# missing values

-- customers
select
    count(*) as total_rows,
    sum(customer_id is null) as missing_customer_id,
    sum(first_name is null) as missing_first_name,
    sum(state is null) as missing_state,
    sum(signup_date is null) as missing_signup_date
from customers;

-- products
select
    count(*) as total_rows,
    sum(product_id is null) as missing_product_id,
    sum(unit_cost is null) as missing_cost,
    sum(selling_price is null) as missing_price
from products;

-- orders
select
    count(*) as total_rows,
    sum(order_id is null) as missing_order_id,
    sum(customer_id is null) as missing_customer_id,
    sum(order_date is null) as missing_order_date,
    sum(delivery_date is null) as missing_delivery_date
from orders;

# relationship checks

-- orders without customers
select count(*) as invalid_orders
from orders o
left join customers c
    on o.customer_id = c.customer_id
where c.customer_id is null;

-- order items without products
select count(*) as invalid_items
from order_items oi
left join products p
    on oi.product_id = p.product_id
where p.product_id is null;

-- order items without orders
select count(*) as invalid_order_items
from order_items oi
left join orders o
    on oi.order_id = o.order_id
where o.order_id is null;

-- payments without orders
select count(*) as invalid_payments
from payments p
left join orders o
    on p.order_id = o.order_id
where o.order_id is null;

-- returns without orders
select count(*) as invalid_returns
from returns r
left join orders o
    on r.order_id = o.order_id
where o.order_id is null;
