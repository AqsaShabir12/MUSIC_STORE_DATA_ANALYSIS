select * from employee

select employee_id, first_name, last_name, title
from employee
where levels = (select max(levels)
from employee)

select *
from employee
order by levels
limit 1


select *
from invoice


select count(invoice_id) as c, Billing_Country
from invoice
group by Billing_Country
order by c desc

select distinct total
from invoice
order by total desc
limit 3

select sum(total) as s,billing_city
from invoice
group by billing_city
order by s desc
limit 1

select *
from customer

select *
from invoice

select sum(total) as s, customer_id,first_name,last_name
from customer c
join invoice i using (customer_id)
group by customer_id
order by s desc


select * from track

select distinct email, first_name,last_name,genre.name
from customer
join invoice using (customer_id)
join invoice_line using (invoice_id)
join track using (track_id)
join genre using (genre_id)
where genre.name like 'Rock'
order by email

select distinct artist.artist_id, artist.name, count(artist.artist_id) as counting
from artist
join album using (artist_id)
join track using (album_id)
join genre using (genre_id)
where genre.name like 'Rock' 
group by artist.artist_id
order by counting desc
limit 10

select * from invoice_line

select distinct name, Milliseconds
from track
where Milliseconds > 
(select avg(Milliseconds)
from track)
order by Milliseconds desc


select c.customer_id, c.first_name, c.last_name, a.name, sum(invoice_line.unit_price * invoice_line.quantity) as total
from customer c
join invoice i using (customer_id)
join invoice_line using (invoice_id)
join track using (track_id)
join album using (album_id)
join artist a using (artist_id)
group by customer_id, a.name
order by total desc
limit 1

select * from genre

with popular as (
select distinct billing_country, count(quantity) as total, g.name,
row_number() over (partition by billing_country order by count(quantity) desc) as rowno
from invoice 
join invoice_line using (invoice_id)
join track using (track_id)
join genre g using (genre_id)
group by billing_country, g.name
order by 1 asc,2 desc,3 desc
)

select *
from popular 
where rowno <=1

with recursive spending as (
select customer_id, first_name, last_name, billing_country, sum(total) as total
from invoice
join customer using (customer_id)
group by 1,2,3,4
order by customer_id, total desc),

country_max_spending as (
select billing_country, max(total) as max_spending
from spending
group by billing_country
)

select spending.billing_country, first_name, last_name, total
from spending
join country_max_spending using (billing_country)
where total = max_spending
order by 1;