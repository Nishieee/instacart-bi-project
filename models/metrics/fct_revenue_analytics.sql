{{ config(materialized='table') }}

WITH order_analytics AS (
    SELECT
        -- Time dimensions
        o.order_dow,
        o.order_hour_of_day,
        dt.date,
        dt.day_name,
        dt.is_weekend,
        dt.week,
        dt.month,
        dt.year,
        
        -- Customer dimensions
        o.user_id,
        c.customer_segment,
        c.frequency_segment,
        c.recency_segment,
        c.is_churn_risk,
        c.is_loyal_customer,
        
        -- Product dimensions
        op.product_id,
        p.product_name,
        p.aisle,
        p.department,
        p.volume_category,
        p.reorder_category,
        p.product_lifecycle,
        p.product_strategy,
        
        -- Order metrics
        o.order_id,
        o.order_number,
        o.days_since_prior_order,
        op.add_to_cart_order,
        op.reordered,
        
        -- Calculated metrics
        CASE WHEN op.reordered = 1 THEN 1 ELSE 0 END AS is_reordered,
        CASE WHEN op.add_to_cart_order = 1 THEN 1 ELSE 0 END AS is_first_in_cart,
        CASE WHEN o.days_since_prior_order > 20 THEN 1 ELSE 0 END AS is_long_gap_order,
        
        -- Customer behavior indicators
        CASE WHEN c.total_orders = 1 THEN 1 ELSE 0 END AS is_first_time_customer,
        CASE WHEN c.avg_days_between_orders <= 7 THEN 1 ELSE 0 END AS is_frequent_customer,
        
        -- Product performance indicators
        CASE WHEN p.reorder_rate >= 0.7 THEN 1 ELSE 0 END AS is_high_reorder_product,
        CASE WHEN p.volume_category = 'High Volume' THEN 1 ELSE 0 END AS is_high_volume_product
        
    FROM {{ ref('stg_orders') }} o
    JOIN {{ ref('stg_order_products') }} op ON o.order_id = op.order_id
    JOIN {{ ref('dim_customers') }} c ON o.user_id = c.user_id
    JOIN {{ ref('dim_products_enhanced') }} p ON op.product_id = p.product_id
    LEFT JOIN {{ ref('dim_time') }} dt ON o.order_dow = dt.day_of_week
),

revenue_insights AS (
    SELECT
        *,
        
        -- Revenue leakage indicators
        CASE 
            WHEN is_first_time_customer = 1 AND is_high_reorder_product = 0 THEN 'New Customer - Low Reorder Product'
            WHEN is_churn_risk = 1 AND is_high_reorder_product = 1 THEN 'Churn Risk - High Reorder Product'
            WHEN is_long_gap_order = 1 AND is_frequent_customer = 1 THEN 'Frequent Customer - Long Gap'
            ELSE 'Standard Order'
        END AS revenue_leakage_category,
        
        -- Operational efficiency indicators
        CASE 
            WHEN order_hour_of_day BETWEEN 8 AND 12 THEN 'Morning Peak'
            WHEN order_hour_of_day BETWEEN 17 AND 21 THEN 'Evening Peak'
            WHEN order_hour_of_day BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Off Peak'
        END AS time_efficiency_category,
        
        -- Customer journey stage
        CASE 
            WHEN is_first_time_customer = 1 THEN 'Acquisition'
            WHEN is_frequent_customer = 1 AND is_loyal_customer = 1 THEN 'Retention'
            WHEN is_churn_risk = 1 THEN 'At Risk'
            ELSE 'Engagement'
        END AS customer_journey_stage
        
    FROM order_analytics
)

SELECT
    -- Primary keys
    order_id,
    product_id,
    user_id,
    
    -- Time dimensions
    order_dow,
    order_hour_of_day,
    date,
    day_name,
    is_weekend,
    week,
    month,
    year,
    
    -- Customer dimensions
    customer_segment,
    frequency_segment,
    recency_segment,
    is_churn_risk,
    is_loyal_customer,
    
    -- Product dimensions
    product_name,
    aisle,
    department,
    volume_category,
    reorder_category,
    product_lifecycle,
    product_strategy,
    
    -- Order metrics
    order_number,
    days_since_prior_order,
    add_to_cart_order,
    reordered,
    
    -- Calculated flags
    is_reordered,
    is_first_in_cart,
    is_long_gap_order,
    is_first_time_customer,
    is_frequent_customer,
    is_high_reorder_product,
    is_high_volume_product,
    
    -- Business categories
    revenue_leakage_category,
    time_efficiency_category,
    customer_journey_stage,
    
    -- Metadata
    CURRENT_TIMESTAMP() AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
    
FROM revenue_insights
