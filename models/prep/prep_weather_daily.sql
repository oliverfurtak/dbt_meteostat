WITH daily_data AS (
    SELECT * 
    FROM {{ref('staging_weather_daily')}}
),
add_features AS (
    SELECT *
		, DATE_PART('day', timestamp) AS date_day 		-- number of the day of month
		, DATE_PART('month', timestamp) AS date_month 	-- number of the month of year
		, DATE_PART('year', timestamp) AS date_year 		-- number of year
		, DATE_PART('week', timestamp) AS cw 			-- number of the week of year
		, TO_CHAR(timestamp, 'FMmonth') AS month_name 	-- name of the month
		, TO_CHAR(timestamp, 'FMday') AS weekday 		-- name of the weekday
    FROM daily_data 
),
add_more_features AS (
    SELECT *
		, (CASE 
			WHEN month_name in ('december', 'january', 'february') THEN 'winter'
			WHEN month_name in ('march', 'april', 'may') THEN 'spring'
            WHEN month_name in ('june', 'july', 'august') THEN 'summer'
            WHEN month_name in ('september', 'october', 'november') THEN 'autumn'
		END) AS season
    FROM add_features
)
SELECT *
FROM add_more_features
ORDER BY date