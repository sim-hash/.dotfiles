# Java Pre-Commit Checklist

> See [global checklist](../../CLAUDE.md) for universal items.
> This covers Java-specific checks only.

## Quality Gates

### Maven

```bash
mvn test && mvn compile && mvn checkstyle:check && mvn spotless:check
```

### Gradle

```bash
./gradlew test && ./gradlew build && ./gradlew checkstyleMain && ./gradlew spotlessCheck
```

## Java-Specific Checks

- [ ] No swallowed exceptions (empty catch blocks)
- [ ] No `System.out.println` debug statements left in
- [ ] No `@SuppressWarnings` without a justifying comment
- [ ] Exception types are domain-specific
- [ ] `Optional` used instead of returning `null`
- [ ] No raw types
- [ ] Public methods have Javadoc
- [ ] No unused imports
- [ ] `equals()`/`hashCode()` consistent or using records

## Common Java Mistakes

- `System.out.println` or `e.printStackTrace()` slipping into production code
- Swallowed exceptions hiding real failures
- Raw types causing unchecked cast warnings
- Mutable collections exposed from getters (return `List.copyOf()` or `Collections.unmodifiableList()`)
- Missing `@Override` annotation on overridden methods
- Using `==` instead of `.equals()` for objects
