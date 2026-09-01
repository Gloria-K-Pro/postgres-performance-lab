# PgBouncer Setup Notes

## What PgBouncer does

PgBouncer is a lightweight connection pooler for PostgreSQL. It accepts client connections and maintains a pool of server connections to the PostgreSQL backend, reducing the overhead of opening and closing database connections.

## Why `pool_mode = transaction` is commonly used

- `transaction` pooling hands a server connection to a client only for the duration of a transaction. After a commit/rollback the server connection is returned to the pool.
- This mode allows efficient reuse of server connections while keeping client sessions logically independent across transactions.
- It is compatible with most ORMs and typical application behavior where connections are used per request/transaction.

## How connection pooling improves scalability

- Opening a new PostgreSQL connection is expensive (authentication, memory, process resources).
- PgBouncer keeps a smaller number of active server connections and multiplexes them among many clients.
- This reduces memory and CPU usage on the database server and allows handling a larger number of concurrent clients.

## Notes and troubleshooting

- Use `auth_type` appropriate for your environment (trust used here for simple local testing).
- When using `transaction` pooling be careful with session-level features (e.g., `SET` variables, prepared statements, session-level temp objects) since server connections can be shared between clients across transactions.
- For features requiring a client to retain the same server connection state across transactions, consider `session` pooling.
