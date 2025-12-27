---
agent: agent
---

Generate a commit message for the staged changes in git.

## Format

```
<type>(<scope>): <subject>

<optional body: wrap at 72 chars>
```

**Type** (required): `fix`, `feat`, `chore`, `ci`, `docs`, `style`, `refactor`, `perf`, `test`

**Scope** (optional): Module, component, or area affected (e.g., `eslint`, `auth`, `api`)

**Subject**: Max ~50 chars total, imperative mood

## Rules

1. **Type**: Choose the most specific type for the change
2. **Scope**: Include when the change is localized to a specific area
3. **Subject**: Concise summary of *why*, not *what*. Imperative mood ("add" not "added").
4. **Body** (if needed): Explain motivation, context, or trade-offs. Wrap at 72 characters.
5. **Focus on intent**: Describe the purpose, not the mechanics.

## Examples

Simple:
```
refactor(eslint): enforce node: prefix for built-ins
```

With scope and body:
```
fix(restore): handle edge cases in binding groups

The previous implementation failed when bindings had identical
keys but different when-clauses. Now groups bindings by key
before processing to maintain correct ordering.
```

Without scope:
```
docs: update README with migration instructions
```

## Task

1. Examine the staged changes
2. Identify the primary intent/purpose
3. Write a commit message following the format above
4. Run `git commit -em "<message>"` with the generated message (this opens the editor so I can review/edit before finalizing)
