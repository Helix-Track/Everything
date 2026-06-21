# CodeGraph — HelixTrack Integration

## Overview

CodeGraph provides local SQLite semantic code-knowledge-graph for HelixTrack, enabling CLI agents to understand the codebase structure, symbols, and relationships.

**Constitution reference:** §11.4.78, §11.4.79, §11.4.80

## Current Status

- **Database:** `.codegraph/codegraph.db` (538 MB)
- **Config:** `.codegraph/config.json` (created)
- **MCP:** Configured in `.mcp.json`

## Configuration

Included: TypeScript, JavaScript, Go, Java, Kotlin, Swift, Dart, Vue, Svelte, HTML, CSS, SCSS

Excluded: node_modules, build artifacts, credentials, .env files

## Usage

```bash
# Re-index the project
cd /Volumes/T7/Projects/helix_track && codegraph index

# Check status
codegraph status

# Start MCP server
codegraph serve --mcp --path /Volumes/T7/Projects/helix_track
```

## MCP Integration

Configured in `.mcp.json`:
```json
{
  "codegraph": {
    "type": "stdio",
    "command": "/Users/milosvasic/.local/bin/codegraph",
    "args": ["serve", "--mcp", "--path", "/Volumes/T7/Projects/helix_track"]
  }
}
```

## HelixTrack-Specific Benefits

- **Multi-language indexing:** Go backend + Angular web + Kotlin Android + Swift iOS + Dart/Flutter
- **Cross-client symbol tracking:** Find where a backend API is used across all clients
- **Dependency graph:** Understand service relationships

## Cross-references
- constitution/Constitution.md §11.4.78 (CodeGraph mandate)
- constitution/Constitution.md §11.4.79 (own-org submodules included)
- constitution/Constitution.md §11.4.80 (regular update + sync)
