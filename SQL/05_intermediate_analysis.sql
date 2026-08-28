-- q21. what is the revenue and profit for each subcategory?
select
    p.category,
    p.subcategory,
    round(sum(oi.sales_amount), 2) as revenue,
    round(sum(oi.profit_amount), 2) as profit
from order_items oi
join products p
    on oi.product_id = p.product_id
group by
    p.category,
    p.subcategory
order by revenue desc;


-- q22. which products have generated revenue above the average product revenue?
select
    p.product_id,
    p.product_name,
    round(sum(oi.sales_amount), 2) as revenue
from order_items oi
join products p
    on oi.product_id = p.product_id
group by
    p.product_id,
    p.product_name
having sum(oi.sales_amount) > (
    select avg(product_revenue)
    from (
        select
            product_id,
            sum(sales_amount) as product_revenue
        from order_items
        group by product_id
    ) as product_sales
)
order by revenue desc;


-- q23. which customers have spent more than the average customer?
select
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as customer_name,
    round(sum(oi.sales_amount), 2) as total_spent
from customers c
join orders o
    on c.customer_id = o.customer_id
join order_items oi
    on o.order_id = oi.order_id
group by
    c.customer_id,
    c.first_name,
    c.last_name
having sum(oi.sales_amount) > (
    select avg(customer_spending)
    from (
        select
            o.customer_id,
            sum(oi.sales_amount) as customer_spending
        from orders o
        join order_items oi
            on o.order_id = oi.order_id
        group by o.customer_id
    ) as customer_sales
)
order by total_spent desc;


-- q24. how many orders does each customer place?
select
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as customer_name,
    count(distinct o.order_id) as total_orders
from customers c
left join orders o
    on c.customer_id = o.customer_id
group by
    c.customer_id,
    c.first_name,
    c.last_name
order by total_orders desc;


-- q25. identify customers with more than 5 orders
select
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as customer_name,
    count(distinct o.order_id) as total_orders
from customers c
join orders o
    on c.customer_id = o.customer_id
group by
    c.customer_id,
    c.first_name,
    c.last_name
having count(distinct o.order_id) > 5
order by total_orders desc;


-- q26. what is the average order value for each customer segment?
select
    c.customer_segment,
    round(
        sum(oi.sales_amount) / count(distinct o.order_id),
        2
    ) as average_order_value
from customers c
join orders o
    on c.customer_id = o.customer_id
join order_items oi
    on o.order_id = oi.order_id
group by c.customer_segment
order by average_order_value desc;


-- q27. which customer segment has the highest profit margin?
select
    c.customer_segment,
    round(sum(oi.sales_amount), 2) as revenue,
    round(sum(oi.profit_amount), 2) as profit,
    round(
        sum(oi.profit_amount) / sum(oi.sales_amount) * 100,
        2
    ) as profit_margin
from customers c
join orders o
    on c.customer_id = o.customer_id
join order_items oi
    on o.order_id = oi.order_id
group by c.customer_segment
order by profit_margin desc;


-- q28. how many customers have never placed an order?
select
    count(*) as customers_without_orders
from customers c
left join orders o
    on c.customer_id = o.customer_id
where o.order_id is null;


-- q29. which products have never been sold?
select
    p.product_id,
    p.product_name,
    p.category,
    p.selling_price
from products p
left join order_items oi
    on p.product_id = oi.product_id
where oi.product_id is null
order by p.category, p.product_name;


-- q30. which products generate high revenue but low profit margin?
select
    p.product_id,
    p.product_name,
    p.category,
    round(sum(oi.sales_amount), 2) as revenue,
    round(sum(oi.profit_amount), 2) as profit,
    round(
        sum(oi.profit_amount) / sum(oi.sales_amount) * 100,
        2
    ) as profit_margin
from products p
join order_items oi
    on p.product_id = oi.product_id
group by
    p.product_id,
    p.product_name,
    p.category
having
    sum(oi.sales_amount) > (
        select avg(product_revenue)
        from (
            select
                product_id,
                sum(sales_amount) as product_revenue
            from order_items
            group by product_id
        ) as avg_sales
    )
    and sum(oi.profit_amount) / sum(oi.sales_amount) < 0.20
order by revenue desc;


-- q31. what is the revenue generated from each discount range?
select
    case
        when discount_percent < 5 then '0-5%'
        when discount_percent < 10 then '5-10%'
        when discount_percent < 20 then '10-20%'
        else '20%+'
    end as discount_range,
    count(*) as order_items,
    round(sum(sales_amount), 2) as revenue,
    round(sum(profit_amount), 2) as profit
from order_items
group by
    case
        when discount_percent < 5 then '0-5%'
        when discount_percent < 10 then '5-10%'
        when discount_percent < 20 then '10-20%'
        else '20%+'
    end
order by revenue desc;


-- q32. does higher discounting reduce profit margin?
select
    case
        when discount_percent < 5 then '0-5%'
        when discount_percent < 10 then '5-10%'
        when discount_percent < 20 then '10-20%'
        else '20%+'
    end as discount_range,
    round(sum(sales_amount), 2) as revenue,
    round(sum(profit_amount), 2) as profit,
    round(
        sum(profit_amount) / sum(sales_amount) * 100,
        2
    ) as profit_margin
from order_items
group by
    case
        when discount_percent < 5 then '0-5%'
        when discount_percent < 10 then '5-10%'
        when discount_percent < 20 then '10-20%'
        else '20%+'
    end
order by profit_margin desc;


-- q33. which categories receive the highest average discount?
select
    p.category,
    round(avg(oi.discount_percent), 2) as average_discount
from order_items oi
join products p
    on oi.product_id = p.product_id
group by p.category
order by average_discount desc;


-- q34. which regions have the highest average shipping cost?
select
    shipping_region as region,
    round(avg(shipping_cost), 2) as average_shipping_cost
from orders
group by shipping_region
order by average_shipping_cost desc;


-- q35. what is the average delivery time by region?
select
    shipping_region as region,
    round(
        avg(datediff(delivery_date, order_date)),
        2
    ) as average_delivery_days
from orders
where delivery_date is not null
group by shipping_region
order by average_delivery_days desc;


-- q36. which states have the highest average delivery time?
select
    shipping_state as state,
    count(*) as delivered_orders,
    round(
        avg(datediff(delivery_date, order_date)),
        2
    ) as average_delivery_days
from orders
where delivery_date is not null
group by shipping_state
having count(*) >= 100
order by average_delivery_days desc;


-- q37. what percentage of orders are cancelled?
select
    count(*) as total_orders,
    sum(
        case
            when order_status = 'Cancelled' then 1
            else 0
        end
    ) as cancelled_orders,
    round(
        sum(
            case
                when order_status = 'Cancelled' then 1
                else 0
            end
        ) * 100.0 / count(*),
        2
    ) as cancellation_rate
from orders;


-- q38. what is the cancellation rate by customer segment?
select
    c.customer_segment,
    count(o.order_id) as total_orders,
    sum(
        case
            when o.order_status = 'Cancelled' then 1
            else 0
        end
    ) as cancelled_orders,
    round(
        sum(
            case
                when o.order_status = 'Cancelled' then 1
                else 0
            end
        ) * 100.0 / count(o.order_id),
        2
    ) as cancellation_rate
from customers c
join orders o
    on c.customer_id = o.customer_id
group by c.customer_segment
order by cancellation_rate desc;


-- q39. which categories have the highest number of returns?
select
    p.category,
    count(r.return_id) as total_returns,
    round(sum(r.refund_amount), 2) as total_refunds
from returns r
join products p
    on r.product_id = p.product_id
group by p.category
order by total_returns desc;


-- q40. what is the return rate by category?
select
    p.category,
    count(distinct oi.order_id) as total_orders,
    count(distinct r.return_id) as returned_items,
    round(
        count(distinct r.return_id) * 100.0
        / count(distinct oi.order_id),
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


-- q41. what are the most returned products?
select
    p.product_id,
    p.product_name,
    p.category,
    count(r.return_id) as return_count,
    round(sum(r.refund_amount), 2) as total_refunds
from returns r
join products p
    on r.product_id = p.product_id
group by
    p.product_id,
    p.product_name,
    p.category
order by return_count desc
limit 10;


-- q42. which return reasons are most common in each category?
select
    p.category,
    r.return_reason,
    count(*) as return_count
from returns r
join products p
    on r.product_id = p.product_id
group by
    p.category,
    r.return_reason
order by
    p.category,
    return_count desc;


-- q43. do returned orders have longer delivery times?
select
    case
        when r.return_id is null then 'Not Returned'
        else 'Returned'
    end as return_status,
    count(distinct o.order_id) as orders,
    round(
        avg(datediff(o.delivery_date, o.order_date)),
        2
    ) as average_delivery_days
from orders o
left join returns r
    on o.order_id = r.order_id
where o.delivery_date is not null
group by
    case
        when r.return_id is null then 'Not Returned'
        else 'Returned'
    end;


-- q44. which payment methods have the highest failure rate?
select
    payment_method,
    count(*) as total_transactions,
    sum(
        case
            when payment_status = 'Failed' then 1
            else 0
        end
    ) as failed_transactions,
    round(
        sum(
            case
                when payment_status = 'Failed' then 1
                else 0
            end
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from payments
group by payment_method
order by failure_rate desc;


-- q45. which customers have placed orders in more than one year?
select
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as customer_name,
    count(distinct year(o.order_date)) as active_years
from customers c
join orders o
    on c.customer_id = o.customer_id
group by
    c.customer_id,
    c.first_name,
    c.last_name
having count(distinct year(o.order_date)) > 1
order by active_years desc;


-- q46. what is the yearly revenue and profit?
select
    year(o.order_date) as year,
    round(sum(oi.sales_amount), 2) as revenue,
    round(sum(oi.profit_amount), 2) as profit,
    round(
        sum(oi.profit_amount) / sum(oi.sales_amount) * 100,
        2
    ) as profit_margin
from orders o
join order_items oi
    on o.order_id = oi.order_id
group by year(o.order_date)
order by year;


-- q47. which month generates the highest revenue?
select
    month(o.order_date) as month_number,
    monthname(o.order_date) as month_name,
    round(sum(oi.sales_amount), 2) as revenue
from orders o
join order_items oi
    on o.order_id = oi.order_id
group by
    month(o.order_date),
    monthname(o.order_date)
order by revenue desc;


-- q48. which customers are responsible for the top 10% of revenue?
with customer_revenue as (
    select
        c.customer_id,
        concat(c.first_name, ' ', c.last_name) as customer_name,
        sum(oi.sales_amount) as revenue
    from customers c
    join orders o
        on c.customer_id = o.customer_id
    join order_items oi
        on o.order_id = oi.order_id
    group by
        c.customer_id,
        c.first_name,
        c.last_name
),
ranked_customers as (
    select
        *,
        ntile(10) over (
            order by revenue desc
        ) as revenue_decile
    from customer_revenue
)
select
    customer_id,
    customer_name,
    round(revenue, 2) as revenue
from ranked_customers
where revenue_decile = 1
order by revenue desc;


-- q49. what percentage of total revenue comes from each category?
with category_sales as (
    select
        p.category,
        sum(oi.sales_amount) as revenue
    from order_items oi
    join products p
        on oi.product_id = p.product_id
    group by p.category
)
select
    category,
    round(revenue, 2) as revenue,
    round(
        revenue * 100.0 / sum(revenue) over (),
        2
    ) as revenue_percentage
from category_sales
order by revenue desc;


-- q50. which customers have high spending but low order frequency?
select
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as customer_name,
    count(distinct o.order_id) as total_orders,
    round(sum(oi.sales_amount), 2) as total_spent,
    round(
        sum(oi.sales_amount) / count(distinct o.order_id),
        2
    ) as average_order_value
from customers c
join orders o
    on c.customer_id = o.customer_id
join order_items oi
    on o.order_id = oi.order_id
group by
    c.customer_id,
    c.first_name,
    c.last_name
having count(distinct o.order_id) <= 3
order by total_spent desc;