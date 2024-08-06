How much amount by each customer by artist? Write a query to return customer name, artist name and total spent.

	WITH best_selling_artist AS (
	SELECT artist.artist_id AS artsit_id, artist.name AS artist_name, 
	SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, 
SUM(il.unitprice*il.quantity) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id= il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

Most popular music Genre

WITH popular_genre AS
(
	SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id,
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo
	FROM invoice_line
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer ON customer.customer_id = invoice.customer_id
	JOIN track on track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC, 1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <= 1

Customer spent most on music for each country

WITH RECURSIVE
   customer_with_country AS (
	SELECT customer.customer_id,first_name,last_name,billing_country,
	SUM(total) AS total_spending
	FROM invoice
	JOIN customer ON customer.customer_id = invoice.customer_id
	GROUP BY 1,2,3,4
	ORDER BY 2,3 DESC),

	country_max_spending AS(
	SELECT billing_country, MAX(total_spending) AS max_spending
	FROM customer_with_country
	GROUP BY billing_country)

	SELECT cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
	FROM customer_with_country cc
	JOIN country_max_spending ms
	ON cc.billing_country = ms.billing_country
	WHERE cc.total_spending = ms.max_spending
	ORDER BY 1;

	


