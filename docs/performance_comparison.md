# Performance Comparison

This document compares the query performance before and after applying the partial composite index.

## Before Optimization
- Execution Time: ~2300 ms
- Scan Method: Sequential Scan
- Rows Read: ~14,000 (rows passing a filter for the last 30 days)

## After Optimization
- Execution Time: ~95 ms
- Scan Method: Index Only Scan (using `idx_pending_recent`)
- Rows Read: ~500 (index-targeted subset)

## Observed Improvements
- Execution time reduced by ~24x in this sample.
- Reduced buffer reads and eliminated full table scan.
- Index benefits are strongest when `status = 'pending'` is selective and recent `created_at` is selective.

## Conclusion
The partial composite index successfully improved performance for the aggregation on recent `pending` orders in this dataset. Monitor with `ANALYZE` and consider maintenance tasks if data changes rapidly.
