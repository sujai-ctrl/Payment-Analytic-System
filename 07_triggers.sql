-- ============================================================
-- PAYMENT ANALYTIC SYSTEM
-- 07_triggers.sql
-- ============================================================

USE payment_analytic_system;

DROP TRIGGER IF EXISTS trg_invoice_item_after_insert;
DROP TRIGGER IF EXISTS trg_invoice_item_after_update;
DROP TRIGGER IF EXISTS trg_invoice_item_after_delete;
DROP TRIGGER IF EXISTS trg_payment_after_insert;

DELIMITER $$

CREATE TRIGGER trg_invoice_item_after_insert
AFTER INSERT ON invoice_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;

    UPDATE invoices i
    SET
        subtotal = (
            SELECT COALESCE(SUM(line_total), 0)
            FROM invoice_items
            WHERE invoice_id = NEW.invoice_id
        ),
        total_amount = (
            SELECT COALESCE(SUM(line_total), 0)
            FROM invoice_items
            WHERE invoice_id = NEW.invoice_id
        ) - i.discount_amount + i.tax_amount
    WHERE invoice_id = NEW.invoice_id;
END$$

CREATE TRIGGER trg_invoice_item_after_update
AFTER UPDATE ON invoice_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity + OLD.quantity - NEW.quantity
    WHERE product_id = NEW.product_id;

    UPDATE invoices i
    SET
        subtotal = (
            SELECT COALESCE(SUM(line_total), 0)
            FROM invoice_items
            WHERE invoice_id = NEW.invoice_id
        ),
        total_amount = (
            SELECT COALESCE(SUM(line_total), 0)
            FROM invoice_items
            WHERE invoice_id = NEW.invoice_id
        ) - i.discount_amount + i.tax_amount
    WHERE invoice_id = NEW.invoice_id;
END$$

CREATE TRIGGER trg_invoice_item_after_delete
AFTER DELETE ON invoice_items
FOR EACH ROW
BEGIN
    UPDATE products
    SET stock_quantity = stock_quantity + OLD.quantity
    WHERE product_id = OLD.product_id;

    UPDATE invoices i
    SET
        subtotal = (
            SELECT COALESCE(SUM(line_total), 0)
            FROM invoice_items
            WHERE invoice_id = OLD.invoice_id
        ),
        total_amount = (
            SELECT COALESCE(SUM(line_total), 0)
            FROM invoice_items
            WHERE invoice_id = OLD.invoice_id
        ) - i.discount_amount + i.tax_amount
    WHERE invoice_id = OLD.invoice_id;
END$$

CREATE TRIGGER trg_payment_after_insert
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
    UPDATE invoices i
    SET invoice_status =
        CASE
            WHEN (
                SELECT COALESCE(SUM(
                    CASE WHEN payment_status = 'SUCCESS'
                         THEN amount ELSE 0 END
                ), 0)
                FROM payments
                WHERE invoice_id = NEW.invoice_id
            ) >= i.total_amount
            THEN 'PAID'

            WHEN (
                SELECT COALESCE(SUM(
                    CASE WHEN payment_status = 'SUCCESS'
                         THEN amount ELSE 0 END
                ), 0)
                FROM payments
                WHERE invoice_id = NEW.invoice_id
            ) > 0
            THEN 'PARTIALLY_PAID'

            ELSE 'OPEN'
        END
    WHERE invoice_id = NEW.invoice_id;
END$$

DELIMITER ;
