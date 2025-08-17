{{ config(materialized='table') }}

WITH customer_metrics AS (
    SELECT
        user_id,
        COUNT(DISTINCT order_id) AS total_orders,
        MIN(order_number) AS first_order_number,
        MAX(order_number) AS last_order_number,
        AVG(days_since_prior_order) AS avg_days_between_orders,
        MAX(days_since_prior_order) AS max_days_between_orders,
        MIN(order_dow) AS first_order_day,
        MAX(order_dow) AS last_order_day,
        COUNT(DISTINCT product_id) AS unique_products_ordered,
        COUNT(DISTINCT CASE WHEN reordered = 1 THEN product_id END) AS unique_products_reordered
    FROM {{ ref('stg_orders') }} o
    LEFT JOIN {{ ref('stg_order_products') }} op ON o.order_id = op.order_id
    GROUP BY user_id
),

customer_segments AS (
    SELECT
        user_id,
        total_orders,
        avg_days_between_orders,
        unique_products_ordered,
        unique_products_reordered,
        
        -- RFM Analysis
        CASE 
            WHEN total_orders >= 10 THEN 'High Frequency'
            WHEN total_orders >= 5 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_segment,
        
        CASE 
            WHEN avg_days_between_orders <= 7 THEN 'High Recency'
            WHEN avg_days_between_orders <= 14 THEN 'Medium Recency'
            ELSE 'Low Recency'
        END AS recency_segment,
        
        -- Customer Value Segments
        CASE 
            WHEN total_orders >= 10 AND avg_days_between_orders <= 7 THEN 'VIP Customer'
            WHEN total_orders >= 5 AND avg_days_between_orders <= 14 THEN 'Regular Customer'
            WHEN total_orders = 1 THEN 'One-time Customer'
            ELSE 'Occasional Customer'
        END AS customer_segment,
        
        -- Churn Risk
        CASE 
            WHEN total_orders = 1 THEN TRUE
            WHEN avg_days_between_orders > 20 THEN TRUE
            ELSE FALSE
        END AS is_churn_risk,
        
        -- Loyalty Indicators
        CASE 
            WHEN unique_products_reordered / NULLIF(unique_products_ordered, 0) >= 0.5 THEN TRUE
            ELSE FALSE
        END AS is_loyal_customer
        
    FROM customer_metrics
)

SELECT
    user_id,
    total_orders,
    avg_days_between_orders,
    max_days_between_orders,
    unique_products_ordered,
    unique_products_reordered,
    first_order_number,
    last_order_number,
    first_order_day,
    last_order_day,
    frequency_segment,
    recency_segment,
    customer_segment,
    is_churn_risk,
    is_loyal_customer,
    
    -- Metadata
    CURRENT_TIMESTAMP() AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
    
FROM customer_segments
