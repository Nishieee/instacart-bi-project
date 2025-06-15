{{ config(materialized='table') }}

SELECT
  p.product_id,
  p.product_name,
  p.aisle,
  p.department,
  COUNT(*) AS total_orders,
  SUM(od.reordered) AS total_reorders,
  ROUND(SAFE_DIVIDE(SUM(od.reordered), COUNT(*)), 2) AS reorder_rate
FROM {{ ref('order_details') }} od
JOIN {{ ref('dim_products') }} p
  ON od.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.aisle, p.department
ORDER BY reorder_rate DESC
LIMIT 25
