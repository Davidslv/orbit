# Core

Shared kernel for the modular Rails application. Provides cross-cutting concerns and utilities used by all engines.

## Concerns

- `Core::Auditable` — Tracks `created_by` and `updated_by` on any model.

## Testing

Core is tested through the engines that depend on it. The billing engine's test suite exercises `Core::Auditable` via `Billing::Invoice`.
