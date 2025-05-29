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

select sum(case when plan_id = 4 then 1 else 0 end) as churned_count,
round(sum(case when plan_id = 4 then 1 else 0 end) * 100 / count(*),1) as percentage_churned
from subscriptions;


-- How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number?

with temp as (
select *, rank() over(partition by customer_id order by start_date) as rk
from subscriptions 
order by customer_id, start_date
),
temp2 as (
select *, 
lead(plan_id) over(partition by customer_id order by rk) as next_plan, 
lead(rk) over(partition by customer_id order by rk) as next_rk   
from temp where plan_id = 0 or plan_id = 4 )

select count(*) as churned_after_trail from temp2
where next_plan is not null and next_rk - rk = 1;


-- What is the number and percentage of customer plans after their initial free trial?
with temp as (
select *, rank() over(partition by customer_id order by start_date) as rk
from subscriptions 
order by customer_id, start_date
),
temp2 as (
select *, 
lead(plan_id) over(partition by customer_id order by rk) as next_plan, 
lead(rk) over(partition by customer_id order by rk) as next_rk   
from temp where plan_id <> 4 ),

temp3 as (
select sum(case when next_plan = 1 then 1 else 0 end) as plan_1,
sum(case when next_plan = 2 then 1 else 0 end) as plan_2,
sum(case when next_plan = 3 then 1 else 0 end) as plan_3
from temp2
where next_plan is not null and next_rk - rk = 1 and plan_id = 0 )

select * , 
plan_1 * 100 / (plan_1 + plan_2 + plan_3) as plan_1_percent,
plan_2 * 100 / (plan_1 + plan_2 + plan_3) as plan_2_percent,
plan_3 * 100 / (plan_1 + plan_2 + plan_3) as plan_3_percent
from temp3;


-- What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?

select plan_id, count(plan_id) , count(plan_id) * 100 / (select count(*) from subscriptions)
from subscriptions
group by 1;

-- How many customers have upgraded to an annual plan in 2020?

-- same as solved before, just need to check if the next plan is anual plan (plan_id = 3)

-- How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?

with temp as (
select *, rank() over(partition by customer_id order by start_date) as rk
from subscriptions 
),

temp2 as (
select * from temp
where rk = 1 or plan_id = 3),

temp3 as (
select *, 
lead(plan_id) over(partition by customer_id order by rk) as next_plan, 
lead(start_date) over(partition by customer_id order by rk) as next_start_date   
from temp2
)

select avg(datediff(next_start_date, start_date)) as average_days_to_anual_plan
from temp3
where next_plan is not null and next_plan = 3;


-- Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)


-- How many customers downgraded from a pro monthly to a basic monthly plan in 2020?