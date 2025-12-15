# HelixTrack CRUSH.md

## Build Commands

### Core (Go)
- **Build**: `go build -o htCore main.go` or `./scripts/build.sh`
- **Release**: `./scripts/build.sh --release`
- **Single test**: `go test ./internal/models/ -v`
- **All tests**: `./scripts/verify-tests.sh` or `go test ./...`
- **Race detection**: `go test -race ./...`
- **Coverage**: `go test -cover ./...`
- **Format**: `go fmt ./...`
- **Lint**: `go vet ./...`

### Web Client (Angular)
- **Dev server**: `npm start` or `./scripts/start.sh`
- **Build**: `npm run build`
- **Tests**: `npm test` (unit), `npm run test:e2e` (E2E)
- **Single test**: `ng test --include="**/*.spec.ts"`
- **Lint**: `npm run lint`
- **Format**: `npm run format`
- **Type check**: `npm run type-check`

### Desktop Client (Tauri + Angular)
- **Dev**: `npm run tauri:dev`
- **Build**: `npm run tauri:build`
- **Tests**: `npm test` (unit), `npm run test:e2e` (E2E)
- **Lint**: `npm run lint`
- **Format**: `npm run format`

### Android Client
- **Build**: `./gradlew build`
- **Tests**: `./gradlew test`
- **APK**: `./gradlew assembleRelease`

### iOS Client
- **Build**: `swift build`
- **Tests**: `swift test` or `./run-full-tests.sh`
- **Xcode**: `xcodebuild test -scheme HelixTrack`

## Code Style Guidelines

### Go (Core)
- **Imports**: stdlib → third-party → local (blank line separated)
- **Naming**: PascalCase (exported), camelCase (unexported), snake_case.go (files)
- **Struct tags**: `json:"fieldName"`, `db:"field_name"`, `form:"fieldName"`
- **Error handling**: Return errors, use structured logging (zap)
- **Organization**: One struct per file, handlers in handlers/, models in models/
- **Formatting**: `go fmt`, 4-space indentation, no trailing whitespace

### TypeScript/Angular (Web/Desktop)
- **Imports**: Angular → third-party → local
- **Naming**: PascalCase (classes), camelCase (vars/functions), kebab-case (files)
- **Formatting**: Prettier (100 print width, single quotes)
- **Components**: Standalone components (Angular 19+), reactive patterns with RxJS
- **Services**: Injectable with providedIn: 'root', Observable-based APIs

### Swift (iOS)
- **Naming**: PascalCase (types), camelCase (vars/functions)
- **Structure**: SwiftUI views, ViewModels for state management
- **Services**: Protocol-oriented design, async/await patterns

### Kotlin (Android)
- **Naming**: PascalCase (classes), camelCase (vars/functions)
- **Architecture**: MVVM with LiveData/Flow, Repository pattern

## Testing Patterns
- **Unit tests**: Test individual functions/components
- **Integration tests**: Test service interactions
- **E2E tests**: Test complete user workflows
- **Coverage goals**: 100% unit, full integration, complete E2E
- **AI QA**: Automated intelligent testing (Desktop/iOS)

## Project Structure
- Always `cd` to specific project directory before running commands
- Core backend must be running for clients to function
- Backend URL configurable via settings (default: `https://localhost:8080`)

## Quality Gates
- Run `go vet` and `npm run lint` before committing
- Ensure all tests pass before merging
- Verify coverage meets project standards
- Use structured logging and proper error handling