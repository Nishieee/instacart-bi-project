{{ config(materialized='table') }}

WITH order_data AS (
    SELECT
        -- Surrogate keys for better performance
        ROW_NUMBER() OVER (ORDER BY o.order_id, op.product_id) AS order_detail_id,
        
        -- Order information
        o.order_id,
        o.user_id,
        o.order_number,
        o.order_dow,
        o.order_hour_of_day,
        o.days_since_prior_order,
        
        -- Product information
        op.product_id,
        op.add_to_cart_order,
        op.reordered,
        
        -- Product attributes
        p.product_name,
        p.aisle_id,
        p.aisle,
        p.department_id,
        p.department,
        
        -- Time attributes
        dt.date,
        dt.day_name,
        dt.is_weekend,
        dt.week,
        dt.month,
        dt.year,
        
        -- Calculated metrics
        CASE WHEN op.reordered = 1 THEN 1 ELSE 0 END AS is_reordered,
        CASE WHEN op.add_to_cart_order = 1 THEN 1 ELSE 0 END AS is_first_in_cart,
        
        -- Metadata
        CURRENT_TIMESTAMP() AS created_at,
        CURRENT_TIMESTAMP() AS updated_at
        
    FROM {{ ref('stg_orders') }} o
    JOIN {{ ref('stg_order_products') }} op ON o.order_id = op.order_id
    JOIN {{ ref('dim_products') }} p ON op.product_id = p.product_id
    LEFT JOIN {{ ref('dim_time') }} dt ON o.order_dow = dt.day_of_week
)

SELECT * FROM order_data
