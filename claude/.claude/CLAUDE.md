# Global Development Rules

These rules apply to ALL projects, regardless of language.

Language-specific guides are in subdirectories (e.g., `rust/`, `java/`).
When working in a project, apply BOTH these global rules AND the relevant
language guide.

---

## Core Principles

### 1. Tests First, Always

**NO implementation without tests first.**

1. Write the failing test
2. Write minimum code to make it pass
3. Refactor while tests stay green

This is the Red-Green-Refactor cycle. No exceptions.

### 2. Quality Gates Are Mandatory

Every change must pass ALL quality gates before being considered complete:

- **Tests** must pass
- **Build** must succeed
- **Linter** must pass (no warnings)
- **Formatter** must pass

If ANY gate fails, the change is NOT done. Fix and re-run.

### 3. No Over-Engineering

- Only make changes that are directly requested or clearly necessary
- Don't add features, refactor code, or make "improvements" beyond what was asked
- Don't add error handling for scenarios that can't happen
- Three similar lines of code is better than a premature abstraction
- Don't design for hypothetical future requirements

---

## TDD Workflow

### The Cycle

1. **Red** - Write the smallest test that describes the next behavior. Run tests. It should fail.
2. **Green** - Write just enough code to make the test pass. No more.
3. **Refactor** - Clean up while keeping tests green. If you add new logic, go back to Red.

### Test Naming

Name tests to describe **behavior**, not implementation:

```
GOOD: returns_error_for_empty_input
GOOD: calculates_total_from_line_items
GOOD: retries_on_transient_failure

BAD:  test_parse_function
BAD:  test_error_branch
```

### Test Structure (Arrange-Act-Assert)

Every test follows this pattern:

1. **Arrange** - Set up test data and preconditions
2. **Act** - Execute the behavior under test
3. **Assert** - Verify the expected outcome

### When to Stop Adding Tests

- Happy path is covered
- Edge cases are covered (empty, zero, boundary values)
- Error cases are covered
- You're confident refactoring won't break undetected behavior

---

## Quality Gates

### When to Run

- After every code change (even small ones)
- After refactoring
- After adding new features or fixing bugs
- Before committing code
- After resolving merge conflicts
- After updating dependencies

### The Pattern (language-specific commands vary)

```
<run tests> && <build> && <lint> && <check formatting>
```

See the language-specific guide for exact commands.

---

## Clean Code Rules

### No Debug Code in Commits

Remove ALL debugging artifacts before committing:
- Debug print statements
- Commented-out code
- Temporary workarounds
- TODO/FIXME without a tracking issue

### Commit Messages

Follow conventional commits:

```
feat: add user authentication
fix: handle empty input in parser
refactor: extract validation into separate module
test: add edge case tests for pricing
docs: update API documentation
chore: update dependencies
```

### Security

- No secrets or credentials in code
- Validate user input at system boundaries
- Dependencies from trusted sources only

---

## Pre-Commit Checklist (Universal)

### Quality Gates
- [ ] Tests pass
- [ ] Build succeeds
- [ ] Linter passes (no warnings)
- [ ] Formatter passes

### Clean Code
- [ ] No debug statements left in
- [ ] No commented-out code
- [ ] No TODO/FIXME without tracking issue

### Tests
- [ ] New behavior has corresponding tests
- [ ] Tests follow Arrange-Act-Assert
- [ ] Test names describe behavior
- [ ] Edge cases covered
- [ ] Error cases tested

### Commit
- [ ] Changes are minimal and focused
- [ ] Conventional commit message format
- [ ] No secrets or credentials

---

## Code Review Checklist (Universal)

### Correctness
- [ ] Logic matches stated intent
- [ ] Edge cases handled
- [ ] Error paths are sensible and tested

### Design
- [ ] Changes are minimal and focused
- [ ] No unnecessary abstractions
- [ ] No dead code or unused imports

### Testing
- [ ] New behavior has tests
- [ ] Tests verify behavior, not implementation
- [ ] Error paths tested, not just happy paths

### Security
- [ ] No secrets or credentials
- [ ] User input validated at boundaries
- [ ] Dependencies from trusted sources

---

## Language-Specific Guides

Apply the relevant guide alongside these global rules:

- **Rust** → See `rust/` directory
- **Java** → See `java/` directory (coming soon)
