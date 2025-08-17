# Instacart BI Project - End-to-End Data Analytics Platform

## 📊 Project Overview

This is a comprehensive **Business Intelligence (BI) platform** built for Instacart to detect revenue leakage and optimize grocery e-commerce operations. The project uses a modern cloud data stack with dbt for transformations and BigQuery for analytics.

### 🎯 Business Objectives
- **Revenue Leakage Detection**: Identify and prevent revenue loss through customer churn and product performance issues
- **Operational Optimization**: Optimize inventory, staffing, and product placement based on data insights
- **Customer Retention**: Improve customer lifetime value through targeted retention strategies
- **Product Performance**: Maximize product reorder rates and inventory efficiency

## 🏗️ Data Architecture

### Recommended Diagram Tools

For professional data architecture diagrams, consider these alternatives to Mermaid:

#### **1. Draw.io (diagrams.net) - FREE**
- **Best for**: Entity-Relationship Diagrams (ERD), Data Flow Diagrams
- **Pros**: Free, web-based, extensive templates, collaborative
- **Use case**: Perfect for this project's star schema and data flow

#### **2. Lucidchart - PAID**
- **Best for**: Enterprise-level architecture diagrams
- **Pros**: Professional templates, real-time collaboration, integrations
- **Cons**: Subscription required

#### **3. dbdiagram.io - FREE/PAID**
- **Best for**: Database schema diagrams, ERDs
- **Pros**: Database-specific, code-based, version control friendly
- **Perfect for**: Our dbt model relationships

#### **4. PlantUML - FREE**
- **Best for**: Code-based diagram generation
- **Pros**: Version control friendly, text-based, automated generation
- **Cons**: Steeper learning curve

### Current Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Raw Sources   │    │  Staging Layer  │    │  Core Models    │
│                 │    │                 │    │                 │
│ • orders        │───▶│ • stg_orders    │───▶│ • fct_order_    │
│ • products      │    │ • stg_products  │    │   details       │
│ • aisles        │    │ • stg_aisles    │    │ • fct_revenue_  │
│ • departments   │    │ • stg_departments│   │   analytics     │
│ • order_products│    │ • stg_order_    │    │                 │
└─────────────────┘    │   products      │    └─────────────────┘
                       └─────────────────┘              │
                                                        │
                       ┌─────────────────┐              │
                       │   Dimensions    │              │
                       │                 │              │
                       │ • dim_customers │◀─────────────┘
                       │ • dim_products_ │
                       │   enhanced      │
                       │ • dim_time      │
                       └─────────────────┘
```

## 📁 Project Structure

```
instacart-bi-project/
├── models/
│   ├── staging/instacart_raw/     # Raw data ingestion
│   ├── dimensions/                # Dimension tables
│   ├── core/                     # Core fact tables
│   ├── metrics/                  # Business metrics
│   └── bi/                       # BI-ready tables
├── analyses/                     # Ad-hoc analyses
├── macros/                       # Reusable macros
├── tests/                        # Custom tests
├── seeds/                        # Static data
└── snapshots/                    # Slowly changing dimensions
```

## 🔧 Technology Stack

### **Data Platform**
- **Google Cloud Platform (GCP)**: Cloud infrastructure
- **BigQuery**: Data warehouse and analytics
- **dbt**: Data transformation and modeling

### **Data Sources**
- **Instacart Dataset**: Orders, products, customers, aisles, departments
- **Format**: CSV files loaded into BigQuery

### **Development Tools**
- **dbt Core**: Data transformation framework
- **Git**: Version control
- **BigQuery Console**: Data exploration and monitoring

## 📊 Data Models

### **Staging Layer** (`models/staging/`)
Raw data ingestion with basic cleaning and standardization.

```sql
-- Example: stg_orders.sql
SELECT
    order_id,
    user_id,
    order_number,
    order_dow,
    order_hour_of_day,
    days_since_prior_order
FROM {{ source('instacart_raw', 'orders') }}
```

### **Dimension Tables** (`models/dimensions/`)

#### **dim_customers** - Enhanced Customer Analytics
- **RFM Analysis**: Frequency, Recency, Monetary segmentation
- **Customer Segments**: VIP, Regular, One-time, Occasional
- **Churn Risk**: Advanced churn prediction indicators
- **Loyalty Metrics**: Customer engagement scores

#### **dim_products_enhanced** - Product Performance
- **Performance Metrics**: Reorder rates, volume categories
- **Product Lifecycle**: New, Staple, Regular, Occasional, Rare
- **Strategy Classification**: Star, Volume, Niche, Standard products

#### **dim_time** - Time Dimensions
- **Date Hierarchy**: Day, week, month, year
- **Business Logic**: Weekend flags, peak hours
- **Seasonal Analysis**: Time-based patterns

### **Core Fact Tables** (`models/core/`)

#### **fct_order_details** - Main Fact Table
```sql
-- Key metrics available
- order_detail_id (surrogate key)
- order_id, product_id, user_id
- reordered, add_to_cart_order
- order_hour_of_day, days_since_prior_order
- calculated flags and metrics
```

#### **fct_revenue_analytics** - Revenue Intelligence
```sql
-- Business intelligence metrics
- revenue_leakage_category
- time_efficiency_category  
- customer_journey_stage
- operational efficiency indicators
```

### **Business Intelligence Layer** (`models/bi/`)
- **top_reordered_products**: Top 25 products by reorder rate
- **orders_by_hour**: Hourly order distribution
- **first_vs_repeated_orders**: Order type breakdown

## 🎯 Key Business Metrics

### **Revenue Leakage Detection**
1. **Customer Churn Risk**
   - One-time buyers
   - Customers with >20 days between orders
   - Declining order frequency

2. **Product Performance Issues**
   - Low reorder rate products
   - High volume, low reorder products
   - Products with declining popularity

3. **Operational Inefficiencies**
   - Peak hour capacity issues
   - Inventory waste on low-performing products
   - Suboptimal product placement

### **Customer Analytics**
- **RFM Segmentation**: Recency, Frequency, Monetary analysis
- **Customer Lifetime Value**: Predictive customer value
- **Churn Prediction**: Early warning system for at-risk customers
- **Journey Mapping**: Acquisition → Engagement → Retention → At Risk

### **Product Analytics**
- **Reorder Performance**: Product reorder rates and trends
- **Category Analysis**: Aisle and department performance
- **Lifecycle Management**: Product development and promotion strategies
- **Inventory Optimization**: Stock level recommendations

## 🚀 Getting Started

### **Prerequisites**
- Google Cloud Platform account
- BigQuery dataset with Instacart data
- dbt Core installed locally
- Git for version control

### **Setup Instructions**

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd instacart-bi-project
   ```

2. **Install Dependencies**
   ```bash
   pip install dbt-core
   pip install dbt-bigquery
   ```

3. **Configure dbt Profile**
   ```yaml
   # ~/.dbt/profiles.yml
   instacart_bi_project:
     target: dev
     outputs:
       dev:
         type: bigquery
         method: service-account
         project: instacart-bi-461818
         dataset: instacart_analytics
         location: US
         keyfile: /path/to/service-account.json
   ```

4. **Run the Models**
   ```bash
   dbt deps
   dbt run
   dbt test
   ```

### **Development Workflow**

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/new-model
   ```

2. **Develop and Test**
   ```bash
   dbt run --select model_name
   dbt test --select model_name
   ```

3. **Document Changes**
   ```bash
   dbt docs generate
   dbt docs serve
   ```

4. **Deploy to Production**
   ```bash
   dbt run --target prod
   dbt test --target prod
   ```

## 📈 Data Quality & Testing

### **Built-in Tests**
- **Primary Key Tests**: Ensure uniqueness
- **Not Null Tests**: Validate required fields
- **Referential Integrity**: Foreign key relationships
- **Accepted Values**: Business logic validation

### **Custom Tests**
```sql
-- Example: customer_segment_consistency
SELECT user_id, customer_segment, total_orders
FROM {{ ref('dim_customers') }}
WHERE (customer_segment = 'One-time Customer' AND total_orders != 1)
   OR (customer_segment = 'VIP Customer' AND total_orders < 10)
```

### **Data Quality Monitoring**
- **Freshness Checks**: Ensure data is up-to-date
- **Volume Checks**: Monitor data volume changes
- **Schema Changes**: Track structural modifications

## 📊 Analytics & Reporting

### **Key Dashboards**
1. **Revenue Leakage Dashboard**
   - Customer churn indicators
   - Product performance alerts
   - Revenue impact analysis

2. **Operational Efficiency Dashboard**
   - Peak hour analysis
   - Inventory optimization
   - Staffing recommendations

3. **Customer Analytics Dashboard**
   - Customer segmentation
   - Lifetime value analysis
   - Retention strategies

### **Sample Queries**

#### **Revenue Leakage Analysis**
```sql
SELECT 
    revenue_leakage_category,
    COUNT(*) as order_count,
    COUNT(DISTINCT user_id) as unique_customers
FROM {{ ref('fct_revenue_analytics') }}
WHERE revenue_leakage_category != 'Standard Order'
GROUP BY revenue_leakage_category
ORDER BY order_count DESC;
```

#### **Customer Churn Risk**
```sql
SELECT 
    customer_segment,
    COUNT(*) as customer_count,
    AVG(total_orders) as avg_orders
FROM {{ ref('dim_customers') }}
WHERE is_churn_risk = TRUE
GROUP BY customer_segment;
```

## 🔄 Data Pipeline

### **Daily Refresh Process**
1. **Data Ingestion**: Load new data from sources
2. **Staging**: Clean and standardize raw data
3. **Transformation**: Build dimensions and facts
4. **Testing**: Validate data quality
5. **Documentation**: Update data catalog

### **Monitoring & Alerting**
- **dbt Cloud**: Automated runs and notifications
- **BigQuery Monitoring**: Query performance and costs
- **Data Quality Alerts**: Failed tests and anomalies

## 📚 Documentation

### **Data Dictionary**
- **Column Descriptions**: Detailed field documentation
- **Business Rules**: Data transformation logic
- **Data Lineage**: Source-to-target mapping

### **Model Documentation**
```bash
dbt docs generate
dbt docs serve
```

## 🤝 Contributing

### **Development Guidelines**
1. **Follow dbt Best Practices**: Use proper naming conventions
2. **Write Tests**: Ensure data quality
3. **Document Changes**: Update schema files
4. **Code Review**: Peer review for all changes

### **Code Standards**
- **SQL Style**: Consistent formatting and naming
- **dbt Conventions**: Follow dbt style guide
- **Documentation**: Comprehensive model descriptions

## 📞 Support & Maintenance

### **Troubleshooting**
- **Common Issues**: Check dbt documentation
- **Performance**: Optimize BigQuery queries
- **Data Quality**: Review test failures

### **Maintenance Tasks**
- **Regular Updates**: Keep dbt and dependencies current
- **Performance Monitoring**: Track query performance
- **Cost Optimization**: Monitor BigQuery usage

## 📈 Future Enhancements

### **Planned Features**
- **Real-time Analytics**: Streaming data integration
- **Machine Learning**: Predictive analytics models
- **Advanced Segmentation**: Behavioral clustering
- **API Integration**: External data sources

### **Scalability Considerations**
- **Incremental Models**: Optimize for large datasets
- **Partitioning**: Improve query performance
- **Caching**: Reduce computation costs

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **Instacart**: For providing the dataset
- **dbt Community**: For the excellent transformation framework
- **Google Cloud**: For the scalable data platform

---

**Last Updated**: December 2024  
**Version**: 1.0.0  
**Maintainer**: Data Engineering Team
