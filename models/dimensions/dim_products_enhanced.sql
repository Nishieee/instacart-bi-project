{{ config(materialized='table') }}

WITH product_performance AS (
    SELECT
        p.product_id,
        p.product_name,
        p.aisle_id,
        p.aisle,
        p.department_id,
        p.department,
        
        -- Order metrics
        COUNT(DISTINCT op.order_id) AS total_orders,
        COUNT(*) AS total_order_items,
        SUM(op.reordered) AS total_reorders,
        AVG(op.reordered) AS reorder_rate,
        
        -- Cart position analysis
        AVG(op.add_to_cart_order) AS avg_cart_position,
        COUNT(CASE WHEN op.add_to_cart_order = 1 THEN 1 END) AS times_first_in_cart,
        
        -- Customer reach
        COUNT(DISTINCT o.user_id) AS unique_customers,
        
        -- Product popularity
        ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT op.order_id) DESC) AS popularity_rank,
        
        -- Performance categories
        CASE 
            WHEN COUNT(DISTINCT op.order_id) >= 1000 THEN 'High Volume'
            WHEN COUNT(DISTINCT op.order_id) >= 100 THEN 'Medium Volume'
            ELSE 'Low Volume'
        END AS volume_category,
        
        CASE 
            WHEN AVG(op.reordered) >= 0.7 THEN 'High Reorder'
            WHEN AVG(op.reordered) >= 0.4 THEN 'Medium Reorder'
            ELSE 'Low Reorder'
        END AS reorder_category
        
    FROM {{ ref('stg_products') }} p
    LEFT JOIN {{ ref('stg_order_products') }} op ON p.product_id = op.product_id
    LEFT JOIN {{ ref('stg_orders') }} o ON op.order_id = o.order_id
    GROUP BY p.product_id, p.product_name, p.aisle_id, p.aisle, p.department_id, p.department
),

product_insights AS (
    SELECT
        *,
        
        -- Product lifecycle indicators
        CASE 
            WHEN total_orders = 0 THEN 'New Product'
            WHEN reorder_rate >= 0.8 THEN 'Staple Product'
            WHEN reorder_rate >= 0.5 THEN 'Regular Product'
            WHEN reorder_rate >= 0.2 THEN 'Occasional Product'
            ELSE 'Rare Product'
        END AS product_lifecycle,
        
        -- Revenue potential
        CASE 
            WHEN volume_category = 'High Volume' AND reorder_category = 'High Reorder' THEN 'Star Product'
            WHEN volume_category = 'High Volume' AND reorder_category = 'Low Reorder' THEN 'Volume Product'
            WHEN volume_category = 'Low Volume' AND reorder_category = 'High Reorder' THEN 'Niche Product'
            ELSE 'Standard Product'
        END AS product_strategy,
        
        -- Customer loyalty indicator
        CASE 
            WHEN unique_customers > 0 AND total_orders / unique_customers >= 2 THEN TRUE
            ELSE FALSE
        END AS has_loyal_customers
        
    FROM product_performance
)

SELECT
    product_id,
    product_name,
    aisle_id,
    aisle,
    department_id,
    department,
    total_orders,
    total_order_items,
    total_reorders,
    reorder_rate,
    avg_cart_position,
    times_first_in_cart,
    unique_customers,
    popularity_rank,
    volume_category,
    reorder_category,
    product_lifecycle,
    product_strategy,
    has_loyal_customers,
    
    -- Metadata
    CURRENT_TIMESTAMP() AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
    
FROM product_insights
