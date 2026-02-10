# Rust Project - Claude Development Guide

> **Start here: [.claude/INDEX.md](.claude/INDEX.md)**

---

## Quick Links

- **New to the project?** → [.claude/QUICK_START.md](.claude/QUICK_START.md)
- **Looking for rules?** → [.claude/rules/_INDEX.md](.claude/rules/_INDEX.md)
- **Working on a task?** → [.claude/guides/workflows.md](.claude/guides/workflows.md)
- **Before committing?** → [.claude/checklists/pre-commit.md](.claude/checklists/pre-commit.md)

---

## Essential Commands

```bash
# Development
cargo run                # Run the application
cargo watch -x run       # Run with auto-reload (requires cargo-watch)

# Testing
cargo test               # Unit + integration + doc tests
cargo test --lib         # Unit tests only
cargo test --test '*'    # Integration tests only

# Quality Gates (MANDATORY before commit)
cargo test && cargo build && cargo clippy -- -D warnings && cargo fmt --check
```

---

## Core Principles (Quick Reference)

### 1. Tests First, Always
**NO implementation without tests first.**
Write the failing test → Make it pass → Refactor.

### 2. Idiomatic Rust
```rust
// Use the type system to make invalid states unrepresentable
enum Status {
    Active { started_at: Instant },
    Blocked { reason: String },
    Complete,
}

// Prefer returning Results over panicking
fn validate(input: &Input) -> Result<(), ValidationError> { ... }
```

### 3. Quality Gates Are Mandatory
```bash
cargo test && cargo build && cargo clippy -- -D warnings && cargo fmt --check
```
All four must pass before every commit.

### 4. Make Invalid States Unrepresentable
```rust
// Use newtypes, enums, and the type system to enforce invariants at compile time
struct EmailAddress(String);  // Validated at construction
struct PositiveInt(u32);      // Can't be negative by definition
```

---

## Need Help?

- **Can't find something?** → Check [.claude/rules/_INDEX.md](.claude/rules/_INDEX.md)
- **Need to know how?** → Check [.claude/guides/workflows.md](.claude/guides/workflows.md)
- **Need an example?** → Check [.claude/examples/](.claude/examples/)
- **Before commit?** → Check [.claude/checklists/pre-commit.md](.claude/checklists/pre-commit.md)
