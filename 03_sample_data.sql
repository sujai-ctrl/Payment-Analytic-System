-- ============================================================
-- PAYMENT ANALYTIC SYSTEM
-- 03_sample_data.sql
-- ============================================================

USE payment_analytic_system;

INSERT INTO malls (mall_name, city, state, address, contact_number) VALUES
('Grand Square Mall', 'Chennai', 'Tamil Nadu', 'Anna Nagar, Chennai', '04440001001'),
('City Central Mall', 'Coimbatore', 'Tamil Nadu', 'Avinashi Road, Coimbatore', '04224000101');

INSERT INTO shops (mall_id, shop_name, floor_number, shop_category, contact_number) VALUES
(1, 'TechWorld', '1', 'Electronics', '9876500001'),
(1, 'Fashion Hub', '2', 'Fashion', '9876500002'),
(1, 'HomeStyle', '2', 'Home & Living', '9876500003'),
(1, 'SportZone', '3', 'Sports', '9876500004'),
(2, 'Smart Devices', '1', 'Electronics', '9876500005'),
(2, 'Urban Wear', '2', 'Fashion', '9876500006');

INSERT INTO categories (category_name, description) VALUES
('Mobiles', 'Smartphones and mobile accessories'),
('Laptops', 'Laptops and computing devices'),
('Fashion', 'Clothing and fashion products'),
('Home Appliances', 'Appliances for home use'),
('Sports', 'Sports and fitness products'),
('Accessories', 'Electronic and lifestyle accessories');

INSERT INTO products
(shop_id, category_id, product_name, sku, unit_price, stock_quantity, reorder_level) VALUES
(1, 1, 'Samsung Galaxy A55', 'MOB001', 32999.00, 25, 5),
(1, 1, 'OnePlus Nord CE', 'MOB002', 24999.00, 30, 5),
(1, 2, 'HP Pavilion 15', 'LAP001', 64999.00, 15, 3),
(1, 6, 'Wireless Earbuds', 'ACC001', 2999.00, 80, 15),
(2, 3, 'Men Formal Shirt', 'FAS001', 1599.00, 100, 20),
(2, 3, 'Women Casual Dress', 'FAS002', 2299.00, 75, 15),
(2, 3, 'Denim Jeans', 'FAS003', 1999.00, 60, 10),
(3, 4, 'Air Fryer 4L', 'HOM001', 5999.00, 25, 5),
(3, 4, 'Mixer Grinder', 'HOM002', 3499.00, 40, 8),
(4, 5, 'Running Shoes', 'SPO001', 3999.00, 50, 10),
(4, 5, 'Cricket Bat', 'SPO002', 2999.00, 30, 5),
(5, 1, 'iPhone 15', 'MOB003', 69999.00, 20, 4),
(5, 6, 'Power Bank 20000mAh', 'ACC002', 1999.00, 60, 10),
(6, 3, 'Hoodie', 'FAS004', 1799.00, 90, 15);

INSERT INTO customers (customer_name, email, phone, city) VALUES
('Arun Kumar', 'arun@example.com', '9000000001', 'Chennai'),
('Priya Sharma', 'priya@example.com', '9000000002', 'Chennai'),
('Karthik Raj', 'karthik@example.com', '9000000003', 'Chennai'),
('Divya S', 'divya@example.com', '9000000004', 'Chennai'),
('Rahul M', 'rahul@example.com', '9000000005', 'Coimbatore'),
('Anitha R', 'anitha@example.com', '9000000006', 'Coimbatore'),
('Vijay Kumar', 'vijay@example.com', '9000000007', 'Coimbatore'),
('Meena P', 'meena@example.com', '9000000008', 'Chennai');

INSERT INTO employees
(shop_id, employee_name, designation, email, phone, joining_date, salary) VALUES
(1, 'Suresh B', 'Store Manager', 'suresh@techworld.com', '9100000001', '2024-01-10', 45000),
(1, 'Naveen K', 'Sales Executive', 'naveen@techworld.com', '9100000002', '2024-06-15', 28000),
(2, 'Harini P', 'Store Manager', 'harini@fashionhub.com', '9100000003', '2023-08-20', 42000),
(2, 'Monisha R', 'Sales Executive', 'monisha@fashionhub.com', '9100000004', '2025-01-12', 26000),
(3, 'Prakash V', 'Store Manager', 'prakash@homestyle.com', '9100000005', '2024-03-01', 40000),
(4, 'Dinesh S', 'Store Manager', 'dinesh@sportzone.com', '9100000006', '2024-05-05', 39000),
(5, 'Lokesh M', 'Store Manager', 'lokesh@smartdevices.com', '9100000007', '2023-11-11', 46000),
(6, 'Keerthana J', 'Store Manager', 'keerthana@urbanwear.com', '9100000008', '2025-02-10', 41000);

INSERT INTO invoices
(invoice_number, shop_id, customer_id, employee_id, invoice_date,
 subtotal, discount_amount, tax_amount, total_amount, invoice_status) VALUES
('INV-2026-0001', 1, 1, 2, '2026-09-01 10:15:00', 35998, 999, 6299.82, 41298.82, 'PAID'),
('INV-2026-0002', 2, 2, 4, '2026-09-02 12:20:00', 3897, 197, 370.00, 4070.00, 'PAID'),
('INV-2026-0003', 3, 3, 5, '2026-09-03 14:05:00', 9498, 498, 1620.00, 10620.00, 'PAID'),
('INV-2026-0004', 4, 4, 6, '2026-09-04 17:40:00', 6998, 498, 1170.00, 7670.00, 'PAID'),
('INV-2026-0005', 5, 5, 7, '2026-09-05 18:10:00', 71998, 1999, 12600.00, 82599.00, 'PAID'),
('INV-2026-0006', 6, 6, 8, '2026-09-06 19:25:00', 5397, 397, 900.00, 5900.00, 'PAID'),
('INV-2026-0007', 1, 7, 1, '2026-09-07 11:30:00', 67998, 2999, 11700.00, 76699.00, 'PAID'),
('INV-2026-0008', 2, 8, 3, '2026-09-08 16:45:00', 4598, 298, 774.00, 5074.00, 'PAID'),
('INV-2026-0009', 5, 1, 7, '2026-09-09 13:20:00', 1999, 0, 360.00, 2359.00, 'PARTIALLY_PAID'),
('INV-2026-0010', 3, 2, 5, '2026-09-10 15:15:00', 3499, 0, 630.00, 4129.00, 'PAID');

INSERT INTO invoice_items
(invoice_id, product_id, quantity, unit_price, discount_amount) VALUES
(1, 1, 1, 32999, 999),
(1, 4, 1, 2999, 0),
(2, 5, 1, 1599, 0),
(2, 6, 1, 2299, 197),
(3, 8, 1, 5999, 0),
(3, 9, 1, 3499, 498),
(4, 10, 1, 3999, 0),
(4, 11, 1, 2999, 498),
(5, 12, 1, 69999, 1999),
(5, 13, 1, 1999, 0),
(6, 14, 3, 1799, 397),
(7, 3, 1, 64999, 2999),
(7, 4, 1, 2999, 0),
(8, 7, 2, 1999, 298),
(8, 5, 1, 1599, 0),
(9, 13, 1, 1999, 0),
(10, 9, 1, 3499, 0);

INSERT INTO payments
(invoice_id, transaction_reference, payment_date, amount, payment_method, payment_status, gateway_name, remarks) VALUES
(1, 'TXN-100001', '2026-09-01 10:20:00', 41298.82, 'UPI', 'SUCCESS', 'Razorpay', 'Paid in full'),
(2, 'TXN-100002', '2026-09-02 12:25:00', 4070.00, 'CREDIT_CARD', 'SUCCESS', 'HDFC Bank', 'Paid in full'),
(3, 'TXN-100003', '2026-09-03 14:10:00', 10620.00, 'DEBIT_CARD', 'SUCCESS', 'SBI Bank', 'Paid in full'),
(4, 'TXN-100004', '2026-09-04 17:45:00', 7670.00, 'CASH', 'SUCCESS', NULL, 'Counter payment'),
(5, 'TXN-100005', '2026-09-05 18:15:00', 82599.00, 'UPI', 'SUCCESS', 'PhonePe', 'Paid in full'),
(6, 'TXN-100006', '2026-09-06 19:30:00', 5900.00, 'WALLET', 'SUCCESS', 'Paytm', 'Paid in full'),
(7, 'TXN-100007', '2026-09-07 11:35:00', 76699.00, 'NET_BANKING', 'SUCCESS', 'ICICI Bank', 'Paid in full'),
(8, 'TXN-100008', '2026-09-08 16:50:00', 5074.00, 'UPI', 'SUCCESS', 'Google Pay', 'Paid in full'),
(9, 'TXN-100009', '2026-09-09 13:25:00', 1000.00, 'UPI', 'SUCCESS', 'Razorpay', 'Partial payment'),
(9, 'TXN-100010', '2026-09-09 14:05:00', 500.00, 'CREDIT_CARD', 'PENDING', 'HDFC Bank', 'Pending confirmation'),
(10, 'TXN-100011', '2026-09-10 15:20:00', 4129.00, 'DEBIT_CARD', 'SUCCESS', 'SBI Bank', 'Paid in full'),
(2, 'TXN-100012', '2026-09-02 12:21:00', 200.00, 'UPI', 'FAILED', 'Razorpay', 'Bank declined');

INSERT INTO refunds
(payment_id, refund_reference, refund_date, refund_amount, refund_reason, refund_status) VALUES
(5, 'REF-500001', '2026-09-07 10:00:00', 1999.00, 'Product returned', 'PROCESSED'),
(8, 'REF-500002', '2026-09-09 11:30:00', 500.00, 'Customer cancellation', 'PROCESSED');
