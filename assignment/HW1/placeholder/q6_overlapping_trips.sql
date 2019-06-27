with 
trips as(
select  * from trip where bike_id <= 200 and bike_id>=100
)
select trip1.bike_id,
trip1.id, trip1.start_time, trip1.end_time,
trip2.id, trip2.start_time, trip2.end_time
from trips as trip1 inner join trips as trip2 on(
trip1.bike_id == trip2.bike_id and trip1.id != trip2.id
)
where  
-- De Morgan's laws 
-- not (trip1.start_time >= trip2.end_time) and not (trip1.end_time <= trip2.start_time)
not(
	trip1.start_time >= trip2.end_time
	or
	trip1.end_time <= trip2.start_time
)