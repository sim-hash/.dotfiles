# Rust Code Review Checklist

> See [global checklist](../../CLAUDE.md) for universal items.
> This covers Rust-specific review points only.

## Idiomatic Rust

- [ ] Types encode domain constraints (newtypes, enums)
- [ ] Borrows used instead of unnecessary clones
- [ ] Pattern matching is exhaustive (no catch-all `_` hiding missed variants)
- [ ] Iterators used where clearer than manual loops
- [ ] Error types are specific and use `thiserror`

## Rust-Specific Documentation

- [ ] Public items have doc comments
- [ ] `# Errors` section for fallible functions
- [ ] Doc examples compile and are correct

## Safety

- [ ] No `.unwrap()` or `.expect()` in non-test code
- [ ] No `unsafe` without `// SAFETY:` justification
- [ ] No `#[allow(clippy::...)]` without explanation

## Red Flags

- `clone()` used to work around borrow checker
- Catch-all `_` in match arms that should be exhaustive
- `String` where `&str` would suffice
- `Vec<T>` where `&[T]` would suffice
- Empty error messages or generic error types
