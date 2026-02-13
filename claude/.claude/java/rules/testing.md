# Java Testing Specifics

> See [global rules](../../CLAUDE.md) for TDD workflow and universal testing standards.
> This file covers Java-specific testing patterns only.

---

## Testing Layers in Java

1. **Unit Tests** - Test individual classes/methods in isolation
2. **Integration Tests** - Test interactions between components, database, APIs
3. **End-to-End Tests** - Test full application behavior (optional, framework-specific)

---

## Unit Tests

Use JUnit 5 (Jupiter) with AssertJ for fluent assertions:

```java
import org.junit.jupiter.api.Test;
import static org.assertj.core.api.Assertions.*;

class PricingServiceTest {

    @Test
    void appliesPercentageDiscount() {
        var service = new PricingService();

        double result = service.applyDiscount(100.0, 10.0);

        assertThat(result).isCloseTo(90.0, within(0.001));
    }
}
```

### Naming

- Use descriptive method names in `camelCase`
- Start with a verb: `returns...`, `handles...`, `calculates...`, `throwsWhen...`
- No `test` prefix needed (`@Test` already marks it)

### Assertions (AssertJ preferred)

```java
assertThat(result).isEqualTo(expected);
assertThat(list).hasSize(3).contains("a", "b");
assertThat(optional).isPresent().hasValue("expected");
assertThat(result).isCloseTo(90.0, within(0.001));  // doubles

// Exception assertions
assertThatThrownBy(() -> service.process(null))
    .isInstanceOf(IllegalArgumentException.class)
    .hasMessageContaining("must not be null");

// Standard JUnit assertions also fine
assertEquals(expected, result);
assertTrue(value.isValid());
assertThrows(NotFoundException.class, () -> service.find("missing"));
```

---

## Test Organization

### Test Class per Production Class

```
src/main/java/com/example/service/PricingService.java
src/test/java/com/example/service/PricingServiceTest.java
```

### Nested Tests for Grouping

```java
class OrderServiceTest {

    @Nested
    class WhenCreatingOrder {
        @Test
        void createsOrderWithValidItems() { ... }

        @Test
        void rejectsEmptyItemList() { ... }
    }

    @Nested
    class WhenCancellingOrder {
        @Test
        void cancelsActiveOrder() { ... }

        @Test
        void throwsForAlreadyCancelledOrder() { ... }
    }
}
```

---

## Mocking with Mockito

```java
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OrderServiceTest {

    @Mock
    private OrderRepository repository;

    @Mock
    private NotificationService notifications;

    @InjectMocks
    private OrderService service;

    @Test
    void savesOrderToRepository() {
        var order = new Order("item-1", 2);

        service.placeOrder(order);

        verify(repository).save(order);
    }

    @Test
    void returnsOrderFromRepository() {
        var expected = new Order("item-1", 2);
        when(repository.findById("order-1")).thenReturn(Optional.of(expected));

        var result = service.getOrder("order-1");

        assertThat(result).isEqualTo(expected);
    }
}
```

### Mock Only What You Don't Own (Prefer)

- Mock external dependencies (repositories, HTTP clients, message queues)
- Don't mock value objects, records, or simple POJOs
- Don't mock the class under test
- If you need too many mocks, the class might have too many dependencies

---

## Test Helpers / Fixtures

```java
class TestFixtures {

    static Config sampleConfig() {
        return new Config("localhost", 8080);
    }

    static List<Item> sampleItems() {
        return List.of(
            new Item("Alpha", 10.0),
            new Item("Beta", 20.0),
            new Item("Gamma", 30.0)
        );
    }
}
```

Use `@BeforeEach` for setup shared across tests in a class:

```java
class ProcessorTest {
    private Processor processor;

    @BeforeEach
    void setUp() {
        processor = new Processor(TestFixtures.sampleConfig());
    }
}
```

---

## Parameterized Tests

```java
@ParameterizedTest
@CsvSource({
    "100.0, 10.0, 90.0",
    "200.0, 25.0, 150.0",
    "50.0,  0.0,  50.0",
})
void appliesDiscountCorrectly(double price, double discount, double expected) {
    double result = service.applyDiscount(price, discount);
    assertThat(result).isCloseTo(expected, within(0.001));
}
```

---

## Commands

### Maven

```bash
mvn test                                      # All tests
mvn test -Dtest=ClassName                     # Single class
mvn test -Dtest=ClassName#methodName          # Single method
mvn test -pl module-name                      # Single module
mvn verify                                    # Unit + integration tests
mvn jacoco:report                             # Coverage report
```

### Gradle

```bash
./gradlew test                                # All tests
./gradlew test --tests "ClassName"            # Single class
./gradlew test --tests "ClassName.methodName" # Single method
./gradlew test -p module-name                 # Single module
./gradlew jacocoTestReport                    # Coverage report
```
