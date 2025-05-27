-- C. Ingredient Optimisation

-- What are the standard ingredients for each pizza?
use pizza_runner;

select *, concat(' ', topping_id) as updated from pizza_recipes
cross join pizza_toppings
where locate(concat(' ', topping_id) ,toppings) > 0;


-- What was the most commonly added extra?

use pizza_runner;

WITH RECURSIVE split_cte AS (
    SELECT
        order_id,
        SUBSTRING_INDEX(extras, ',', 1) AS item,
        SUBSTRING(extras, LENGTH(SUBSTRING_INDEX(extras, ',', 1)) + 2) AS rest
    FROM customer_orders

    UNION ALL

    SELECT
        order_id,
        SUBSTRING_INDEX(rest, ',', 1),
        SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2)
    FROM split_cte
    WHERE rest != ''
)

select item as extras, count(item) as num_of_times 
from split_cte
where item is not null and item <> 'null' and item <> ''
group by item
order by 2 desc;


-- What was the most common exclusion?

use pizza_runner;

with recursive temp as (
select 
	order_id,
    substring_index(exclusions,',',1) as item,
    substring(exclusions, length(exclusions) + 2) as rest
from customer_orders

union all

select
	order_id,
    substring_index(rest,',',1),
    substring(rest, length(rest) + 2)
from temp
where rest <> ''
)

select item as topping_id, count(item) as num_of_time_excluded from temp
where item is not null and item <> 'null' and item <> ''
group by item
order by 2 desc;


-- Generate an order item for each record in the customers_orders table in the format of one of the following:
-- Meat Lovers
-- Meat Lovers - Exclude Beef
-- Meat Lovers - Extra Bacon
-- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers


with recursive 
customer_orders_details as (
	select c.order_id, c.pizza_id, p.pizza_name, c.extras, c.exclusions
	from customer_orders c join pizza_names as p
	on p.pizza_id = c.pizza_id
),
excluded_details as (
	select 
		order_id,
        pizza_name,
		substring_index(exclusions,',',1) as item,
		substring(exclusions, length(exclusions) + 2) as rest
	from customer_orders_details

	union all

	select
		order_id,
        pizza_name,
		substring_index(rest,',',1),
		substring(rest, length(rest) + 2)
	from excluded_details
	where rest <> ''
),
extras_details AS (
    SELECT
		order_id,
        pizza_name,
        SUBSTRING_INDEX(extras, ',', 1) AS item,
        SUBSTRING(extras, LENGTH(SUBSTRING_INDEX(extras, ',', 1)) + 2) AS rest
    FROM customer_orders_details

    UNION ALL

    SELECT
		order_id,
        pizza_name,
        SUBSTRING_INDEX(rest, ',', 1),
        SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2)
    FROM extras_details
    WHERE rest != ''
),
detailed_names as (
select e.order_id, e.pizza_name, concat( ' - Exclude ',group_concat(p.topping_name order by p.topping_name separator ', ')) as items
from excluded_details e 
join pizza_toppings p on e.item = p.topping_id
where item is not null and item <> 'null' and item <> ''
group by 1,2

union all

select e.order_id, e.pizza_name, concat('- Extra ',group_concat(p.topping_name order by p.topping_name separator ', ')) as items
from extras_details e 
join pizza_toppings p on e.item = p.topping_id
where item is not null and item <> 'null' and item <> ''
group by 1,2),

final_format as (
select order_id, pizza_name, group_concat(items order by items separator ' ')  as order_details
from detailed_names
group by order_id, pizza_name )

select concat(pizza_name, ' ', order_details) as pizza_details
from final_format;



-- Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
-- For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"

use pizza_runner;

with recursive pizza_ingridients as (
    
    select 
		pizza_id,
		substring_index(toppings,',',1) as item,
		substring(toppings, length(substring_index(toppings,',',1) + 2 )) as rest
	from pizza_recipes

	union all

	select
		pizza_id,
		substring_index(rest,',',1),
        SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2)
	from pizza_ingridients
	where rest <> ''
    
),
pizza_recipe_transformed as (
select distinct pizza_id, item from pizza_ingridients
)

select * from pizza_recipe_transformed;



-- What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
use pizza_runner;



