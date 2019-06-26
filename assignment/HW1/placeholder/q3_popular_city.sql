with
diff_start as(
    select startCity, count(startCity) as diff_start_count from(
        select * from
            ( select id, city as startCity from trip left join station where station.station_id = trip.start_station_id) as A
            left join
            ( select id, city as endCity from trip left join station where station.station_id = trip.end_station_id) as B
        where A.id = B.id
)
    where startCity != endCity
    group by startCity
),
diff_end as(
    select endCity, count(endCity) as diff_end_count from(
        select * from 
            ( select id, city as startCity from trip left join station where station.station_id = trip.start_station_id) as A
            left join
            ( select id, city as endCity from trcip left join station where station.station_id = trip.end_station_id) as B
        where A.id = B.id
    )
    where startCity != endCity
    group by endCity
),
uni as (
    select startCity, count(startCity) as uni_count from(
        select * from 
            ( select id, city as startCity from trip left join station where station.station_id = trip.start_station_id) as A
            left join 
            ( select id, city as endCity from trip left join station where station.station_id = trip.end_station_id) as B
        where A.id = B.id
    )
    where startCity == endCity
    group by startCity
),
trip_city_count as (
    select startCity, ( diff_start_count + diff_end_count + uni_count) as total_count from
    (select * from uni inner join diff_start where uni.startCity = diff_start.startCity) as tmp
    inner join diff_end
    where tmp.startCity = diff_end.endCity
)
select trip_city_count.startCity, 
round((trip_city_count.total_count*1.0)/(select count(*) from trip), 4) as ratio
from trip_city_count
order by ratio DESC, trip_city_count.startCity ASC;