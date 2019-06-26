with 
start_diff as(
select city as startCity, start_station_name as start_name, count(start_station_id) as count1
from station left join trip 
where station.station_id == trip.start_station_id and trip.start_station_id != trip.end_station_id
group by start_station_id
),
end_diff as(
select city as endCity, end_station_name as end_name, count(end_station_id) as count2
from trip left join station
where station.station_id == trip.end_station_id and trip.start_station_id != trip.end_station_id
group by end_station_id
),
uni as(
select city as uniCity, start_station_name, end_station_name, count(start_station_id) as count3
from trip left join station
where trip.start_station_id == station.station_id and trip.start_station_id == trip.end_station_id
group by start_station_id
),
tmp1 as(
select startCity, start_name, (count1+count2) as partial_count
from start_diff left join end_diff
where start_diff.startCity == end_diff.endCity 
and start_diff.start_name == end_diff.end_name
),
tmp2 as(
select startCity, start_name, (partial_count+count3) as total_count
from tmp1 left join uni
where tmp1.startCity == uni.uniCity
and tmp1.start_name == uni.start_station_name
),
merge as(
select startCity as city, start_name as station_name, sum(total_count) as res
from tmp2
group by station_name
)

select city, station_name, res 
from merge
where (
   select count(*) from merge as m
   where m.city = merge.city and m.res >= merge.res
) <= 1
order by city ASC;
