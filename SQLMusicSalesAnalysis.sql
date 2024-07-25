with Cte_SaleGenre as (
select
	g.GenreId,
	g.Name 						  as NameGenre,
	sum(il.UnitPrice*il.Quantity) as SalesGenre
from InvoiceLine il
left join Track t
on t.TrackId = il.TrackId
left join Genre g
on g.GenreId = t.GenreId
where 1=1
group by g.GenreId)

select
	aa.artist,
	aa.genre,
	aa.sales,
	aa.sales_percentage_by_genre,
	printf('%.1f%%',sum(aa.sales_percentage_by_genre) over (partition by aa.genre order by aa.sales desc, aa.artist asc)) as cumulative_sum_by_genre
from
	(select
	    a.Name						  as artist,
		g.Name 						  as genre,
		sum(il.UnitPrice*il.Quantity) as sales,
		printf('%.1f%%',sum((il.UnitPrice*il.Quantity)/c.SalesGenre)*100) as sales_percentage_by_genre
	from InvoiceLine il
	left join Track t
	on t.TrackId = il.TrackId
	left join Genre g
	on g.GenreId = t.GenreId
	left join Album al
	on al.AlbumId = t.AlbumId
	left join Artist a
	on a.ArtistId = al.ArtistId
	left join Cte_SaleGenre c
	on c.GenreId = g.GenreId
	where 1=1
	group by a.Name, g.Name) aa
where 1=1
order by aa.genre
limit 10;

