-- ============================================================
-- PAYMENT ANALYTIC SYSTEM
-- 08_reports.sql
-- Professional Analytics & Management Reports
-- ============================================================

USE payment_analytic_system;

-- ============================================================
-- 1. EXECUTIVE DASHBOARD
-- ============================================================

SELECT
    COUNT(DISTINCT CASE WHEN p.payment_status = 'SUCCESS'
                        THEN p.payment_id END) AS successful_transactions,
    COALESCE(SUM(CASE WHEN p.payment_status = 'SUCCESS'
                      THEN p.amount ELSE 0 END), 0) AS gross_collected,
    COALESCE(SUM(CASE WHEN r.refund_status = 'PROCESSED'
                      THEN r.refund_amount ELSE 0 END), 0) AS refunds
FROM payments p
LEFT JOIN refunds r ON p.payment_id = r.payment_id;


-- ============================================================
-- 2. NET REVENUE AFTER REFUNDS
-- ============================================================

SELECT
    COALESCE(SUM(
        CASE WHEN p.payment_status = 'SUCCESS' THEN p.amount ELSE 0 END
    ), 0) -
    COALESCE(SUM(
        CASE WHEN r.refund_status = 'PROCESSED' THEN r.refund_amount ELSE 0 END
    ), 0) AS net_revenue
FROM payments p
LEFT JOIN refunds r ON p.payment_id = r.payment_id;


-- ============================================================
-- 3. PAYMENT METHOD PERFORMANCE
-- ============================================================

SELECT
    payment_method,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_amount,
    ROUND(AVG(amount), 2) AS average_transaction
FROM payments
WHERE payment_status = 'SUCCESS'
GROUP BY payment_method
ORDER BY total_amount DESC;


-- ============================================================
-- 4. DAILY REVENUE
-- ============================================================

SELECT
    DATE(payment_date) AS payment_date,
    COUNT(*) AS successful_transactions,
    ROUND(SUM(amount), 2) AS daily_revenue
FROM payments
WHERE payment_status = 'SUCCESS'
GROUP BY DATE(payment_date)
ORDER BY payment_date;


-- ============================================================
-- 5. SHOP-WISE REVENUE
-- ============================================================

SELECT
    m.mall_name,
    s.shop_name,
    COUNT(DISTINCT i.invoice_id) AS invoice_count,
    ROUND(SUM(
        CASE WHEN p.payment_status = 'SUCCESS'
             THEN p.amount ELSE 0 END
    ), 2) AS revenue
FROM malls m
JOIN shops s ON m.mall_id = s.mall_id
LEFT JOIN invoices i ON s.shop_id = i.shop_id
LEFT JOIN payments p ON i.invoice_id = p.invoice_id
GROUP BY m.mall_id, m.mall_name, s.shop_id, s.shop_name
ORDER BY revenue DESC;


-- ============================================================
-- 6. CUSTOMER SPENDING REPORT
-- ============================================================

SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(DISTINCT i.invoice_id) AS purchase_count,
    ROUND(SUM(
        CASE WHEN p.payment_status = 'SUCCESS'
             THEN p.amount ELSE 0 END
    ), 2) AS total_spending
FROM customers c
JOIN invoices i ON c.customer_id = i.customer_id
LEFT JOIN payments p ON i.invoice_id = p.invoice_id
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_spending DESC;


-- ============================================================
-- 7. PAYMENT STATUS REPORT
-- ============================================================

SELECT
    payment_status,
    COUNT(*) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_amount
FROM payments
GROUP BY payment_status
ORDER BY transaction_count DESC;


-- ============================================================
-- 8. PAYMENT SUCCESS RATE
-- ============================================================

SELECT
    COUNT(*) AS total_transactions,
    SUM(payment_status = 'SUCCESS') AS successful_transactions,
    SUM(payment_status = 'FAILED') AS failed_transactions,
    ROUND(
        100 * SUM(payment_status = 'SUCCESS') / COUNT(*),
        2
    ) AS success_rate_percentage
FROM payments;


-- ============================================================
-- 9. TOP 5 HIGH-VALUE TRANSACTIONS
-- ============================================================

SELECT
    p.transaction_reference,
    i.invoice_number,
    s.shop_name,
    p.amount,
    p.payment_method,
    p.payment_date
FROM payments p
JOIN invoices i ON p.invoice_id = i.invoice_id
JOIN shops s ON i.shop_id = s.shop_id
WHERE p.payment_status = 'SUCCESS'
ORDER BY p.amount DESC
LIMIT 5;


-- ============================================================
-- 10. REFUND ANALYSIS
-- ============================================================

SELECT
    r.refund_status,
    COUNT(*) AS refund_count,
    ROUND(SUM(r.refund_amount), 2) AS refund_amount
FROM refunds r
GROUP BY r.refund_status;


-- ============================================================
-- 11. MONTHLY REVENUE
-- ============================================================

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS revenue_month,
    COUNT(*) AS transactions,
    ROUND(SUM(amount), 2) AS monthly_revenue
FROM payments
WHERE payment_status = 'SUCCESS'
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY revenue_month;


-- ============================================================
-- 12. PRODUCT SALES REPORT
-- ============================================================

SELECT
    p.product_name,
    s.shop_name,
    SUM(ii.quantity) AS units_sold,
    ROUND(SUM(ii.line_total), 2) AS sales_value
FROM invoice_items ii
JOIN products p ON ii.product_id = p.product_id
JOIN shops s ON p.shop_id = s.shop_id
JOIN invoices i ON ii.invoice_id = i.invoice_id
WHERE i.invoice_status <> 'CANCELLED'
GROUP BY p.product_id, p.product_name, s.shop_name
ORDER BY units_sold DESC;


-- ============================================================
-- 13. LOW STOCK REPORT
-- ============================================================

SELECT
    p.sku,
    p.product_name,
    s.shop_name,
    p.stock_quantity,
    p.reorder_level,
    CASE
        WHEN p.stock_quantity = 0 THEN 'OUT OF STOCK'
        WHEN p.stock_quantity <= p.reorder_level THEN 'REORDER'
        ELSE 'AVAILABLE'
    END AS stock_status
FROM products p
JOIN shops s ON p.shop_id = s.shop_id
WHERE p.stock_quantity <= p.reorder_level
ORDER BY p.stock_quantity;


-- ============================================================
-- 14. SHOP RANKING BY REVENUE
-- ============================================================

SELECT
    s.shop_name,
    ROUND(SUM(
        CASE WHEN p.payment_status = 'SUCCESS'
             THEN p.amount ELSE 0 END
    ), 2) AS revenue,
    DENSE_RANK() OVER (
        ORDER BY SUM(
            CASE WHEN p.payment_status = 'SUCCESS'
                 THEN p.amount ELSE 0 END
        ) DESC
    ) AS revenue_position
FROM shops s
LEFT JOIN invoices i ON s.shop_id = i.shop_id
LEFT JOIN payments p ON i.invoice_id = p.invoice_id
GROUP BY s.shop_id, s.shop_name
ORDER BY revenue_position;


-- ============================================================
-- 15. CUSTOMER SEGMENTATION
-- ============================================================

SELECT
    c.customer_name,
    COALESCE(SUM(
        CASE WHEN p.payment_status = 'SUCCESS'
             THEN p.amount ELSE 0 END
    ), 0) AS total_spending,
    CASE
        WHEN COALESCE(SUM(
            CASE WHEN p.payment_status = 'SUCCESS'
                 THEN p.amount ELSE 0 END
        ), 0) >= 50000 THEN 'HIGH VALUE'
        WHEN COALESCE(SUM(
            CASE WHEN p.payment_status = 'SUCCESS'
                 THEN p.amount ELSE 0 END
        ), 0) >= 10000 THEN 'REGULAR'
        ELSE 'OCCASIONAL'
    END AS customer_segment
FROM customers c
LEFT JOIN invoices i ON c.customer_id = i.customer_id
LEFT JOIN payments p ON i.invoice_id = p.invoice_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC;


-- ============================================================
-- 16. FAILED PAYMENT GATEWAY ANALYSIS
-- ============================================================

SELECT
    COALESCE(gateway_name, 'CASH / OFFLINE') AS gateway,
    COUNT(*) AS failed_transactions,
    ROUND(SUM(amount), 2) AS failed_amount
FROM payments
WHERE payment_status = 'FAILED'
GROUP BY gateway_name
ORDER BY failed_transactions DESC;


-- ============================================================
-- 17. AVERAGE BILL VALUE BY SHOP
-- ============================================================

SELECT
    s.shop_name,
    COUNT(i.invoice_id) AS invoices,
    ROUND(AVG(i.total_amount), 2) AS average_bill_value
FROM shops s
JOIN invoices i ON s.shop_id = i.shop_id
GROUP BY s.shop_id, s.shop_name
ORDER BY average_bill_value DESC;


-- ============================================================
-- 18. PAYMENT COLLECTION BY MALL
-- ============================================================

SELECT
    m.mall_name,
    COUNT(DISTINCT i.invoice_id) AS invoices,
    ROUND(SUM(
        CASE WHEN p.payment_status = 'SUCCESS'
             THEN p.amount ELSE 0 END
    ), 2) AS collected_amount
FROM malls m
JOIN shops s ON m.mall_id = s.mall_id
LEFT JOIN invoices i ON s.shop_id = i.shop_id
LEFT JOIN payments p ON i.invoice_id = p.invoice_id
GROUP BY m.mall_id, m.mall_name
ORDER BY collected_amount DESC;


-- ============================================================
-- 19. CUSTOMER PURCHASE HISTORY
-- ============================================================

SELECT
    c.customer_name,
    i.invoice_number,
    i.invoice_date,
    s.shop_name,
    i.total_amount,
    i.invoice_status
FROM customers c
JOIN invoices i ON c.customer_id = i.customer_id
JOIN shops s ON i.shop_id = s.shop_id
ORDER BY c.customer_name, i.invoice_date DESC;


-- ============================================================
-- 20. COMPLETE TRANSACTION REPORT
-- ============================================================

SELECT
    p.transaction_reference,
    p.payment_date,
    m.mall_name,
    s.shop_name,
    i.invoice_number,
    c.customer_name,
    p.amount,
    p.payment_method,
    p.payment_status,
    p.gateway_name
FROM payments p
JOIN invoices i ON p.invoice_id = i.invoice_id
JOIN shops s ON i.shop_id = s.shop_id
JOIN malls m ON s.mall_id = m.mall_id
LEFT JOIN customers c ON i.customer_id = c.customer_id
ORDER BY p.payment_date DESC;
