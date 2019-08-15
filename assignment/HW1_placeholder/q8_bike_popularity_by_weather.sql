select 
events, 
round(count(*)/ ((select count(*) from weather  w2 where w2.events = w1.events group by events) *1.0),4) as average_trips
from trip
join station on 
trip.start_station_id == station.station_id
join weather w1 on
  events <> '\N'
  and w1.zip_code = station.zip_code
  and date(trip.start_time) = w1.date
group by w1.events
order by average_trips,events desc;
