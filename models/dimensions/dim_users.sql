{{ config(materialized='table') }}

SELECT
  user_id,
  COUNT(DISTINCT order_id) AS total_orders,
  MIN(order_number) AS first_order_number,
  MAX(order_number) AS last_order_number,
  AVG(days_since_prior_order) AS avg_days_between_orders,
  CASE WHEN COUNT(*) = 1 THEN TRUE ELSE FALSE END AS is_one_time_user,
  CASE WHEN MAX(days_since_prior_order) > 20 THEN TRUE ELSE FALSE END AS likely_to_churn
FROM {{ ref('stg_orders') }}
GROUP BY user_id
