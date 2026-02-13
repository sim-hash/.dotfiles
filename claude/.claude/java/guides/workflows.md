# Development Workflows

## Adding a New Feature

```
1. Write failing test(s)
2. Implement minimum code to pass
3. Refactor
4. Run quality gates (see CLAUDE.md for commands)
5. Commit
```

Repeat the TDD cycle (steps 1-3) for each piece of behavior.

---

## Adding a New Class

1. Create the class in the appropriate package
2. Write tests in the mirror test package
3. Add Javadoc for public methods
4. Run quality gates

---

## Adding a Dependency

### Maven

1. Add to `pom.xml` with a specific version
2. Use the correct scope (`compile`, `test`, `provided`, `runtime`)
3. Run `mvn dependency:tree` to verify no conflicts
4. Run full quality gates

### Gradle

1. Add to `build.gradle` with a specific version
2. Use the correct configuration (`implementation`, `testImplementation`, `compileOnly`, `runtimeOnly`)
3. Run `./gradlew dependencies` to verify no conflicts
4. Run full quality gates

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
3. Run tests after each change
4. Run full quality gates when done

---

## Updating Dependencies

### Maven

```bash
# Check for outdated dependencies
mvn versions:display-dependency-updates

# Update a specific dependency in pom.xml manually, then:
mvn test && mvn compile && mvn checkstyle:check && mvn spotless:check
```

### Gradle

```bash
# Check for outdated dependencies (requires versions plugin)
./gradlew dependencyUpdates

# Update a specific dependency in build.gradle manually, then:
./gradlew test && ./gradlew build && ./gradlew checkstyleMain && ./gradlew spotlessCheck
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

### Maven

```bash
# Run a specific failing test
mvn test -Dtest=ClassName#methodName

# Run tests with debug output
mvn test -X

# Remote debug (attach IDE debugger to port 5005)
mvn test -Dmaven.surefire.debug
```

### Gradle

```bash
# Run a specific failing test
./gradlew test --tests "ClassName.methodName"

# Run tests with debug output
./gradlew test --info

# Remote debug
./gradlew test --debug-jvm
```

Use your IDE's debugger. Remove all `System.out.println` debug statements
before committing.
