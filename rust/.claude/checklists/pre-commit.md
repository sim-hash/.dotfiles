# Pre-Commit Checklist

## Quality Gates (MANDATORY)

- [ ] `cargo test` - All tests pass
- [ ] `cargo build` - Build succeeds
- [ ] `cargo clippy -- -D warnings` - No clippy warnings
- [ ] `cargo fmt --check` - Formatting correct

```bash
cargo test && cargo build && cargo clippy -- -D warnings && cargo fmt --check
```

**All four must pass. No exceptions.**

---

## Code Quality

- [ ] No `.unwrap()` or `.expect()` in production code
- [ ] Error types are domain-specific (not stringly-typed)
- [ ] `?` used for error propagation (not manual match-and-return)
- [ ] No unnecessary `.clone()` calls
- [ ] Public items have doc comments

---

## Clean Code

- [ ] No `dbg!()` macros left in
- [ ] No `println!()` debugging left in
- [ ] No `todo!()` or `unimplemented!()` without a tracking issue
- [ ] No commented-out code
- [ ] No `#[allow(...)]` without a justifying comment

---

## Tests

- [ ] New behavior has corresponding tests
- [ ] Tests follow Arrange-Act-Assert pattern
- [ ] Test names describe behavior, not implementation
- [ ] Edge cases covered (empty, zero, boundary values)
- [ ] Error cases have dedicated tests

---

## Dependencies

- [ ] No unnecessary new dependencies added
- [ ] `Cargo.lock` is up to date
- [ ] `cargo audit` shows no vulnerabilities (if applicable)

---

## Commit Message

Follow conventional commits:

```
feat: add user authentication
fix: handle empty input in parser
refactor: extract validation into separate module
test: add edge case tests for pricing
docs: update API documentation
chore: update dependencies
```

---

## Common Mistakes to Watch For

- `.unwrap()` slipping into production code
- Forgetting to declare new modules in `mod.rs` / `lib.rs`
- Dead code warnings (remove unused code, don't just suppress)
- Missing `#[derive(Debug)]` on public types
- Forgetting to update `Cargo.lock` after dependency changes
