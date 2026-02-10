# Quick Start - 5 Minute Onboarding

## Golden Rules

1. **Tests first** - Write the test, watch it fail, then write the code
2. **`cargo test && cargo build && cargo clippy -- -D warnings && cargo fmt --check`** before every commit
3. **No `.unwrap()` in production code** - Use `?`, `Result`, or `Option` combinators
4. **Make invalid states unrepresentable** - Lean on the type system
5. **No `clone()` without reason** - Prefer borrowing; clone only when ownership is needed

---

## First Time Setup

```bash
# Ensure Rust toolchain is up to date
rustup update stable

# Install development tools
cargo install cargo-watch     # Auto-rebuild on changes
cargo install cargo-tarpaulin # Code coverage (optional)

# Verify everything works
cargo test && cargo build && cargo clippy -- -D warnings && cargo fmt --check
```

---

## Workflow: Adding a Feature

```
1. Write failing test(s)              ← Red phase
2. Implement minimum code to pass     ← Green phase
3. Refactor while tests stay green    ← Refactor phase
4. Run quality gates                  ← Verify
5. Commit                             ← Ship it
```

---

## Code Style Cheat Sheet

```rust
// Newtypes for domain values
struct UserId(Uuid);
struct EmailAddress(String);

// Enums for states (not strings or booleans)
enum OrderStatus {
    Pending,
    Processing { started_at: Instant },
    Shipped { tracking: String },
    Delivered,
}

// Builder pattern for complex construction
let config = ConfigBuilder::new()
    .timeout(Duration::from_secs(30))
    .retries(3)
    .build()?;

// Result for fallible operations
fn parse_input(raw: &str) -> Result<Config, ParseError> {
    // ...
}

// Iterators over manual loops
let total: f64 = items.iter().map(|i| i.value()).sum();

// Documentation on public items
/// Process the input and return a validated result.
///
/// # Errors
///
/// Returns `ParseError::InvalidFormat` if the input is malformed.
pub fn process(input: &str) -> Result<Output, ParseError> {
    // ...
}
```

---

## Essential Commands

```bash
cargo test                    # Run all tests
cargo test --lib              # Unit tests only
cargo test --test '*'         # Integration tests only
cargo test -- --nocapture     # Show println! output
cargo clippy -- -D warnings   # Lint (treat warnings as errors)
cargo fmt --check             # Check formatting
cargo fmt                     # Auto-format
cargo doc --open              # Generate and view docs
cargo watch -x test           # Auto-run tests on save
```

---

## Before You Commit

- [ ] `cargo test` passes
- [ ] `cargo build` succeeds
- [ ] `cargo clippy -- -D warnings` clean
- [ ] `cargo fmt --check` clean
- [ ] No `.unwrap()` in production code
- [ ] No `TODO` or `FIXME` without a tracking issue
- [ ] No commented-out code
- [ ] No `dbg!()` or `println!()` debugging left in

---

## Next Steps

- Read [rules/rust-idioms.md](rules/rust-idioms.md) for coding standards
- Read [rules/testing.md](rules/testing.md) for test patterns
- Read [rules/error-handling.md](rules/error-handling.md) for error strategy
