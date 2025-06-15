{{ config(materialized='table') }}

SELECT
  reordered,
  COUNT(*) AS total_orders
FROM {{ ref('order_details') }}
GROUP BY reordered
