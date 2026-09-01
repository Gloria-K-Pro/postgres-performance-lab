# Isolation Level Observations

This file summarizes the expected behavior observed when demonstrating `READ COMMITTED` and `REPEATABLE READ` in PostgreSQL.

## READ COMMITTED

- Session 1 started a transaction (default isolation `READ COMMITTED`) and ran:
  - `SELECT COUNT(*) FROM orders WHERE status = 'pending';`  -- returned `N` pending rows.
- Session 2 updated one or more rows (e.g., changed `status` from `pending` to `completed`) and committed.
- Session 1 re-ran the same `SELECT` within the same transaction and observed the updated result (the committed change was visible).

Explanation: `READ COMMITTED` uses a statement-level snapshot. Each statement sees the effect of transactions committed before the statement began. As a result, a transaction will observe changes committed by other transactions between statements.

## REPEATABLE READ

- Session 1 began a transaction with `BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;` and executed:
  - `SELECT COUNT(*) FROM orders WHERE status = 'pending';` -- returned `N`.
- Session 2 updated rows and committed.
- Session 1 re-ran the same `SELECT` within the same transaction and observed the original result `N` (did not see the committed changes from Session 2).

Explanation: `REPEATABLE READ` provides a transaction-level snapshot (snapshot isolation). All statements in the transaction see a consistent snapshot taken at the start of the transaction; later commits by other transactions are not visible until the transaction ends.

## What Session 1 Observed vs Session 2 Changes

- Session 1 under `READ COMMITTED`: saw Session 2's committed updates between statements.
- Session 1 under `REPEATABLE READ`: did not see Session 2's committed updates during the transaction.

## Example terminal excerpts (illustrative)

Session 1 (READ COMMITTED):
```
$ psql -c "BEGIN; SELECT COUNT(*) FROM orders WHERE status='pending';"
 count 
-------
 14000
(1 row)
-- After Session 2 commits
$ psql -c "SELECT COUNT(*) FROM orders WHERE status='pending';"
 count 
-------
 13999
(1 row)
```

Session 1 (REPEATABLE READ):
```
$ psql -c "BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ; SELECT COUNT(*) FROM orders WHERE status='pending';"
 count 
-------
 14000
(1 row)
-- After Session 2 commits
$ psql -c "SELECT COUNT(*) FROM orders WHERE status='pending';"
 count 
-------
 14000
(1 row)
```

