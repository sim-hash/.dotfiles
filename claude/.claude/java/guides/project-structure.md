# Project Structure

## Directory Layout (Maven)

```
my-project/
├── pom.xml                         # Project manifest and dependencies
├── CLAUDE.md                       # Claude development guide entry point
├── .claude/                        # Development methodology docs
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/example/myapp/
│   │   │       ├── Application.java        # Entry point (if applicable)
│   │   │       ├── domain/                 # Core domain types and logic
│   │   │       │   ├── model/              # Entities, value objects, records
│   │   │       │   └── validation/         # Domain validation rules
│   │   │       ├── service/                # Business logic, orchestration
│   │   │       ├── repository/             # Data access interfaces
│   │   │       ├── exception/              # Domain exception types
│   │   │       └── config/                 # Configuration classes
│   │   └── resources/
│   │       └── application.properties      # Configuration files
│   └── test/
│       ├── java/
│       │   └── com/example/myapp/
│       │       ├── domain/                 # Unit tests mirror main structure
│       │       ├── service/
│       │       ├── repository/
│       │       └── testutil/               # Shared test utilities / fixtures
│       └── resources/
│           └── test-data/                  # Test fixtures, sample files
└── checkstyle.xml                          # Checkstyle config (if used)
```

## Directory Layout (Gradle)

Same structure, but with `build.gradle` (or `build.gradle.kts`) instead of `pom.xml`,
and a `settings.gradle` for multi-module projects.

## Package Naming

| Type | Convention | Example |
|------|-----------|---------|
| Packages | Lowercase, dot-separated, reverse domain | `com.example.myapp.domain` |
| Classes | `PascalCase`, match file name | `OrderService.java` |
| Test classes | Production class + `Test` suffix | `OrderServiceTest.java` |
| Integration tests | Production class + `IntegrationTest` suffix | `OrderRepositoryIntegrationTest.java` |

## Package Organization

### Package by Feature (Preferred)

```
com.example.myapp.order/
├── Order.java
├── OrderService.java
├── OrderRepository.java
└── OrderNotFoundException.java

com.example.myapp.payment/
├── Payment.java
├── PaymentService.java
└── PaymentMethod.java
```

### Package by Layer (Alternative)

```
com.example.myapp.domain/
├── Order.java
├── Payment.java

com.example.myapp.service/
├── OrderService.java
├── PaymentService.java

com.example.myapp.repository/
├── OrderRepository.java
├── PaymentRepository.java
```

## Where to Put New Code

| You're adding... | Put it in... |
|-----------------|-------------|
| A new domain type (entity, value object) | `domain/model/` |
| Validation logic | `domain/validation/` or as compact validation in the record itself |
| Business logic | `service/` |
| A new exception type | `exception/` |
| A unit test | Mirror the production class path under `src/test/java` |
| An integration test | Same location, with `IntegrationTest` suffix |
| Test helpers / fixtures | `testutil/` under test sources |

## Import Conventions

```java
// Standard library first
import java.time.Duration;
import java.util.List;
import java.util.Optional;

// Third-party libraries second
import com.fasterxml.jackson.annotation.JsonProperty;
import org.slf4j.Logger;

// Project imports last
import com.example.myapp.domain.Order;
import com.example.myapp.exception.OrderNotFoundException;
```

Let the IDE or formatter handle import ordering. Avoid wildcard imports (`import java.util.*`).
