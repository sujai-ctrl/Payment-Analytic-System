-- ============================================================
-- PAYMENT ANALYTIC SYSTEM
-- 02_tables.sql
-- ============================================================

USE payment_analytic_system;

CREATE TABLE malls (
    mall_id INT PRIMARY KEY AUTO_INCREMENT,
    mall_name VARCHAR(120) NOT NULL,
    city VARCHAR(80) NOT NULL,
    state VARCHAR(80) NOT NULL,
    address VARCHAR(255),
    contact_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE shops (
    shop_id INT PRIMARY KEY AUTO_INCREMENT,
    mall_id INT NOT NULL,
    shop_name VARCHAR(120) NOT NULL,
    floor_number VARCHAR(20),
    shop_category VARCHAR(80),
    contact_number VARCHAR(20),
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_shops_mall
        FOREIGN KEY (mall_id) REFERENCES malls(mall_id)
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(80) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    shop_id INT NOT NULL,
    category_id INT NOT NULL,
    product_name VARCHAR(150) NOT NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    unit_price DECIMAL(12,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 10,
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_product_price CHECK (unit_price >= 0),
    CONSTRAINT chk_product_stock CHECK (stock_quantity >= 0),
    CONSTRAINT fk_products_shop
        FOREIGN KEY (shop_id) REFERENCES shops(shop_id),
    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(120) NOT NULL,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    city VARCHAR(80),
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    shop_id INT NOT NULL,
    employee_name VARCHAR(120) NOT NULL,
    designation VARCHAR(80),
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20),
    joining_date DATE,
    salary DECIMAL(12,2),
    status ENUM('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
    CONSTRAINT chk_employee_salary CHECK (salary IS NULL OR salary >= 0),
    CONSTRAINT fk_employees_shop
        FOREIGN KEY (shop_id) REFERENCES shops(shop_id)
);

CREATE TABLE invoices (
    invoice_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    invoice_number VARCHAR(40) NOT NULL UNIQUE,
    shop_id INT NOT NULL,
    customer_id INT NULL,
    employee_id INT NULL,
    invoice_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(12,2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    tax_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    invoice_status ENUM('OPEN','PAID','PARTIALLY_PAID','CANCELLED') DEFAULT 'OPEN',
    CONSTRAINT chk_invoice_amounts CHECK (
        subtotal >= 0 AND discount_amount >= 0
        AND tax_amount >= 0 AND total_amount >= 0
    ),
    CONSTRAINT fk_invoices_shop
        FOREIGN KEY (shop_id) REFERENCES shops(shop_id),
    CONSTRAINT fk_invoices_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE SET NULL,
    CONSTRAINT fk_invoices_employee
        FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
        ON DELETE SET NULL
);

CREATE TABLE invoice_items (
    invoice_item_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    invoice_id BIGINT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(12,2) NOT NULL,
    discount_amount DECIMAL(12,2) NOT NULL DEFAULT 0,
    line_total DECIMAL(12,2) GENERATED ALWAYS AS
        ((quantity * unit_price) - discount_amount) STORED,
    CONSTRAINT chk_item_quantity CHECK (quantity > 0),
    CONSTRAINT chk_item_price CHECK (unit_price >= 0),
    CONSTRAINT chk_item_discount CHECK (discount_amount >= 0),
    CONSTRAINT fk_items_invoice
        FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    invoice_id BIGINT NOT NULL,
    transaction_reference VARCHAR(100) NOT NULL UNIQUE,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(12,2) NOT NULL,
    payment_method ENUM(
        'CASH',
        'UPI',
        'CREDIT_CARD',
        'DEBIT_CARD',
        'NET_BANKING',
        'WALLET'
    ) NOT NULL,
    payment_status ENUM(
        'PENDING',
        'SUCCESS',
        'FAILED',
        'REFUNDED'
    ) DEFAULT 'PENDING',
    gateway_name VARCHAR(80),
    remarks VARCHAR(255),
    CONSTRAINT chk_payment_amount CHECK (amount > 0),
    CONSTRAINT fk_payments_invoice
        FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id)
        ON DELETE CASCADE
);

CREATE TABLE refunds (
    refund_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    payment_id BIGINT NOT NULL,
    refund_reference VARCHAR(100) NOT NULL UNIQUE,
    refund_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    refund_amount DECIMAL(12,2) NOT NULL,
    refund_reason VARCHAR(255),
    refund_status ENUM('REQUESTED','PROCESSED','REJECTED') DEFAULT 'REQUESTED',
    CONSTRAINT chk_refund_amount CHECK (refund_amount > 0),
    CONSTRAINT fk_refunds_payment
        FOREIGN KEY (payment_id) REFERENCES payments(payment_id)
        ON DELETE CASCADE
);

-- Helpful indexes
CREATE INDEX idx_shops_mall ON shops(mall_id);
CREATE INDEX idx_products_shop ON products(shop_id);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_invoices_shop_date ON invoices(shop_id, invoice_date);
CREATE INDEX idx_invoices_customer ON invoices(customer_id);
CREATE INDEX idx_items_invoice ON invoice_items(invoice_id);
CREATE INDEX idx_payments_date_status ON payments(payment_date, payment_status);
CREATE INDEX idx_payments_method ON payments(payment_method);
CREATE INDEX idx_refunds_date ON refunds(refund_date);
