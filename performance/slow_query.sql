-- slow_query.sql
-- Aggregation showing top customers with pending orders in the last 30 days

SELECT
  customer_id,
  SUM(amount) AS total_pending
FROM orders
WHERE status = 'pending'
  AND created_at >= now() - INTERVAL '30 days'
GROUP BY customer_id
ORDER BY total_pending DESC
LIMIT 10;
