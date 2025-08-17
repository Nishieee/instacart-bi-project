# Instacart BI Project - Data Analytics Platform

## 📊 Project Overview

A **Business Intelligence (BI) platform** for Instacart to detect revenue leakage and optimize grocery e-commerce operations using dbt and BigQuery.

### 🎯 Business Goals
- **Revenue Leakage Detection**: Identify customer churn and product performance issues
- **Operational Optimization**: Optimize inventory and staffing based on data insights
- **Customer Retention**: Improve customer lifetime value through targeted strategies

## 🏗️ Data Architecture

### Recommended Diagram Tools
- **Draw.io (diagrams.net)** - FREE, perfect for ERDs and data flow diagrams
- **dbdiagram.io** - FREE/PAID, specifically for database schemas
- **Lucidchart** - PAID, enterprise-level architecture diagrams
- **Microsoft Visio** - PAID, professional data modeling and architecture diagrams

### Architecture Overview
```
Raw Sources → Staging → Dimensions → Fact Tables → BI Layer
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
└── tests/                        # Custom tests
```

## 🔧 Technology Stack
- **Google Cloud Platform (GCP)**: Cloud infrastructure
- **BigQuery**: Data warehouse and analytics
- **dbt**: Data transformation and modeling
- **Looker**: Business intelligence and dashboarding platform

## 📊 Data Models

### **Dimension Tables**
- **dim_customers**: Customer analytics with RFM segmentation and churn prediction
- **dim_products_enhanced**: Product performance metrics and lifecycle indicators
- **dim_time**: Time dimensions for seasonal and temporal analysis

### **Fact Tables**
- **fct_order_details**: Main fact table with order-product combinations
- **fct_revenue_analytics**: Advanced analytics with revenue leakage detection

### **Business Intelligence Layer**
- **top_reordered_products**: Top 25 products by reorder rate
- **orders_by_hour**: Hourly order distribution
- **first_vs_repeated_orders**: Order type breakdown

## 🎯 Key Business Metrics

### **Revenue Leakage Detection**
- Customer churn risk (one-time buyers, >20 days between orders)
- Product performance issues (low reorder rates, declining popularity)
- Operational inefficiencies (peak hour capacity, inventory waste)

### **Customer Analytics**
- **RFM Segmentation**: Recency, Frequency, Monetary analysis
- **Customer Journey**: Acquisition → Engagement → Retention → At Risk
- **Churn Prediction**: Early warning system for at-risk customers

### **Product Analytics**
- **Reorder Performance**: Product reorder rates and trends
- **Lifecycle Management**: Product development strategies
- **Inventory Optimization**: Stock level recommendations

## 🚀 Getting Started

### **Prerequisites**
- Google Cloud Platform account
- BigQuery dataset with Instacart data
- dbt Core installed locally
- Looker instance (optional for dashboards)

### **Quick Setup**
1. **Clone and Install**
   ```bash
   git clone <repository-url>
   cd instacart-bi-project
   pip install dbt-core dbt-bigquery
   ```

2. **Configure dbt Profile**
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

3. **Run the Models**
   ```bash
   dbt deps
   dbt run
   dbt test
   ```

## 📈 Sample Analytics Queries

### **Revenue Leakage Analysis**
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

### **Customer Churn Risk**
```sql
SELECT 
    customer_segment,
    COUNT(*) as customer_count,
    AVG(total_orders) as avg_orders
FROM {{ ref('dim_customers') }}
WHERE is_churn_risk = TRUE
GROUP BY customer_segment;
```

### **Product Performance**
```sql
SELECT 
    product_lifecycle,
    product_strategy,
    COUNT(*) as product_count,
    AVG(reorder_rate) as avg_reorder_rate
FROM {{ ref('dim_products_enhanced') }}
GROUP BY product_lifecycle, product_strategy;
```

## 📊 Looker Dashboards

### **Revenue Leakage Dashboard**
- **Customer Churn Monitor**: Real-time churn risk indicators
- **Product Performance Alert**: Low reorder rate product alerts
- **Revenue Impact Analysis**: Quantified revenue leakage impact
- **Trend Analysis**: Historical churn and performance trends

### **Operational Efficiency Dashboard**
- **Peak Hour Analysis**: Order volume by hour and day
- **Inventory Optimization**: Stock level recommendations
- **Staffing Recommendations**: Capacity planning insights
- **Operational KPIs**: Key performance indicators

### **Customer Analytics Dashboard**
- **Customer Segmentation**: RFM analysis visualization
- **Lifetime Value Analysis**: Customer value trends
- **Retention Strategies**: Targeted retention recommendations
- **Journey Mapping**: Customer lifecycle visualization

### **Product Analytics Dashboard**
- **Reorder Performance**: Product reorder rate analysis
- **Category Performance**: Aisle and department insights
- **Lifecycle Management**: Product development recommendations
- **Inventory Optimization**: Stock level analysis

## 🔄 Data Pipeline

### **Daily Process**
1. **Data Ingestion**: Load new data from sources
2. **Staging**: Clean and standardize raw data
3. **Transformation**: Build dimensions and facts
4. **Testing**: Validate data quality
5. **Documentation**: Update data catalog
6. **Looker Refresh**: Update dashboards with new data

## 📚 Documentation

### **Generate Documentation**
```bash
dbt docs generate
dbt docs serve
```

## 📈 Future Enhancements

### **Planned Features**
- **Real-time Analytics**: Streaming data integration
- **Machine Learning**: Predictive analytics models
- **Advanced Segmentation**: Behavioral clustering
- **API Integration**: External data sources

---

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- **Instacart**: For providing the dataset
- **dbt Community**: For the excellent transformation framework
- **Google Cloud**: For the scalable data platform

---

**Last Updated**: December 2024  
**Version**: 1.0.0
