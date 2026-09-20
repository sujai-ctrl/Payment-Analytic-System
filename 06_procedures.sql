-- ============================================================
-- PAYMENT ANALYTIC SYSTEM
-- 06_procedures.sql
-- ============================================================

USE payment_analytic_system;

DROP PROCEDURE IF EXISTS sp_payment_summary;
DELIMITER $$

CREATE PROCEDURE sp_payment_summary(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT
        COUNT(*) AS successful_transactions,
        COALESCE(SUM(amount), 0) AS total_collected,
        COALESCE(AVG(amount), 0) AS average_transaction
    FROM payments
    WHERE payment_status = 'SUCCESS'
      AND DATE(payment_date) BETWEEN p_start_date AND p_end_date;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_shop_revenue;
DELIMITER $$

CREATE PROCEDURE sp_shop_revenue(IN p_shop_id INT)
BEGIN
    SELECT
        s.shop_name,
        COUNT(DISTINCT i.invoice_id) AS invoices,
        COALESCE(SUM(
            CASE WHEN p.payment_status = 'SUCCESS' THEN p.amount ELSE 0 END
        ), 0) AS total_revenue
    FROM shops s
    LEFT JOIN invoices i ON s.shop_id = i.shop_id
    LEFT JOIN payments p ON i.invoice_id = p.invoice_id
    WHERE s.shop_id = p_shop_id
    GROUP BY s.shop_id, s.shop_name;
END$$

DELIMITER ;

DROP PROCEDURE IF EXISTS sp_customer_purchase_history;
DELIMITER $$

CREATE PROCEDURE sp_customer_purchase_history(IN p_customer_id INT)
BEGIN
    SELECT
        c.customer_name,
        i.invoice_number,
        i.invoice_date,
        i.total_amount,
        i.invoice_status
    FROM customers c
    JOIN invoices i ON c.customer_id = i.customer_id
    WHERE c.customer_id = p_customer_id
    ORDER BY i.invoice_date DESC;
END$$

DELIMITER ;

-- Examples:
-- CALL sp_payment_summary('2026-09-01', '2026-09-30');
-- CALL sp_shop_revenue(1);
-- CALL sp_customer_purchase_history(1);
