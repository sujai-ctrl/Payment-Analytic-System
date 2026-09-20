-- ============================================================
-- PAYMENT ANALYTIC SYSTEM
-- 04_queries.sql
-- ============================================================

USE payment_analytic_system;

-- 1. Display all successful payments
SELECT *
FROM payments
WHERE payment_status = 'SUCCESS';

-- 2. Display invoices with customer names
SELECT
    i.invoice_number,
    c.customer_name,
    i.invoice_date,
    i.total_amount,
    i.invoice_status
FROM invoices i
LEFT JOIN customers c ON i.customer_id = c.customer_id
ORDER BY i.invoice_date DESC;

-- 3. Payment method summary
SELECT
    payment_method,
    COUNT(*) AS transactions,
    SUM(amount) AS amount_collected
FROM payments
WHERE payment_status = 'SUCCESS'
GROUP BY payment_method
ORDER BY amount_collected DESC;

-- 4. Shop-wise sales
SELECT
    s.shop_name,
    COUNT(i.invoice_id) AS invoice_count,
    SUM(i.total_amount) AS sales
FROM shops s
LEFT JOIN invoices i ON s.shop_id = i.shop_id
GROUP BY s.shop_id, s.shop_name
ORDER BY sales DESC;

-- 5. Customers with purchases above 10,000
SELECT
    c.customer_name,
    SUM(i.total_amount) AS total_purchase
FROM customers c
JOIN invoices i ON c.customer_id = i.customer_id
WHERE i.invoice_status <> 'CANCELLED'
GROUP BY c.customer_id, c.customer_name
HAVING SUM(i.total_amount) > 10000
ORDER BY total_purchase DESC;

-- 6. Highest-value invoices
SELECT
    invoice_number,
    total_amount
FROM invoices
ORDER BY total_amount DESC
LIMIT 5;

-- 7. Products below reorder level
SELECT
    p.product_name,
    s.shop_name,
    p.stock_quantity,
    p.reorder_level
FROM products p
JOIN shops s ON p.shop_id = s.shop_id
WHERE p.stock_quantity <= p.reorder_level
ORDER BY p.stock_quantity;

-- 8. Failed transactions
SELECT
    transaction_reference,
    invoice_id,
    amount,
    payment_date,
    gateway_name
FROM payments
WHERE payment_status = 'FAILED';

-- 9. Partial payments
SELECT
    i.invoice_number,
    i.total_amount,
    SUM(CASE WHEN p.payment_status = 'SUCCESS' THEN p.amount ELSE 0 END) AS paid_amount,
    i.total_amount -
        SUM(CASE WHEN p.payment_status = 'SUCCESS' THEN p.amount ELSE 0 END) AS balance
FROM invoices i
LEFT JOIN payments p ON i.invoice_id = p.invoice_id
GROUP BY i.invoice_id, i.invoice_number, i.total_amount
HAVING balance > 0;

-- 10. Refund summary
SELECT
    COUNT(*) AS refund_count,
    SUM(refund_amount) AS total_refunded
FROM refunds
WHERE refund_status = 'PROCESSED';
