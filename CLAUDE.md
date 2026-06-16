# CLAUDE.md

## INHERITED FROM constitution/CLAUDE.md

All rules in `constitution/CLAUDE.md` (and the
`constitution/Constitution.md` it references) apply unconditionally.
Project-specific rules below extend them — they do NOT weaken any
universal clause. When this file disagrees with the constitution
submodule, the constitution wins.

@constitution/CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**HelixTrack** is a comprehensive, modern, open-source JIRA alternative for the free world. It's a multi-platform project management and issue tracking system with a microservices architecture.

The project consists of:
- **Core** (Go backend) - RESTful API microservice with JWT authentication
- **Web-Client** (Angular 19) - Browser-based client application
- **Desktop-Client** (Tauri + Angular) - Cross-platform desktop application
- **Android-Client** (Kotlin/Java) - Native Android application
- **iOS-Client** (Swift) - Native iOS application

## Repository Structure

```
HelixTrack/
├── Core/                           # Go backend microservices (PRODUCTION READY)
│   ├── Application/                # Main API service
│   ├── Services/
│   │   └── Localization/          # Localization service (HTTP/3 QUIC) ✅ PRODUCTION READY
│   └── Tools/
│       └── KeyManager/            # Key management CLI tool ✅ PRODUCTION READY
├── Web-Client/                     # Angular web application
├── Desktop-Client/                 # Tauri desktop application
├── Android-Client/                 # Android native application
├── iOS-Client/                     # iOS native application
├── scripts/                        # Cross-project utility scripts
└── test-reports/                   # Consolidated test reports
```

## Core Backend (Go)

### Location
`Core/Application/`

### Build & Test Commands

```bash
# Navigate to Core
cd Core/Application

# Build
go build -o htCore main.go

# Run
./htCore
./htCore --config=../Configurations/dev.json

# Tests (comprehensive verification)
./scripts/verify-tests.sh

# Quick tests
go test ./...
go test -cover ./...
go test -race ./...

# Single package test
go test ./internal/models/
```

### Key Architecture Points

**Microservices Architecture:**
- **All services communicate via HTTP/3 QUIC** for optimal performance (30-50% reduced latency)
- Core service integrates with external Authentication and Permissions services
- All services are fully decoupled - can run on separate machines/clusters
- JWT-based authentication with claims validation
- **Localization Service** (✅ Production Ready):
  - Port: 8085 (HTTP/3 QUIC with TLS 1.3)
  - Multi-language support with variable interpolation
  - Multi-layer caching (In-memory LRU + Redis)
  - PostgreSQL with SQL Cipher encryption
  - 107 tests, 81.1% coverage
  - Integrated with all 5 client platforms
- **Key Manager Tool** (✅ Production Ready):
  - CLI tool for secure key generation and management
  - Supports: JWT secrets, DB keys, TLS certs, Redis passwords, API keys
  - 33 tests, 83.5% coverage
- Optional extensions: Times, Documents, Chats

**API Design:**
- Single unified `/do` endpoint with action-based routing
- Request format: `{"action": "create", "jwt": "...", "object": "ticket", "data": {...}}`
- Response format: `{"errorCode": -1, "errorMessage": "", "data": {...}}`
- **372 API actions**: 282 core (V1/V2/V3) + 90 Documents extension

**Database:**
- Multi-database support: SQLite (dev) and PostgreSQL (production)
- Three core schema versions:
  - V1 (61 tables): Core features - tickets, projects, workflows
  - V2 (72 tables): JIRA parity - priorities, versions, filters, custom fields
  - V3 (89 tables): Advanced features - epics, subtasks, dashboards, voting, notifications
- **Documents Extension**: 32 tables for Confluence-style document management (102% feature parity)
- **Total**: 121 tables (89 core + 32 documents)
- Migration scripts available in `Database/DDL/`

**Code Organization:**
- `internal/models/` - Data structures and domain models
- `internal/handlers/` - HTTP request handlers
- `internal/server/` - Gin Gonic server setup
- `internal/middleware/` - JWT validation, CORS
- `internal/database/` - Database abstraction layer
- `internal/services/` - External service clients (auth, permissions)

### Important Notes
- **1,769 total tests**: 1,375 core + 394 Documents extension model tests
- **71.9% average coverage** (core), Documents models 100% tested
- **Documents V2 Extension**: 95% complete (90 actions, 32 tables, 102% Confluence parity)
- All external services use interfaces for testing/mocking
- Service can run standalone with authentication/permissions disabled in config
- See `Core/CLAUDE.md` for detailed backend guidance

## Web Client (Angular 19)

### Location
`Web-Client/`

### Build & Test Commands

```bash
# Navigate to Web Client
cd Web-Client

# Install dependencies
npm install

# Development server (auto port selection, opens browser)
npm start
# Or use enhanced script
./scripts/start.sh

# Stop server
./scripts/stop.sh

# Build
npm run build              # Production build
npm run build:dev          # Development build

# Tests
npm test                   # Unit tests (ChromeHeadless, no watch)
npm run test:watch         # Unit tests with watch
npm run test:ci            # CI tests with coverage
npm run test:e2e           # E2E tests
npm run test:integration   # Integration tests

# Quality
npm run lint               # Lint code
npm run lint:fix           # Auto-fix linting issues
npm run format             # Format with Prettier
npm run type-check         # TypeScript validation

# Analysis
npm run build:analyze      # Bundle analysis
npm run docs               # Generate Compodoc documentation
```

### Key Architecture Points

**Technology Stack:**
- Angular 19+ with standalone components
- Angular Material for UI components
- RxJS for reactive state management
- Custom HTTP/3 QUIC service
- WebSocket for real-time updates

**Project Structure:**
- `src/app/core/` - Core services, guards, interceptors
- `src/app/features/` - Feature modules (auth, projects, tickets, boards, etc.)
- `src/app/layouts/` - Layout components (header, sidebar, footer)
- `src/app/shared/` - Shared/reusable components

**Design System:**
- HelixTrack brand colors: Primary `#0066cc`, Secondary `#00cc66`, Accent `#ff6600`
- Light/Dark theme with system preference detection
- WCAG 2.1 AA accessibility compliance
- Responsive design for all screen sizes

**Features:**
- Dynamic backend URL configuration (localStorage persisted)
- 234+ API action integrations
- JWT authentication with RBAC
- Real-time updates via WebSocket
- PWA with offline capability
- Comprehensive test coverage goals: 100% unit, full integration, complete E2E

### Important Notes
- Always configure backend URL via settings icon on login page
- Default backend: `https://localhost:8080`
- Enhanced startup includes auto port selection and landing page verification
- See `Web-Client/README.md` for comprehensive feature documentation

## Desktop Client (Tauri + Angular)

### Location
`Desktop-Client/`

### Build & Test Commands

```bash
# Navigate to Desktop Client
cd Desktop-Client

# Install dependencies
npm install

# Development (hot reload)
npm run tauri:dev

# Build for production
npm run tauri:build
npm run tauri:build:release

# Tests
npm test                   # Unit tests
npm run test:ci            # CI tests
npm run test:e2e           # E2E tests
npm run test:ai-qa         # AI QA tests

# Run AI QA automation
./scripts/run-ai-qa-tests.sh

# Quality
npm run lint
npm run format
npm run type-check
```

### Key Architecture Points

**Technology Stack:**
- Tauri 2.0+ with Rust backend
- Angular 19+ frontend (same as Web Client)
- SQLite with SQL Cipher for encrypted local storage
- HTTP/3 QUIC via Tauri invoke
- Live data synchronization between local and remote

**Desktop-Specific Features:**
- Local encrypted database for offline work
- Real-time bidirectional sync with server
- Native OS integrations via Tauri
- Cross-platform: Windows, macOS, Linux
- Multiple distribution formats: MSI, DMG, AppImage, DEB, RPM

**Project Structure:**
- `src/` - Angular frontend (mirrors Web-Client structure)
- `src-tauri/` - Rust backend with Tauri
- `src-tauri/icons/` - Application icons for all platforms

### Important Notes
- Requires Rust 1.77+ in addition to Node.js
- Uses WebView2 (Windows), WebKit (macOS), WebKitGTK (Linux)
- AI QA automation included for intelligent testing
- See `Desktop-Client/README.md` for deployment details

## Mobile Clients

### Android Client (`Android-Client/`)

**Build Commands:**
```bash
cd Android-Client

# Build
./gradlew build

# Run tests
./gradlew test

# Generate APK
./gradlew assembleDebug       # Debug build
./gradlew assembleRelease     # Release build

# Install on device
./gradlew installDebug
```

**Technology:**
- Kotlin/Java with Android SDK
- Gradle build system
- Native Android UI

### iOS Client (`iOS-Client/`)

**Build Commands:**
```bash
cd iOS-Client

# Build with Swift Package Manager
swift build

# Run tests
swift test
./run-full-tests.sh

# AI QA tests
./ai-qa-runner.js
```

**Technology:**
- Swift with SwiftUI
- Swift Package Manager
- Native iOS frameworks
- XCTest for testing

## Cross-Project Development

### Common Patterns

**Backend URL Configuration:**
All clients support dynamic backend URL configuration:
- Web/Desktop: Settings dialog on login page
- Mobile: Configuration screens in app settings
- Default: `https://localhost:8080`

**Authentication:**
- JWT tokens issued by external Authentication service
- Token contains: username, role, permissions, htCoreAddress
- All clients validate JWT and include in API requests

**API Communication:**
- All clients use the Core's unified `/do` endpoint
- Action-based request/response pattern
- Consistent error codes across all clients

### Testing Strategy

**Unit Tests:**
- Core: Go tests with testify framework (1,375 tests, 71.9% coverage)
- Web/Desktop: Karma + Jasmine (target 100% coverage)
- Android: JUnit/AndroidX Test
- iOS: XCTest

**Integration Tests:**
- API interaction tests in all clients
- Service integration verification
- WebSocket communication tests

**E2E Tests:**
- Web/Desktop: Cypress, Playwright, Puppeteer, TestCafe
- Mobile: Platform-specific frameworks
- Complete user workflow validation

**AI QA Automation:**
- Desktop and iOS clients include AI-powered test automation
- Intelligent test case generation
- Automated bug detection
- Performance regression analysis

### Common Development Tasks

**Starting the Full Stack:**
```bash
# Terminal 1: Start Core backend
cd Core/Application
./htCore --config=../Configurations/dev.json

# Terminal 2: Start Web Client
cd Web-Client
npm start

# Or Desktop Client
cd Desktop-Client
npm run tauri:dev
```

**Running Tests Across Projects:**
```bash
# From repository root
cd Core/Application && ./scripts/verify-tests.sh
cd ../../Web-Client && npm test
cd ../Desktop-Client && npm test
```

**Building All Clients:**
```bash
# Core
cd Core/Application && go build -o htCore main.go

# Web
cd Web-Client && npm run build

# Desktop
cd Desktop-Client && npm run tauri:build

# Android
cd Android-Client && ./gradlew assembleRelease

# iOS
cd iOS-Client && swift build
```

## Development Environment

### Prerequisites

**All Projects:**
- Git

**Core Backend:**
- Go 1.22+
- SQLite 3 or PostgreSQL 12+

**Web/Desktop Clients:**
- Node.js 18+
- npm or yarn
- Angular CLI 19+

**Desktop Client (additional):**
- Rust 1.77+
- Tauri CLI

**Android Client:**
- Android SDK
- Gradle 8.13+
- JDK 11+

**iOS Client:**
- Xcode (macOS only)
- Swift 5.5+

## Code Style Guidelines

### Go (Core)
- Follow standard Go conventions
- Imports: stdlib → third-party → local (separated by blank lines)
- Naming: PascalCase (exported), camelCase (unexported)
- Files: snake_case.go
- One struct per file when possible
- Return errors, don't panic
- Use structured logging (zap)

### TypeScript/Angular (Web/Desktop)
- ESLint with Angular rules
- Prettier formatting (100 print width, single quotes)
- Conventional commits
- JSDoc for public APIs
- Standalone components (Angular 19+)
- Reactive patterns with RxJS
- Material Design components

### Kotlin (Android)
- Standard Kotlin conventions
- Gradle build configuration

### Swift (iOS)
- Swift standard style
- SwiftUI for UI components
- Swift Package Manager

## Key Documentation Files

### Root Level
- `CLAUDE.md` - This file
- `AGENTS.md` - Agent-specific guidelines (if applicable)
- `TEST_RESULTS.md` - Consolidated test results

### Per-Project Documentation
- `Core/CLAUDE.md` - Detailed backend guidance (24KB, comprehensive)
- `Core/README.md` - Core project overview
- `Core/Application/docs/USER_MANUAL.md` - Complete API reference
- `Core/Application/docs/DEPLOYMENT.md` - Deployment guide
- `Web-Client/README.md` - Web client documentation
- `Web-Client/TESTING.md` - Testing strategy
- `Desktop-Client/README.md` - Desktop client documentation
- `Android-Client/README.md` - Android documentation
- `iOS-Client/README.md` - iOS documentation

## Important Notes

1. **Monorepo Structure**: This is a multi-project repository. Always `cd` to the specific project directory before running commands.

2. **Backend First**: Core backend must be running for clients to function. Start with `cd Core/Application && ./htCore`.

3. **Test Coverage**: Core has **1,769 total tests** (1,375 core at 98.8% pass rate + 394 Documents extension at 100%). Web/Desktop clients target 100% unit test coverage.

4. **Production Ready**: Core V1, V2, V3 features are production-ready. **Documents V2 Extension** is 95% complete (95% ready for production). Clients are in active development.

5. **JIRA + Confluence Alternative**: Full JIRA feature parity achieved in Core. **Documents V2 Extension provides 102% Confluence parity** (46 features). See `Core/Application/JIRA_FEATURE_GAP_ANALYSIS.md` and `Core/Application/DOCUMENTS_V2_FINAL_SESSION_REPORT.md`.

6. **Documents V2 Extension** (✅ 95% Complete):
   - **90 API actions** for Confluence-style document management
   - **32 database tables** with complete relationships
   - **394 model tests** (100% pass rate)
   - **102% Confluence parity**: Spaces, pages, version history, collaboration, templates, export, analytics
   - See `Core/Application/docs/USER_MANUAL.md` section "Documents V2" and `Core/Application/docs/DEPLOYMENT.md` section "Documents V2 Extension Deployment"
   - **Known Issue**: Database implementation has field mismatches (see `DOCUMENTS_V2_DATABASE_ISSUES.md`, 8-10 hours to fix)

7. **Microservices**: Authentication and Permissions are external services. Can be disabled in Core config for testing.

8. **Cross-Platform**: True cross-platform support - Web, Windows, macOS, Linux, Android, iOS.

9. **Modern Stack**: Go 1.22+, Angular 19+, Tauri 2.0+, latest mobile SDKs.

10. **Comprehensive Testing**: Unit, integration, E2E, and AI QA automation across all platforms.

11. **Open Source**: MIT licensed. JIRA + Confluence alternative for the free world.

---

**Project Status**:
- **Core**: Production-ready (V1/V2/V3 complete, 282 actions, 89 tables, 1,375 tests)
- **Documents V2 Extension**: 95% complete (90 actions, 32 tables, 394 model tests, 102% Confluence parity)
- **Clients**: Feature-complete and in testing/polish phase

**API Statistics**:
- **Total API Actions**: 372 (282 core + 90 documents)
- **Total Database Tables**: 121 (89 core + 32 documents)
- **Total Tests**: 1,769 (1,375 core + 394 documents)

**When in Doubt**: Refer to project-specific README.md and CLAUDE.md files in each subdirectory for detailed guidance.
