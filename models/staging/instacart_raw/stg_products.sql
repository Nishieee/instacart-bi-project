{{ config(materialized='view') }}

SELECT
  p.product_id,
  p.product_name,
  p.aisle_id,             -- ✅ include foreign key ID
  a.aisle,
  p.department_id,        -- ✅ include foreign key ID
  d.department
FROM {{ source('instacart_raw', 'products') }} p
LEFT JOIN {{ source('instacart_raw', 'aisles') }} a
  ON p.aisle_id = a.aisle_id
LEFT JOIN {{ source('instacart_raw', 'departments') }} d
  ON p.department_id = d.department_id
