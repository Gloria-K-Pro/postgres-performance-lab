-- orders_table.sql
-- Schema for orders table used in the performance lab
CREATE TABLE IF NOT EXISTS orders (
    id BIGSERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    amount NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    status TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Useful indexes (created later in optimization step)
