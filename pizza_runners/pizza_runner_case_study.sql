-- A. Pizza Metrics 

-- How many pizzas were ordered?
use pizza_runner;

 select count(order_id) as total_pizza_ordered
 from customer_orders;

-- How many unique customer orders were made?

use pizza_runner;

select count(distinct customer_id) as unique_customers
from customer_orders;

-- How many successful orders were delivered by each runner?

use pizza_runner;

select runner_id, count(order_id) as total_orders
from runner_orders
where cancellation <> 'Restaurant Cancellation' and  cancellation <> 'Customer Cancellation' or cancellation is null
group by runner_id;


-- How many of each type of pizza was delivered?

use pizza_runner;

select co.pizza_id, count(*) as pizza_count
from customer_orders co
join (
	select * from runner_orders
	where pickup_time <> 'null' ) x
on x.order_id = co.order_id
group by 1 ;


-- What was the maximum number of pizzas delivered in a single order?
use pizza_runner;

select max(max_qty) as max_qty_res
from (
select count(co.order_id) as max_qty
from customer_orders co
join (
	select * from runner_orders
	where pickup_time <> 'null' ) x
on x.order_id = co.order_id
group by co.order_id ) y ;


-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
use pizza_runner;

select customer_id, 
sum(case when changes = 1 then 1 else 0 end) as changes_count,
sum(case when changes = 0 then 1 else 0 end) as no_changes_count
from (
select co.customer_id, co.order_id, 
case when co.exclusions is null or co.exclusions = 'null' or co.extras is null or co.extras = 'null' then 0 else 1 end as changes
from customer_orders co
join (
	select * from runner_orders
	where pickup_time <> 'null' ) x
on x.order_id = co.order_id ) final
group by 1;


-- How many pizzas were delivered that had both exclusions and extras?

use pizza_runner;

select co.order_id, (co.exclusions), (co.extras)
from customer_orders co
join (
	select * from runner_orders
	where pickup_time <> 'null' ) x
on x.order_id = co.order_id
where TRIM(co.exclusions) is not null and co.exclusions <> 'null' and co.exclusions <> '' and TRIM(co.extras) is not null and co.extras <> 'null' and co.extras <> '';

-- What was the total volume of pizzas ordered for each hour of the day?
use pizza_runner;

select  hour(order_time) as hours, day(order_time) as days, count(order_id) as volume
from customer_orders
group by 1,2;

-- What was the volume of orders for each day of the week?
use pizza_runner;

select day(order_time) as days, count(order_id) as volume
from customer_orders
group by 1;
