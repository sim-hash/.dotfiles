# Testing Patterns

## Unit Test Structure

### Arrange-Act-Assert

```java
class PricingServiceTest {

    @Test
    void appliesDiscountCorrectly() {
        // Arrange
        var service = new PricingService();
        double price = 100.0;
        double discount = 10.0;

        // Act
        double result = service.applyDiscount(price, discount);

        // Assert
        assertThat(result).isCloseTo(90.0, within(0.001));
    }
}
```

---

## Testing Exceptions

```java
@Test
void throwsForNullInput() {
    var service = new ParserService();

    assertThatThrownBy(() -> service.parse(null))
        .isInstanceOf(IllegalArgumentException.class)
        .hasMessageContaining("must not be null");
}

@Test
void throwsNotFoundForMissingItem() {
    var service = new ItemService(emptyRepository());

    assertThatThrownBy(() -> service.findById("abc123"))
        .isInstanceOf(ItemNotFoundException.class)
        .hasFieldOrPropertyWithValue("itemId", "abc123");
}
```

---

## Testing Optional Results

```java
@Test
void returnsUserWhenFound() {
    var repo = new InMemoryUserRepository();
    repo.save(new User("user-1", "Alice"));

    Optional<User> result = repo.findById("user-1");

    assertThat(result)
        .isPresent()
        .hasValueSatisfying(user ->
            assertThat(user.getName()).isEqualTo("Alice")
        );
}

@Test
void returnsEmptyForMissingUser() {
    var repo = new InMemoryUserRepository();

    Optional<User> result = repo.findById("nonexistent");

    assertThat(result).isEmpty();
}
```

---

## Testing with Fixtures

```java
class OrderServiceTest {

    private static Order sampleOrder() {
        return new Order("order-1", List.of(
            new LineItem("Alpha", 10.0),
            new LineItem("Beta", 20.0),
            new LineItem("Gamma", 30.0)
        ));
    }

    private static Config sampleConfig() {
        return new Config("localhost", 8080);
    }

    @Test
    void calculatesOrderTotal() {
        var order = sampleOrder();
        assertThat(order.total()).isCloseTo(60.0, within(0.001));
    }

    @Test
    void filtersExpensiveItems() {
        var order = sampleOrder();
        var expensive = order.itemsAbove(15.0);
        assertThat(expensive).hasSize(2);
    }
}
```

---

## Testing Edge Cases

```java
class CalculatorTest {

    @Test
    void handlesEmptyInput() {
        assertThat(Calculator.total(List.of())).isEqualTo(0.0);
    }

    @Test
    void handlesSingleItem() {
        var items = List.of(new Item("Only", 42.0));
        assertThat(Calculator.total(items)).isCloseTo(42.0, within(0.001));
    }

    @Test
    void handlesZeroValues() {
        var items = List.of(new Item("Free", 0.0));
        assertThat(Calculator.total(items)).isEqualTo(0.0);
    }

    @Test
    void handlesNullInput() {
        assertThatThrownBy(() -> Calculator.total(null))
            .isInstanceOf(NullPointerException.class);
    }
}
```

---

## Testing with Mocks (Dependency Injection)

Use interfaces and Mockito to inject test doubles:

```java
// Define an interface for the dependency
interface Clock {
    Instant now();
}

// Production implementation
class SystemClock implements Clock {
    public Instant now() {
        return Instant.now();
    }
}

// The service accepts any Clock
class ExpirationChecker {
    private final Clock clock;

    ExpirationChecker(Clock clock) {
        this.clock = clock;
    }

    boolean isExpired(Instant deadline) {
        return clock.now().isAfter(deadline);
    }
}

// Tests with a fake
class ExpirationCheckerTest {

    @Test
    void returnsTrueWhenPastDeadline() {
        var deadline = Instant.parse("2024-01-01T00:00:00Z");
        var clock = mock(Clock.class);
        when(clock.now()).thenReturn(deadline.plusSeconds(60));
        var checker = new ExpirationChecker(clock);

        assertThat(checker.isExpired(deadline)).isTrue();
    }

    @Test
    void returnsFalseWhenBeforeDeadline() {
        var deadline = Instant.parse("2024-01-01T00:00:00Z");
        var clock = mock(Clock.class);
        when(clock.now()).thenReturn(deadline.minusSeconds(60));
        var checker = new ExpirationChecker(clock);

        assertThat(checker.isExpired(deadline)).isFalse();
    }
}
```

---

## Integration Test Structure

```java
// Use a separate source set or naming convention
class OrderWorkflowIntegrationTest {

    @Test
    void fullWorkflowProcessesAllItems() {
        // Setup
        var config = Config.defaults();
        var pipeline = new OrderPipeline(config);
        var orders = List.of(
            new Order("1", List.of(new LineItem("a", 10.0))),
            new Order("2", List.of(new LineItem("b", 20.0))),
            new Order("3", List.of(new LineItem("c", 30.0)))
        );

        // Execute
        var results = pipeline.processAll(orders);

        // Verify
        assertThat(results).hasSize(3);
        assertThat(results).allMatch(Result::isSuccessful);
    }
}
```

---

## Anti-Patterns to Avoid

```java
// BAD - Testing implementation, not behavior
@Test
void internalBufferHasCorrectCapacity() {
    var processor = new Processor();
    assertThat(processor.getBuffer().capacity()).isEqualTo(1024);
}

// GOOD - Testing observable behavior
@Test
void processesUpTo1024Items() {
    var processor = new Processor();
    var items = IntStream.range(0, 1024)
        .mapToObj(i -> new Item("item-" + i))
        .toList();
    assertThat(processor.process(items)).isNotEmpty();
}

// BAD - Brittle string matching on error messages
@Test
void showsError() {
    var ex = assertThrows(ValidationException.class,
        () -> validate(""));
    assertEquals("validation error: input cannot be empty", ex.getMessage());
}

// GOOD - Check exception type and properties
@Test
void returnsEmptyInputError() {
    assertThatThrownBy(() -> validate(""))
        .isInstanceOf(ValidationException.class)
        .hasFieldOrPropertyWithValue("violations",
            List.of("input cannot be empty"));
}
```
