# Rust Coding Standards

## Code Formatting

This project uses **rustfmt** with default settings. Formatting is enforced by the quality gate.

```bash
cargo fmt        # Auto-format
cargo fmt --check # Verify formatting
```

Do not fight the formatter. If you disagree with a specific choice, adjust
`rustfmt.toml` with team agreement, never `#[rustfmt::skip]` casually.

---

## Core Idioms

### Use the Type System

**CRITICAL: Make invalid states unrepresentable.**

```rust
// BAD - Any string could be passed
fn send_email(to: &str) { ... }

// GOOD - Newtype enforces the constraint
struct EmailAddress(String);

impl EmailAddress {
    pub fn new(value: &str) -> Result<Self, ValidationError> {
        if !value.contains('@') {
            return Err(ValidationError::InvalidEmail(value.to_string()));
        }
        Ok(Self(value.to_string()))
    }
}

fn send_email(to: &EmailAddress) { ... }
```

```rust
// BAD - Stringly-typed state
fn set_status(status: &str) { ... }

// GOOD - Enum-typed, compiler checks exhaustiveness
enum OrderStatus {
    Pending,
    Processing { started_at: Instant },
    Shipped { tracking: String },
    Delivered,
    Cancelled { reason: String },
}
```

### Ownership and Borrowing

- **Prefer borrowing** (`&T`, `&mut T`) over cloning
- **Clone only when ownership transfer is genuinely needed**
- **Use `Cow<str>`** when a function might or might not allocate
- **Never `.clone()` to silence the borrow checker** - restructure the code instead

```rust
// BAD - Takes ownership unnecessarily
fn process_name(name: String) -> String {
    format!("Hello, {}", name)
}

// GOOD - Borrow when you don't need ownership
fn process_name(name: &str) -> String {
    format!("Hello, {}", name)
}
```

### Pattern Matching

Prefer exhaustive pattern matching over if-else chains:

```rust
// GOOD - Compiler ensures all variants handled
match order.status {
    OrderStatus::Pending => show_pending(),
    OrderStatus::Processing { started_at } => show_progress(started_at),
    OrderStatus::Shipped { ref tracking } => show_tracking(tracking),
    OrderStatus::Delivered => show_complete(),
    OrderStatus::Cancelled { ref reason } => show_cancelled(reason),
}
```

### Iterators Over Loops

Prefer iterator combinators when the intent is clearer:

```rust
// GOOD - Declarative, composable
let total: f64 = items.iter().map(|i| i.value()).sum();

let active: Vec<&Item> = items
    .iter()
    .filter(|i| i.is_active())
    .collect();
```

Use judgment: if a chain becomes hard to read, a `for` loop may be clearer.

```rust
// Also fine - when logic is complex
let mut result = Vec::new();
for item in &items {
    if let Some(output) = transform(item)? {
        result.push(output);
    }
}
```

---

## Naming Conventions

| Item | Convention | Example |
|------|-----------|---------|
| Crates | `snake_case` | `my_lib` |
| Modules | `snake_case` | `user_auth` |
| Types (struct, enum, trait) | `PascalCase` | `UserAccount` |
| Functions / methods | `snake_case` | `validate_input` |
| Constants | `SCREAMING_SNAKE_CASE` | `MAX_RETRIES` |
| Type parameters | Single uppercase or short `PascalCase` | `T`, `E` |
| Lifetimes | Short lowercase | `'a`, `'ctx` |
| Builder methods | Same name as field | `.name("value")` |
| Conversions | `as_*`, `to_*`, `into_*` | `as_str()`, `to_string()`, `into_inner()` |
| Fallible constructors | `new` returning `Result` | `Config::new(path)?` |
| Boolean methods | `is_*`, `has_*`, `can_*` | `is_valid()`, `has_items()` |

---

## Struct Design

### Prefer Small, Focused Structs

Each struct should have a single responsibility. Split large structs into
composed smaller ones.

### Builder Pattern for Complex Construction

Use the builder pattern when a struct has many fields, optional fields, or
construction-time validation:

```rust
let config = ConfigBuilder::new()
    .timeout(Duration::from_secs(30))
    .retries(3)
    .build()?;
```

The `build()` method should return `Result` if validation is needed.

---

## Trait Design

### Keep Traits Focused

One trait = one capability. Prefer multiple small traits over one large one.

### Use Default Implementations Sparingly

Provide defaults only when there's a genuinely universal implementation.

---

## Visibility

- Default to private
- Use `pub` only for the module's public API
- Use `pub(crate)` for internal-but-shared items
- Use `pub(super)` for parent-module access

---

## Documentation

### Document All Public Items

```rust
/// Brief one-line summary.
///
/// More detailed explanation if needed.
///
/// # Errors
///
/// Returns `ParseError::InvalidFormat` if the input is malformed.
///
/// # Examples
///
/// ```
/// let result = my_crate::process("input")?;
/// assert_eq!(result, expected);
/// ```
pub fn process(input: &str) -> Result<Output, ParseError> {
    // ...
}
```

Doc tests (code in `///` blocks) are compiled and run by `cargo test`.
Use them to keep examples up to date.

---

## Dependencies

- Prefer well-maintained crates from the ecosystem
- Keep the dependency tree minimal - don't add a crate for something trivial
- Audit new dependencies with `cargo audit`
- Use feature flags to keep optional dependencies optional

---

## Unsafe Code

- **Do not use `unsafe`** unless absolutely necessary
- If needed, isolate it behind a safe public API in a dedicated module
- Every `unsafe` block requires a `// SAFETY:` comment explaining the invariants
- Prefer safe abstractions from vetted crates over writing your own
