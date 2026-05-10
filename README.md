# Orbit — Companion Application

> **This is the companion application for [Modular Rails: Architecture for the Long Game](https://davidslv.uk/modular-rails/) by David Silva.**
> Available now on [Amazon UK](https://www.amazon.co.uk/dp/B0GZL7D53M) · [Amazon US](https://www.amazon.com/dp/B0GZL7D53M)

Orbit is a simplified SaaS platform that manages subscriptions, generates invoices, and sends notifications to customers. It starts as a standard Rails monolith and gets progressively modularised through the book, demonstrating how to decompose a Rails application into well-isolated engines.

## Architecture

```
orbit/
├── app/                  # Host application (thin orchestration layer)
├── engines/
│   ├── core/             # Shared kernel — cross-cutting concerns
│   ├── billing/          # Invoices, subscriptions, plans
│   └── notifications/    # In-app notifications
└── config/               # Host configuration wires engines together
```

```mermaid
graph TD
    Host["Host Application<br/>(orchestration layer)"]
    Core["engines/core<br/>(shared kernel)"]
    Billing["engines/billing<br/>(invoices, subscriptions)"]
    Notifications["engines/notifications<br/>(in-app notifications)"]

    Host --> Billing
    Host --> Notifications
    Billing --> Core
    Notifications --> Core
    Billing -.->|"events"| Notifications

    style Host fill:#f5f5f5,stroke:#333
    style Core fill:#D4E6F1,stroke:#2874A6
    style Billing fill:#D5F5E3,stroke:#1E8449
    style Notifications fill:#FCF3CF,stroke:#B7950B
```

## Prerequisites

- Ruby 3.4+
- PostgreSQL 14+
- Bundler 2.5+

## Setup

```bash
git clone https://github.com/Davidslv/orbit.git
cd orbit

bundle install

bin/rails db:create db:migrate db:seed

bin/rails server
```

## Running Tests

```bash
# Host application tests
bundle exec rspec

# Individual engine tests
cd engines/billing && bundle exec rspec
cd engines/notifications && bundle exec rspec

# All engine tests from the root
bin/rails test
```

## Key Patterns Demonstrated

- **Namespace isolation** -- Each engine uses `isolate_namespace` to prevent accidental coupling
- **Configurable base controllers** -- Engines inherit from a configurable parent controller
- **Event-driven communication** -- Billing publishes events, Notifications subscribes via `ActiveSupport::Notifications`
- **Concern-based integration** -- Engines expose concerns (`Billable`, `Notifiable`) included by host models
- **Shared kernel** -- Core engine provides cross-cutting concerns like `Auditable`
- **Background jobs** -- Event subscribers enqueue jobs instead of processing inline
- **Authorization policies** -- Plain Ruby policy objects without external dependencies
- **API endpoints** -- Versioned JSON API within engine boundaries
- **i18n per engine** -- Each engine owns its locale files

## The Book

This application is the practical companion to [**Modular Rails: Architecture for the Long Game**](https://davidslv.uk/modular-rails/). Each chapter references specific files and patterns in this codebase. The book covers:

- **Part I** -- Clean Architecture, trade-off analysis, and XP principles applied to Rails
- **Part II** -- How Rails Engines work internally and how to build them
- **Part III** -- Extracting engines, managing dependencies, data ownership, testing, team workflows
- **Part IV** -- When engines are wrong, microservices, and evolving your architecture

[Buy on Amazon UK](https://www.amazon.co.uk/dp/B0GZL7D53M) · [Buy on Amazon US](https://www.amazon.com/dp/B0GZL7D53M) · [Learn more](https://davidslv.uk/modular-rails/)

## What's next

Orbit is the **starting point** — three engines, deliberately small enough to read in an afternoon. When you're ready for more:

- **[seams](https://github.com/Davidslv/seams)** — a CLI framework that ships the patterns Orbit demonstrates (and several more — auth, accounts, teams, admin) as opinionated `bin/rails generate seams:<engine>` generators. The book's later chapters reference seams directly.
- **[seams-example](https://github.com/Davidslv/seams-example)** — a reference Rails 8 host wiring all six canonical seams engines end-to-end. The "what does this look like in production shape" answer.

Reading order: book → Orbit (this repo) → seams (the framework) → seams-example (the framework composed).

## License

The code in this repository is licensed under the [MIT License](LICENSE).
