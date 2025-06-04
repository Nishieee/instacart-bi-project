{{ config(materialized='view') }}

SELECT
  order_id,
  product_id,
  add_to_cart_order,
  reordered
FROM {{ source('instacart_raw', 'order_products__prior') }}

UNION ALL

SELECT
  order_id,
  product_id,
  add_to_cart_order,
  reordered
FROM {{ source('instacart_raw', 'order_products__train') }}
