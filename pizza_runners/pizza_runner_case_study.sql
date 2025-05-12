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
-- How many Vegetarian and Meatlovers were ordered by each customer?
-- What was the maximum number of pizzas delivered in a single order?
-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
-- How many pizzas were delivered that had both exclusions and extras?
-- What was the total volume of pizzas ordered for each hour of the day?
-- What was the volume of orders for each day of the week?