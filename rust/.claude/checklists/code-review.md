# Code Review Checklist

## Quality Gates

- [ ] `cargo test` passes
- [ ] `cargo build` succeeds
- [ ] `cargo clippy -- -D warnings` clean
- [ ] `cargo fmt --check` clean

---

## Correctness

- [ ] Logic matches the stated intent
- [ ] Edge cases handled (empty, zero, None, boundaries)
- [ ] Error paths are sensible and tested
- [ ] No panicking code in production paths (`.unwrap()`, indexing, etc.)
- [ ] Numeric operations handle overflow/underflow if applicable

---

## Idiomatic Rust

- [ ] Types encode domain constraints (newtypes, enums)
- [ ] Borrows used instead of unnecessary clones
- [ ] Pattern matching is exhaustive (no catch-all `_` hiding missed variants)
- [ ] Iterators used where clearer than manual loops
- [ ] Error types are specific and use `thiserror`

---

## Design

- [ ] Changes are minimal and focused on the stated goal
- [ ] No unnecessary abstractions or premature generalization
- [ ] Public API is minimal (default to private)
- [ ] No dead code or unused imports

---

## Testing

- [ ] New behavior has tests
- [ ] Tests are meaningful (test behavior, not implementation)
- [ ] Test names are descriptive
- [ ] Error paths are tested, not just happy paths
- [ ] No test pollution (tests are independent of each other)

---

## Documentation

- [ ] Public items have doc comments
- [ ] `# Errors` section in docs for fallible functions
- [ ] Doc examples compile and are correct
- [ ] No stale comments referencing old behavior

---

## Security

- [ ] No secrets or credentials in code
- [ ] User input is validated at boundaries
- [ ] No `unsafe` without `// SAFETY:` justification
- [ ] Dependencies are from trusted sources

---

## Red Flags

Watch for these during review:

- `.unwrap()` or `.expect()` in non-test code
- `#[allow(clippy::...)]` without explanation
- `unsafe` blocks
- `clone()` used to work around borrow checker
- Catch-all `_` in match arms that should be exhaustive
- `String` where `&str` would suffice
- `Vec<T>` where `&[T]` would suffice
- Empty error messages or generic error types
