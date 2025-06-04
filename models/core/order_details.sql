{{ config(materialized='table') }}

SELECT
  o.order_id,
  o.user_id,
  o.order_number,
  o.order_dow,
  o.order_hour_of_day,
  o.days_since_prior_order,
  op.product_id,
  op.add_to_cart_order,
  op.reordered,
  p.product_name,
  p.aisle_id,
  p.aisle,
  p.department_id,
  p.department
FROM {{ ref('stg_orders') }} o
JOIN {{ ref('stg_order_products') }} op
  ON o.order_id = op.order_id
JOIN {{ ref('stg_products') }} p
  ON op.product_id = p.product_id
