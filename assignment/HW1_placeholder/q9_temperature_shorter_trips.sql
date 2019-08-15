select 
avg(
case when strftime('%s',end_time) - strftime('%s',start_time) <= 60
then weather.mean_temp
else null
end) as short_trip_avg_temp,
avg(
case when strftime('%s',end_time) - strftime('%s',start_time) > 60
then weather.mean_temp
else null
end) as non_trip_avg_temp

from trip
inner join station
on station.station_id == trip.start_station_id
inner join weather
on date(trip.start_time) = weather.date and weather.zip_code = station.zip_code
