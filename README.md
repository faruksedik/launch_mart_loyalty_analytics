# LaunchMart Loyalty Analytics

## Project Overview
LaunchMart is a growing African e-commerce company that recently launched a loyalty program to improve customer retention. 
This project analyzes customer behavior, revenue performance, and loyalty engagement using PostgreSQL.

---

## Setup Instructions

### Step 1: Connect to PostgreSQL
Open your terminal or command prompt and connect to your PostgreSQL server:
```bash
psql -U your_username -d postgres
```
your_username can be anyone you decide to use, in my own case I used `postgres`.

Enter your password when prompted.

### Step 2: Create a New Database
```sql
CREATE DATABASE launch_mart_loyalty_analytics_db;
```

### Step 3: Verify Database Creation
List all databases to confirm the new one exists:
```sql
\l
```

### Step 4: Exit psql
```sql
\q
```

### Step 5: Run SQL `01_schema.sql` and `02_seed_data.sql` Scripts to create and the database populate tables respectively
From your terminal, run:
```bash
psql -U postgres -d launch_mart_loyalty_analytics_db -f C:/Users/USER/Documents/de-launchpad/launch_mart_loyalty_analytics/01_schema.sql
psql -U postgres -d launch_mart_loyalty_analytics_db -f C:/Users/USER/Documents/de-launchpad/launch_mart_loyalty_analytics/02_seed_data.sql
```

> Note: You’ll be prompted to enter your PostgreSQL password each time you run a script.

---

## SQL Analysis & Results

Below are the key analytical SQL results.

### 1. Total Customers Joined in 2023
| customers_joined_2023 |
|------------------------|
| 15 |

---

### 2. Total Revenue per Customer
| customer_id | full_name | total_revenue |
|--------------|------------|---------------|
| 8 | Hannah Kim | 59000 |
| 10 | Jessica White | 55000 |
| 15 | Olivia Brown | 35000 |
| 2 | Brian Smith | 26500 |
| 4 | David Lee | 23000 |
| 12 | Leo Fernandez | 22000 |
| 6 | Fatima Bello | 18000 |
| 1 | Alice Johnson | 16500 |
| 13 | Mariam Yusuf | 16000 |
| 9 | Ibrahim Musa | 12000 |
| 3 | Chinwe Okafor | 10500 |
| 5 | Emeka Nwosu | 7000 |
| 11 | Kemi Adebayo | 6000 |
| 14 | Nathan Okeke | 5000 |
| 7 | George Adewale | 1500 |

---

### 3. Top 5 Customers by Total Revenue
| customer_id | full_name | total_revenue | spend_rank |
|--------------|------------|---------------|-------------|
| 8 | Hannah Kim | 59000 | 1 |
| 10 | Jessica White | 55000 | 2 |
| 15 | Olivia Brown | 35000 | 3 |
| 2 | Brian Smith | 26500 | 4 |
| 4 | David Lee | 23000 | 5 |

---

### 4. Monthly Revenue for 2023
| year | month | monthly_revenue |
|------|--------|----------------|
| 2023 | 1 | 16500 |
| 2023 | 2 | 26500 |
| 2023 | 3 | 33500 |
| 2023 | 4 | 7000 |
| 2023 | 5 | 18000 |
| 2023 | 6 | 1500 |
| 2023 | 7 | 59000 |
| 2023 | 8 | 12000 |
| 2023 | 9 | 55000 |
| 2023 | 10 | 6000 |
| 2023 | 11 | 38000 |
| 2023 | 12 | 40000 |

---

### 5. Customers with No Orders in Last 60 Days (as of 2023-12-31)
| customer_id | full_name | last_order_date |
|--------------|------------|-----------------|
| 1 | Alice Johnson | 2023-01-20 |
| 2 | Brian Smith | 2023-02-25 |
| 3 | Chinwe Okafor | 2023-03-10 |
| 4 | David Lee | 2023-03-22 |
| 5 | Emeka Nwosu | 2023-04-15 |
| 6 | Fatima Bello | 2023-05-30 |
| 7 | George Adewale | 2023-06-10 |
| 8 | Hannah Kim | 2023-07-20 |
| 9 | Ibrahim Musa | 2023-08-25 |
| 10 | Jessica White | 2023-09-05 |
| 11 | Kemi Adebayo | 2023-10-12 |

---

### 6. Average Order Value (AOV) per Customer
| customer_id | full_name | aov |
|--------------|------------|------|
| 8 | Hannah Kim | 59000.00 |
| 10 | Jessica White | 55000.00 |
| 15 | Olivia Brown | 35000.00 |
| 2 | Brian Smith | 26500.00 |
| 4 | David Lee | 23000.00 |
| 12 | Leo Fernandez | 22000.00 |
| 6 | Fatima Bello | 18000.00 |
| 1 | Alice Johnson | 16500.00 |
| 13 | Mariam Yusuf | 16000.00 |
| 9 | Ibrahim Musa | 12000.00 |
| 3 | Chinwe Okafor | 10500.00 |
| 5 | Emeka Nwosu | 7000.00 |
| 11 | Kemi Adebayo | 6000.00 |
| 14 | Nathan Okeke | 5000.00 |
| 7 | George Adewale | 1500.00 |

---

### 7. Revenue Rank for Customers with ≥1 Order
| customer_id | full_name | total_revenue | spend_rank |
|--------------|------------|---------------|-------------|
| 8 | Hannah Kim | 59000 | 1 |
| 10 | Jessica White | 55000 | 2 |
| 15 | Olivia Brown | 35000 | 3 |
| 2 | Brian Smith | 26500 | 4 |
| 4 | David Lee | 23000 | 5 |
| 12 | Leo Fernandez | 22000 | 6 |
| 6 | Fatima Bello | 18000 | 7 |
| 1 | Alice Johnson | 16500 | 8 |
| 13 | Mariam Yusuf | 16000 | 9 |
| 9 | Ibrahim Musa | 12000 | 10 |
| 3 | Chinwe Okafor | 10500 | 11 |
| 5 | Emeka Nwosu | 7000 | 12 |
| 11 | Kemi Adebayo | 6000 | 13 |
| 14 | Nathan Okeke | 5000 | 14 |
| 7 | George Adewale | 1500 | 15 |

---

### 8. Customers Who Placed More Than 1 Order
| customer_id | full_name | order_count | first_order_date | last_order_date |
|--------------|------------|-------------|------------------|-----------------|
| *(No customers with more than one order in this dataset)* |

---

### 9. Total Loyalty Points per Customer
| customer_id | full_name | total_points |
|--------------|------------|---------------|
| 10 | Jessica White | 500 |
| 2 | Brian Smith | 300 |
| 15 | Olivia Brown | 250 |
| 12 | Leo Fernandez | 220 |
| 1 | Alice Johnson | 200 |
| 4 | David Lee | 200 |
| 8 | Hannah Kim | 190 |
| 6 | Fatima Bello | 180 |
| 3 | Chinwe Okafor | 120 |
| 9 | Ibrahim Musa | 120 |
| 13 | Mariam Yusuf | 90 |
| 11 | Kemi Adebayo | 70 |
| 5 | Emeka Nwosu | 50 |
| 14 | Nathan Okeke | 30 |
| 7 | George Adewale | 10 |

---

### 10. Loyalty Tiers Summary
| tier | tier_count | tier_total_points |
|-------|-------------|------------------|
| Gold | 1 | 500 |
| Silver | 9 | 1780 |
| Bronze | 5 | 250 |

---

### 11. High Spenders (> ₦50,000) but Low Points (<200)
| customer_id | full_name | total_spent | total_points |
|--------------|------------|--------------|---------------|
| 8 | Hannah Kim | 59000 | 190 |

---

### 12. Churn Risk (No orders in last 90 days + Bronze tier)
| customer_id | full_name | last_order_date | total_spent | total_points |
|--------------|------------|-----------------|--------------|---------------|
| 7 | George Adewale | 2023-06-10 | 1500 | 10 |
| 5 | Emeka Nwosu | 2023-04-15 | 7000 | 50 |

---

## Insights Summary
- **Total Customers (2023):** 15 joined. **{from Table 1}**.  
- **Top Spenders:** Hannah Kim and Jessica White generated the most revenue. **{from Table 7}**.  
- **Monthly Peak:** July and September had the highest revenues (₦59,000 and ₦55,000). **{from Table 4}**.  
- **Churn Risk:** Bronze-tier customers with inactivity are potential re-engagement targets. **{from Table 10}**.  
- **Opportunity:** Encourage high-spending but low-loyalty customers like *Hannah Kim* to redeem or earn more points. **{from Table 11}**.

---

## Author
**Faruk Sedik**  
Data Engineer | DE LaunchPad  
*faruksedik@yahoo.com*  

---

