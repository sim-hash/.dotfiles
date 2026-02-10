# Rust Quality Gates

> See [global rules](../../CLAUDE.md) for when and why. This file covers the Rust-specific commands.

## Commands

```bash
cargo test                    # Gate 1: Tests
cargo build                   # Gate 2: Build
cargo clippy -- -D warnings   # Gate 3: Lint (all warnings are errors)
cargo fmt --check             # Gate 4: Format
```

## All-in-One

```bash
cargo test && cargo build && cargo clippy -- -D warnings && cargo fmt --check
```

## Rust-Specific Troubleshooting

### Clippy Failures

1. Read the lint description and suggested fix
2. Apply the suggestion or suppress with `#[allow(clippy::...)]`
3. Suppressions require a comment explaining why
4. Never blanket-suppress at the crate level

### Build Failures

1. Read the compiler's suggestions - they're usually right
2. Check for type mismatches, missing trait impls, lifetime issues
3. Follow the compiler's guidance before reaching for workarounds

### Format Failures

1. Run `cargo fmt` to auto-fix
2. Use `#[rustfmt::skip]` only when manual formatting is genuinely better (rare)
