# Java Quality Gates

> See [global rules](../../CLAUDE.md) for when and why. This file covers the Java-specific commands.

## Commands (Maven)

```bash
mvn test                    # Gate 1: Tests
mvn compile                 # Gate 2: Build
mvn checkstyle:check        # Gate 3: Lint
mvn spotless:check          # Gate 4: Format
```

## Commands (Gradle)

```bash
./gradlew test              # Gate 1: Tests
./gradlew build             # Gate 2: Build
./gradlew checkstyleMain    # Gate 3: Lint
./gradlew spotlessCheck     # Gate 4: Format
```

## All-in-One

### Maven

```bash
mvn test && mvn compile && mvn checkstyle:check && mvn spotless:check
```

### Gradle

```bash
./gradlew test && ./gradlew build && ./gradlew checkstyleMain && ./gradlew spotlessCheck
```

## Java-Specific Troubleshooting

### Checkstyle Failures

1. Read the violation description and line number
2. Fix the style issue directly
3. If a rule is wrong for the project, adjust `checkstyle.xml` with team agreement
4. Never suppress warnings with `@SuppressWarnings` without a comment explaining why

### Build Failures

1. Read the compiler error - check for type mismatches, missing imports, generics issues
2. Check that all dependencies are declared in `pom.xml` / `build.gradle`
3. Run `mvn dependency:tree` / `./gradlew dependencies` to inspect the dependency graph

### Test Failures

1. Run the failing test in isolation: `mvn test -Dtest=ClassName#methodName`
2. Check for test ordering issues (tests should be independent)
3. Check for flaky tests caused by shared mutable state or time-dependent logic

### Format Failures

1. Run `mvn spotless:apply` / `./gradlew spotlessApply` to auto-fix
2. Configure your IDE to use the project's formatter settings
