{{ config(materialized='table') }}

SELECT
  user_id,
  COUNT(order_id) AS total_orders,
  CASE WHEN COUNT(order_id) = 1 THEN TRUE ELSE FALSE END AS is_one_time_user,
  CASE WHEN MAX(days_since_prior_order) > 20 THEN TRUE ELSE FALSE END AS likely_to_churn
FROM {{ ref('stg_orders') }}
GROUP BY user_id
