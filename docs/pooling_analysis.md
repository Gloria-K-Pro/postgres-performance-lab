# Connection Pooling Analysis

## Why opening many PostgreSQL connections is expensive
- Each PostgreSQL connection consumes memory and backend process resources.
- Creating new connections involves authentication, SSL setup (if used), and negotiation — which adds latency per connection.
- Large numbers of active connections increase context switching and memory pressure on the database host.

## Role of PgBouncer
- PgBouncer is a lightweight proxy that manages a pool of server connections and accepts many client connections.
- It decouples client concurrency from the number of active server connections, allowing better resource utilization.

## Benefits of transaction pooling
- `transaction` pooling assigns a server connection only for the duration of a transaction, returning it to the pool immediately after commit/rollback.
- This enables a small pool of server connections to serve many short-lived client requests, improving throughput.
- It reduces per-request connection overhead and memory usage on the DB server.

## When session pooling is required
- `session` pooling keeps the same server connection for the life of the client session.
- Use `session` pooling if the application relies on session-local state on the server (e.g., `SET` options, temporary tables that persist across transactions, prepared statements that must remain on the server).

## Practical recommendations
- Start with `transaction` pooling for typical web applications and services.
- Monitor connection usage, pool saturation, and application errors that indicate stateful assumptions.
- Tune `default_pool_size` and `max_client_conn` according to workload and available server connections.
