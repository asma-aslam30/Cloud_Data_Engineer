-- ============================================
-- SQL Server — Class 3 Homework
-- BikeStores Sample Database
-- Topics: GROUP BY · HAVING · Subqueries · EXISTS
-- ============================================

-- Q1: Count how many products each brand has in the catalog.
-- Show brand name and product count.
-- Sort by count descending.
select count(product_name) as total_product,brand_name  from [production].[products] p 
inner join [production].[brands] b 
on b.brand_id=p.brand_id
group by brand_name
order by total_product desc



-- Q2: For each category, show:
-- category name,
-- total number of products,
-- cheapest price,
-- most expensive price,
-- average price (rounded to 2 decimals).
-- Sort by average price descending.
select 
c.category_name,
count(product_name) as total_product,
MIN(list_price) as min_price,
MAX(list_price) as max_prize,
AVG(list_price) as avg_price
from [production].[products] p 
inner join [production].[categories]  c
on c.category_id=p.category_id
group by category_name
order by avg_price desc

-- Q3: Show the number of orders placed per order status.
-- Display the status value and order count.
-- Sort by order_status ascending.
select count (*) as order_summary,order_status
from [sales].[orders]
group by order_status
order by order_status asc

-- Q4: For each store, calculate total revenue:
-- (quantity × list_price × (1 – discount)) from order_items.
-- Show store name and total revenue.
-- Sort by revenue descending.


select s.store_name,
sum(oi.quantity * oi.list_price * (1 - oi.discount)) as total_revenue
from [sales].[stores] s
inner join 
[sales].[orders] o
on s.store_id=o.store_id
inner join 
[sales].[order_items] oi
on o.order_id=oi.order_id
group by s.store_name
order by total_revenue desc

 
 
-- Q5: Show total number of products per brand per model year.
-- Display brand name, model year, and product count.
-- Sort by brand name then model year.

select count(*) total_product,b.brand_name,p.model_year from [production].[products] p
inner join [production].[brands] b 
on b.brand_id=p.brand_id
group by b.brand_name,p.model_year 
order by b.brand_name,p.model_year 

-- Q6: Find all brands that have more than 25 products in the catalog.
-- Show brand name and product count.

select count(*) total_product,b.brand_name  from [production].[products] p
inner join [production].[brands] b 
on b.brand_id=p.brand_id
group by b.brand_name 
having count(*)>25
order by b.brand_name 

-- Q7: Among products from year 2018 only,
-- find categories whose average price is above $1500.
-- Show category name, product count, and average price.

select c.category_name,count(*) as product_count ,avg(p.list_price) as avg_price,p.model_year from [production].[products] p
inner join [production].[categories] c
on p.category_id=c.category_id
where model_year=2018
group by c.category_name,p.model_year
having  avg(p.list_price)>1500

 

-- Q8: Find customers who have placed 3 or more orders.
-- Show customer full name and order count.
-- Sort by order count descending.

select c.first_name+ ' '+ c.last_name as full_name,count(o.order_id) order_count 
 from [sales].[orders] o
inner join [sales].[customers] c
on c.customer_id=o.customer_id
group by c.first_name,c.last_name
having count(o.order_id)>=3
order by order_count desc 


 
-- Q9: Find all products whose list price is higher than
-- the average list price of all products.
-- Show product name and price.
-- Sort by price descending.
select p.product_name,p.list_price from 
  [production].[products] p
  where list_price>(select avg(list_price) from production.products)
order by list_price desc

 
-- Q10: Find all orders placed by customers from state 'TX'.
-- Use a subquery (NOT a JOIN).
-- Show order ID, customer ID, and order date.
 

select order_id,order_date,customer_id
from [sales].[orders]
where customer_id in (select customer_id from [sales].[customers]  
where state='TX')
 

-- Q11: For each brand, show its average price,
-- but only for brands whose average price exceeds overall product average.
-- Use a subquery in FROM (derived table).
-- Show brand name and average price.
SELECT 
    brand_name,avg_price
FROM
(SELECT b.brand_name,AVG(p.list_price) AS avg_price FROM production.products p
INNER JOIN production.brands b
ON b.brand_id = p.brand_id
GROUP BY b.brand_name
) AS brand_avg
WHERE avg_price >(SELECT AVG(list_price) FROM production.products);
 

-- Q12: Using EXISTS:
-- Find all customers who have placed at least one order.
-- Show customer full name and email.
select c.first_name+ ' '+ c.last_name as full_name,c.email from [sales].[customers] c
where exists (select * from [sales].[orders] o
where c.customer_id=o.customer_id)

-- Q13: Using NOT EXISTS:
-- Find all products that have never appeared in any order (order_items).
-- Show product name and list price.
select p.product_name,p.list_price from [production].[products] p
where not exists (select * from [sales].[order_items] oi
where oi.product_id=p.product_id)

 