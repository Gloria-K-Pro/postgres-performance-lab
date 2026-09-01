-- index_optimization.sql
-- Create the partial composite index used to accelerate the slow query

CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_pending_recent
ON orders (created_at DESC, customer_id)
WHERE status = 'pending';

-- Note: use CONCURRENTLY in production to avoid long locks.
