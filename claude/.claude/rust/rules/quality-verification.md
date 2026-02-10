# Quality Verification Rules

## Mandatory Verification After Every Change

**CRITICAL: After making ANY code change, you MUST verify quality by running all four checks.**

This is NON-NEGOTIABLE. Every change must pass all quality gates before being considered complete.

## Four Quality Gates

### 1. Tests Must Pass

```bash
cargo test
```

**What this verifies:**
- All unit tests pass
- All integration tests pass
- All doc tests pass
- No regressions introduced

**Expected result:** All tests green, 0 failures

### 2. Build Must Succeed

```bash
cargo build
```

**What this verifies:**
- No compilation errors
- No missing dependencies
- All type constraints satisfied
- No unresolved imports

**Expected result:** Compiles cleanly

### 3. Clippy Must Pass

```bash
cargo clippy -- -D warnings
```

**What this verifies:**
- No common mistakes or anti-patterns
- Idiomatic Rust usage
- Performance suggestions applied
- No unnecessary complexity

**Expected result:** No warnings or errors. We treat ALL clippy warnings as errors.

### 4. Formatting Must Be Correct

```bash
cargo fmt --check
```

**What this verifies:**
- Consistent code style across the project
- Standard Rust formatting conventions

**Expected result:** No formatting differences

## Complete Verification Command

```bash
cargo test && cargo build && cargo clippy -- -D warnings && cargo fmt --check
```

If ANY check fails, the change is NOT complete. Fix the issues and re-run all checks.

## When to Run Quality Checks

Run quality verification:

- After every code change (even small ones)
- After refactoring
- After adding new features or fixing bugs
- Before committing code
- After resolving merge conflicts
- After updating dependencies

## Common Issues and Solutions

### Test Failures

1. Read the failure message carefully - Rust's test output is descriptive
2. Fix the code or update the test if requirements changed
3. Re-run `cargo test` to verify
4. Use `cargo test -- --nocapture` to see debug output

### Build Failures

1. Check for type mismatches - read the compiler's suggestions
2. Verify all imports resolve
3. Check for missing trait implementations
4. Look for lifetime issues - follow the compiler's guidance

### Clippy Failures

1. Read the lint description and suggested fix
2. Apply the suggestion or justify suppression with `#[allow(clippy::...)]`
3. Suppressions require a comment explaining why
4. Never blanket-suppress clippy at the crate level

### Format Failures

1. Run `cargo fmt` to auto-fix
2. Use `#[rustfmt::skip]` only for genuinely better manual formatting (rare)
