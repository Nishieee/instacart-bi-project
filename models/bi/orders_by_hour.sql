{{ config(materialized='table') }}

SELECT
  order_hour_of_day,
  COUNT(*) AS total_orders
FROM {{ ref('order_details') }}
GROUP BY order_hour_of_day
ORDER BY order_hour_of_day
