-- select database
use eco;

-- fix date columns
alter table customers
modify signup_date date;

alter table products
modify launch_date date;

alter table orders
modify order_date date,
modify delivery_date date;

alter table payments
modify payment_date date;

alter table returns
modify return_date date;


-- add primary keys
alter table customers
add primary key (customer_id);

alter table products
add primary key (product_id);

alter table orders
add primary key (order_id);

alter table order_items
add primary key (order_item_id);

alter table payments
add primary key (payment_id);

alter table returns
add primary key (return_id);


-- add foreign keys
alter table orders
add constraint fk_orders_customer
foreign key (customer_id)
references customers(customer_id);

alter table orders
add constraint fk_orders_payment
foreign key (payment_id)
references payments(payment_id);


-- create index for faster payment lookups
create index idx_payments_order
on payments(order_id);


alter table order_items
add constraint fk_items_order
foreign key (order_id)
references orders(order_id);

alter table order_items
add constraint fk_items_product
foreign key (product_id)
references products(product_id);


alter table returns
add constraint fk_returns_order
foreign key (order_id)
references orders(order_id);

alter table returns
add constraint fk_returns_product
foreign key (product_id)
references products(product_id);