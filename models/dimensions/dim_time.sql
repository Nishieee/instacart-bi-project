WITH date_spine AS (

    {{ dbt_utils.date_spine(
        start_date="cast('2021-01-01' as date)",
        end_date="cast('2023-12-31' as date)",
        datepart="day"
    ) }}

)

SELECT
  date_day AS date,
  EXTRACT(DAYOFWEEK FROM date_day) - 1 AS day_of_week,
  FORMAT_DATE('%A', date_day) AS day_name,
  EXTRACT(WEEK FROM date_day) AS week,
  EXTRACT(MONTH FROM date_day) AS month,
  EXTRACT(YEAR FROM date_day) AS year,
  CASE WHEN EXTRACT(DAYOFWEEK FROM date_day) IN (1, 7) THEN TRUE ELSE FALSE END AS is_weekend
FROM date_spine
