{{ config(materialized='table') }}

SELECT
  f.user_id,
  f.total_orders,
  f.avg_days_between_orders,
  f.first_order_number,
  f.last_order_number,
  c.is_one_time_user,
  c.likely_to_churn
FROM {{ ref('fct_user_order_summary') }} f
LEFT JOIN {{ ref('user_churn_signals') }} c
  ON f.user_id = c.user_id
