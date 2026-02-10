# Rust Project - Documentation Index

## Overview

This project follows strict test-driven development, idiomatic Rust patterns,
and mandatory quality gates.

### Technology Stack

| Layer | Technology |
|-------|-----------|
| Language | Rust (latest stable) |
| Build | Cargo |
| Testing | Built-in test framework |
| Linting | Clippy |
| Formatting | rustfmt |
| Error handling | thiserror (libraries) / anyhow (applications) |

---

## Documentation Structure

```
.claude/
├── INDEX.md              # You are here
├── QUICK_START.md        # 5-minute onboarding
├── rules/
│   ├── _INDEX.md         # Searchable rule index
│   ├── quality-verification.md
│   ├── rust-idioms.md
│   ├── tdd-workflow.md
│   ├── testing.md
│   └── error-handling.md
├── guides/
│   ├── project-structure.md
│   └── workflows.md
├── examples/
│   ├── type-driven-design.md
│   └── testing-patterns.md
└── checklists/
    ├── pre-commit.md
    └── code-review.md
```

---

## Core Principles

### 1. Tests First, Always
No implementation without tests first. Red → Green → Refactor.

### 2. Idiomatic Rust
Leverage the type system. Use enums for states, newtypes for domain values,
`Result` for fallible operations. No `.unwrap()` in production code.

### 3. Quality Gates Are Mandatory
Every change must pass all four gates:
```bash
cargo test && cargo build && cargo clippy -- -D warnings && cargo fmt --check
```

### 4. Make Invalid States Unrepresentable
Use the type system to enforce invariants at compile time, not runtime.

### 5. Own Your Errors
Use domain-specific error types. Provide context. Never expose internals through errors.

---

## Quick Navigation

| I want to... | Go to |
|---------------|-------|
| Get started quickly | [QUICK_START.md](QUICK_START.md) |
| Write idiomatic Rust | [rules/rust-idioms.md](rules/rust-idioms.md) |
| Write tests | [rules/testing.md](rules/testing.md) |
| Handle errors properly | [rules/error-handling.md](rules/error-handling.md) |
| Understand TDD workflow | [rules/tdd-workflow.md](rules/tdd-workflow.md) |
| See design examples | [examples/type-driven-design.md](examples/type-driven-design.md) |
| See test examples | [examples/testing-patterns.md](examples/testing-patterns.md) |
| Prepare a commit | [checklists/pre-commit.md](checklists/pre-commit.md) |
| Review a PR | [checklists/code-review.md](checklists/code-review.md) |
