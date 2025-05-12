-- What is the total amount each customer spent at the restaurant?

use dannys_diner;

select s.customer_id, sum(m.price) as total_spent
from sales s
join menu m
on s.product_id = m.product_id
group by s.customer_id;


-- How many days has each customer visited the restaurant?

use dannys_diner;

select customer_id, count(distinct order_date) as num_of_visits
from sales s
group by customer_id;

-- What was the first item from the menu purchased by each customer?

use dannys_diner;

with temp as (
select s.customer_id, min(s.order_date) as first_date
from sales s
group by s.customer_id )

select x.customer_id, x.product_id, product_name
from (
select t.customer_id, s.product_id
from sales s
join temp t where s.customer_id = t.customer_id and s.order_date = t.first_date ) x
join menu m on x.product_id = m.product_id;


-- What is the most purchased item on the menu and how many times was it purchased by all customers?

use dannys_diner;

select product_id, count(product_id) as sales_count
from sales s
group by product_id
order by sales_count desc
limit 1;

-- Which item was the most popular for each customer?

use dannys_diner;

with temp as (
select customer_id, product_id, count(product_id) as num_of_times_ordered
from sales s
group by 1,2 )

select x.customer_id, t.product_id
from
(
	select customer_id, max(num_of_times_ordered) as c
    from temp
    group by customer_id
) x
join temp t
on t.customer_id = x.customer_id and x.c = t.num_of_times_ordered ;


-- Which item was purchased first by the customer after they became a member?

use dannys_diner;

with temp as (
select s.customer_id, s.product_id, s.order_date
from sales s
join members m
on m.customer_id = s.customer_id and s.order_date >= m.join_date
)

select s.customer_id, s.product_id
from temp s
join (
select t.customer_id, min(t.order_date) as first_order_date
from temp t
group by customer_id ) x
on x.customer_id = s.customer_id and x.first_order_date = s.order_date;

-- Which item was purchased just before the customer became a member?
-- What is the total items and amount spent for each member before they became a member?
-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?