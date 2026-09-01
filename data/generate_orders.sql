-- generate_orders.sql
-- Populate orders with ~2,000,000 rows using generate_series

-- Example: adjust batch size if necessary for your environment.

INSERT INTO orders (customer_id, amount, status, created_at)
SELECT
  (random()*10000)::int + 1 as customer_id,
  (random()*1000)::numeric(10,2) as amount,
  (CASE WHEN random() < 0.7 THEN 'completed' WHEN random() < 0.85 THEN 'pending' ELSE 'cancelled' END) as status,
  now() - (random() * (interval '365 days')) as created_at
FROM generate_series(1,2000000);

-- After loading data run:
-- ANALYZE orders;
