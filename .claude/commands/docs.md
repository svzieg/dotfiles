# Generate Documentation

Generate idiomatic documentation. Uses the docs sub-agent for language-aware doc generation.

## Instructions

1. Discover target: if `$ARGUMENTS` references a file or selection, document that. Otherwise use the current buffer.

2. Spawn the docs sub-agent using the Agent tool (agentType: "docs") with prompt:
"Generate idiomatic documentation for the following code. Detect the language/framework and apply matching conventions (Go → godoc, TypeScript → TSDoc, Python → Google-style docstrings, Rust → ///, Lua → ---). Match existing comment style. Don't add trivial docs. Preserve existing comments unless wrong. Keep docs concise.

Target: [insert the file content here]"

$ARGUMENTS
