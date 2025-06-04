{{ config(materialized='view') }}

SELECT
  aisle_id,
  aisle
FROM {{ source('instacart_raw', 'aisles') }}
