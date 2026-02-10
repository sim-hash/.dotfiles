# Project Structure

## Directory Layout

```
my-project/
├── Cargo.toml              # Project manifest and dependencies
├── Cargo.lock              # Locked dependency versions (commit this)
├── rustfmt.toml            # Formatter config (if customized)
├── .clippy.toml            # Clippy config (if customized)
├── CLAUDE.md               # Claude development guide entry point
├── .claude/                # Development methodology docs
├── src/
│   ├── main.rs             # Binary entry point (if applicable)
│   ├── lib.rs              # Library root - public API, module declarations
│   ├── domain/             # Core domain types and logic
│   │   ├── mod.rs
│   │   ├── types.rs        # Newtypes, enums, core structs
│   │   └── validation.rs   # Domain validation rules
│   ├── services/           # Business logic, orchestration
│   │   └── mod.rs
│   ├── errors.rs           # Error type definitions
│   └── test_helpers.rs     # Shared test utilities (#[cfg(test)])
├── tests/                  # Integration tests
│   ├── api_tests.rs
│   └── workflow_tests.rs
└── benches/                # Benchmarks (optional)
    └── performance.rs
```

## File Naming

| Type | Convention | Example |
|------|-----------|---------|
| Modules | `snake_case` | `user_auth.rs` |
| Test files | `*_tests.rs` or match module name | `api_tests.rs` |
| Benchmark files | Descriptive `snake_case` | `performance.rs` |

## Module Organization

### `lib.rs` - Declare and Re-export

```rust
pub mod domain;
pub mod services;
pub mod errors;

// Re-export the public API for convenient access
pub use domain::{MyType, AnotherType};
pub use errors::AppError;
```

### `mod.rs` - Organize Submodules

```rust
// src/domain/mod.rs
mod types;
mod validation;

pub use types::*;
pub use validation::validate;
```

## Where to Put New Code

| You're adding... | Put it in... |
|-----------------|-------------|
| A new domain type | `src/domain/types.rs` |
| Validation logic | `src/domain/validation.rs` |
| Business logic | `src/services/` |
| A new error variant | `src/errors.rs` |
| A unit test | `#[cfg(test)] mod tests` in the same file |
| An integration test | `tests/` directory |
| Test helpers | `src/test_helpers.rs` with `#[cfg(test)]` |

## Import Conventions

```rust
// Standard library first
use std::collections::HashMap;
use std::time::Duration;

// External crates second
use serde::{Deserialize, Serialize};
use thiserror::Error;

// Internal modules last
use crate::domain::MyType;
use crate::errors::AppError;
```

Let `cargo fmt` handle import ordering if configured, or follow this convention manually.
