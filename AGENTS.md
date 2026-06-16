# HelixTrack Agent Guidelines

> Base agent rules: `constitution/AGENTS.md` — READ IT FIRST.
> The base file is authoritative for any topic not covered here.
> Project-specific rules below extend them; they never weaken them.
> Full universal policy: `constitution/Constitution.md` (the constitution wins on any conflict).

## Build Commands
- **Quick build**: `go build -o htCore main.go`
- **Full build**: `./scripts/build.sh`
- **Release build**: `./scripts/build.sh --release`

## Test Commands
- **All tests**: `go test ./...`
- **Single test**: `go test -run TestFunctionName ./path/to/package`
- **With coverage**: `go test -cover ./...`
- **With race detection**: `go test -race ./...`
- **Comprehensive**: `./scripts/verify-tests.sh`

## Code Style Guidelines

### Language & Version
- Go 1.22+, follow standard conventions

### Imports
- Standard library first, third-party second, local packages last
- Blank lines between groups

### Naming
- **Exported**: PascalCase (Types, Functions, Constants)
- **Unexported**: camelCase (variables, functions)
- **Files**: snake_case.go, **Packages**: lowercase single word

### Struct Tags
- JSON: `json:"fieldName"`, Database: `db:"field_name"`, Form: `form:"fieldName"`

### Error Handling
- Return errors from functions, use structured logging with zap
- Check errors immediately after operations

### Code Organization
- One struct per file when possible, handlers in handlers package
- Models in models package, keep functions focused and small

### Formatting
- Use `go fmt` and `go vet`, no trailing whitespace, 4-space indentation