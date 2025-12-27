---
applyTo: '**/*.test.ts'
---

# Write Both Comprehensive and Focused Tests

Write **two types of tests** for each function: comprehensive tests that verify complete output, and focused tests that verify specific behaviors with clear failure messages.

## Two Test Types (Write Both)

### 1. Comprehensive tests with `deepEqual`

Verify the complete return value to catch regressions:

```typescript
test("returns complete binding structure", () => {
  const result = processBinding(input);

  assert.deepEqual(result, {
    name: "foo",
    id: 1,
    status: "active",
    source: "vscode",
  });
});
```

This proves:
- All expected properties exist with correct values
- No unexpected properties were added
- No mutations occurred to other fields

### 2. Focused tests with targeted assertions

Verify specific behaviors with clear, descriptive failure messages:

```typescript
test("preserves source attribution", () => {
  const result = processBinding(input);

  assert.equal(result.source, "vscode", "should preserve source attribution");
});

test("preserves binding order within groups", () => {
  const result = groupBindings(inputs);

  assert.deepEqual(
    result.items.map((x) => x.id),
    ["first", "second", "third"],
  );
});

test("negates command for removal", () => {
  const result = createRemoval(original);

  assert.equal(result.command, `-${original.command}`);
});
```

Focused tests:
- Have descriptive test names that explain the specific behavior
- Use targeted assertions that produce clear failure messages
- Test one aspect per test

## Why Both Types

| Test Type | Catches | Failure Message Quality |
|-----------|---------|------------------------|
| Comprehensive (`deepEqual`) | Any regression, unexpected changes | Noisy diff on large objects |
| Focused (targeted assertions) | Specific behavior violations | Clear, actionable message |

Together they provide:
- **Broad regression coverage** from comprehensive tests
- **Clear diagnostics** from focused tests when something breaks

## Pattern: Comprehensive + Targeted in Same Test

When a test focuses on a specific behavior but you also want regression protection:

```typescript
test("preserves source attribution", () => {
  const result = processBinding(input);

  // Targeted assertion first—clear failure message if this breaks
  assert.equal(result.source, "vscode", "should preserve source attribution");

  // Then full structure—catches any other regressions
  assert.deepEqual(result, expectedBinding);
});
```

## Testing Transformations

When testing a transformation, verify both what changed AND what didn't:

```typescript
assert.deepEqual(result, {
  ...originalObject,
  updatedField: "new value",  // only this should differ
});
```

## Exceptions

Spot-checks alone are acceptable for:
- Very large objects where only one field is relevant to the test's purpose
- Error cases where you only care about error type/message
- Precondition checks (e.g., array length before iterating)

Even then, consider if a comprehensive test would catch more regressions.
