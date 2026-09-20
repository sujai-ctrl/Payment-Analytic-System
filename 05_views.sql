-- ============================================================
-- PAYMENT ANALYTIC SYSTEM
-- 05_views.sql
-- ============================================================

USE payment_analytic_system;

DROP VIEW IF EXISTS vw_payment_summary;
CREATE VIEW vw_payment_summary AS
SELECT
    p.payment_id,
    p.transaction_reference,
    i.invoice_number,
    s.shop_name,
    c.customer_name,
    p.payment_date,
    p.amount,
    p.payment_method,
    p.payment_status
FROM payments p
JOIN invoices i ON p.invoice_id = i.invoice_id
JOIN shops s ON i.shop_id = s.shop_id
LEFT JOIN customers c ON i.customer_id = c.customer_id;

DROP VIEW IF EXISTS vw_shop_revenue;
CREATE VIEW vw_shop_revenue AS
SELECT
    s.shop_id,
    s.shop_name,
    m.mall_name,
    COUNT(DISTINCT i.invoice_id) AS invoice_count,
    COALESCE(SUM(
        CASE WHEN p.payment_status = 'SUCCESS' THEN p.amount ELSE 0 END
    ), 0) AS collected_revenue
FROM shops s
JOIN malls m ON s.mall_id = m.mall_id
LEFT JOIN invoices i ON s.shop_id = i.shop_id
LEFT JOIN payments p ON i.invoice_id = p.invoice_id
GROUP BY s.shop_id, s.shop_name, m.mall_name;

DROP VIEW IF EXISTS vw_customer_spending;
CREATE VIEW vw_customer_spending AS
SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(DISTINCT i.invoice_id) AS invoice_count,
    COALESCE(SUM(
        CASE WHEN p.payment_status = 'SUCCESS' THEN p.amount ELSE 0 END
    ), 0) AS total_spending
FROM customers c
LEFT JOIN invoices i ON c.customer_id = i.customer_id
LEFT JOIN payments p ON i.invoice_id = p.invoice_id
GROUP BY c.customer_id, c.customer_name, c.city;

DROP VIEW IF EXISTS vw_daily_revenue;
CREATE VIEW vw_daily_revenue AS
SELECT
    DATE(payment_date) AS payment_day,
    COUNT(*) AS successful_transactions,
    SUM(amount) AS daily_revenue
FROM payments
WHERE payment_status = 'SUCCESS'
GROUP BY DATE(payment_date);
