-- A. Data Analysis Questions

-- How many customers has Foodie-Fi ever had?
use foodie_fi;
select count(distinct customer_id) from subscriptions;


-- What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value

-- as all the dates are from 2020, just using the month to group by
select month(start_date) as month, count(*) as monthly_count
from subscriptions 
where plan_id = 0
group by month(start_date)
order by 1;


-- What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
select plan_id, month(start_date), count(*) from subscriptions
group by 1,2
order by 2,1;


-- What is the customer count and percentage of customers who have churned rounded to 1 decimal place?
with temp as (
select customer_id, count(customer_id) as number_of_times_subscribed
from subscriptions
where plan_id <> 0
group by 1)

select customer_id from temp where number_of_times_subscribed = 1;


-- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?


-- What is the number and percentage of customer plans after their initial free trial?
-- What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
-- How many customers have upgraded to an annual plan in 2020?
-- How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
-- Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)
-- How many customers downgraded from a pro monthly to a basic monthly plan in 2020?