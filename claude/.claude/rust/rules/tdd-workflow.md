# TDD Workflow Rules

## Core Principle

**Tests come before code. Always.**

1. **No implementation without tests first** - Write failing tests before any implementation code
2. **Red-Green-Refactor** - Follow the TDD cycle strictly
3. **Small steps** - Each cycle should be small and focused

---

## The Cycle

### 1. Red - Write a Failing Test

Write the smallest test that describes the next behavior you need:

```rust
#[test]
fn parses_valid_email() {
    let result = EmailAddress::new("user@example.com");
    assert!(result.is_ok());
}
```

Run `cargo test` - it should **fail** (or not compile, which counts as red).

### 2. Green - Write Minimum Code to Pass

Write just enough code to make the test pass. No more.

```rust
pub struct EmailAddress(String);

impl EmailAddress {
    pub fn new(value: &str) -> Result<Self, ValidationError> {
        Ok(Self(value.to_string()))
    }
}
```

Run `cargo test` - it should **pass**.

### 3. Refactor - Clean Up While Green

Improve the code while keeping all tests passing:

```rust
impl EmailAddress {
    pub fn new(value: &str) -> Result<Self, ValidationError> {
        if !value.contains('@') {
            return Err(ValidationError::InvalidEmail(value.to_string()));
        }
        Ok(Self(value.to_string()))
    }
}
```

But wait - you just added validation logic. That needs a test first!
Go back to Red:

```rust
#[test]
fn rejects_email_without_at_sign() {
    let result = EmailAddress::new("not-an-email");
    assert!(matches!(result, Err(ValidationError::InvalidEmail(_))));
}
```

---

## Guidelines

### Test Naming

Name tests to describe **behavior**, not implementation:

```rust
// GOOD - Describes what should happen
#[test]
fn returns_error_for_empty_input() { ... }

#[test]
fn calculates_total_from_line_items() { ... }

#[test]
fn retries_on_transient_failure() { ... }

// BAD - Describes implementation
#[test]
fn test_parse_function() { ... }

#[test]
fn test_error_branch() { ... }
```

### Test Structure (Arrange-Act-Assert)

```rust
#[test]
fn applies_discount_to_order_total() {
    // Arrange
    let order = Order::new(vec![
        LineItem::new("Widget", 10.0),
        LineItem::new("Gadget", 20.0),
    ]);
    let discount = Discount::percentage(10.0);

    // Act
    let total = order.total_with_discount(&discount);

    // Assert
    assert!((total - 27.0).abs() < f64::EPSILON);
}
```

### One Assertion Per Test (Conceptually)

Each test should verify one behavior. Multiple `assert!` calls are fine if they
verify different aspects of the **same** behavior:

```rust
#[test]
fn parses_config_from_valid_toml() {
    let config = Config::from_toml(VALID_TOML).unwrap();

    assert_eq!(config.timeout, Duration::from_secs(30));
    assert_eq!(config.retries, 3);
    assert!(config.verbose);
}
```

### When to Stop Adding Tests

You have enough tests when:
- Happy path is covered
- Edge cases are covered (empty input, zero values, boundaries)
- Error cases are covered
- You're confident refactoring won't break undetected behavior

---

## Integration with Quality Gates

After completing a TDD cycle, always run the full gate:

```bash
cargo test && cargo build && cargo clippy -- -D warnings && cargo fmt --check
```

TDD is not a substitute for the other quality checks. Clippy may catch issues
your tests don't, and formatting must always be consistent.
