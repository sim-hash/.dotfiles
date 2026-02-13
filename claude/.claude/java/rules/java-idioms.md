# Java Coding Standards

## Code Formatting

This project uses a formatter (Spotless, google-java-format, or IDE settings).
Formatting is enforced by the quality gate.

Do not fight the formatter. If you disagree with a specific choice, adjust
the formatter config with team agreement.

### Column Alignment

Use column alignment to improve readability of related declarations,
assignments, and similar grouped statements. Align the types, names, equals
signs, and values into columns:

```java
// GOOD - Aligned declarations
private final String   host;
private final int      port;
private final int      maxConnections;
private final Duration timeout;

// GOOD - Aligned assignments
String name    = "Alice";
int    age     = 30;
double balance = 100.50;

// GOOD - Aligned map/builder-style calls
var config = Map.of(
    "host",            "localhost",
    "port",            "8080",
    "maxConnections",  "100",
    "timeout",         "30s"
);

// GOOD - Aligned constants
public static final int    MAX_RETRIES  = 3;
public static final long   TIMEOUT_MS   = 5000;
public static final String DEFAULT_HOST = "localhost";
public static final int    DEFAULT_PORT = 8080;

// GOOD - Aligned parameter lists (when wrapping)
public Order createOrder(
    String     customerId,
    String     productId,
    int        quantity,
    BigDecimal price
) { ... }
```

Apply column alignment when there are **3 or more** related lines that benefit
from visual grouping. Don't force it on unrelated or dissimilar lines.

---

## Core Idioms

### Use the Type System

**CRITICAL: Make invalid states unrepresentable.**

```java
// BAD - Any string could be passed
public void sendEmail(String to) { ... }

// GOOD - Value object enforces the constraint
public record EmailAddress(String value) {
    public EmailAddress {
        if (value == null || !value.contains("@")) {
            throw new IllegalArgumentException("Invalid email: " + value);
        }
    }
}

public void sendEmail(EmailAddress to) { ... }
```

```java
// BAD - Stringly-typed state
public void setStatus(String status) { ... }

// GOOD - Enum-typed, compiler checks usage
public enum OrderStatus {
    PENDING,
    PROCESSING,
    SHIPPED,
    DELIVERED,
    CANCELLED
}
```

### Use Records for Value Objects (Java 16+)

```java
// Records are immutable, get equals/hashCode/toString for free
public record Money(BigDecimal amount, Currency currency) {
    public Money {
        Objects.requireNonNull(amount, "amount must not be null");
        Objects.requireNonNull(currency, "currency must not be null");
        if (amount.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Amount must not be negative");
        }
    }
}
```

### Use Sealed Classes for Restricted Hierarchies (Java 17+)

```java
// Compiler knows all possible subtypes
public sealed interface Shape permits Circle, Rectangle, Triangle {
    double area();
}

public record Circle(double radius) implements Shape {
    public double area() { return Math.PI * radius * radius; }
}

public record Rectangle(double width, double height) implements Shape {
    public double area() { return width * height; }
}

public record Triangle(double base, double height) implements Shape {
    public double area() { return 0.5 * base * height; }
}
```

### Defensive Programming

**Annotate all public method parameters and return types with `@NotNull` or `@Nullable`.**

Use `org.jetbrains.annotations.NotNull` / `org.jetbrains.annotations.Nullable`.
Always validate `@NotNull` parameters with `Objects.requireNonNull()`.

```java
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import static java.util.Objects.requireNonNull;

// GOOD - Annotations make the contract explicit, requireNonNull enforces it
public @NotNull User createUser(@NotNull String name, @NotNull EmailAddress email) {
    requireNonNull(name);
    requireNonNull(email);
    return new User(name, email);
}

// GOOD - @Nullable return clearly signals the caller must handle absence
public @Nullable User findByUsername(@NotNull String username) {
    requireNonNull(username);
    return userMap.get(username);
}
```

#### Null-Check Rules

- **Public methods**: Validate `@NotNull` parameters with `requireNonNull()` at the top
- **Private methods**: Trust the caller (null checks already happened at the boundary)
- **Constructors**: Validate and assign in one step: `this.name = requireNonNull(name);`
- **Return types**: Use `@Nullable` for values that may be absent. Avoid `Optional` — it
  often clutters code and does not add more safety than a `@Nullable` annotation

```java
// GOOD - Constructor validates with requireNonNull
public class Batch {
    @NotNull  final BatchNumber batchNumber;
    @NotNull  final BatchId     batchId;
    @Nullable final Duration    previousCycleDuration;

    public Batch(
            @NotNull  BatchNumber batchNumber,
            @NotNull  BatchId     batchId,
            @Nullable Duration    previousCycleDuration
    ) {
        this.batchNumber             = requireNonNull(batchNumber);
        this.batchId                 = requireNonNull(batchId);
        this.previousCycleDuration   = previousCycleDuration;
    }
}
```

#### Use `@Contract` for Null-Behavior Documentation

Use `org.jetbrains.annotations.Contract` to express null-related method contracts
for static analysis:

```java
import org.jetbrains.annotations.Contract;

@Contract("null -> null; !null -> !null")
public static String trimOrNull(@Nullable String value) {
    return value == null ? null : value.trim();
}

@Contract("null -> true")
public static boolean isEmpty(@Nullable Collection<?> list) {
    return list == null || list.isEmpty();
}
```

#### Null-Safe Utility Methods

Use `ifNotNull` / `ifNotEmpty` utility methods as a concise alternative to
if-null checks. These replace `Optional` for inline null handling:

```java
import static com.example.Utils.ifNotNull;
import static com.example.Utils.ifNotEmpty;
import static com.example.Utils.ifNotNullDo;

// ifNotNull - transform a value if non-null, return null otherwise
@Nullable String name = ifNotNull(user, User::getName);

// ifNotNull with default - transform or return default
@NotNull String name = ifNotNull(user, User::getName, "Unknown");

// ifNotNullDo - side-effect if non-null (void)
ifNotNullDo(user, u -> sendWelcomeEmail(u.getEmail()));

// ifNotEmpty - transform a string/list/map if non-null and non-empty
Language lang = ifNotEmpty(langCode, Language::forShortName, Language.DEFAULT);
```

These are especially useful for column-aligned chains of assignments:

```java
ifNotNull(metadata.programName,    builder::setProgramName);
ifNotNull(metadata.firmwareVersion, builder::setFirmwareVersion);
ifNotNull(metadata.programNr,      builder::setProgramNumber);
ifNotNull(metadata.userName,        builder::setUserName);
```

### Prefer Immutability

- Use `final` fields by default
- Use `List.of()`, `Set.of()`, `Map.of()` for unmodifiable collections
- Use `List.copyOf()` for defensive copies
- Use records for value objects
- Only make things mutable when there's a clear reason

```java
// BAD - Mutable, error-prone
public class Config {
    private String host;
    private int port;
    // getters and setters...
}

// GOOD - Immutable record
public record Config(String host, int port) {
    public Config {
        Objects.requireNonNull(host);
        if (port < 1 || port > 65535) {
            throw new IllegalArgumentException("Invalid port: " + port);
        }
    }
}
```

### Use Streams Where Clearer Than Loops

```java
// GOOD - Declarative, composable
double total = items.stream()
    .mapToDouble(Item::getValue)
    .sum();

List<Item> active = items.stream()
    .filter(Item::isActive)
    .toList();
```

Use judgment: if a stream chain becomes hard to read, a `for` loop may be clearer.

```java
// Also fine - when logic is complex
var result = new ArrayList<Output>();
for (var item : items) {
    var output = transform(item);
    if (output.isPresent()) {
        result.add(output.get());
    }
}
```

---

## Naming Conventions

| Item | Convention | Example |
|------|-----------|---------|
| Packages | `lowercase` dot-separated | `com.example.auth` |
| Classes / Interfaces | `PascalCase` | `UserAccount` |
| Methods / Fields | `camelCase` | `validateInput` |
| Constants | `SCREAMING_SNAKE_CASE` | `MAX_RETRIES` |
| Type parameters | Single uppercase | `T`, `E`, `K`, `V` |
| Enum values | `SCREAMING_SNAKE_CASE` | `ORDER_PENDING` |
| Boolean methods | `is*`, `has*`, `can*` | `isValid()`, `hasItems()` |
| Factory methods | `of`, `from`, `create` | `Money.of(10, USD)` |

---

## Class Design

### Prefer Small, Focused Classes

Each class should have a single responsibility. If a class is doing too many
things, split it.

### Builder Pattern for Complex Construction

```java
ServerConfig config = ServerConfig.builder()
    .host("localhost")
    .port(8080)
    .maxConnections(100)
    .timeout(Duration.ofSeconds(30))
    .build();
```

Use Lombok's `@Builder` or write by hand depending on project conventions.

---

## Interface Design

### Keep Interfaces Focused

One interface = one capability. Prefer multiple small interfaces over one
large one (Interface Segregation Principle).

### Use Default Methods Sparingly

Provide defaults only when there's a genuinely universal implementation.

---

## Visibility

- Default to `private`
- Use package-private (no modifier) for implementation details shared within a package
- Use `protected` only when designing for inheritance
- Use `public` only for the module's/package's public API

---

## Documentation

### Document All Public Items

```java
/**
 * Brief one-line summary.
 *
 * <p>More detailed explanation if needed.
 *
 * @param input the raw input to process
 * @return the processed output
 * @throws ParseException if the input is malformed
 */
public Output process(String input) throws ParseException {
    // ...
}
```

---

## Dependencies

- Prefer well-maintained, widely-used libraries
- Keep the dependency tree minimal - don't add a library for something trivial
- Audit new dependencies with `mvn dependency:tree` / `./gradlew dependencies`
- Use dependency scopes correctly (`test`, `provided`, `runtime`)

---

## Avoid Common Pitfalls

- **Don't use raw types** - always parameterize generics: `List<String>`, not `List`
- **Don't ignore `InterruptedException`** - restore the interrupt flag: `Thread.currentThread().interrupt()`
- **Don't compare strings with `==`** - use `.equals()`
- **Don't use `Date`/`Calendar`** - use `java.time` (`LocalDate`, `Instant`, `Duration`)
- **Don't return `null` from collections** - return empty collections instead
