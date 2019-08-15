SELECT city, count(city) FROM  station
GROUP BY city
ORDER BY count(city) ASC
