# Rust Testing Specifics

> See [global rules](../../CLAUDE.md) for TDD workflow and universal testing standards.
> This file covers Rust-specific testing patterns only.

---

## Testing Layers in Rust

1. **Unit Tests** - `#[cfg(test)] mod tests` inline with source
2. **Integration Tests** - `tests/` directory, tests public API
3. **Doc Tests** - code in `///` blocks, compiled by `cargo test`

---

## Unit Tests

Live alongside the code in a `#[cfg(test)]` module:

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn applies_percentage_discount() {
        let result = apply_discount(100.0, 10.0);
        assert!((result - 90.0).abs() < f64::EPSILON);
    }
}
```

### Naming

- Avoid `test_` prefix (`#[test]` already marks it)
- Start with a verb: `returns_...`, `handles_...`, `calculates_...`

### Assertions

```rust
assert_eq!(result, expected);
assert!(value.is_valid());
assert!((result - expected).abs() < f64::EPSILON);  // floats
assert!(matches!(result, Err(MyError::NotFound(_)))); // enum variants
```

---

## Doc Tests

Every public function should have one. They're compiled and tested:

```rust
/// Combine two strings with a separator.
///
/// # Examples
///
/// ```
/// let result = my_crate::join("hello", "world", " ");
/// assert_eq!(result, "hello world");
/// ```
pub fn join(a: &str, b: &str, sep: &str) -> String {
    format!("{}{}{}", a, sep, b)
}
```

---

## Test Helpers

```rust
#[cfg(test)]
pub mod fixtures {
    use crate::*;

    pub fn sample_config() -> Config {
        Config { timeout: Duration::from_secs(30), retries: 3 }
    }
}
```

Use `.unwrap()` freely in tests - a panic IS the correct failure mode.

---

## Property-Based Testing (Optional)

```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn discount_never_exceeds_original(
        price in 0.0f64..1_000_000.0,
        discount in 0.0f64..100.0,
    ) {
        let result = apply_discount(price, discount);
        assert!(result <= price);
        assert!(result >= 0.0);
    }
}
```

---

## Commands

```bash
cargo test                    # All tests
cargo test --lib              # Unit tests only
cargo test --test '*'         # Integration tests only
cargo test --doc              # Doc tests only
cargo test -- --nocapture     # Show stdout
cargo test -- some_name       # Filter by name
cargo watch -x test           # Auto-run on save
cargo tarpaulin --out html    # Coverage report
```
