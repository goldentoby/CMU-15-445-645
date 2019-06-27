with 
bike_station as(
-- reduce the duplicated data
select bike_id, start_station_id as station_id from trip 
union 
select bike_id, end_station_id from trip
),
bike_city as(
select  bike_id, s.city as city
from bike_station as bs 
inner join station as s 
on s.station_id == bs.station_id
)

select bike_id, count(distinct city) as cnt from bike_city
group by bike_id having cnt > 1
order by cnt desc, bike_id ASC

