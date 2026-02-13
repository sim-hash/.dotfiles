# Java-Specific Development Guide

> This extends the [global rules](../CLAUDE.md). Apply both.

---

## Quality Gates (Java Commands)

### Maven

```bash
mvn test && mvn compile && mvn checkstyle:check && mvn spotless:check
```

### Gradle

```bash
./gradlew test && ./gradlew build && ./gradlew checkstyleMain && ./gradlew spotlessCheck
```

## Quick Reference

- **Coding standards** → [rules/java-idioms.md](rules/java-idioms.md)
- **Error handling** → [rules/error-handling.md](rules/error-handling.md)
- **Testing specifics** → [rules/testing.md](rules/testing.md)
- **Examples** → [examples/](examples/)
