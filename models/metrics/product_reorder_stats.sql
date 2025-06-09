{{ config(materialized='table') }}

SELECT
  product_id,
  product_name,
  COUNT(*) AS total_orders,
  SUM(reordered) AS total_reorders,
  ROUND(SAFE_DIVIDE(SUM(reordered), COUNT(*)), 2) AS reorder_rate
FROM {{ ref('order_details') }}
GROUP BY product_id, product_name
ORDER BY reorder_rate DESC
