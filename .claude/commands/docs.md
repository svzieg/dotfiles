# Generate Documentation

Generate idiomatic documentation for the given code. Detect language/framework and apply matching conventions.

## Workflow

1. Identify language/framework from file extension and imports:
   - `.go` → Go (godoc + kubebuilder if controller code)
   - `.ts`/`.tsx` → TypeScript (TSDoc/JSDoc, React prop types if JSX)
   - `.js`/`.jsx` → JavaScript (JSDoc)
   - `.py` → Python (docstrings: Google or NumPy style)
   - `.rs` → Rust (`///` doc comments)
2. Detect context: exported vs internal symbol, public API vs implementation detail.
3. Match existing comment style in file before adding new docs.

## Conventions

### Go
- Doc comments start with symbol name: `// Foo does X.`
- Complete sentences, third person, present tense
- For kubebuilder APIs: add `// +kubebuilder:object:root=true`, `// +kubebuilder:subresource:status`, etc. as needed
- Include runnable YAML example for CRD/spec types
- Reference https://pkg.go.dev for stdlib style
- `gofmt` applies tabs; preserve in code blocks

### TypeScript / JavaScript
- Use TSDoc/JSDoc: `/** ... */`
- Tag types: `@param`, `@returns`, `@throws`, `@example`, `@remarks`, `@see`
- For React components: document props via TypeScript types (no manual JSDoc if typed)
- Use `@example` with ` ```tsx ` blocks
- For pure functions/utilities: JSDoc with `@param`/`@returns`

### Python
- Google-style: `"""Summary line.\n\nExtended description.\n\nArgs:\n    name: description.\n\nReturns:\n    description.\n"""`

### Rust
- `///` for item docs, `//!` for module docs
- Markdown inside: code blocks with ```` ``` ````, lists, links
- First line: one-line summary

## Rules

- Preserve existing comments unless wrong/outdated
- Don't add trivial docs (e.g. `// foo sets foo` for `func setFoo()`)
- Code blocks: use language tag (`` ```go ``, `` ```ts ``, etc.)
- Keep docs concise; link to external refs instead of duplicating
- For framework-specific (kubebuilder, React, etc.) add the idiomatic annotations/markers

$ARGUMENTS
