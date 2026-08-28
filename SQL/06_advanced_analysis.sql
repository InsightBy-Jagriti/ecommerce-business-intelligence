use ecommerce_db;


-- q51. rank products by revenue
select
    p.product_id,
    p.product_name,
    p.category,
    round(sum(oi.sales_amount), 2) as revenue,
    rank() over (
        order by sum(oi.sales_amount) desc
    ) as revenue_rank
from products p
join order_items oi
    on p.product_id = oi.product_id
group by
    p.product_id,
    p.product_name,
    p.category
order by revenue_rank;


-- q52. rank products by profit
select
    p.product_id,
    p.product_name,
    p.category,
    round(sum(oi.profit_amount), 2) as profit,
    rank() over (
        order by sum(oi.profit_amount) desc
    ) as profit_rank
from products p
join order_items oi
    on p.product_id = oi.product_id
group by
    p.product_id,
    p.product_name,
    p.category
order by profit_rank;


-- q53. find the top 3 products in each category
with product_sales as (
    select
        p.product_id,
        p.product_name,
        p.category,
        sum(oi.sales_amount) as revenue
    from products p
    join order_items oi
        on p.product_id = oi.product_id
    group by
        p.product_id,
        p.product_name,
        p.category
),
ranked_products as (
    select
        *,
        dense_rank() over (
            partition by category
            order by revenue desc
        ) as category_rank
    from product_sales
)
select
    product_id,
    product_name,
    category,
    round(revenue, 2) as revenue,
    category_rank
from ranked_products
where category_rank <= 3
order by
    category,
    category_rank;


-- q54. find the bottom 3 products in each category by revenue
with product_sales as (
    select
        p.product_id,
        p.product_name,
        p.category,
        sum(oi.sales_amount) as revenue
    from products p
    join order_items oi
        on p.product_id = oi.product_id
    group by
        p.product_id,
        p.product_name,
        p.category
),
ranked_products as (
    select
        *,
        row_number() over (
            partition by category
            order by revenue asc
        ) as product_rank
    from product_sales
)
select
    product_id,
    product_name,
    category,
    round(revenue, 2) as revenue,
    product_rank
from ranked_products
where product_rank <= 3
order by
    category,
    product_rank;


-- q55. rank customers by total spending
with customer_sales as (
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
)
select
    customer_id,
    customer_name,
    round(revenue, 2) as revenue,
    rank() over (
        order by revenue desc
    ) as customer_rank
from customer_sales
order by customer_rank;


-- q56. find the top 10 customers by revenue
with customer_sales as (
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
        rank() over (
            order by revenue desc
        ) as customer_rank
    from customer_sales
)
select
    customer_id,
    customer_name,
    round(revenue, 2) as revenue,
    customer_rank
from ranked_customers
where customer_rank <= 10
order by customer_rank;


-- q57. calculate each customer's percentage contribution to total revenue
with customer_sales as (
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
)
select
    customer_id,
    customer_name,
    round(revenue, 2) as revenue,
    round(
        revenue * 100.0 / sum(revenue) over (),
        2
    ) as revenue_percentage
from customer_sales
order by revenue desc;


-- q58. calculate cumulative revenue contribution by customer
with customer_sales as (
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
        sum(revenue) over (
            order by revenue desc
            rows between unbounded preceding and current row
        ) as cumulative_revenue
    from customer_sales
)
select
    customer_id,
    customer_name,
    round(revenue, 2) as revenue,
    round(cumulative_revenue, 2) as cumulative_revenue,
    round(
        cumulative_revenue * 100.0 / sum(revenue) over (),
        2
    ) as cumulative_percentage
from ranked_customers
order by revenue desc;


-- q59. identify customers responsible for the first 80% of revenue
with customer_sales as (
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
customer_contribution as (
    select
        *,
        sum(revenue) over (
            order by revenue desc
            rows between unbounded preceding and current row
        ) as cumulative_revenue
    from customer_sales
),
final_data as (
    select
        *,
        sum(revenue) over () as total_revenue
    from customer_contribution
)
select
    customer_id,
    customer_name,
    round(revenue, 2) as revenue,
    round(
        cumulative_revenue * 100.0 / total_revenue,
        2
    ) as cumulative_percentage
from final_data
where cumulative_revenue <= total_revenue * 0.80
order by revenue desc;


-- q60. calculate monthly revenue with month-over-month growth
with monthly_sales as (
    select
        date_format(o.order_date, '%Y-%m') as month,
        sum(oi.sales_amount) as revenue
    from orders o
    join order_items oi
        on o.order_id = oi.order_id
    group by date_format(o.order_date, '%Y-%m')
),
monthly_growth as (
    select
        month,
        revenue,
        lag(revenue) over (
            order by month
        ) as previous_month_revenue
    from monthly_sales
)
select
    month,
    round(revenue, 2) as revenue,
    round(previous_month_revenue, 2) as previous_month_revenue,
    round(
        (revenue - previous_month_revenue) * 100.0
        / nullif(previous_month_revenue, 0),
        2
    ) as mom_growth_percentage
from monthly_growth
order by month;


-- q61. find the month with the highest revenue growth
with monthly_sales as (
    select
        date_format(o.order_date, '%Y-%m') as month,
        sum(oi.sales_amount) as revenue
    from orders o
    join order_items oi
        on o.order_id = oi.order_id
    group by date_format(o.order_date, '%Y-%m')
),
monthly_growth as (
    select
        month,
        revenue,
        lag(revenue) over (
            order by month
        ) as previous_revenue
    from monthly_sales
)
select
    month,
    round(revenue, 2) as revenue,
    round(
        (revenue - previous_revenue) * 100.0
        / nullif(previous_revenue, 0),
        2
    ) as growth_percentage
from monthly_growth
where previous_revenue is not null
order by growth_percentage desc
limit 1;


-- q62. find the month with the highest revenue decline
with monthly_sales as (
    select
        date_format(o.order_date, '%Y-%m') as month,
        sum(oi.sales_amount) as revenue
    from orders o
    join order_items oi
        on o.order_id = oi.order_id
    group by date_format(o.order_date, '%Y-%m')
),
monthly_growth as (
    select
        month,
        revenue,
        lag(revenue) over (
            order by month
        ) as previous_revenue
    from monthly_sales
)
select
    month,
    round(revenue, 2) as revenue,
    round(
        (revenue - previous_revenue) * 100.0
        / nullif(previous_revenue, 0),
        2
    ) as growth_percentage
from monthly_growth
where previous_revenue is not null
order by growth_percentage asc
limit 1;


-- q63. calculate a 3-month moving average of revenue
with monthly_sales as (
    select
        date_format(o.order_date, '%Y-%m') as month,
        sum(oi.sales_amount) as revenue
    from orders o
    join order_items oi
        on o.order_id = oi.order_id
    group by date_format(o.order_date, '%Y-%m')
)
select
    month,
    round(revenue, 2) as revenue,
    round(
        avg(revenue) over (
            order by month
            rows between 2 preceding and current row
        ),
        2
    ) as three_month_average
from monthly_sales
order by month;


-- q64. calculate yearly revenue growth
with yearly_sales as (
    select
        year(o.order_date) as year,
        sum(oi.sales_amount) as revenue
    from orders o
    join order_items oi
        on o.order_id = oi.order_id
    group by year(o.order_date)
),
yearly_growth as (
    select
        year,
        revenue,
        lag(revenue) over (
            order by year
        ) as previous_year_revenue
    from yearly_sales
)
select
    year,
    round(revenue, 2) as revenue,
    round(previous_year_revenue, 2) as previous_year_revenue,
    round(
        (revenue - previous_year_revenue) * 100.0
        / nullif(previous_year_revenue, 0),
        2
    ) as yoy_growth_percentage
from yearly_growth
order by year;


-- q65. calculate monthly profit and cumulative profit
with monthly_profit as (
    select
        date_format(o.order_date, '%Y-%m') as month,
        sum(oi.profit_amount) as profit
    from orders o
    join order_items oi
        on o.order_id = oi.order_id
    group by date_format(o.order_date, '%Y-%m')
)
select
    month,
    round(profit, 2) as monthly_profit,
    round(
        sum(profit) over (
            order by month
            rows between unbounded preceding and current row
        ),
        2
    ) as cumulative_profit
from monthly_profit
order by month;


-- q66. find the highest revenue month for each year
with monthly_sales as (
    select
        year(o.order_date) as year,
        month(o.order_date) as month_number,
        monthname(o.order_date) as month_name,
        sum(oi.sales_amount) as revenue
    from orders o
    join order_items oi
        on o.order_id = oi.order_id
    group by
        year(o.order_date),
        month(o.order_date),
        monthname(o.order_date)
),
ranked_months as (
    select
        *,
        rank() over (
            partition by year
            order by revenue desc
        ) as month_rank
    from monthly_sales
)
select
    year,
    month_name,
    round(revenue, 2) as revenue
from ranked_months
where month_rank = 1
order by year;


-- q67. find the best performing category in each year
with category_sales as (
    select
        year(o.order_date) as year,
        p.category,
        sum(oi.sales_amount) as revenue
    from orders o
    join order_items oi
        on o.order_id = oi.order_id
    join products p
        on oi.product_id = p.product_id
    group by
        year(o.order_date),
        p.category
),
ranked_categories as (
    select
        *,
        rank() over (
            partition by year
            order by revenue desc
        ) as category_rank
    from category_sales
)
select
    year,
    category,
    round(revenue, 2) as revenue
from ranked_categories
where category_rank = 1
order by year;


-- q68. find each category's percentage of yearly revenue
with yearly_category_sales as (
    select
        year(o.order_date) as year,
        p.category,
        sum(oi.sales_amount) as revenue
    from orders o
    join order_items oi
        on o.order_id = oi.order_id
    join products p
        on oi.product_id = p.product_id
    group by
        year(o.order_date),
        p.category
)
select
    year,
    category,
    round(revenue, 2) as revenue,
    round(
        revenue * 100.0
        / sum(revenue) over (
            partition by year
        ),
        2
    ) as yearly_revenue_percentage
from yearly_category_sales
order by
    year,
    revenue desc;


-- q69. rank categories by profit within each year
with yearly_category_profit as (
    select
        year(o.order_date) as year,
        p.category,
        sum(oi.profit_amount) as profit
    from orders o
    join order_items oi
        on o.order_id = oi.order_id
    join products p
        on oi.product_id = p.product_id
    group by
        year(o.order_date),
        p.category
)
select
    year,
    category,
    round(profit, 2) as profit,
    rank() over (
        partition by year
        order by profit desc
    ) as profit_rank
from yearly_category_profit
order by
    year,
    profit_rank;


-- q70. find customers whose spending increased over time
with yearly_customer_sales as (
    select
        o.customer_id,
        year(o.order_date) as year,
        sum(oi.sales_amount) as revenue
    from orders o
    join order_items oi
        on o.order_id = oi.order_id
    group by
        o.customer_id,
        year(o.order_date)
),
customer_growth as (
    select
        customer_id,
        year,
        revenue,
        lag(revenue) over (
            partition by customer_id
            order by year
        ) as previous_year_revenue
    from yearly_customer_sales
)
select
    customer_id,
    year,
    round(revenue, 2) as revenue,
    round(previous_year_revenue, 2) as previous_year_revenue,
    round(
        (revenue - previous_year_revenue) * 100.0
        / nullif(previous_year_revenue, 0),
        2
    ) as growth_percentage
from customer_growth
where previous_year_revenue is not null
  and revenue > previous_year_revenue
order by growth_percentage desc;


-- q71. find customers whose spending decreased over time
with yearly_customer_sales as (
    select
        o.customer_id,
        year(o.order_date) as year,
        sum(oi.sales_amount) as revenue
    from orders o
    join order_items oi
        on o.order_id = oi.order_id
    group by
        o.customer_id,
        year(o.order_date)
),
customer_growth as (
    select
        customer_id,
        year,
        revenue,
        lag(revenue) over (
            partition by customer_id
            order by year
        ) as previous_year_revenue
    from yearly_customer_sales
)
select
    customer_id,
    year,
    round(revenue, 2) as revenue,
    round(previous_year_revenue, 2) as previous_year_revenue,
    round(
        (revenue - previous_year_revenue) * 100.0
        / nullif(previous_year_revenue, 0),
        2
    ) as growth_percentage
from customer_growth
where previous_year_revenue is not null
  and revenue < previous_year_revenue
order by growth_percentage asc;


-- q72. find products with above-average revenue and above-average profit
with product_performance as (
    select
        p.product_id,
        p.product_name,
        p.category,
        sum(oi.sales_amount) as revenue,
        sum(oi.profit_amount) as profit
    from products p
    join order_items oi
        on p.product_id = oi.product_id
    group by
        p.product_id,
        p.product_name,
        p.category
)
select
    product_id,
    product_name,
    category,
    round(revenue, 2) as revenue,
    round(profit, 2) as profit
from product_performance
where revenue > (
    select avg(revenue)
    from product_performance
)
and profit > (
    select avg(profit)
    from product_performance
)
order by revenue desc;


-- q73. find products with high sales but negative profit
select
    p.product_id,
    p.product_name,
    p.category,
    round(sum(oi.sales_amount), 2) as revenue,
    round(sum(oi.profit_amount), 2) as profit
from products p
join order_items oi
    on p.product_id = oi.product_id
group by
    p.product_id,
    p.product_name,
    p.category
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
and sum(oi.profit_amount) < 0
order by revenue desc;


-- q74. find the most profitable product in each category
with product_profit as (
    select
        p.product_id,
        p.product_name,
        p.category,
        sum(oi.profit_amount) as profit
    from products p
    join order_items oi
        on p.product_id = oi.product_id
    group by
        p.product_id,
        p.product_name,
        p.category
),
ranked_products as (
    select
        *,
        rank() over (
            partition by category
            order by profit desc
        ) as profit_rank
    from product_profit
)
select
    product_id,
    product_name,
    category,
    round(profit, 2) as profit
from ranked_products
where profit_rank = 1
order by category;


-- q75. calculate average discount and profit margin by category
select
    p.category,
    round(avg(oi.discount_percent), 2) as average_discount,
    round(sum(oi.profit_amount), 2) as total_profit,
    round(
        sum(oi.profit_amount)
        / sum(oi.sales_amount) * 100,
        2
    ) as profit_margin
from products p
join order_items oi
    on p.product_id = oi.product_id
group by p.category
order by average_discount desc;


-- q76. compare returned and non-returned order revenue
with order_returns as (
    select distinct
        order_id
    from returns
)
select
    case
        when r.order_id is null then 'Not Returned'
        else 'Returned'
    end as return_status,
    count(distinct o.order_id) as orders,
    round(sum(oi.sales_amount), 2) as revenue,
    round(sum(oi.profit_amount), 2) as profit
from orders o
join order_items oi
    on o.order_id = oi.order_id
left join order_returns r
    on o.order_id = r.order_id
group by
    case
        when r.order_id is null then 'Not Returned'
        else 'Returned'
    end;


-- q77. find products with unusually high return rates
with product_orders as (
    select
        oi.product_id,
        count(distinct oi.order_id) as total_orders
    from order_items oi
    group by oi.product_id
),
product_returns as (
    select
        product_id,
        count(*) as total_returns
    from returns
    group by product_id
)
select
    p.product_id,
    p.product_name,
    p.category,
    po.total_orders,
    coalesce(pr.total_returns, 0) as total_returns,
    round(
        coalesce(pr.total_returns, 0) * 100.0
        / po.total_orders,
        2
    ) as return_rate
from products p
join product_orders po
    on p.product_id = po.product_id
left join product_returns pr
    on p.product_id = pr.product_id
where coalesce(pr.total_returns, 0) * 100.0
      / po.total_orders > 15
order by return_rate desc;


-- q78. find customers with both high order frequency and high spending
with customer_metrics as (
    select
        c.customer_id,
        concat(c.first_name, ' ', c.last_name) as customer_name,
        count(distinct o.order_id) as total_orders,
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
benchmarks as (
    select
        avg(total_orders) as avg_orders,
        avg(revenue) as avg_revenue
    from customer_metrics
)
select
    cm.customer_id,
    cm.customer_name,
    cm.total_orders,
    round(cm.revenue, 2) as revenue
from customer_metrics cm
cross join benchmarks b
where cm.total_orders > b.avg_orders
  and cm.revenue > b.avg_revenue
order by cm.revenue desc;


-- q79. calculate customer revenue rank within each segment
with customer_sales as (
    select
        c.customer_id,
        concat(c.first_name, ' ', c.last_name) as customer_name,
        c.customer_segment,
        sum(oi.sales_amount) as revenue
    from customers c
    join orders o
        on c.customer_id = o.customer_id
    join order_items oi
        on o.order_id = oi.order_id
    group by
        c.customer_id,
        c.first_name,
        c.last_name,
        c.customer_segment
)
select
    customer_id,
    customer_name,
    customer_segment,
    round(revenue, 2) as revenue,
    rank() over (
        partition by customer_segment
        order by revenue desc
    ) as segment_rank
from customer_sales
order by
    customer_segment,
    segment_rank;


-- q80. find the top 5 customers in each customer segment
with customer_sales as (
    select
        c.customer_id,
        concat(c.first_name, ' ', c.last_name) as customer_name,
        c.customer_segment,
        sum(oi.sales_amount) as revenue
    from customers c
    join orders o
        on c.customer_id = o.customer_id
    join order_items oi
        on o.order_id = oi.order_id
    group by
        c.customer_id,
        c.first_name,
        c.last_name,
        c.customer_segment
),
ranked_customers as (
    select
        *,
        row_number() over (
            partition by customer_segment
            order by revenue desc
        ) as segment_rank
    from customer_sales
)
select
    customer_id,
    customer_name,
    customer_segment,
    round(revenue, 2) as revenue,
    segment_rank
from ranked_customers
where segment_rank <= 5
order by
    customer_segment,
    segment_rank;