-- ============================================
-- TPM PREWORK - ORDER MANAGEMENT SYSTEM
-- PostgreSQL / Supabase Compatible
-- ============================================

-- Drop tables if already exist
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

-- ============================================
-- CUSTOMERS
-- ============================================
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    phone VARCHAR(20),
    city VARCHAR(80),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- PRODUCTS
-- ============================================
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(120) NOT NULL,
    category VARCHAR(80),
    price NUMERIC(10,2) NOT NULL,
    stock INT DEFAULT 0
);

-- ============================================
-- ORDERS
-- ============================================
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(30) DEFAULT 'Pending',
    total_amount NUMERIC(10,2)
);

-- ============================================
-- ORDER ITEMS
-- ============================================
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL,
    unit_price NUMERIC(10,2) NOT NULL
);

-- ============================================
-- PAYMENTS
-- ============================================
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT UNIQUE REFERENCES orders(order_id) ON DELETE CASCADE,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(50),
    payment_status VARCHAR(30),
    amount NUMERIC(10,2)
);

-- ============================================
-- SAMPLE CUSTOMERS (5)
-- ============================================
INSERT INTO customers (full_name, email, phone, city) VALUES
('Rahul Sharma', 'rahul@gmail.com', '900000001', 'Hyderabad'),
('Priya Reddy', 'priya@gmail.com', '900000002', 'Bangalore'),
('Amit Kumar', 'amit@gmail.com', '900000003', 'Chennai'),
('Sneha Patel', 'sneha@gmail.com', '900000004', 'Mumbai'),
('David John', 'david@gmail.com', '900000005', 'Delhi');

-- ============================================
-- SAMPLE PRODUCTS
-- ============================================
INSERT INTO products (product_name, category, price, stock) VALUES
('Laptop', 'Electronics', 55000, 10),
('Mouse', 'Electronics', 800, 50),
('Keyboard', 'Electronics', 1500, 40),
('Shoes', 'Fashion', 2500, 30),
('T-Shirt', 'Fashion', 900, 60),
('Watch', 'Accessories', 4500, 25);

-- ============================================
-- SAMPLE ORDERS (10)
-- ============================================
INSERT INTO orders (customer_id, order_date, order_status, total_amount) VALUES
(1, CURRENT_TIMESTAMP - INTERVAL '2 days', 'Completed', 55800),
(2, CURRENT_TIMESTAMP - INTERVAL '5 days', 'Completed', 2500),
(3, CURRENT_TIMESTAMP - INTERVAL '10 days', 'Completed', 900),
(1, CURRENT_TIMESTAMP - INTERVAL '12 days', 'Completed', 1500),
(4, CURRENT_TIMESTAMP - INTERVAL '18 days', 'Completed', 4500),
(5, CURRENT_TIMESTAMP - INTERVAL '22 days', 'Completed', 55000),
(2, CURRENT_TIMESTAMP - INTERVAL '28 days', 'Completed', 800),
(3, CURRENT_TIMESTAMP - INTERVAL '35 days', 'Completed', 2500),
(1, CURRENT_TIMESTAMP - INTERVAL '3 days', 'Completed', 900),
(4, CURRENT_TIMESTAMP - INTERVAL '7 days', 'Completed', 1500);

-- ============================================
-- SAMPLE ORDER ITEMS
-- ============================================
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1,1,1,55000),(1,2,1,800),
(2,4,1,2500),
(3,5,1,900),
(4,3,1,1500),
(5,6,1,4500),
(6,1,1,55000),
(7,2,1,800),
(8,4,1,2500),
(9,5,1,900),
(10,3,1,1500);

-- ============================================
-- SAMPLE PAYMENTS
-- ============================================
INSERT INTO payments (order_id, payment_method, payment_status, amount) VALUES
(1,'UPI','Paid',55800),
(2,'Card','Paid',2500),
(3,'UPI','Paid',900),
(4,'Card','Paid',1500),
(5,'Cash','Paid',4500),
(6,'UPI','Paid',55000),
(7,'Card','Paid',800),
(8,'UPI','Paid',2500),
(9,'Cash','Paid',900),
(10,'Card','Paid',1500);

-- ============================================
-- REQUIRED QUERIES
-- ============================================

-- 1. Top 3 customers with highest number of orders
SELECT c.full_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.full_name
ORDER BY total_orders DESC
LIMIT 3;

-- 2. Orders placed in last 30 days
SELECT *
FROM orders
WHERE order_date >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY order_date DESC;

-- 3. Total revenue for each product
SELECT p.product_name,
       SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;