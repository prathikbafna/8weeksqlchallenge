-- B. Runner and Customer Experience


-- How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

use pizza_runner;
select FLOOR(datediff(registration_date,'2021-01-01')/7) as week_num,
count(runner_id) as count_of_signup
from runners
group by FLOOR(datediff(registration_date,'2021-01-01')/7) ;

-- What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
use pizza_runner;

select ro.runner_id, avg(timestampdiff(minute,co.order_time,ro.pickup_time)) as avg_time_taken
from customer_orders co
join runner_orders ro
on ro.order_id = co.order_id
group by 1;


-- Is there any relationship between the number of pizzas and how long the order takes to prepare?

use pizza_runner;

with temp as (
select ro.order_id, sum(timestampdiff(minute,co.order_time,ro.pickup_time)) as avg_time_taken,
count(co.pizza_id) as num_of_pizza
from customer_orders co
join runner_orders ro
on ro.order_id = co.order_id
group by 1 )

select num_of_pizza, avg(avg_time_taken) 
from temp
group by 1
order by 1;



-- What was the average distance travelled for each customer?

use pizza_runner;

select co.customer_id,
avg(substring_index(ro.distance,'km',1)*1) as average_distance_travelled
from runner_orders ro join customer_orders co
on ro.order_id = co.order_id
where distance is not null and distance <> 'null' and distance <> ''
group by 1;


-- What was the difference between the longest and shortest delivery times for all orders?

use pizza_runner;

select  max(substring_index(duration, 'min',1)*1) - min(substring_index(duration, 'min',1)*1) as difference_duration_minutes
from runner_orders
where duration is not null and duration <> 'null';


-- What was the average speed for each runner for each delivery and do you notice any trend for these values?

use pizza_runner;

select runner_id, avg((substring_index(distance,'km',1)*1)/(substring_index(duration,'min',1)*1)) as avg_km_per_min
from runner_orders
where distance is not null and distance <> 'null' and duration is not null and duration <> 'null'
group by 1;

-- What is the successful delivery percentage for each runner?

with temp as (
select runner_id,
sum(case when distance is not null and distance <> 'null' then 1 else 0 end) as success, 
sum(case when distance is null or distance = 'null' then 1 else 0 end) as failed
from runner_orders
group by runner_id )

select runner_id, success/(success+failed) as delivery_percentage
from temp;
