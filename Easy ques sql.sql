Who is the senior most employee based on job title?

select * from employee
ORDER BY levels desc
limit 1

Which countries have most Invoices?

select COUNT(*) as c, billing_country
from invoice
group by billing_country 
order by c desc

What are top 3 values of total invoices?

SELECT total FROM invoice
order by total desc 
limit 3

Which city has best customers? Give a query that returns person who has spent most money.

SELECT SUM(total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total desc

Ans. Prague

Who is the best customer? Customer spending most money.

SELECT customer.customer_id, customer.first_name, customer.last_name, SUM(invoice.total) as total
from customer
JOIN invoice on customer.customer_id= invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total DESC
limit 1

Madhav





