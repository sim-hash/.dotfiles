# Type-Driven Design Examples

## Newtypes

Wrap primitive types to add meaning and prevent misuse:

```rust
// Without newtypes - easy to swap arguments by accident
fn transfer(amount: f64, from: u64, to: u64) { ... }
transfer(100.0, to_id, from_id); // Oops! Compiles fine, but wrong

// With newtypes - compiler catches the mistake
struct Amount(f64);
struct AccountId(u64);

fn transfer(amount: Amount, from: AccountId, to: AccountId) { ... }
```

### Newtype with Validation

```rust
#[derive(Debug, Clone, PartialEq)]
pub struct NonEmptyString(String);

impl NonEmptyString {
    pub fn new(value: impl Into<String>) -> Result<Self, ValidationError> {
        let value = value.into();
        if value.trim().is_empty() {
            return Err(ValidationError::EmptyString);
        }
        Ok(Self(value))
    }

    pub fn as_str(&self) -> &str {
        &self.0
    }
}

// Now functions that need non-empty strings express it in the type
fn create_user(name: NonEmptyString, email: EmailAddress) -> User { ... }
```

---

## Enums for State Machines

Use enums to model states. The compiler ensures you handle all transitions:

```rust
enum DoorState {
    Locked,
    Closed,
    Open,
}

impl DoorState {
    fn unlock(self) -> Result<Self, &'static str> {
        match self {
            DoorState::Locked => Ok(DoorState::Closed),
            _ => Err("door is not locked"),
        }
    }

    fn open(self) -> Result<Self, &'static str> {
        match self {
            DoorState::Closed => Ok(DoorState::Open),
            DoorState::Locked => Err("door is locked"),
            DoorState::Open => Err("door is already open"),
        }
    }
}
```

### Enums with Associated Data

```rust
enum PaymentMethod {
    CreditCard {
        number: CardNumber,
        expiry: ExpiryDate,
    },
    BankTransfer {
        iban: Iban,
    },
    Wallet {
        balance: Amount,
    },
}

// Each variant carries exactly the data it needs - no Option fields,
// no unused fields depending on which "type" it is
```

---

## Builder Pattern

For structs with many fields or construction-time validation:

```rust
pub struct ServerConfig {
    host: String,
    port: u16,
    max_connections: usize,
    timeout: Duration,
}

pub struct ServerConfigBuilder {
    host: Option<String>,
    port: Option<u16>,
    max_connections: usize,
    timeout: Duration,
}

impl ServerConfigBuilder {
    pub fn new() -> Self {
        Self {
            host: None,
            port: None,
            max_connections: 100,         // sensible default
            timeout: Duration::from_secs(30), // sensible default
        }
    }

    pub fn host(mut self, host: impl Into<String>) -> Self {
        self.host = Some(host.into());
        self
    }

    pub fn port(mut self, port: u16) -> Self {
        self.port = Some(port);
        self
    }

    pub fn max_connections(mut self, max: usize) -> Self {
        self.max_connections = max;
        self
    }

    pub fn timeout(mut self, timeout: Duration) -> Self {
        self.timeout = timeout;
        self
    }

    pub fn build(self) -> Result<ServerConfig, BuildError> {
        let host = self.host.ok_or(BuildError::MissingField("host"))?;
        let port = self.port.ok_or(BuildError::MissingField("port"))?;

        Ok(ServerConfig {
            host,
            port,
            max_connections: self.max_connections,
            timeout: self.timeout,
        })
    }
}

// Usage
let config = ServerConfigBuilder::new()
    .host("localhost")
    .port(8080)
    .build()?;
```

---

## Typestate Pattern

Use the type system to enforce correct ordering of operations at compile time:

```rust
struct Unvalidated;
struct Validated;

struct Form<State> {
    data: HashMap<String, String>,
    _state: std::marker::PhantomData<State>,
}

impl Form<Unvalidated> {
    fn new(data: HashMap<String, String>) -> Self {
        Self { data, _state: std::marker::PhantomData }
    }

    fn validate(self) -> Result<Form<Validated>, ValidationError> {
        // ... perform validation ...
        Ok(Form { data: self.data, _state: std::marker::PhantomData })
    }
}

impl Form<Validated> {
    fn submit(self) -> Result<(), SubmitError> {
        // Can only submit a validated form - compiler enforces this!
        Ok(())
    }
}

// This compiles:
let form = Form::new(data).validate()?.submit()?;

// This does NOT compile - submit() doesn't exist on Form<Unvalidated>:
// let form = Form::new(data).submit();
```

---

## Composition Over Inheritance

Rust doesn't have inheritance. Use composition and traits:

```rust
// Compose behavior from small, focused traits
trait Describable {
    fn description(&self) -> &str;
}

trait Measurable {
    fn size(&self) -> usize;
}

// Compose into a concrete type
struct Report {
    title: String,
    content: Vec<Section>,
}

impl Describable for Report {
    fn description(&self) -> &str {
        &self.title
    }
}

impl Measurable for Report {
    fn size(&self) -> usize {
        self.content.len()
    }
}

// Use trait bounds to accept anything with the right capabilities
fn summarize(item: &(impl Describable + Measurable)) -> String {
    format!("{} ({} items)", item.description(), item.size())
}
```
