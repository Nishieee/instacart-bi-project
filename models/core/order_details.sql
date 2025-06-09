{{ config(materialized='table') }}

WITH order_data AS (
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
        p.aisle,
        p.department,
        dt.day_name,
        dt.is_weekend
    FROM {{ ref('stg_orders') }} o
    JOIN {{ ref('stg_order_products') }} op ON o.order_id = op.order_id
    JOIN {{ ref('dim_products') }} p ON op.product_id = p.product_id
    LEFT JOIN {{ ref('dim_time') }} dt ON o.order_dow = dt.day_of_week
)

SELECT * FROM order_data
