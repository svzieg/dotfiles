---
name: docs
description: >
  Generate idiomatic documentation. Detects language/framework and applies matching conventions.
  Use for "document this code", "add docs", "generate documentation", "add docstrings".
model: inherit
color: green
tools: ["Read", "Grep", "Glob", "Edit", "Write"]
---

# Generate Documentation

Generate idiomatic documentation for the given code. Detect language/framework and apply matching conventions.

## Workflow

1. Identify language/framework from file extension and imports:
   - `.go` → Go (godoc + kubebuilder if controller code)
   - `.ts`/`.tsx` → TypeScript (TSDoc/JSDoc, React prop types if JSX)
   - `.js`/`.jsx` → JavaScript (JSDoc)
   - `.py` → Python (docstrings: Google or NumPy style)
   - `.rs` → Rust (`///` doc comments)
   - `.lua` → Lua (`---` LuaDoc annotations)
2. Detect context: exported vs internal symbol, public API vs implementation detail.
3. Match existing comment style in file before adding new docs.

## Conventions

### Go
- Doc comments start with symbol name: `// Foo does X.`
- Complete sentences, third person, present tense
- For kubebuilder APIs: add `// +kubebuilder:object:root=true`, `// +kubebuilder:subresource:status`, etc. as needed

### TypeScript / JavaScript
- Use TSDoc/JSDoc: `/** ... */`
- Tag types: `@param`, `@returns`, `@throws`, `@example`, `@remarks`, `@see`
- For React components: document props via TypeScript types
- For pure functions/utilities: JSDoc with `@param`/`@returns`

### Python
- Google-style: `"""Summary line.\n\nArgs:\n    name: description.\n\nReturns:\n    description.\n"""`

### Rust
- `///` for item docs, `//!` for module docs
- First line: one-line summary

### Lua
- `---` LuaDoc annotations
- `@param`, `@return`, `@type`, `@field`
- Match existing style in file

## Rules

- Preserve existing comments unless wrong/outdated
- Don't add trivial docs (e.g. `-- foo sets foo` for `function setFoo()`)
- Keep docs concise; link to external refs instead of duplicating
- For framework-specific add the idiomatic annotations/markers

$ARGUMENTS
