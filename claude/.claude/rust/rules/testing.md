# Testing Standards

## Test-First Development

**Tests must always be written before implementation code.**

See [tdd-workflow.md](tdd-workflow.md) for the full Red-Green-Refactor cycle.

---

## Testing Layers

1. **Unit Tests** (inline `#[cfg(test)]` modules) - Functions, types, logic
2. **Integration Tests** (`tests/` directory) - Public API, module interactions
3. **Doc Tests** (in `///` comments) - API examples stay correct

---

## Unit Tests

Unit tests live alongside the code they test:

```rust
// src/pricing.rs

pub fn apply_discount(price: f64, discount_pct: f64) -> f64 {
    price * (1.0 - discount_pct / 100.0)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn applies_percentage_discount() {
        let result = apply_discount(100.0, 10.0);
        assert!((result - 90.0).abs() < f64::EPSILON);
    }

    #[test]
    fn zero_discount_returns_original_price() {
        let result = apply_discount(50.0, 0.0);
        assert!((result - 50.0).abs() < f64::EPSILON);
    }

    #[test]
    fn full_discount_returns_zero() {
        let result = apply_discount(50.0, 100.0);
        assert!((result - 0.0).abs() < f64::EPSILON);
    }
}
```

### Naming Conventions

- Test module: `mod tests` with `#[cfg(test)]`
- Test functions: `snake_case` describing the behavior
- Start with a verb: `returns_...`, `handles_...`, `calculates_...`
- Avoid `test_` prefix (the `#[test]` attribute already marks it)

### Assertions

```rust
// Exact equality
assert_eq!(result, expected);
assert_ne!(result, other);

// Boolean conditions
assert!(value.is_valid());

// Float comparison (never use == for floats)
assert!((result - expected).abs() < f64::EPSILON);

// Pattern matching for enum variants
assert!(matches!(result, Err(MyError::NotFound(_))));

// With custom failure message
assert_eq!(result, expected, "price should reflect 10% discount");
```

---

## Integration Tests

Integration tests live in the `tests/` directory and test the public API:

```rust
// tests/workflow.rs

use my_crate::{Config, Pipeline};

#[test]
fn processes_items_through_full_pipeline() {
    let config = Config::default();
    let pipeline = Pipeline::new(config);

    let input = vec!["a", "b", "c"];
    let output = pipeline.process(&input).unwrap();

    assert_eq!(output.len(), 3);
    assert!(output.iter().all(|o| o.is_processed()));
}
```

---

## Doc Tests

Every public function should have a doc test to keep examples honest:

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

Doc tests are compiled and run by `cargo test`. They catch API-breaking changes
and keep documentation accurate.

---

## Test Helpers and Fixtures

For reusable test data, create a test helpers module:

```rust
// src/test_helpers.rs
#[cfg(test)]
pub mod fixtures {
    use crate::*;

    pub fn sample_config() -> Config {
        Config {
            timeout: Duration::from_secs(30),
            retries: 3,
            verbose: false,
        }
    }

    pub fn sample_items(count: usize) -> Vec<Item> {
        (0..count)
            .map(|i| Item::new(&format!("Item {}", i + 1)))
            .collect()
    }
}
```

Use `.unwrap()` freely in tests - a panic IS the correct failure mode there.

---

## Property-Based Testing (Optional)

For functions with wide input ranges, consider `proptest`:

```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn discount_never_exceeds_original_price(
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

## Test Commands

```bash
cargo test                        # All tests (unit + integration + doc)
cargo test --lib                  # Unit tests only
cargo test --test '*'             # Integration tests only
cargo test --doc                  # Doc tests only
cargo test -- --nocapture         # Show stdout/stderr
cargo test -- some_name           # Filter by test name
cargo watch -x test               # Auto-run on file change
```

---

## Coverage

Use `cargo tarpaulin` for coverage reports:

```bash
cargo install cargo-tarpaulin
cargo tarpaulin --out html
```

Focus on meaningful coverage:
- Core logic: 90%+
- Utility functions: 80%+
- Don't chase 100% - cover behavior, not lines
