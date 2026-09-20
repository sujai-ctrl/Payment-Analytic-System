# Payment Analytic System

A professional MySQL database project for managing mall shops, products,
customers, invoices, payment transactions, refunds, inventory and analytics.

## Technology
- MySQL 8.0+
- SQL
- MySQL Workbench

## Modules
- Mall Management
- Shop Management
- Product & Inventory Management
- Customer Management
- Employee Management
- Invoice Management
- Payment Management
- Refund Management
- Business Analytics

## Database execution order

Run the files in this order:

1. `01_database.sql`
2. `02_tables.sql`
3. `03_sample_data.sql`
4. `04_queries.sql`
5. `05_views.sql`
6. `06_procedures.sql`
7. `07_triggers.sql`
8. `08_reports.sql`

## Main SQL concepts demonstrated

- Primary Keys
- Foreign Keys
- Constraints
- ENUM
- Generated Columns
- Indexes
- INNER JOIN / LEFT JOIN
- GROUP BY / HAVING
- Aggregate Functions
- CASE expressions
- Subqueries
- Views
- Stored Procedures
- Triggers
- Window Functions
- Business Reports

## Example procedure

```sql
CALL sp_payment_summary('2026-09-01', '2026-09-30');
```

## Example views

```sql
SELECT * FROM vw_payment_summary;
SELECT * FROM vw_shop_revenue;
SELECT * FROM vw_customer_spending;
SELECT * FROM vw_daily_revenue;
```

## Project title for resume

**Payment Analytic System – MySQL**

## Resume description

Designed and implemented a relational payment analytics system using MySQL
to manage mall shops, products, customers, invoices, payment transactions,
refunds and inventory. Developed complex SQL queries, views, stored
procedures, triggers and analytical reports for revenue, payment method,
customer, shop and transaction analysis.
