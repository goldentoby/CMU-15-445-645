select 
station.zip_code,
station.station_name,
station.station_id,
count(*)

from trip 
inner join station on trip.start_station_id = station.station_id 
inner join weather on weather.zip_code = station.zip_code and date(trip.start_time) = weather.date
where weather.events = 'Rain-Thunderstorm'
group by station.station_id
order by station.zip_code desc