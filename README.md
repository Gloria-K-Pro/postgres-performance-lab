<<<<<<< HEAD
# postgres-performance-lab

Project overview

This repository contains artifacts for a PostgreSQL performance lab focused on diagnosing slow queries, applying index optimizations, demonstrating transaction isolation behavior, and configuring PgBouncer for connection pooling.

## Objectives
- Create a large dataset for testing (2,000,000 rows)
- Measure a slow aggregation query with EXPLAIN ANALYZE
- Add a partial composite index to optimize the query
- Compare before/after performance
- Demonstrate READ COMMITTED vs REPEATABLE READ
- Configure PgBouncer and validate connectivity

## Repository structure
- `schema/` - table schema
- `data/` - data generation SQL
- `performance/` - slow query, index SQL, and EXPLAIN outputs
- `isolation/` - demo scripts and results for isolation levels
- `pgbouncer/` - PgBouncer config and connection test notes
- `docs/` - optimization report, comparison, pooling analysis, reflection

## Setup instructions (local testing)
1. Create the `bootcamp` database and ensure Postgres is running.
2. Run the schema:

```sh
psql -U postgres -d bootcamp -f schema/orders_table.sql
```

3. Load data (this can take several minutes):

```sh
psql -U postgres -d bootcamp -f data/generate_orders.sql
psql -U postgres -d bootcamp -c "ANALYZE orders;"
```

4. Capture the before plan:

```sh
psql -U postgres -d bootcamp -c "EXPLAIN (ANALYZE, BUFFERS) \"`cat performance/slow_query.sql`\"" > performance/before_explain.txt
```

5. Create the index (use CONCURRENTLY in production):

```sh
psql -U postgres -d bootcamp -f performance/index_optimization.sql
psql -U postgres -d bootcamp -c "ANALYZE orders;"
```

6. Capture the after plan:

```sh
psql -U postgres -d bootcamp -c "EXPLAIN (ANALYZE, BUFFERS) \"`cat performance/slow_query.sql`\"" > performance/after_explain.txt
```

7. Isolation demos: follow the scripts in `isolation/` using two psql sessions to observe behavior.

8. PgBouncer: configure and start PgBouncer using `pgbouncer/pgbouncer.ini`. Then test with:

```sh
psql -h 127.0.0.1 -p 6432 -U postgres bootcamp
```

## Files created during the assignment
See the repository tree for all SQL, config, and documentation files created as part of this lab.
