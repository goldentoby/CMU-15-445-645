with dates(val) as (
  select date(start_time) as s from trip where bike_id <= 100
  union 
  select date(end_time) as e from trip where bike_id <= 100
  order by s ASC
)
select val, round(sum(dur/86400.0)/count(*),4) as util_rate from(
	select val, strftime('%s',endTime) - strftime('%s',startTime) as dur from(
		select trip.id, dates.val as val, trip.start_time,
		trip.end_time, datetime(val),
		-- set up the deadline of the day
		datetime(strftime('%Y-%m-%d',val) || '24:00'),
		
		-- dealing with the start of the day
		case
			when trip.start_time < datetime(val)
			then datetime(val) else trip.start_time end as startTime,
			
		-- dealing with the end of the day
		case 
			when trip.end_time > datetime(strftime('%Y-%m-%d',val) || '24:00')
			then datetime(strftime('%Y-%m-%d',val) || '24:00') else trip.end_time end as endTime

		from dates inner join trip on(
		dates.val >= date(trip.start_time) 
		and 
		dates.val <= date(trip.end_time)
		and
		trip.bike_id <= 100
		)
	)
)
group by val
order by util_rate desc
limit 10

	






