# Error Handling Rules

## Core Principle

**Use exceptions purposefully. Prefer specific, domain-level exceptions over generic ones.**

Java has checked and unchecked exceptions. Use them intentionally:
checked for recoverable failures at API boundaries, unchecked for programming
errors and unrecoverable conditions.

---

## The Rules

### 1. No Swallowing Exceptions

```java
// BAD - Exception is silently swallowed
try {
    processOrder(order);
} catch (Exception e) {
    // do nothing
}

// GOOD - Handle, log, or rethrow
try {
    processOrder(order);
} catch (OrderProcessingException e) {
    log.error("Failed to process order {}: {}", order.id(), e.getMessage(), e);
    throw e;
}
```

### 2. No Catching Generic Exception in Business Logic

```java
// BAD - Catches everything, masks bugs
try {
    calculate(input);
} catch (Exception e) {
    return defaultValue;
}

// GOOD - Catch specific exceptions
try {
    calculate(input);
} catch (ArithmeticException e) {
    throw new CalculationException("Division by zero for input: " + input, e);
}
```

**Exception:** Catching `Exception` is acceptable at top-level boundaries
(main method, request handlers, message consumers) where you need a catch-all.

### 3. Define Domain Exception Types

```java
public class OrderNotFoundException extends RuntimeException {
    private final String orderId;

    public OrderNotFoundException(String orderId) {
        super("Order not found: " + orderId);
        this.orderId = orderId;
    }

    public String getOrderId() {
        return orderId;
    }
}

public class ValidationException extends RuntimeException {
    private final List<String> violations;

    public ValidationException(List<String> violations) {
        super("Validation failed: " + String.join(", ", violations));
        this.violations = List.copyOf(violations);
    }

    public List<String> getViolations() {
        return violations;
    }
}
```

### 4. Preserve the Cause Chain

```java
// BAD - Original cause is lost
try {
    repository.save(entity);
} catch (SQLException e) {
    throw new PersistenceException("Failed to save entity");
}

// GOOD - Wraps the original cause
try {
    repository.save(entity);
} catch (SQLException e) {
    throw new PersistenceException("Failed to save entity: " + entity.id(), e);
}
```

### 5. Use `@Nullable` for Absent Values, Not `Optional`

Avoid `Optional` — it often clutters code and does not add more safety than a
`@Nullable` annotation. Use `@Nullable` on return types and let callers handle
null explicitly.

```java
// BAD - Optional adds ceremony without real safety
public Optional<User> findById(String id) {
    return Optional.ofNullable(userMap.get(id));
}

// GOOD - @Nullable makes absence explicit without wrapping
public @Nullable User findById(@NotNull String id) {
    requireNonNull(id);
    return userMap.get(id);
}
```

Use null-safe utility methods (like `ifNotNull`) for concise null handling:

```java
// GOOD - Utility method for transform-if-present
ifNotNull(findById(id), user -> sendWelcomeEmail(user.getEmail()));
```

### 6. Don't Use Exceptions for Control Flow

```java
// BAD - Exception used for expected case
try {
    int value = Integer.parseInt(input);
    process(value);
} catch (NumberFormatException e) {
    handleNonNumeric(input);
}

// GOOD - Check first
if (input.matches("-?\\d+")) {
    process(Integer.parseInt(input));
} else {
    handleNonNumeric(input);
}
```

---

## Null Policy

- **Annotate everything**: All public method parameters and return types get `@NotNull` or `@Nullable`
- **Validate at the boundary**: `requireNonNull()` on every `@NotNull` parameter in public methods
- **Never return `null` for collections**: Return `List.of()`, `Set.of()`, `Map.of()` instead
- **Use `@Nullable`** for single values that may be absent — not `Optional`

```java
// BAD
public List<Item> getItems() {
    if (noItems) return null;
}

// GOOD
public @NotNull List<Item> getItems() {
    if (noItems) return List.of();
}
```
