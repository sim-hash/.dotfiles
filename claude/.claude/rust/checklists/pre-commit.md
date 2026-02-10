# Rust Pre-Commit Checklist

> See [global checklist](../../CLAUDE.md) for universal items.
> This covers Rust-specific checks only.

## Quality Gates

```bash
cargo test && cargo build && cargo clippy -- -D warnings && cargo fmt --check
```

## Rust-Specific Checks

- [ ] No `.unwrap()` or `.expect()` in production code
- [ ] No `dbg!()` macros left in
- [ ] No `#[allow(...)]` without a justifying comment
- [ ] Error types are domain-specific (use `thiserror`)
- [ ] `?` used for error propagation
- [ ] No unnecessary `.clone()` calls
- [ ] Public items have doc comments
- [ ] `Cargo.lock` is up to date

## Common Rust Mistakes

- `.unwrap()` slipping into production code
- Forgetting to declare new modules in `mod.rs` / `lib.rs`
- Dead code warnings (remove unused code, don't suppress)
- Missing `#[derive(Debug)]` on public types
