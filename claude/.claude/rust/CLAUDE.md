# Rust-Specific Development Guide

> This extends the [global rules](../CLAUDE.md). Apply both.

---

## Quality Gates (Rust Commands)

```bash
cargo test && cargo build && cargo clippy -- -D warnings && cargo fmt --check
```

## Quick Reference

- **Coding standards** → [rules/rust-idioms.md](rules/rust-idioms.md)
- **Error handling** → [rules/error-handling.md](rules/error-handling.md)
- **Testing specifics** → [rules/testing.md](rules/testing.md)
- **Examples** → [examples/](examples/)
