# Error Handling Rules

## Core Principle

**Errors are values, not exceptions. Handle them explicitly.**

Rust has no exceptions. Use `Result<T, E>` for operations that can fail and
`Option<T>` for values that may be absent. Never panic in production code.

---

## The Rules

### 1. No `.unwrap()` in Production Code

```rust
// BAD - Panics on None/Err
let item = collection.find(id).unwrap();
let value: f64 = input.parse().unwrap();

// GOOD - Handle the absence/error
let item = collection.find(id)
    .ok_or(AppError::NotFound(id))?;
let value: f64 = input.parse()
    .map_err(|_| AppError::InvalidNumber(input.to_string()))?;
```

**Exception:** `.unwrap()` is acceptable in:
- Tests (where a panic IS the failure mode)
- Provably infallible cases with a comment: `// Infallible: regex is a compile-time constant`

### 2. No `.expect()` in Production Code

Same rules as `.unwrap()`. Use `?` with proper error types instead.

### 3. Define Domain Error Types

Use `thiserror` for library/domain errors:

```rust
use thiserror::Error;

#[derive(Debug, Error)]
pub enum AppError {
    #[error("item not found: {0}")]
    NotFound(String),

    #[error("invalid input: {0}")]
    InvalidInput(String),

    #[error("operation timed out after {duration:?}")]
    Timeout { duration: Duration },

    #[error("validation failed")]
    Validation(#[from] ValidationError),
}
```

### 4. Use `anyhow` Only at the Application Boundary

```rust
// In library code: use specific error types
pub fn process(input: &str) -> Result<Output, ProcessError> { ... }

// In main.rs / CLI / top-level: anyhow is fine
fn main() -> anyhow::Result<()> {
    let config = Config::load(&path)?;
    let result = process(&config)?;
    println!("{}", result);
    Ok(())
}
```

### 5. Provide Context in Error Chains

```rust
use anyhow::Context;

let config = Config::load(&path)
    .with_context(|| format!("failed to load config from {}", path.display()))?;
```

### 6. Error Conversion with `From`

Let `thiserror`'s `#[from]` derive conversions:

```rust
#[derive(Debug, Error)]
pub enum AppError {
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),

    #[error("parse error: {0}")]
    Parse(#[from] serde_json::Error),
}
```

---

## Option Handling

### Prefer Combinators Over Match When Clear

```rust
// Concise, clear intent
let name = item.description.as_deref().unwrap_or("No description");

let values: Vec<f64> = items
    .iter()
    .filter_map(|i| i.optional_value())
    .collect();
```

When logic is complex, `match` is clearer:

```rust
match collection.find(id) {
    Some(item) if item.is_active() => process(item),
    Some(item) => skip_inactive(item),
    None => log_missing(id),
}
```

---

## Panic Policy

**Panics are bugs.** Code that can panic in production is incorrect.

Acceptable panics:
- `unreachable!()` for truly unreachable code paths
- `assert!()` in tests
- `debug_assert!()` for invariant checking during development

Unacceptable panics:
- `.unwrap()` / `.expect()` on user input or external data
- Array indexing without bounds checking on dynamic data
- Integer overflow in release mode (use checked arithmetic)

```rust
// BAD - Panics on out-of-bounds
let item = items[index];

// GOOD - Returns Option
let item = items.get(index)
    .ok_or(AppError::IndexOutOfBounds(index))?;
```
