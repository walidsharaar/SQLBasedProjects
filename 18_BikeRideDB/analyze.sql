-- List of first 100 users
select * from users limit 100

-- List of first 100 stations
select * from stations limit 100

-- List of first 100 rides
select * from rides limit 100

-- Total number of rows in each table
Select 
-- check # of rows in each table 1000 rows
(select count(*) from users) as total_users,
-- 25 rows
(select count(*) from stations) as total_stations,
--15000 rows
(select count(*) from rides )as total_rides


-- check for missing values in each table
SELECT 
    COUNT(CASE WHEN ride_id IS NULL THEN 1 END) AS null_ride_ids,
    COUNT(CASE WHEN user_id IS NULL THEN 1 END) AS null_user_ids,
    COUNT(CASE WHEN start_time IS NULL THEN 1 END) AS null_start_station_ids,
    COUNT(CASE WHEN end_time IS NULL THEN 1 END) AS null_end_station_ids
FROM rides;

--check for missing values in users table
SELECT 
    COUNT(CASE WHEN user_id IS NULL THEN 1 END) AS null_user_ids,
    COUNT(CASE WHEN username IS NULL THEN 1 END) AS null_user_names,
    COUNT(CASE WHEN age IS NULL THEN 1 END) AS null_age,
    COUNT(CASE WHEN membership_level IS NULL THEN 1 END) AS null_membership_levels
FROM users;



--summary statistics for numerical columns in rides table
SELECT 
    ROUND(CAST(MIN(distance_km) AS numeric), 2) AS min_distance,
    ROUND(CAST(MAX(distance_km) AS numeric), 2) AS max_distance,
    ROUND(CAST(AVG(distance_km) AS numeric), 2) AS avg_distance,
    ROUND(MIN(EXTRACT(EPOCH FROM (end_time::timestamp - start_time::timestamp)) / 60), 2) AS min_ride_duration_minutes,
    ROUND(MAX(EXTRACT(EPOCH FROM (end_time::timestamp - start_time::timestamp)) / 60), 2) AS max_ride_duration_minutes,
    ROUND(AVG(EXTRACT(EPOCH FROM (end_time::timestamp - start_time::timestamp)) / 60), 2) AS avg_ride_duration_minutes
FROM rides;    


--check for false start and end times in rides table
SELECT 
    COUNT(CASE WHEN EXTRACT(EPOCH FROM (end_time::timestamp - start_time::timestamp)) / 60 < 2 THEN 1 END) AS false_time_entries,
    COUNT(CASE WHEN start_time::timestamp > end_time::timestamp THEN 1 END) AS negative_time_entries,
    COUNT(CASE WHEN distance_km = 0 THEN 1 END) AS zero_distance_entries
FROM rides;



-- summary statistics for numerical columns in users table
SELECT 
    MIN(age) AS min_age,
    MAX(age) AS max_age,
    ROUND(AVG(age), 2) AS avg_age
FROM users;


--distribution of membership levels in users table
SELECT 
    membership_level,
    COUNT(*) AS count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM users)), 2) AS percentage
FROM users
GROUP BY membership_level;

--different membership levels
SELECT 
u.membership_level,
COUNT(r.ride_id) AS total_rides,
avg(r.distance_km) AS avg_distance,
ROUND(AVG(EXTRACT(EPOCH FROM (r.end_time::timestamp - r.start_time::timestamp)) / 60), 2) AS avg_ride_duration_minutes
FROM users u
LEFT JOIN rides r ON u.user_id = r.user_id
GROUP BY u.membership_level
order by total_rides desc;


--peek hourly distribution of rides
SELECT 
    EXTRACT(HOUR FROM start_time::timestamp) AS ride_start_hour,
    COUNT(*) AS total_rides
FROM rides
GROUP BY EXTRACT(HOUR FROM start_time::timestamp)
ORDER BY ride_start_hour;


-- check for popular stations
SELECT 
    s.station_name,
    COUNT(r.ride_id) AS total_rides_started
FROM stations s
LEFT JOIN rides r ON s.station_id = r.start_station_id
GROUP BY s.station_name
ORDER BY total_rides_started DESC
LIMIT 10;


---categorical distribution of users by age groups
SELECT 
    CASE 
        WHEN age < 18 THEN 'Under 18'                       
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS user_count
FROM users
GROUP BY age_group
ORDER BY user_count DESC;


-- categorizing rides by distance into short, medium, long
SELECT 
    CASE 
        WHEN distance_km < 5 THEN 'Short'                
        WHEN distance_km BETWEEN 5 AND 15 THEN 'Medium'
        ELSE 'Long'                                                    
    END AS distance_category,
    COUNT(*) AS ride_count
FROM rides
GROUP BY distance_category
ORDER BY ride_count DESC;


--net flow analysis at each stations
WITH station_flows AS (
    SELECT 
        start_station_id AS station_id,
        COUNT(*) AS rides_started
    FROM rides
    GROUP BY start_station_id),
end_flows AS (
    SELECT 
        end_station_id AS station_id,
        -COUNT(*) AS rides_ended
    FROM rides
    GROUP BY end_station_id
)
SELECT 
    s.station_name,
    COALESCE(sf.rides_started, 0) + COALESCE(ef.rides_ended, 0) AS net_flow
FROM stations s
LEFT JOIN station_flows sf ON s.station_id = sf.station_id
LEFT JOIN end_flows ef ON s.station_id = ef.station_id
ORDER BY net_flow DESC;         


--user retention analysis

WITH monthly_rides AS (
    SELECT 
        count(user_id) AS rides_per_month,
        DATE_TRUNC('month', start_time::timestamp) AS ride_month
    FROM rides
    GROUP BY  ride_month
)
SELECT 
    ride_month,
    rides_per_month,
    lag(rides_per_month) OVER (ORDER BY ride_month) AS previous_month_rides,
    (rides_per_month - lag(rides_per_month) OVER (ORDER BY ride_month)) AS rides_difference,
    ROUND(CASE 
        WHEN lag(rides_per_month) OVER (ORDER BY ride_month) IS NULL THEN NULL
        WHEN lag(rides_per_month) OVER (ORDER BY ride_month) = 0 THEN NULL
        ELSE ((rides_per_month - lag(rides_per_month) OVER (ORDER BY ride_month)) * 100.0 / lag(rides_per_month) OVER (ORDER BY ride_month))
    END, 2) AS percentage_change
    FROM monthly_rides
ORDER BY ride_month            