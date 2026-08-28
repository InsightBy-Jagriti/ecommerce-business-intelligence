# 🛒 E-Commerce Business Intelligence & Customer Analytics

<p align="center">

<img src="https://img.shields.io/badge/Excel-Data%20Analysis-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white">
<img src="https://img.shields.io/badge/MySQL-SQL%20Analytics-4479A1?style=for-the-badge&logo=mysql&logoColor=white">
<img src="https://img.shields.io/badge/Power%20BI-Business%20Intelligence-F2C811?style=for-the-badge&logo=powerbi&logoColor=black">
<img src="https://img.shields.io/badge/Python-Data%20Generation-3776AB?style=for-the-badge&logo=python&logoColor=white">

</p>

<p align="center">
  <b>An end-to-end Business Intelligence project for analyzing e-commerce sales, customers, products, profitability, regions, payments, deliveries, and returns.</b>
</p>

---

## 📌 Project Overview

**E-Commerce Business Intelligence & Customer Analytics** is an end-to-end data analytics project designed to transform raw e-commerce transaction data into meaningful business insights.

The project follows a complete analytics workflow:

```text
Raw Data
   ↓
Python
   ↓
Excel
   ↓
MySQL
   ↓
SQL Analysis
   ↓
Power BI
   ↓
Business Insights
```

The objective is not simply to create charts, but to answer real-world business questions related to sales, customers, products, profitability, delivery performance, payments, and returns.

### Key Business Questions

* Which products generate the most revenue?
* Which products are actually the most profitable?
* Which customers contribute the most revenue?
* Which customers are at risk of leaving?
* Which regions perform best?
* Does discounting increase sales but reduce profitability?
* Which categories have the highest return rates?
* Does delayed delivery increase product returns?
* Which payment methods have higher cancellation rates?
* Which customer segments generate the highest revenue?
* How do sales and profit change over time?

---

# 🎯 Business Objective

The primary objective of this project is to build a centralized **Business Intelligence solution** that helps an e-commerce company understand its overall business performance and make data-driven decisions.

The analysis focuses on:

* 📈 Sales performance
* 💰 Revenue and profitability
* 👥 Customer behavior
* 🎯 Customer segmentation
* 📦 Product performance
* 🌎 Regional performance
* 💳 Payment behavior
* 🔄 Returns and refunds
* 🚚 Delivery performance
* 📅 Business growth
* 🔁 Customer retention

The final **Power BI dashboard** converts these analyses into an interactive decision-support system.

---

# 🧰 Tools & Technologies

| Technology          | Purpose                                                         |
| ------------------- | --------------------------------------------------------------- |
| 🐍 **Python**       | Dataset generation and data preparation                         |
| 📊 **Excel**        | Data validation, cleaning, calculations, pivot analysis and EDA |
| 🗄️ **MySQL**       | Database management and SQL-based business analysis             |
| 📈 **Power BI**     | Interactive dashboards and data visualization                   |
| 📐 **DAX**          | KPIs, calculated measures and time intelligence                 |
| 🔧 **Git & GitHub** | Version control and project documentation                       |

---

# 📂 Dataset

The project uses a relational e-commerce dataset containing approximately **103,000 records** distributed across six tables.

| Table         |     Records | Description                                         |
| ------------- | ----------: | --------------------------------------------------- |
| `customers`   |       8,000 | Customer demographic and location information       |
| `products`    |       1,000 | Product, category, pricing and supplier information |
| `orders`      |      20,000 | Order, status and delivery information              |
| `order_items` |      50,000 | Product-level transaction details                   |
| `payments`    |      20,000 | Payment transactions and payment status             |
| `returns`     |       4,000 | Returned products, reasons and refund information   |
| **Total**     | **103,000** | **Records across all tables**                       |

---

# 🗃️ Database Structure

The project follows a relational database design connecting customers, orders, products, payments and returns.

```text
                         ┌────────────────────┐
                         │     CUSTOMERS       │
                         │────────────────────│
                         │ customer_id        │
                         │ name               │
                         │ location           │
                         │ segment            │
                         └─────────┬──────────┘
                                   │
                                   │ 1 : M
                                   ▼
                         ┌────────────────────┐
                         │       ORDERS       │
                         │────────────────────│
                         │ order_id           │
                         │ customer_id        │
                         │ order_date         │
                         │ status             │
                         │ delivery_date      │
                         └─────────┬──────────┘
                                   │
                                   │ 1 : M
                                   ▼
                    ┌─────────────────────────────┐
                    │        ORDER_ITEMS          │
                    │─────────────────────────────│
                    │ order_item_id               │
                    │ order_id                    │
                    │ product_id                  │
                    │ quantity                    │
                    │ sales_amount                │
                    │ profit_amount               │
                    └──────────────┬──────────────┘
                                   │
                                   │ M : 1
                                   ▼
                         ┌────────────────────┐
                         │      PRODUCTS      │
                         │────────────────────│
                         │ product_id        │
                         │ product_name      │
                         │ category          │
                         │ brand             │
                         │ price             │
                         └────────────────────┘


                         ┌────────────────────┐
                         │      PAYMENTS      │
                         │────────────────────│
                         │ payment_id        │
                         │ order_id           │
                         │ method             │
                         │ status             │
                         │ amount             │
                         └─────────┬──────────┘
                                   │
                                   │ M : 1
                                   ▼
                                 ORDERS


                         ┌────────────────────┐
                         │      RETURNS      │
                         │────────────────────│
                         │ return_id         │
                         │ order_id          │
                         │ product_id        │
                         │ reason            │
                         │ refund_amount     │
                         └─────────┬──────────┘
                                   │
                                   │ M : 1
                                   ▼
                                 ORDERS
```

---

# 🧹 Data Preparation & Data Quality

Before performing analysis, the datasets are validated, cleaned and prepared for analysis.

### Data Quality Checks

The following checks are performed:

* Duplicate records
* Missing values
* Invalid customer IDs
* Invalid product IDs
* Invalid order IDs
* Invalid dates
* Invalid prices
* Invalid quantities
* Discount validation
* Foreign key validation
* Payment validation
* Return validation
* Business-rule validation

### Handling Intentional Missing Values

Not every missing value represents a data-quality problem.

For example:

```text
Cancelled / Processing Order
          ↓
   No Delivery Date
          ↓
     Valid Business Logic
```

Therefore, missing delivery dates for cancelled or still-processing orders are treated as **valid business conditions** rather than automatically being replaced or removed.

---

# 📊 Excel Analysis

Excel is used as the first analytical layer of the project.

### Key Tasks

* Data validation
* Data cleaning
* Calculated columns
* Pivot tables
* KPI calculations
* Exploratory data analysis
* Trend analysis
* Category analysis
* Customer analysis

### Calculated Fields

The following business metrics are calculated:

```text
Gross Sales
Discount Amount
Net Sales
Cost
Profit
Profit Margin
Delivery Days
Return Flag
```

### Excel Analysis Includes

#### 📈 Sales Analysis

* Revenue by month
* Revenue by category
* Revenue by region
* Sales by product
* Sales trends

#### 💰 Profitability Analysis

* Profit by category
* Profit by product
* Profit margin
* Discount vs. profit analysis

#### 👥 Customer Analysis

* Top customers
* Customer revenue contribution
* Customer segment performance
* Customer purchase behavior

#### 💳 Payment Analysis

* Payment method performance
* Successful payments
* Failed payments
* Cancelled transactions

#### 🔄 Return Analysis

* Return rate
* Returns by category
* Returns by product
* Refund analysis
* Return reasons

#### 🚚 Delivery Analysis

* Average delivery time
* Delivery performance by region
* Delayed orders
* Delivery delay vs. return behavior

---

# 🗄️ SQL Analysis

**MySQL** is used to perform structured and advanced business analysis.

The SQL analysis progresses from basic queries to advanced analytical techniques.

### SQL Concepts Covered

```text
SELECT
WHERE
GROUP BY
ORDER BY
HAVING
JOIN
CASE
Subqueries
Common Table Expressions (CTEs)
Aggregate Functions
Date Functions
Window Functions
Ranking
Conditional Aggregation
```

### SQL Business Analysis

The analysis answers questions such as:

#### 📊 Sales & Revenue

* What is the total revenue?
* What is the monthly revenue trend?
* Which categories generate the highest sales?
* Which products generate the highest revenue?
* Which regions contribute the most revenue?

#### 💰 Profitability

* Which products generate the highest profit?
* Which categories have the highest profit margin?
* How does discount percentage affect profit?
* Which products have high sales but low profitability?

#### 👥 Customer Analytics

* Who are the top customers by revenue?
* Which customers have placed the highest number of orders?
* What is the average customer order value?
* Which customer segments contribute the most revenue?
* Which customers show signs of reduced purchasing activity?

#### 📦 Product Analytics

* Which products are best sellers?
* Which products generate the highest profit?
* Which products have high return rates?
* Which products generate high revenue but low margins?

#### 🌎 Regional Analysis

* Which regions have the highest revenue?
* Which regions have the highest profit?
* Which regions experience more delivery delays?
* Which regions have higher return rates?

#### 🔄 Returns & Delivery

* Which categories have the highest return rates?
* What are the most common return reasons?
* Does delayed delivery correlate with higher returns?
* Which products contribute most to refunds?

#### 💳 Payment Analytics

* Which payment methods are most frequently used?
* Which payment methods have the highest failure rate?
* Which payment methods have higher cancellation rates?

---

# 📐 Advanced SQL Analysis

Advanced SQL techniques are used to derive deeper business insights.

### Window Functions

Examples include:

```sql
ROW_NUMBER()
RANK()
DENSE_RANK()
LAG()
LEAD()
SUM() OVER()
AVG() OVER()
```

These are used for:

* Product ranking
* Customer ranking
* Running revenue
* Month-over-month analysis
* Customer purchase patterns
* Category comparisons

### Common Table Expressions

CTEs are used to break complex business problems into smaller analytical steps.

```sql
WITH customer_sales AS (
    SELECT
        customer_id,
        SUM(sales_amount) AS total_sales
    FROM order_items
    GROUP BY customer_id
)
SELECT *
FROM customer_sales;
```

---

# 📈 Power BI Dashboard

Power BI is used as the final visualization and business intelligence layer.

The dashboard provides an interactive view of:

* Overall business performance
* Sales trends
* Profitability
* Customer behavior
* Product performance
* Regional performance
* Payments
* Returns
* Delivery performance

---

## 📊 Dashboard KPIs

The main KPI cards include:

```text
Total Revenue
Total Profit
Profit Margin
Total Orders
Total Customers
Average Order Value
Return Rate
Average Delivery Days
```

---

# 📌 Dashboard Pages

### 1️⃣ Executive Overview

Provides a high-level view of overall business performance.

**Key Metrics:**

* Revenue
* Profit
* Profit Margin
* Orders
* Customers
* Average Order Value

**Visuals:**

* Monthly revenue trend
* Revenue by category
* Profit by category
* Revenue by region
* Order status distribution

---

### 2️⃣ Sales & Profitability

Focuses on sales performance and financial efficiency.

**Analysis:**

* Revenue trends
* Profit trends
* Category performance
* Product performance
* Discount vs. profitability
* Profit margin analysis

---

### 3️⃣ Customer Analytics

Analyzes customer behavior and contribution.

**Analysis:**

* Customer revenue
* Order frequency
* Average order value
* Customer segments
* Top customers
* Customer contribution

Potential segmentation:

```text
High Value Customers
Regular Customers
Occasional Customers
At-Risk Customers
```

---

### 4️⃣ Product Analytics

Identifies products that drive revenue and profitability.

**Analysis:**

* Top products by revenue
* Top products by profit
* Best-selling products
* Product margins
* Product return rates
* Category performance

---

### 5️⃣ Regional Performance

Provides a geographical view of business performance.

**Analysis:**

* Revenue by region
* Profit by region
* Orders by region
* Return rate by region
* Delivery performance by region

---

### 6️⃣ Returns & Delivery

Analyzes operational problems affecting customer experience.

**Analysis:**

* Return rate
* Return reasons
* Returns by category
* Refund amount
* Average delivery days
* Delayed orders
* Delivery delay vs. return behavior

---

### 7️⃣ Payment Analytics

Analyzes payment behavior and transaction performance.

**Analysis:**

* Payment method distribution
* Successful payments
* Failed payments
* Cancelled payments
* Payment amount
* Cancellation rate by payment method

---

# 📐 DAX & KPI Calculations

Power BI uses DAX to create business measures and analytical KPIs.

Examples include:

```text
Total Revenue
Total Profit
Profit Margin %
Total Orders
Total Customers
Average Order Value
Return Rate %
Average Delivery Days
Monthly Revenue
Previous Month Revenue
MoM Growth %
Customer Revenue %
```

### Time Intelligence

Time-based analysis includes:

* Monthly sales
* Monthly profit
* Month-over-month growth
* Year-over-year comparison
* Running totals
* Revenue trends

---

# 🔍 Key Business Insights

The project is designed to identify actionable business insights rather than simply report historical numbers.

Examples of insights that can be generated include:

### 💰 Revenue vs. Profit

High-revenue products may not always be the most profitable products.

This helps identify products where:

```text
High Sales
      +
Low Margin
      ↓
Profitability Risk
```

### 🏷️ Discount Impact

Discounting may increase sales volume while reducing profit margins.

The analysis compares:

```text
Discount %
      ↓
Sales
      ↓
Profit
      ↓
Profit Margin
```

### 🔄 Returns

Certain products or categories may have disproportionately high return rates.

This can help the business investigate:

* Product quality
* Customer expectations
* Product descriptions
* Delivery experience
* Category-specific issues

### 🚚 Delivery Performance

Delayed deliveries can potentially be associated with higher return behavior.

The analysis compares:

```text
Delivery Days
      ↓
Delivery Delay
      ↓
Return Rate
```

### 👥 Customer Value

Customer segmentation helps identify:

* High-value customers
* Frequent customers
* Low-engagement customers
* Potentially at-risk customers

This can support targeted retention strategies.

---

# 🎯 Business Recommendations

Based on the analytical findings, the business can take actions such as:

### 1. Improve Product-Level Profitability

Focus on products that generate strong revenue but weak margins.

### 2. Optimize Discount Strategy

Avoid excessive discounting on products where discounts significantly reduce profitability.

### 3. Improve Customer Retention

Develop targeted retention campaigns for valuable customers showing reduced engagement.

### 4. Reduce Product Returns

Investigate categories and products with unusually high return rates.

### 5. Improve Delivery Operations

Identify regions and order types with frequent delivery delays.

### 6. Optimize Payment Operations

Investigate payment methods with higher failure or cancellation rates.

### 7. Focus on High-Value Customers

Use customer segmentation to develop personalized offers and loyalty strategies.

---

# 🔄 End-to-End Project Workflow

```text
                 RAW E-COMMERCE DATA
                         │
                         ▼
                    PYTHON
              Data Generation / Prep
                         │
                         ▼
                     EXCEL
            Cleaning + Validation + EDA
                         │
                         ▼
                     MySQL
               Database & Data Model
                         │
                         ▼
                  SQL ANALYSIS
          Business Questions & Insights
                         │
                         ▼
                   POWER BI
              Data Modeling + DAX
                         │
                         ▼
               INTERACTIVE DASHBOARD
                         │
                         ▼
                BUSINESS INSIGHTS
                         │
                         ▼
              BUSINESS RECOMMENDATIONS
```

---

# 📁 Project Structure

```text
E-Commerce-Business-Intelligence/
│
├── 📂 data/
│   ├── customers.csv
│   ├── products.csv
│   ├── orders.csv
│   ├── order_items.csv
│   ├── payments.csv
│   └── returns.csv
│
├── 📂 python/
│   └── data_generation.py
│
├── 📂 excel/
│   └── ecommerce_analysis.xlsx
│
├── 📂 sql/
│   ├── database_schema.sql
│   ├── data_loading.sql
│   └── business_analysis.sql
│
├── 📂 powerbi/
│   └── ecommerce_business_intelligence.pbix
│
├── 📂 dashboard/
│   └── dashboard_preview.png
│
├── 📄 README.md
└── 📄 LICENSE
```

---

# 🚀 Project Outcomes

This project demonstrates practical experience in:

* Data cleaning
* Data validation
* Exploratory Data Analysis
* Excel analytics
* Relational database design
* SQL querying
* Advanced SQL
* Data modeling
* DAX
* Power BI dashboard development
* Customer analytics
* Product analytics
* Sales analytics
* Profitability analysis
* Business intelligence
* Data-driven decision making

---

# 💡 Skills Demonstrated

### Technical Skills

```text
Python
Excel
MySQL
SQL
Power BI
DAX
Data Cleaning
Data Modeling
Data Visualization
Exploratory Data Analysis
```

### Analytical Skills

```text
Business Analysis
Customer Analytics
Sales Analysis
Profitability Analysis
Product Analysis
Regional Analysis
Payment Analysis
Return Analysis
Delivery Analysis
Customer Segmentation
KPI Development
Trend Analysis
```

### Business Skills

```text
Problem Solving
Business Question Formulation
Insight Generation
Data-Driven Decision Making
Performance Monitoring
Strategic Recommendations
```

---

# 📊 Final Deliverable

The final deliverable is an interactive **Power BI Business Intelligence Dashboard** that allows stakeholders to explore:

```text
Sales
   +
Customers
   +
Products
   +
Profitability
   +
Regions
   +
Payments
   +
Returns
   +
Delivery
   ↓
Business Intelligence
```

The dashboard transforms transactional data into actionable insights that can support better **sales, marketing, customer retention, pricing, operations and profitability decisions**.

---

# 👩‍💻 Author

**Jagriti Yadav**

Aspiring Data Analyst | Business Intelligence | SQL | Excel | Power BI | Python

---

⭐ **If you find this project useful, consider giving the repository a star!**
