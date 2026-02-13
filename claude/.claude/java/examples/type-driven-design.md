# Type-Driven Design Examples

## Value Objects with Records

Use records to create immutable value objects with built-in validation:

```java
// Without value objects - easy to swap arguments by accident
void transfer(double amount, long from, long to) { ... }
transfer(100.0, toId, fromId); // Oops! Compiles fine, but wrong

// With value objects - compiler catches the mistake
record Amount(BigDecimal value) {
    Amount {
        Objects.requireNonNull(value);
        if (value.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Amount must not be negative");
        }
    }
}

record AccountId(long value) {}

void transfer(Amount amount, AccountId from, AccountId to) { ... }
```

### Record with Validation

```java
public record NonEmptyString(String value) {
    public NonEmptyString {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("String must not be empty");
        }
    }
}

// Now methods that need non-empty strings express it in the type
public User createUser(NonEmptyString name, EmailAddress email) { ... }
```

---

## Enums for Fixed States

```java
public enum DoorState {
    LOCKED {
        @Override
        public DoorState unlock() { return CLOSED; }

        @Override
        public DoorState open() {
            throw new IllegalStateException("Door is locked");
        }
    },
    CLOSED {
        @Override
        public DoorState unlock() {
            throw new IllegalStateException("Door is not locked");
        }

        @Override
        public DoorState open() { return OPEN; }
    },
    OPEN {
        @Override
        public DoorState unlock() {
            throw new IllegalStateException("Door is not locked");
        }

        @Override
        public DoorState open() {
            throw new IllegalStateException("Door is already open");
        }
    };

    public abstract DoorState unlock();
    public abstract DoorState open();
}
```

---

## Sealed Interfaces for Algebraic Data Types (Java 17+)

Use sealed interfaces when you need variants with different associated data:

```java
public sealed interface PaymentMethod
    permits CreditCard, BankTransfer, Wallet {
}

public record CreditCard(CardNumber number, ExpiryDate expiry)
    implements PaymentMethod {}

public record BankTransfer(Iban iban)
    implements PaymentMethod {}

public record Wallet(Amount balance)
    implements PaymentMethod {}

// Each variant carries exactly the data it needs - no Optional fields,
// no unused fields depending on which "type" it is.

// Pattern matching (Java 21+)
String describe(PaymentMethod method) {
    return switch (method) {
        case CreditCard cc -> "Card ending " + cc.number().lastFour();
        case BankTransfer bt -> "Bank " + bt.iban().bankCode();
        case Wallet w -> "Wallet with " + w.balance();
    };
}
```

---

## Builder Pattern

For classes with many fields or construction-time validation:

```java
public class ServerConfig {
    private final String host;
    private final int port;
    private final int maxConnections;
    private final Duration timeout;

    private ServerConfig(Builder builder) {
        this.host = builder.host;
        this.port = builder.port;
        this.maxConnections = builder.maxConnections;
        this.timeout = builder.timeout;
    }

    public static Builder builder() {
        return new Builder();
    }

    public static class Builder {
        private String host;
        private int port;
        private int maxConnections = 100;              // sensible default
        private Duration timeout = Duration.ofSeconds(30); // sensible default

        public Builder host(String host) {
            this.host = host;
            return this;
        }

        public Builder port(int port) {
            this.port = port;
            return this;
        }

        public Builder maxConnections(int max) {
            this.maxConnections = max;
            return this;
        }

        public Builder timeout(Duration timeout) {
            this.timeout = timeout;
            return this;
        }

        public ServerConfig build() {
            Objects.requireNonNull(host, "host is required");
            if (port < 1 || port > 65535) {
                throw new IllegalArgumentException("Invalid port: " + port);
            }
            return new ServerConfig(this);
        }
    }
}

// Usage
var config = ServerConfig.builder()
    .host("localhost")
    .port(8080)
    .build();
```

---

## Step Builder (Typestate-Like Pattern)

Use interfaces to enforce correct ordering of operations at compile time:

```java
// Step builder - compiler enforces required fields are set
public class FormBuilder {

    public interface NeedsName {
        NeedsEmail name(String name);
    }

    public interface NeedsEmail {
        CanBuild email(String email);
    }

    public interface CanBuild {
        CanBuild phone(String phone);  // optional
        Form build();
    }

    public static NeedsName create() {
        return name -> email -> new Steps(name, email);
    }

    private record Steps(String name, String email) implements CanBuild {
        private String phone;

        public CanBuild phone(String phone) {
            // store phone
            return this;
        }

        public Form build() {
            return new Form(name, email);
        }
    }
}

// This compiles - all required fields provided
var form = FormBuilder.create()
    .name("Alice")
    .email("alice@example.com")
    .build();

// This does NOT compile - can't skip name or email
// var form = FormBuilder.create().email("alice@example.com").build();
```

---

## Composition Over Inheritance

Prefer interfaces and composition over class hierarchies:

```java
// Compose behavior from small, focused interfaces
interface Describable {
    String description();
}

interface Measurable {
    int size();
}

// Compose into a concrete type
record Report(String title, List<Section> sections)
    implements Describable, Measurable {

    @Override
    public String description() {
        return title;
    }

    @Override
    public int size() {
        return sections.size();
    }
}

// Use interface types to accept anything with the right capabilities
String summarize(Describable item) {
    return item.description();
}

<T extends Describable & Measurable> String summarize(T item) {
    return "%s (%d items)".formatted(item.description(), item.size());
}
```
