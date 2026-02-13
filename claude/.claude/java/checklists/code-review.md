# Java Code Review Checklist

> See [global checklist](../../CLAUDE.md) for universal items.
> This covers Java-specific review points only.

## Idiomatic Java

- [ ] Types encode domain constraints (value objects, records, enums)
- [ ] Immutability preferred (`final` fields, unmodifiable collections, records)
- [ ] `Optional` used for absent values instead of `null`
- [ ] Streams used where clearer than manual loops
- [ ] Modern Java features used (records, sealed classes, pattern matching where available)
- [ ] Exception types are specific and domain-level

## Java-Specific Documentation

- [ ] Public classes and methods have Javadoc
- [ ] `@param`, `@return`, `@throws` documented for public methods
- [ ] No Javadoc on private methods or trivial getters

## Safety

- [ ] No swallowed exceptions (empty catch blocks)
- [ ] No catching generic `Exception` in business logic
- [ ] No raw types (unparameterized generics)
- [ ] `equals()` and `hashCode()` consistent (or using records)
- [ ] No `@SuppressWarnings` without explanation

## Red Flags

- Returning `null` where `Optional` or empty collection would be appropriate
- `instanceof` chains that should be polymorphism or sealed classes
- Mutable state where immutable would work
- String concatenation in loops (use `StringBuilder` or `String.join`)
- `Date`/`Calendar` instead of `java.time`
- Catching `Exception` or `Throwable` in business logic
- Empty catch blocks
