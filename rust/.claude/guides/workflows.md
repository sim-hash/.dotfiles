# Development Workflows

## Adding a New Feature

```
1. Write failing test(s)
2. Implement minimum code to pass
3. Refactor
4. Run quality gates: cargo test && cargo build && cargo clippy -- -D warnings && cargo fmt --check
5. Commit
```

Repeat the TDD cycle (steps 1-3) for each piece of behavior.

---

## Adding a New Module

1. Create the file in the appropriate directory
2. Declare it in the parent `mod.rs` or `lib.rs`
3. Write tests in a `#[cfg(test)]` block within the file
4. Re-export public items if they're part of the crate API
5. Run quality gates

---

## Adding a Dependency

1. Add to `Cargo.toml` with a specific major version: `serde = "1"`
2. Use feature flags to keep optional features optional
3. Run `cargo build` to update `Cargo.lock`
4. Run `cargo audit` to check for known vulnerabilities
5. Run full quality gates

---

## Fixing a Bug

1. Write a test that reproduces the bug (should fail)
2. Fix the bug (test passes)
3. Check for similar issues elsewhere
4. Run quality gates

---

## Refactoring

1. Ensure existing tests cover the code being refactored
2. Make small, incremental changes
3. Run `cargo test` after each change
4. Run full quality gates when done

---

## Updating Dependencies

```bash
# Check for outdated dependencies
cargo outdated          # requires cargo-outdated

# Update within semver constraints
cargo update

# Run full quality gates after updating
cargo test && cargo build && cargo clippy -- -D warnings && cargo fmt --check
```

---

## Committing Changes

1. Run quality gates one final time
2. Review changes with `git diff`
3. Stage specific files (not `git add .`)
4. Write a clear commit message following conventional commits:
   - `feat:` new feature
   - `fix:` bug fix
   - `refactor:` code restructuring
   - `test:` adding or updating tests
   - `docs:` documentation changes
   - `chore:` maintenance tasks

---

## Debugging

```bash
# Run tests with output visible
cargo test -- --nocapture

# Run a specific test
cargo test test_name

# Use RUST_LOG for structured logging
RUST_LOG=debug cargo run

# Compile in debug mode (default) for better error messages
cargo build
```

Use `dbg!()` for quick debugging but **always remove before committing**.
