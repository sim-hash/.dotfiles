# Testing Patterns

## Unit Test Structure

### Arrange-Act-Assert

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn applies_discount_correctly() {
        // Arrange
        let price = 100.0;
        let discount = 10.0;

        // Act
        let result = apply_discount(price, discount);

        // Assert
        assert!((result - 90.0).abs() < f64::EPSILON);
    }
}
```

---

## Testing Result and Option

```rust
#[test]
fn returns_ok_for_valid_input() {
    let result = parse("42");
    assert!(result.is_ok());
    assert_eq!(result.unwrap(), 42);
}

#[test]
fn returns_error_for_invalid_input() {
    let result = parse("not a number");
    assert!(result.is_err());
}

// Match specific error variants
#[test]
fn returns_not_found_for_missing_item() {
    let result = find_item("nonexistent");
    assert!(matches!(result, Err(AppError::NotFound(_))));
}

// Extract and inspect error details
#[test]
fn error_contains_the_missing_id() {
    let result = find_item("abc123");
    match result {
        Err(AppError::NotFound(id)) => assert_eq!(id, "abc123"),
        other => panic!("expected NotFound, got {:?}", other),
    }
}
```

---

## Testing with Fixtures

```rust
#[cfg(test)]
mod tests {
    use super::*;

    // Reusable test data
    fn sample_config() -> Config {
        Config {
            timeout: Duration::from_secs(30),
            retries: 3,
        }
    }

    fn sample_items() -> Vec<Item> {
        vec![
            Item::new("Alpha", 10.0),
            Item::new("Beta", 20.0),
            Item::new("Gamma", 30.0),
        ]
    }

    #[test]
    fn calculates_total() {
        let items = sample_items();
        let total = calculate_total(&items);
        assert!((total - 60.0).abs() < f64::EPSILON);
    }

    #[test]
    fn filters_expensive_items() {
        let items = sample_items();
        let expensive = filter_above(&items, 15.0);
        assert_eq!(expensive.len(), 2);
    }
}
```

---

## Testing Edge Cases

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn handles_empty_input() {
        assert_eq!(calculate_total(&[]), 0.0);
    }

    #[test]
    fn handles_single_item() {
        let items = vec![Item::new("Only", 42.0)];
        assert!((calculate_total(&items) - 42.0).abs() < f64::EPSILON);
    }

    #[test]
    fn handles_zero_values() {
        let items = vec![Item::new("Free", 0.0)];
        assert!((calculate_total(&items) - 0.0).abs() < f64::EPSILON);
    }

    #[test]
    fn handles_large_numbers() {
        let items = vec![Item::new("Big", f64::MAX / 2.0)];
        let total = calculate_total(&items);
        assert!(total.is_finite());
    }
}
```

---

## Testing with Traits (Dependency Injection)

Use traits to inject test doubles:

```rust
// Define a trait for the dependency
trait Clock {
    fn now(&self) -> Instant;
}

// Production implementation
struct SystemClock;
impl Clock for SystemClock {
    fn now(&self) -> Instant {
        Instant::now()
    }
}

// The function accepts any Clock
fn is_expired(deadline: Instant, clock: &impl Clock) -> bool {
    clock.now() > deadline
}

#[cfg(test)]
mod tests {
    use super::*;

    // Test double
    struct FakeClock {
        now: Instant,
    }

    impl Clock for FakeClock {
        fn now(&self) -> Instant {
            self.now
        }
    }

    #[test]
    fn returns_true_when_past_deadline() {
        let deadline = Instant::now();
        let clock = FakeClock {
            now: deadline + Duration::from_secs(1),
        };

        assert!(is_expired(deadline, &clock));
    }

    #[test]
    fn returns_false_when_before_deadline() {
        let now = Instant::now();
        let clock = FakeClock { now };
        let deadline = now + Duration::from_secs(60);

        assert!(!is_expired(deadline, &clock));
    }
}
```

---

## Integration Test Structure

```rust
// tests/workflow_test.rs

use my_crate::{Config, Pipeline};

#[test]
fn full_pipeline_processes_all_items() {
    // Setup
    let config = Config::default();
    let pipeline = Pipeline::new(config);
    let input = vec!["a", "b", "c"];

    // Execute
    let output = pipeline.process(&input).unwrap();

    // Verify
    assert_eq!(output.len(), 3);
    assert!(output.iter().all(|o| o.is_processed()));
}
```

---

## Testing Async Code (if applicable)

```rust
#[tokio::test]
async fn fetches_data_successfully() {
    let client = TestClient::new();
    let result = fetch_data(&client).await;
    assert!(result.is_ok());
}
```

---

## Anti-Patterns to Avoid

```rust
// BAD - Testing implementation, not behavior
#[test]
fn internal_buffer_has_correct_capacity() {
    let processor = Processor::new();
    assert_eq!(processor.buffer.capacity(), 1024); // Don't test internals
}

// GOOD - Testing observable behavior
#[test]
fn processes_up_to_1024_items() {
    let processor = Processor::new();
    let items = (0..1024).map(|i| Item::new(i)).collect::<Vec<_>>();
    let result = processor.process(&items);
    assert!(result.is_ok());
}

// BAD - Brittle string matching on error messages
#[test]
fn shows_error() {
    let err = validate("").unwrap_err();
    assert_eq!(err.to_string(), "validation error: input cannot be empty");
}

// GOOD - Match on error variant
#[test]
fn returns_empty_input_error() {
    let err = validate("").unwrap_err();
    assert!(matches!(err, ValidationError::EmptyInput));
}
```
