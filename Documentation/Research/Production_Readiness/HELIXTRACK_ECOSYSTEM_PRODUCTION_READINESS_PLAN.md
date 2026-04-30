# HelixTrack Ecosystem — Comprehensive Production Readiness Plan

## All Modules & Services — Anti-Bluff Verified Implementation Roadmap

**Document Version:** 2.0.0  
**Scope:** Entire HelixTrack ecosystem (7 repositories, 13 components)  
**Companion:** `HELIXTRACK_CORE_PRODUCTION_READINESS_PLAN.md` (Core-specific, 2,506 lines)  
**Classification:** PROJECT CONSTITUTION — BINDING FOR ALL CONTRIBUTORS AND AI AGENTS  

---

## TABLE OF CONTENTS

1. [Ecosystem Map & Repository Inventory](#1-ecosystem-map--repository-inventory)
2. [Cross-Module Dependency Graph](#2-cross-module-dependency-graph)
3. [Unified Anti-Bluff Audit Results](#3-unified-anti-bluff-audit-results)
4. [Module-by-Module Gap Analysis](#4-module-by-module-gap-analysis)
5. [Phase 0: Ecosystem Constitution](#5-phase-0-ecosystem-constitution)
6. [Phase 1: Core Application Remediation](#6-phase-1-core-application-remediation)
7. [Phase 2: Chat Service Remediation](#7-phase-2-chat-service-remediation)
8. [Phase 3: Localization Service Remediation](#8-phase-3-localization-service-remediation)
9. [Phase 4: Attachments Service Completion](#9-phase-4-attachments-service-completion)
10. [Phase 5: KeyManager Security Remediation](#10-phase-5-keymanager-security-remediation)
11. [Phase 6: QA-AI Framework Rebuild](#11-phase-6-qa-ai-framework-rebuild)
12. [Phase 7: Website Remediation](#12-phase-7-website-remediation)
13. [Phase 8: Cross-Service Integration](#13-phase-8-cross-service-integration)
14. [Phase 9: Unified Testing Strategy](#14-phase-9-unified-testing-strategy)
15. [Phase 10: Documentation & Release](#15-phase-10-documentation--release)
16. [Appendix A: Master Issue Tracker](#appendix-a-master-issue-tracker)
17. [Appendix B: Constitution Templates per Module](#appendix-b-constitution-templates-per-module)

---

## 1. ECOSYSTEM MAP & REPOSITORY INVENTORY

### 1.1 Organization: `Helix-Track` on GitHub

| Repository | URL | Language | LOC | Status | Purpose |
|-----------|-----|----------|-----|--------|---------|
| **Core** | github.com/Helix-Track/Core | Go | ~180K (source+tests) | Primary | REST API microservice |
| **Website** | github.com/Helix-Track/Website | HTML/CSS/JS | ~7,150 | Active | Marketing & documentation site |
| **Screensaver** | github.com/Helix-Track/Screensaver | Shell | ~87 | Abandoned | MATE desktop screensaver |
| **Website-Theme-Jekyll** | github.com/Helix-Track/Website-Theme-Jekyll | HTML/SCSS | ~700 | Abandoned | Forked Jekyll theme (never customized) |
| **Everything** | github.com/Helix-Track/Everything | — | — | **404** | Does not exist (referenced by user, not found) |

### 1.2 Component Hierarchy (Within Core Repository)

The Core repository contains 13 distinct components:

```
Core Repository (291 MB)
├── Application/                    # PRIMARY: Go REST API service
│   ├── internal/config/            # 267 lines — Config management
│   ├── internal/database/          # 4,958 lines — DB abstraction
│   ├── internal/server/            # 689 lines — Gin + HTTP/3
│   ├── internal/logger/            # 162 lines — Uber Zap
│   ├── internal/middleware/         # 1,120 lines — JWT, RBAC, CORS, rate limit
│   ├── internal/services/          # 2,592 lines — Auth, JWT, permissions
│   ├── internal/models/            # 14,577 lines — 33+ model files
│   ├── internal/handlers/          # 82,135 lines — 29+ handler files
│   ├── internal/security/          # Input validation, CSRF, DDoS, brute force
│   ├── internal/security/engine/   # RBAC engine, permission resolver
│   ├── internal/websocket/         # WebSocket manager, publisher
│   ├── internal/cache/             # LRU cache
│   ├── internal/client/            # HTTP/3 client
│   ├── internal/metrics/           # Metrics collection
│   ├── tests/                     # Integration + E2E tests
│   ├── qa-ai/                      # QA AI testing framework
│   └── docker/                     # Docker configs
│
├── Services/
│   ├── Chat/                       # Chat microservice (Go)
│   └── Localization/               # Localization microservice (Go)
│
├── Tools/
│   └── KeyManager/                 # CLI key management tool (Go)
│
├── Attachments-Service/            # File storage microservice (Go)
├── Extensions/                     # STUB — only "Tbd." README
├── Database/                       # SQL schemas (V1-V5 + extensions)
├── Configurations/                 # JSON configs
├── Documentation/                  # Service discovery docs
├── Website/                        # SUBMODULE — failed (empty)
└── [Various build/CI scripts]      # pre_open, post_open, commit, etc.
```

### 1.3 Component Statistics

| Component | Language | Source LOC | Test LOC | Test Files | Tests (claimed) | Tests (actual) | Status |
|-----------|----------|-----------|---------|-----------|-----------------|----------------|--------|
| **Application (Core)** | Go | 89,319 | 90,395 | 112 | 1,819 | ~1,500 (17+ skipped) | Functional with issues |
| **Chat Service** | Go | 6,147 | 2,750 | 8 | 105 | ~95 | 65-70% complete |
| **Localization Service** | Go | 8,077 | 2,400 | 26 | 116 | ~110 | 85% complete |
| **KeyManager** | Go | 909 | 1,420 | 2 | 33 | ~33 | 80% complete (security bluff) |
| **Attachments Service** | Go | 12,203 | 2,962 | 8 | ~60 | ~40 | 65% complete |
| **QA-AI** | Go | 1,194 | 0 | 0 | N/A | 0 | Won't compile |
| **Website** | HTML/CSS/JS | 7,150 | 0 | 0 | N/A | N/A | Functional with issues |
| **Screensaver** | Shell | 87 | 0 | 0 | N/A | N/A | Broken install script |
| **Jekyll Theme** | HTML/SCSS | 700 | 0 | 0 | N/A | N/A | Pure placeholder |
| **Extensions/** | — | 2 | 0 | 0 | N/A | N/A | Empty stub |
| **TOTAL** | | **~225,788** | **~99,927** | **~156** | **~2,133** | **~1,778** | |

---

## 2. CROSS-MODULE DEPENDENCY GRAPH

```
                    ┌──────────────┐
                    │   Website    │ (GitHub Pages → helixtrack.ru)
                    │  (HTML/JS)   │
                    └──────┬───────┘
                           │ Documents/links to
                    ┌──────▼───────┐
                    │   Core App   │ (Go REST API on :8080)
                    │  /do endpoint│
                    └──┬───┬───┬───┘
                       │   │   │
            ┌──────────┘   │   └──────────┐
            │              │              │
     ┌──────▼──────┐ ┌───▼──────┐ ┌──────▼──────┐
     │ Chat Service│ │ L10n Svc │ │ Attachments  │
     │  (:9090)    │ │ (:8085)  │ │  (:8090)     │
     └──────┬──────┘ └────┬─────┘ └──────┬──────┘
            │              │              │
            │     ┌────────▼────────┐     │
            │     │  KeyManager     │     │
            │     │  (CLI tool)     │     │
            │     └─────────────────┘     │
            │                             │
     ┌──────▼─────────────────────────────▼──────┐
     │         QA-AI Framework (broken)           │
     │   Tests Core API endpoints                 │
     └────────────────────────────────────────────┘

  Dependency Protocols:
  Core ↔ Chat:        HTTP (Core /do endpoint via CoreService client)
  Core ↔ Localization: HTTP/3 QUIC (catalog requests)
  Core ↔ Attachments: HTTP (file operations)
  All services:       JWT (signed by Auth Service — proprietary, not in repo)
  KeyManager:         Standalone CLI (generates keys for all services)
```

### 2.1 Integration Points (Current State)

| Source → Target | Protocol | Implementation | Working? |
|-----------------|----------|---------------|----------|
| Core → Chat | HTTP POST `/do` | `core_service.go` | ❌ baseURL wrong ("helixtrack-chat") |
| Core → Localization | HTTP/3 QUIC | `localization_service.go` | ✅ Works (when service running) |
| Core → Auth | HTTP/3 QUIC | `auth_service.go` | ⚠️ Real service returns "not implemented" |
| Core → Permissions | HTTP/3 QUIC | `permission_service.go` | ⚠️ Disabled = all allowed |
| Chat → Core | HTTP POST `/do` | `core_service.go` | ❌ baseURL wrong |
| Chat → Auth | JWT validation | `jwt.go` middleware | ✅ Works |
| All → KeyManager | CLI | N/A (standalone) | ✅ Works |
| QA-AI → Core | HTTP | `qa_agent.go` | ❌ Won't compile |

---

## 3. UNIFIED ANTI-BLUFF AUDIT RESULTS

### 3.1 Master Bluff Scorecard

| Component | Bluff Level | Key Findings |
|-----------|------------|--------------|
| **Core Application** | 🔴 **HIGH** | 6 stub export handlers, no-op event publisher, 17+ skipped tests, weak assertions in E2E, self-generated verification reports claiming 100% complete |
| **Chat Service** | 🟡 **MEDIUM** | WebSocket crashes on connection (nil map), CoreService URL wrong, 14 TODO WebSocket broadcasts, rate limiter per-request bug, 4 orphan model files, claims 89% but ~65% complete |
| **Localization Service** | 🟢 **LOW** | Genuinely implemented, 47 real DB methods, 843-line mock DB. Issues: encrypt/decrypt are no-ops, copy-paste bug in version counts, service discovery is placeholder |
| **Attachments Service** | 🟡 **MEDIUM** | Status doc contradicts reality (claims 0% for features that exist), S3 adapter buffers entire file in memory, duplicate health check goroutines, no storage integration tests |
| **KeyManager** | 🟡 **MEDIUM** | Claims "encrypted file-based storage" but nothing is encrypted — keys stored in plaintext JSON. Secrets printed to stdout. RSA key only 2048-bit. |
| **QA-AI** | 🔴 **CRITICAL** | Won't compile (undefined variables), `verifyDatabase` always returns true (fake passes), "AI" in name but zero AI integration, zero self-tests, status doc claims 100% for stubs |
| **Website** | 🟡 **MEDIUM** | 3 stale API action counts (235/297 vs actual 372), broken links, missing Open Graph tags claimed in README, duplicate h1 tags, dark theme broken on 3 pages |
| **Screensaver** | 🟢 **LOW** | Functional concept but install script doesn't actually install the .desktop file. Minor i18n inconsistencies. |
| **Jekyll Theme** | 🔴 **HIGH** | Entirely default Start Bootstrap boilerplate — zero HelixTrack content. `_config.yml` is blank. Outdated jQuery 1.x with known CVEs. |

### 3.2 Top 30 Critical Issues (Ecosystem-Wide, Priority Order)

| # | Severity | Component | Issue | File:Line |
|---|----------|-----------|-------|-----------|
| 1 | 🔴 CRITICAL | Core | Hardcoded JWT secret key | `middleware/jwt.go:95`, `services/jwt_service.go:22` |
| 2 | 🔴 CRITICAL | Core | Wildcard CORS in production | `server/server.go:325` |
| 3 | 🔴 CRITICAL | Core | 6 document export handlers are stubs | `handlers/document_handler.go:4448-4750` |
| 4 | 🔴 CRITICAL | Core | No FK constraints in 80+ tables | `Database/DDL/Definition.V1-V4.sql` |
| 5 | 🔴 CRITICAL | Core | Document DB uses SQLite-only `?` placeholders | `database/database_documents_impl.go` (3,033 lines) |
| 6 | 🔴 CRITICAL | QA-AI | Won't compile (undefined `respBody`, `duration`) | `qa-ai/agents/qa_agent.go:306,313` |
| 7 | 🔴 CRITICAL | QA-AI | `verifyDatabase` always returns true | `qa-ai/agents/qa_agent.go:381-383` |
| 8 | 🔴 CRITICAL | Chat | WebSocket nil map panic on connection | `server/server.go:44` |
| 9 | 🔴 CRITICAL | Chat | CoreService baseURL = "helixtrack-chat" (not a URL) | `services/core_service.go:32` |
| 10 | 🔴 HIGH | Chat | Rate limiter created per-request (disabled) | `middleware/ratelimit.go:107-134` |
| 11 | 🔴 HIGH | Chat | ChatRoomList returns ALL rooms (no authz) | `database/chatroom_repo.go:117` |
| 12 | 🔴 HIGH | Core | RBAC middleware consumes request body | `middleware/rbac.go:271-280` |
| 13 | 🔴 HIGH | Core | Report execution is placeholder | `handlers/report_handler.go:546` |
| 14 | 🔴 HIGH | Core | No-op EventPublisher by default | `handlers/handler.go:39` |
| 15 | 🟡 HIGH | Core | 17+ tests are t.Skip()-ed | `failover_manager_test.go:27,372,504,616,622` |
| 16 | 🟡 HIGH | KeyManager | Claims "encrypted storage" but plaintext JSON | `storage/storage.go:61-63` |
| 17 | 🟡 HIGH | KeyManager | Secrets printed to stdout | `cmd/main.go:207` |
| 18 | 🟡 HIGH | Attachments | S3 adapter buffers entire file in memory | `storage/adapters/s3.go:164-166` |
| 19 | 🟡 HIGH | Attachments | Duplicate health check goroutines (race) | `orchestrator/orchestrator.go:103,568` |
| 20 | 🟡 HIGH | Localization | encrypt/decrypt are no-ops | `database/database.go:158-176` |
| 21 | 🟡 HIGH | Localization | Version counts copy-paste bug | `handlers/version_handlers.go:245-247` |
| 22 | 🟡 MEDIUM | Core | V4 history tables use invalid INDEX syntax | `Database/DDL/Definition.V4.sql:71-74` |
| 23 | 🟡 MEDIUM | Core | Indexes_Performance.sql references 20+ non-existent columns | `Database/DDL/Indexes_Performance.sql` |
| 24 | 🟡 MEDIUM | Chat | Role validation accepts any string | `handlers/participant_handler.go:217` |
| 25 | 🟡 MEDIUM | Chat | MessageUpdate always sets IsEdited=true (bug) | `database/message_repo.go:65` |
| 26 | 🟡 MEDIUM | Website | Missing Open Graph tags (README claims they exist) | All HTML files |
| 27 | 🟡 MEDIUM | Website | Stale API counts (235/297 vs 372) | `book/index.html`, `implementation.html` |
| 28 | 🟢 MEDIUM | Screensaver | Install script doesn't copy .desktop file | `install.sh:49` |
| 29 | 🟢 LOW | Jekyll | All content is Start Bootstrap boilerplate | All HTML/SCSS files |
| 30 | 🟢 LOW | Jekyll | Outdated jQuery 1.x with CVEs | `js/jquery.js` |

---

## 4. MODULE-BY-MODULE GAP ANALYSIS

### 4.1 Core Application (detailed in companion plan)

**Refer to:** `HELIXTRACK_CORE_PRODUCTION_READINESS_PLAN.md` (2,506 lines)

**Summary of Critical Gaps:**
- 4 security vulnerabilities (hardcoded JWT, wildcard CORS, permission bypass, RBAC body consumption)
- 6 stub export handlers returning fake success
- Database schema lacks FK constraints (80+ tables)
- Document DB incompatible with PostgreSQL
- 17+ skipped tests, weak E2E assertions
- No-op event publisher
- No anti-bluff constitution

### 4.2 Chat Service

**Implementation Status: Real at 65-70% (not 89% as claimed)**

**What's Real:**
- ✅ 30 HTTP handler actions fully implemented
- ✅ PostgreSQL database layer with real SQL (15+ repository methods)
- ✅ JWT authentication middleware
- ✅ CORS and rate limiting middleware
- ✅ Message search with PostgreSQL full-text search
- ✅ Edit history tracking
- ✅ Soft delete pattern throughout
- ✅ Role-based access control
- ✅ HTTP/3 QUIC server support

**What's Broken/Stubs:**
- ❌ WebSocket connection will panic (nil map — `server.go:44`)
- ❌ WebSocket broadcast sends to ALL users, not room-scoped (`server.go:350-363`)
- ❌ 14 TODO comments for WebSocket event broadcasting
- ❌ `AttachmentUpload` returns 501 "Not yet implemented" (`realtime_handler.go:324-327`)
- ❌ CoreService baseURL is "helixtrack-chat" — not a valid URL (`core_service.go:32`)
- ❌ DDOSProtectionMiddleware creates new RateLimiter per request (`ratelimit.go:107-134`)
- ❌ Rate limiter cleanup nukes ALL limiters when count > 1000 (`ratelimit.go:66-77`)
- ❌ 4 orphan model files: export.go, sharing.go, tag.go, mention.go (no handlers)
- ❌ No database layer tests
- ❌ JWT accepted from URL query params (security leak — `jwt.go:70-77`)
- ❌ Role validation accepts any arbitrary string (`participant_handler.go:217`)
- ❌ MessageUpdate always sets IsEdited=true even for pin/unpin (`message_repo.go:65`)
- ❌ MessageQuote never sets QuotedMessageID (`message_handler.go:433-446`)
- ❌ ChatRoomList returns ALL rooms to any user (`chatroom_repo.go:117`)
- ❌ SQLCipher mentioned in README but no code exists

**Test Status:**
- 8 test files, ~2,750 lines of tests
- Config tests: ⭐⭐⭐⭐ Good
- Handler tests: ⭐⭐⭐ Adequate (weak on verifying DB function arguments)
- Middleware tests: ⭐⭐⭐⭐ Good
- Server tests: ⭐⭐ Weak (MockDatabase doesn't implement interface)
- Database tests: ⭐ Zero — none exist

### 4.3 Localization Service

**Implementation Status: Real at 85% — highest quality module**

**What's Real:**
- ✅ 47 database interface methods all with real PostgreSQL implementations
- ✅ 843-line thread-safe mock database
- ✅ 24 handler methods with caching, audit logging, WebSocket events
- ✅ LRU cache with eviction and pattern matching (344 lines)
- ✅ Real XLIFF 1.2 export (valid XML output)
- ✅ Real CSV export
- ✅ WebSocket pub/sub manager with ping/pong
- ✅ HTTP/3 QUIC support
- ✅ Seed data for 10 languages
- ✅ Comprehensive config with env var overrides
- ✅ Proper error chain with errors.As/Unwrap

**What's Stubs/Bugs:**
- ❌ `encrypt()` and `decrypt()` are no-ops with TODO comments (`database.go:158-176`)
- ❌ Version count copy-paste bug — keysCount/languagesCount/totalLocalizations all call CountVersions() (`version_handlers.go:245-247`)
- ❌ Service discovery (Consul/etcd) registration is placeholder
- ❌ WebSocket CheckOrigin always returns true (`manager.go:19`)
- ⚠️ `HandleBatchLocalizations` uses raw `gin.H` instead of `models.ErrorResponse` (`import_export_handlers.go:572-576`)
- ⚠️ 7 WebSocket methods are dead code (never called from handlers)

### 4.4 Attachments Service

**Implementation Status: Real at 65% (status doc claims 40% — doc is wrong)**

**What's Real:**
- ✅ Upload handler with multipart form data
- ✅ Download handler with HTTP range requests
- ✅ Local filesystem storage adapter with sharding
- ✅ S3 storage adapter (AWS SDK v2)
- ✅ MinIO storage adapter
- ✅ Orchestrator with circuit breaker and retry logic
- ✅ Security scanner interface
- ✅ Rate limiter
- ✅ Input validator
- ✅ File hasher (SHA-256)
- ✅ 8 PostgreSQL tables with triggers

**What's Broken/Stubs:**
- ❌ S3 adapter buffers entire file into memory (`s3.go:164-166`) — memory bomb
- ❌ S3 `isNotFoundError` uses fragile string matching (`s3.go:507-509`)
- ❌ S3 `GetStorageStats` is O(n) HeadObject calls (`s3.go:456-471`)
- ❌ Orchestrator also buffers with `io.ReadAll` (`orchestrator.go:151`)
- ❌ Duplicate health check goroutines (race condition — `orchestrator.go:103,568`)
- ❌ `HandleMetadata` downloads entire file to return metadata (`download.go:329`)
- ❌ `UploadRequest.Tags` binding broken for `[]string` (`upload.go:83`)
- ❌ `reference/counter.go:303-304` — GetStatistics returns "not implemented"
- ❌ Service watching is placeholder (`service_registry.go:119-121`)
- ❌ routes.go passes zero-value deduplication engine (`routes.go:127`)
- ❌ IMPLEMENTATION_STATUS.md claims storage/security/middleware are "0% Not started" but they're fully implemented
- ❌ No integration tests for storage adapters

### 4.5 KeyManager

**Implementation Status: Functional but security model is bluff**

**What's Real:**
- ✅ CLI tool for generating JWT secrets, DB keys, TLS certs, Redis passwords, API keys
- ✅ File-based storage with JSON metadata
- ✅ Export to JSON, YAML, ENV formats
- ✅ Key rotation with version tracking
- ✅ 33 tests, good coverage

**What's Bluff:**
- ❌ Claims "Encrypted file-based storage" — `keys.json` stores ALL values in plaintext (`storage.go:61-63`)
- ❌ Secrets printed to stdout after generation (`main.go:207`)
- ❌ RSA keys only 2048-bit (NIST recommends 3072+) (`generator.go:102`)
- ❌ Self-signed cert hardcoded to localhost only (`generator.go:117-126`)
- ❌ Export writes plaintext secrets to files (`storage.go:173-208`)
- ❌ No file locking on `keys.json` — concurrent access corrupts data
- ❌ No `--show-value` flag — secrets always shown

### 4.6 QA-AI Framework

**Implementation Status: FAKE — won't compile, fake passes**

**What's Broken:**
- ❌ **Won't compile**: `qa_agent.go:306` references undefined `respBody`, line 313 references undefined `duration`
- ❌ `verifyDatabase()` always returns `true` — all DB checks are fake passes (`qa_agent.go:381-383`)
- ❌ "AI" in name but zero AI integration — no LLM calls, no intelligent test generation
- ❌ Agent selection always returns first agent (`orchestrator.go:237-238`)
- ❌ ConcurrentTests config field never used
- ❌ ScreenshotOnFail config field never used
- ❌ AIModel/AITemperature/AIMaxTokens config fields never used
- ❌ Zero tests for itself
- ❌ Hardcoded test passwords in source (`config/qa_config.go:91-136`)
- ❌ IMPLEMENTATION_STATUS.md claims 100% for components that are stubs
- ❌ JSONPath verification only supports simple dot-notation (no array indexing)

### 4.7 Website

**Implementation Status: Functional but outdated and inconsistent**

**Issues:**
- ❌ API action count stale: 235 (book/README) and 297 (implementation footer) vs actual 372
- ❌ JIRA parity self-contradicts: 85% vs 90% vs 100% within same page
- ❌ Missing Open Graph / canonical meta tags (README claims they exist)
- ❌ 3 missing referenced files (Wide_Black.png, JIRA_FEATURE_GAP_ANALYSIS.md, COMPREHENSIVE_TEST_REPORT.md)
- ❌ Dark theme broken on http3-quic.html, localization.html, diagrams.html
- ❌ localization.html breaks site design (no navbar, no theme, own CSS)
- ❌ Duplicate h1 tags on 4 pages (accessibility violation)
- ❌ Version numbers in API examples stale (1.0.0/2.0.0 instead of 4.0.0)
- ❌ Phase 1 action count wrong (40 vs actual 45)
- ❌ No favicon
- ❌ No ARIA attributes on interactive elements
- ❌ No skip-to-content link

### 4.8 Screensaver

**Issues:**
- ❌ Install script copies SVG but never copies .desktop file
- ❌ 6 locales still reference "GNOME" or "MATE" instead of "HelixTrack"
- ❌ No uninstall script
- ❌ Copyright holder unfilled in LICENSE

### 4.9 Jekyll Theme

**Issues:**
- ❌ Entirely default Start Bootstrap boilerplate — zero HelixTrack content
- ❌ `_config.yml` completely blank
- ❌ jQuery 1.x with known CVEs
- ❌ IE8 shims for obsolete browser
- ❌ No Gemfile for dependency management
- ❌ `cbpAnimatedHeader.js` included but never loaded
- ❌ 518 KB of vendored assets in git

---

## 5. PHASE 0: ECOSYSTEM CONSTITUTION

**Duration:** 3-5 days  
**Priority:** MANDATORY — must precede all other phases

### 5.1 Task 0.1: Create Ecosystem-Wide Constitution

**Files:** (NEW — one per module)

Create `CONSTITUTION.md` in every module directory following this template:

```markdown
# [Module Name] Constitution

## Anti-Bluff Principle

1. NO feature may be marked "complete" unless it works end-to-end
2. NO test may pass if the feature it tests does not actually work
3. All test assertions MUST verify concrete, observable outcomes
4. Stub implementations MUST return error codes (not success) and be labeled // STUB:
5. Every documentation claim MUST be verifiable by running the test suite

## Testing Requirements

1. Every public function MUST have at least one test verifying real behavior
2. Integration tests MUST use real database/storage (not mocks)
3. t.Skip() is PROHIBITED without tracking issue
4. Test coverage below 80% blocks merge
5. "AI" or "intelligent" labels require actual AI/ML integration

## Security Requirements

1. No secrets in source code
2. No wildcard CORS in production configs
3. All external inputs MUST be validated
4. "Encrypted" claims require actual encryption implementation
5. All security tests MUST use real tokens (not mocks)

## Documentation Requirements

1. All public APIs documented with request/response examples
2. All configuration options documented with defaults
3. README status claims MUST match test results
4. Version numbers MUST be consistent across all files
```

**Modules requiring Constitution:**
- `Application/CONSTITUTION.md`
- `Services/Chat/CONSTITUTION.md`
- `Services/Localization/CONSTITUTION.md`
- `Tools/KeyManager/CONSTITUTION.md`
- `Attachments-Service/CONSTITUTION.md`
- `Application/qa-ai/CONSTITUTION.md`

### 5.2 Task 0.2: Update All CLAUDE.md and AGENTS.md

For each module that has (or should have) CLAUDE.md / AGENTS.md:

**Add section:**
```markdown
## Constitution Reference
This module is governed by CONSTITUTION.md in its root directory.
All contributors and AI agents MUST read and follow these rules before any code change.

## Anti-Bluff Rules
1. A passing test that doesn't verify real behavior is a BUG
2. Documentation claims must be test-verified
3. "Production Ready" requires anti-bluff verified tests passing
4. Stubs MUST be labeled and MUST return error codes
```

### 5.3 Task 0.4: Remove Binaries and Backup Files

**Files to delete (committed binaries):**
- `Tools/KeyManager/keymanager` (compiled binary)
- `Attachments-Service/attachments-service` (compiled binary)
- `Services/Localization/localization-service` (compiled binary)
- `Services/Localization/localization-service-test` (compiled binary)

**Files to delete (backups):**
- `Attachments-Service/internal/handlers/upload_test.go.backup`
- `Services/Localization/internal/security/engine/role_evaluator_test.go.bak`
- `Services/Localization/internal/security/engine/security_level_checker_test.go.bak`
- `Database/Definition.sqlite.backup.*`

**Add to .gitignore:**
```
*.backup
*.bak
*_test.go.backup
*_test.go.bak
*.sqlite.backup.*
```

### 5.5 Task 0.6: Fix .gitmodules

**File:** `.gitmodules` (Core root)
```
[submodule "Website"]
    path = Website
-   url = git@github.com:Helix-Track/Website.git
+   url = https://github.com/Helix-Track/Website.git
```

---

## 6. PHASE 1: CORE APPLICATION REMEDIATION

**Duration:** 16-22 weeks  
**Priority:** CRITICAL  
**Detailed Plan:** See companion document `HELIXTRACK_CORE_PRODUCTION_READINESS_PLAN.md`

**Summary of Key Tasks (from companion plan):**
- Phase 0: Foundation & Constitution (3-5 days)
- Phase 1: Database Schema Remediation (2-3 weeks)
- Phase 2: Security Hardening (1-2 weeks)
- Phase 3: Anti-Bluff API Remediation (3-4 weeks)
- Phase 4: Document Extension Completion (2-3 weeks)
- Phase 5: Testing Constitution (4-6 weeks, parallel)
- Phase 6: Service Integration (2-3 weeks)
- Phase 7: Configuration Overhaul (1 week)
- Phase 8: Performance & Reliability (2 weeks)
- Phase 9: UX & Enterprise Readiness (2-3 weeks)
- Phase 10: Documentation (2-3 weeks)

---

## 7. PHASE 2: CHAT SERVICE REMEDIATION

**Duration:** 3-4 weeks  
**Priority:** HIGH  
**Dependencies:** Phase 0 complete

### 7.1 Task 2.1: Fix WebSocket Crash (CRITICAL)

**File:** `Services/Chat/internal/server/server.go:44`

**Current:** `connections map[string]*websocket.Conn` is nil
**Fix:**
```go
type Server struct {
    // ...
    connections map[string]*websocket.Conn
    connMu     sync.RWMutex
}

func NewServer(/*...*/) *Server {
    return &Server{
        // ...
        connections: make(map[string]*websocket.Conn),
    }
}
```

### 7.2 Task 2.2: Fix CoreService URL

**File:** `Services/Chat/internal/services/core_service.go:32`

**Current:** `baseURL: config.JWT.Issuer` → "helixtrack-chat"
**Fix:** Add `core_service_url` to config, default to `http://localhost:8080`

### 7.3 Task 2.3: Fix Rate Limiter Per-Request Bug

**File:** `Services/Chat/internal/middleware/ratelimit.go:107-134`

**Fix:** Move `rateLimiter` creation outside the handler closure:
```go
limiter := NewRateLimiter(rateLimit)  // Create ONCE, not per-request
middleware := func(c *gin.Context) {
    // Use shared limiter
}
```

### 7.4 Task 2.4: Fix Rate Limiter Nuclear Cleanup

**File:** `Services/Chat/internal/middleware/ratelimit.go:66-77`

**Fix:** Remove expired entries by last access time, not all entries:
```go
func (r *rateLimiter) cleanup() {
    r.mu.Lock()
    defer r.mu.Unlock()
    for ip, bucket := range r.buckets {
        if time.Since(bucket.lastAccess) > 5*time.Minute {
            delete(r.buckets, ip)
        }
    }
}
```

### 7.5 Task 2.5: Add Role Validation

**File:** `Services/Chat/internal/handlers/participant_handler.go:217`

**Fix:**
```go
validRoles := map[string]bool{
    models.RoleOwner: true,
    models.RoleAdmin: true,
    models.RoleModerator: true,
    models.RoleMember: true,
}
if !validRoles[roleStr] {
    c.JSON(http.StatusBadRequest, models.ErrorResponse(models.ErrInvalidRole))
    return
}
```

### 7.6 Task 2.6: Fix MessageUpdate IsEdited Bug

**File:** `Services/Chat/internal/database/message_repo.go:65`

**Fix:** Pass `isEdited` as parameter instead of hardcoding true:
```go
func (r *MessageRepo) Update(ctx context.Context, msg *models.Message) error {
    // Don't unconditionally set IsEdited=true
    // Only set it when content actually changes
}
```

### 7.7 Task 2.7: Fix MessageQuote Bug

**File:** `Services/Chat/internal/handlers/message_handler.go:433-446`

**Fix:** Set `QuotedMessageID` on the message before creating:
```go
quotedID := getString(data, "quoted_message_id")
if quotedID != "" {
    // Verify quoted message exists
    _, err := h.db.MessageRead(ctx, quotedID)
    if err != nil {
        c.JSON(http.StatusNotFound, models.ErrorResponse(models.ErrMessageNotFound))
        return
    }
    msg.QuotedMessageID = &quotedID
}
```

### 7.8 Task 2.8: Add Room Scoping to ChatRoomList

**File:** `Services/Chat/internal/database/chatroom_repo.go:117`

**Fix:** Add user-based filtering:
```sql
SELECT cr.* FROM chat_rooms cr
LEFT JOIN participants p ON p.room_id = cr.id AND p.user_id = $1
WHERE cr.deleted = false AND (cr.type IN ('public', 'entity') OR p.id IS NOT NULL)
ORDER BY cr.created DESC LIMIT $2 OFFSET $3
```

### 7.9 Task 2.9: Implement WebSocket Room-Scoped Broadcasting

**File:** `Services/Chat/internal/server/server.go:350-363`

**Fix:** Add room membership tracking and filter broadcasts:
```go
func (s *Server) broadcastToRoom(roomID string, message []byte) {
    s.connMu.RLock()
    defer s.connMu.RUnlock()
    for userID, conn := range s.connections {
        if s.isUserInRoom(userID, roomID) {
            conn.WriteMessage(websocket.TextMessage, message)
        }
    }
}
```

### 7.10 Task 2.10: Implement AttachmentUpload

**File:** `Services/Chat/internal/handlers/realtime_handler.go:324-327`

**Current:** Returns 501 "Not yet implemented"
**Implementation:** Integrate with Attachments-Service or local file storage

### 7.11 Task 2.11: Add Database Layer Tests

**Scope:** All repository files (chatroom_repo.go, message_repo.go, participant_repo.go, realtime_repo.go)
**Requirement:** Each method must have at least one integration test using real PostgreSQL

### 7.12 Task 2.12: Remove JWT from URL Query Params

**File:** `Services/Chat/internal/middleware/jwt.go:70-77`

**Fix:** Remove query parameter token extraction — only accept via Authorization header

### 7.13 Task 2.13: Fix Connection String SQL Injection

**File:** `Services/Chat/internal/database/database.go:88-97`

**Fix:** Use `pq.ParseURL()` or proper escaping instead of `fmt.Sprintf`

### 7.14 Task 2.14: Remove Orphan Model Files or Implement Handlers

**Files:** `export.go`, `sharing.go`, `tag.go`, `mention.go`

**Decision needed:** Either implement handlers/DB for these features, or remove the model files and update documentation to remove feature claims

### 7.15 Task 2.15: Update IMPLEMENTATION_STATUS.md

**Action:** Replace inflated claims with verified status based on actual test results

---

## 8. PHASE 3: LOCALIZATION SERVICE REMEDIATION

**Duration:** 1-2 weeks  
**Priority:** MEDIUM  
**Dependencies:** Phase 0 complete

### 8.1 Task 3.1: Implement Encryption

**File:** `Services/Localization/internal/database/database.go:158-176`

**Current:** `encrypt()` and `decrypt()` are no-ops
**Fix:** Implement AES-256-GCM encryption using the configured encryption key:
```go
func (d *PostgresDatabase) encrypt(value string) (string, error) {
    block, err := aes.NewCipher(d.encryptionKey)
    if err != nil {
        return "", err
    }
    gcm, err := cipher.NewGCM(block)
    if err != nil {
        return "", err
    }
    nonce := make([]byte, gcm.NonceSize())
    if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
        return "", err
    }
    ciphertext := gcm.Seal(nonce, nonce, []byte(value), nil)
    return base64.StdEncoding.EncodeToString(ciphertext), nil
}
```

### 8.2 Task 3.2: Fix Version Count Copy-Paste Bug

**File:** `Services/Localization/internal/handlers/version_handlers.go:245-247`

**Current:** All three variables call `CountVersions()`
**Fix:**
```go
keysCount, _ := h.db.CountLocalizationKeys(ctx)
languagesCount, _ := h.db.CountLanguages(ctx)
totalLocalizations, _ := h.db.CountLocalizations(ctx)
```

### 8.3 Task 3.3: Fix Error Response Consistency

**File:** `Services/Localization/internal/handlers/import_export_handlers.go:572-576`

**Fix:** Replace `gin.H{"success": false, "error": ...}` with `models.ErrorResponse(...)`

### 8.4 Task 3.4: Restrict WebSocket Origin

**File:** `Services/Localization/internal/websocket/manager.go:19`

**Fix:** Read allowed origins from config, reject non-matching origins

### 8.5 Task 3.5: Remove Dead WebSocket Methods or Document

**Action:** Either integrate the 7 dead convenience methods or remove them

### 8.6 Task 3.6: Add Integration Tests for Version Handlers

**Scope:** Test that `CreateVersion` stores correct keysCount/languagesCount/totalLocalizations after bug fix

---

## 9. PHASE 4: ATTACHMENTS SERVICE COMPLETION

**Duration:** 3-4 weeks  
**Priority:** HIGH  
**Dependencies:** Phase 0 complete

### 9.1 Task 4.1: Stream S3 Uploads

**File:** `Attachments-Service/internal/storage/adapters/s3.go:164-166`

**Fix:** Use `io.Reader` directly with PutObject instead of buffering:
```go
func (a *S3Adapter) Store(ctx context.Context, id string, data io.Reader, meta StorageMetadata) error {
    _, err := a.client.PutObject(ctx, &s3.PutObjectInput{
        Bucket:      aws.String(a.bucket),
        Key:         aws.String(a.keyPrefix + id),
        Body:        data,  // Stream directly
        ContentType: aws.String(meta.ContentType),
    })
    return err
}
```

### 9.2 Task 4.2: Fix S3 Error Detection

**File:** `Attachments-Service/internal/storage/adapters/s3.go:507-509`

**Fix:** Use typed AWS SDK v2 errors:
```go
func (a *S3Adapter) isNotFoundError(err error) bool {
    var nfe *types.NoSuchKey
    var nbe *types.NoSuchBucket
    return errors.As(err, &nfe) || errors.As(err, &nbe)
}
```

### 9.3 Task 4.3: Fix S3 Storage Stats Performance

**File:** `Attachments-Service/internal/storage/adapters/s3.go:456-471`

**Fix:** Use ListObjectsV2 with metrics or a separate metadata table

### 9.4 Task 4.4: Fix Duplicate Health Check Goroutines

**File:** `Attachments-Service/internal/storage/orchestrator/orchestrator.go:103,568`

**Fix:** Remove the second goroutine spawn in `StartHealthMonitor` (it's already started in constructor)

### 9.5 Task 4.5: Fix Metadata Handler Efficiency

**File:** `Attachments-Service/internal/handlers/download.go:329`

**Fix:** Query database directly for metadata instead of downloading the file:
```go
func (h *MetadataHandler) HandleGetMetadata(c *gin.Context) {
    id := c.Param("id")
    file, err := h.db.GetFile(c.Request.Context(), id)
    // Return file metadata from DB, not from download
}
```

### 9.6 Task 4.6: Fix Tags Binding

**File:** `Attachments-Service/internal/handlers/upload.go:83`

**Fix:** Implement custom binder for `[]string` tags field

### 9.7 Task 4.7: Implement Reference Counter

**File:** `Attachments-Service/internal/storage/reference/counter.go:303-304`

**Current:** `GetStatistics` returns "not implemented"
**Fix:** Implement using database queries

### 9.8 Task 4.8: Fix Deduplication Engine Integration

**File:** `Attachments-Service/internal/handlers/routes.go:127`

**Current:** Zero-value `deduplication.Engine{}` passed instead of real engine
**Fix:** Initialize real deduplication engine in main.go and pass to handlers

### 9.9 Task 4.9: Update IMPLEMENTATION_STATUS.md

**Action:** Correct contradictory claims — storage/security/middleware are implemented, not "0% Not started"

### 9.10 Task 4.10: Add Integration Tests

**Scope:** Storage adapters (local, S3), orchestrator, complete upload→download flow

---

## 10. PHASE 5: KEYMANAGER SECURITY REMEDIATION

**Duration:** 1 week  
**Priority:** HIGH  
**Dependencies:** Phase 0 complete

### 10.1 Task 5.1: Implement Actual Encryption

**File:** `Tools/KeyManager/internal/storage/storage.go:61-63`

**Current:** Keys stored in plaintext JSON
**Fix:** Implement AES-256-GCM encryption for the `keys.json` file and individual `.key` files:
```go
func (s *Storage) encryptData(data []byte) ([]byte, error) {
    // Use master encryption key (from env var or generated on first run)
    // Encrypt entire keys.json with AES-256-GCM
}
```

### 10.2 Task 5.2: Stop Printing Secrets to Stdout

**File:** `Tools/KeyManager/cmd/main.go:207`

**Fix:** Print only key ID by default, add `--show-value` flag:
```go
if showValue {
    fmt.Printf("  Value:   %s\n", key.Value)
} else {
    fmt.Printf("  Value:   [hidden — use --show-value]\n")
}
```

### 10.3 Task 5.3: Upgrade RSA Key Size

**File:** `Tools/KeyManager/internal/generator/generator.go:102`

**Fix:** Change from 2048 to 4096:
```go
const defaultRSAKeySize = 4096
```

### 10.4 Task 5.4: Remove "Encrypted" Claims or Implement

**Action:** Either implement real encryption (Task 5.1) or remove "Encrypted" from README and all documentation

### 10.5 Task 5.5: Add File Locking

**File:** `Tools/KeyManager/internal/storage/storage.go:258-288`

**Fix:** Use `syscall.Flock` for concurrent access safety

### 10.6 Task 5.6: Fix UTF-8 Truncation

**File:** `Tools/KeyManager/cmd/main.go:329-333`

**Fix:** Use rune-aware truncation:
```go
func truncate(s string, maxLen int) string {
    runes := []rune(s)
    if len(runes) <= maxLen {
        return s
    }
    return string(runes[:maxLen-3]) + "..."
}
```

### 10.7 Task 5.7: Fix JSON→YAML Silent Fallback

**File:** `Tools/KeyManager/internal/storage/storage.go:222-226`

**Fix:** Detect file extension or content type before attempting parse

---

## 11. PHASE 6: QA-AI FRAMEWORK REBUILD

**Duration:** 3-4 weeks  
**Priority:** HIGH  
**Dependencies:** Phase 0 complete

### 11.1 Task 6.1: Fix Compile Errors (CRITICAL)

**File:** `Application/qa-ai/agents/qa_agent.go:306,313`

**Fix:**
```go
// Line 306: Change `respBody` to `body`
if !agent.verifyJSONPath([]byte(body), expected.JSONPath) {

// Line 313: Add duration tracking
start := time.Now()
resp, err := agent.httpClient.Do(req)
duration := time.Since(start)
if expected.ResponseTime > 0 && duration > expected.ResponseTime {
```

### 11.2 Task 6.2: Implement Real Database Verification

**File:** `Application/qa-ai/agents/qa_agent.go:381-383`

**Current:** `return true` unconditionally
**Fix:** Connect to test database, run verification queries:
```go
func (agent *QAAgent) verifyDatabase(expected testcases.ExpectedDBState) bool {
    db, err := sql.Open("postgres", agent.config.DatabaseURL)
    // Query actual tables and verify expected data exists
    var count int
    db.QueryRow("SELECT COUNT(*) FROM tickets WHERE id = $1", expected.EntityID).Scan(&count)
    return count > 0
}
```

### 11.3 Task 6.3: Remove "AI" Label or Implement AI Integration

**Decision needed:**
- **Option A:** Rename to "QA Framework" (honest naming)
- **Option B:** Implement actual AI features (LLM test generation, self-healing, intelligent assertion)

### 11.4 Task 6.4: Add Self-Tests

**Action:** Create `qa-ai/agents/qa_agent_test.go` and `qa-ai/orchestrator/orchestrator_test.go`
**Minimum:** Test HTTP execution, variable substitution, assertion logic, result reporting

### 11.5 Task 6.5: Implement Proper JSONPath

**File:** `Application/qa-ai/agents/qa_agent.go:440-454`

**Fix:** Use a real JSONPath library (e.g., `github.com/oliveagle/jsonpath`) or implement array indexing

### 11.6 Task 6.6: Implement Concurrent Test Execution

**File:** `Application/qa-ai/config/qa_config.go:21`

**Current:** `ConcurrentTests` field exists but is never used
**Fix:** Implement goroutine-based concurrent execution with worker pool

### 11.7 Task 6.7: Update IMPLEMENTATION_STATUS.md

**Action:** Replace all "100% Complete" claims with accurate status. Remove claims for unimplemented features.

### 11.8 Task 6.8: Remove Hardcoded Passwords

**File:** `Application/qa-ai/config/qa_config.go:91-136`

**Fix:** Use environment variables or a secrets file

---

## 12. PHASE 7: WEBSITE REMEDIATION

**Duration:** 1-2 weeks  
**Priority:** MEDIUM  
**Dependencies:** Phase 0 complete

### 12.1 Task 7.1: Update All Stale Numbers

| Page | Current (Wrong) | Correct |
|------|----------------|---------|
| `book/index.html` body | 235 actions | 387 actions |
| `implementation.html` footer | 297 actions | 387 actions |
| `implementation.html` body | 85-90% JIRA parity | 100% |
| `implementation.html` section header | "40 Actions" | "45 Actions" |
| `api.html` example version | "2.0.0" | "4.1.0" |
| `manual.html` example version | "1.0.0" | "4.1.0" |
| `book/index.html` version | "2.0.0" | "4.1.0" |
| `diagrams.html` tables | 89 | 121 |

### 12.2 Task 7.2: Add Open Graph Meta Tags

**All pages:** Add:
```html
<meta property="og:title" content="[page-specific]">
<meta property="og:description" content="[page-specific]">
<meta property="og:image" content="https://www.helixtrack.ru/docs/assets/Logo.png">
<meta property="og:url" content="https://www.helixtrack.ru/[page]">
<meta property="og:type" content="website">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="[page-specific]">
<link rel="canonical" href="https://www.helixtrack.ru/[page]">
```

### 12.3 Task 7.3: Fix Broken Links

- Remove reference to `docs/assets/Wide_Black.png` (doesn't exist)
- Fix relative links to `../JIRA_FEATURE_GAP_ANALYSIS.md` and `../COMPREHENSIVE_TEST_REPORT.md`
- Fix relative links to `../Services/Localization/USER_MANUAL.md`

### 12.4 Task 7.4: Fix Dark Theme on Broken Pages

**Files:** `http3-quic.html`, `localization.html`, `diagrams.html`
**Fix:** Remove hardcoded `background: white` inline styles, use CSS variables from `style.css`

### 12.5 Task 7.5: Fix localization.html Navigation

**Action:** Replace custom nav with standard nav-wrapper + nav-menu + hamburger pattern used by all other pages

### 12.6 Task 7.6: Fix Accessibility Issues

- Remove duplicate h1 tags (4 pages)
- Add ARIA labels to hamburger menu
- Add skip-to-content link
- Add `aria-hidden="true"` to decorative SVGs
- Add `aria-modal="true"` to image modal

### 12.7 Task 7.7: Add Favicon

**Action:** Add `<link rel="icon" type="image/png" href="docs/assets/Logo.png">` to all pages

### 12.8 Task 7.8: Deduplicate SVG GitHub Icon

**Action:** Extract to shared SVG sprite or inline SVG component

---

## 13. PHASE 8: CROSS-SERVICE INTEGRATION

**Duration:** 2-3 weeks  
**Priority:** HIGH  
**Dependencies:** Phases 2-6 partially complete

### 13.1 Task 8.1: Fix Core↔Chat Integration

**File:** `Services/Chat/internal/services/core_service.go:32`
**Fix:** Add `core_service_url` config field, default to `http://localhost:8080`

### 13.2 Task 8.2: Implement Core↔Attachments Integration

**Action:** Wire Attachments service into Core's document export handlers (replace stubs)

### 13.3 Task 8.3: Implement Cross-Service Integration Tests

**Test Matrix:**

| Service Pair | Test | Endpoint |
|-------------|------|----------|
| Core → Chat | Create ticket → verify chat room created | HTTP |
| Core → Localization | Request with locale → verify localized response | HTTP/3 |
| Core → Attachments | Upload file → attach to ticket → download | HTTP |
| Chat → Core | Create chat → verify user info from Core | HTTP |
| All Services | Health check across all services | HTTP |

### 13.4 Task 8.4: Create Docker Compose for Full Stack

**File:** `docker-compose.yml` (NEW — repo root)

```yaml
services:
  core:
    build: ./Application
    ports: ["8080:8080"]
    depends_on: [postgres]
    
  chat:
    build: ./Services/Chat
    ports: ["9090:9090"]
    depends_on: [postgres, core]
    
  localization:
    build: ./Services/Localization
    ports: ["8085:8085"]
    depends_on: [postgres, redis]
    
  attachments:
    build: ./Attachments-Service
    ports: ["8090:8090"]
    depends_on: [postgres, minio]
    
  postgres:
    image: postgres:16
    environment:
      POSTGRES_DB: helixtrack
      POSTGRES_USER: helixtrack
      POSTGRES_PASSWORD: dev_password
    
  redis:
    image: redis:7-alpine
    
  minio:
    image: minio/minio
    command: server /data
```

---

## 14. PHASE 9: UNIFIED TESTING STRATEGY

**Duration:** 4-6 weeks (parallel with all phases)  
**Priority:** MANDATORY  
**Dependencies:** Phase 0 complete

### 14.1 Test Type Requirements (Ecosystem-Wide)

| Test Type | Core | Chat | L10n | Attach | KeyMgr | QA-AI | Total Target |
|-----------|------|------|------|--------|--------|-------|-------------|
| Unit Tests | ~2,000 | ~150 | ~120 | ~200 | ~40 | ~50 | ~2,560 |
| Integration Tests | ~400 | ~50 | ~30 | ~30 | 0 | 0 | ~510 |
| API Contract Tests | ~387 | ~31 | ~16 | ~20 | 0 | 0 | ~454 |
| Cross-Service Tests | ~20 | ~5 | ~3 | ~3 | 0 | 0 | ~31 |
| E2E Workflow Tests | ~50 | ~10 | ~5 | ~5 | 0 | 0 | ~70 |
| Security Tests | ~100 | ~30 | ~20 | ~20 | ~10 | 0 | ~180 |
| Performance Tests | ~20 | ~5 | ~5 | ~5 | 0 | 0 | ~35 |
| Challenges | ~20 | ~5 | ~3 | ~3 | 0 | 0 | ~31 |
| **TOTAL** | **~2,997** | **~286** | **~202** | **~286** | **~50** | **~50** | **~3,871** |

### 14.2 Anti-Bluff Verification Constitution

**Every test in the ecosystem MUST satisfy these rules:**

1. **Positive Assertions:** `assert.Equal(expected, actual)` — NOT `assert.NotEqual(500, code)`
2. **Data Verification:** After write operations, verify data exists in database/storage
3. **Side-Effect Verification:** Verify events published, audit logs written, caches invalidated
4. **No Mock Bypass:** Integration tests use real database/storage, not mocks
5. **No Silent Skips:** `t.Skip()` tracked and minimized to zero
6. **Challenge Gates:** All challenge tests must pass before release

### 14.3 Cross-Module Challenge Suite

| # | Challenge | Modules Tested |
|---|-----------|----------------|
| 1 | Full Ticket Lifecycle | Core |
| 2 | Chat Room with Messages | Chat |
| 3 | Multi-Language Response | Core + L10n |
| 4 | Upload → Attach → Download | Core + Attachments |
| 5 | Real-Time WebSocket Notification | Core (WebSocket) |
| 6 | End-to-End: Ticket Created → Chat Notified → Document Linked | All 4 |
| 7 | Parallel Operations: 100 concurrent ticket creates | Core |
| 8 | Export Verification: Document → All Formats | Core |
| 9 | Key Generation → Service Usage → Rotation | KeyMgr + Core |
| 10 | QA Framework Validates Real API Behavior | QA-AI + Core |

---

## 15. PHASE 10: DOCUMENTATION & RELEASE

**Duration:** 2-3 weeks  
**Priority:** HIGH  
**Dependencies:** Phases 1-8 substantially complete

### 15.1 Task 10.1: Unified Version Strategy

**Action:** Ensure all components report the same version number
- Create `Version/` directory at repo root with single source of truth
- All services read version from this file
- Website reads version from this file
- Build scripts inject version into binaries

### 15.2 Task 10.2: Create Unified CHANGELOG.md

**File:** `CHANGELOG.md` (NEW — repo root)

### 15.3 Task 10.3: Create Unified CONTRIBUTING.md

**File:** `CONTRIBUTING.md` (NEW — repo root)

### 15.4 Task 10.4: Synchronize Website with Reality

**Action:** Run automated verification script that:
1. Counts actual API actions from request.go
2. Counts actual database tables from DDL files
3. Runs actual test suite and counts passing tests
4. Generates website content from verified data

### 15.5 Task 10.5: Create Release Process

**Action:** Define release checklist:
1. All constitutions pass
2. All anti-bluff tests pass
3. All challenges pass
4. All cross-service integration tests pass
5. Security scan passes
6. Version numbers synchronized
7. CHANGELOG.md updated
8. Website updated with verified numbers

---

## APPENDIX A: MASTER ISSUE TRACKER

### Priority 1 — Security (Must fix before any release)

| ID | Component | Issue | File:Line | Phase |
|----|-----------|-------|-----------|-------|
| SEC-001 | Core | Hardcoded JWT secret | `middleware/jwt.go:95` | 1-SEC |
| SEC-002 | Core | Wildcard CORS | `server/server.go:325` | 1-SEC |
| SEC-003 | Core | Permission bypass when disabled | `services/permission_service.go:66` | 1-SEC |
| SEC-004 | Core | RBAC consumes request body | `middleware/rbac.go:271` | 1-SEC |
| SEC-005 | Chat | JWT in URL params | `middleware/jwt.go:70` | 2-SEC |
| SEC-006 | Chat | Connection string injection | `database/database.go:88` | 2-SEC |
| SEC-007 | Chat | WebSocket CheckOrigin=true | `server/server.go:26` | 2-SEC |
| SEC-008 | KeyMgr | Plaintext "encrypted" storage | `storage/storage.go:61` | 5-SEC |
| SEC-009 | KeyMgr | Secrets to stdout | `cmd/main.go:207` | 5-SEC |
| SEC-010 | Jekyll | jQuery 1.x CVEs | `js/jquery.js` | ABANDON |
| SEC-011 | L10n | WebSocket CheckOrigin=true | `websocket/manager.go:19` | 3-SEC |
| SEC-012 | QA-AI | Hardcoded passwords | `config/qa_config.go:91` | 6-QA |

### Priority 2 — Correctness (Must fix for features to work)

| ID | Component | Issue | File:Line | Phase |
|----|-----------|-------|-----------|-------|
| COR-001 | Core | 6 export handler stubs | `handlers/document_handler.go:4448-4750` | 1-API |
| COR-002 | Core | Report execution placeholder | `handlers/report_handler.go:546` | 1-API |
| COR-003 | Core | No-op EventPublisher | `handlers/handler.go:39` | 1-API |
| COR-004 | Core | Document DB PostgreSQL incompat | `database/database_documents_impl.go` | 1-DB |
| COR-005 | Core | V4 invalid INDEX syntax | `Database/DDL/Definition.V4.sql:71` | 1-DB |
| COR-006 | Chat | WebSocket nil map panic | `server/server.go:44` | 2-CRASH |
| COR-007 | Chat | Rate limiter per-request bug | `middleware/ratelimit.go:107` | 2-FIX |
| COR-008 | Chat | CoreService URL wrong | `services/core_service.go:32` | 2-FIX |
| COR-009 | Chat | MessageUpdate IsEdited bug | `database/message_repo.go:65` | 2-FIX |
| COR-010 | Chat | MessageQuote missing QuotedMessageID | `handlers/message_handler.go:433` | 2-FIX |
| COR-011 | Chat | Role validation accepts any string | `handlers/participant_handler.go:217` | 2-FIX |
| COR-012 | L10n | Version count copy-paste bug | `handlers/version_handlers.go:245` | 3-FIX |
| COR-013 | L10n | encrypt/decrypt are no-ops | `database/database.go:158` | 3-IMPL |
| COR-014 | Attach | S3 buffers entire file | `storage/adapters/s3.go:164` | 4-FIX |
| COR-015 | Attach | Duplicate health check goroutines | `orchestrator/orchestrator.go:103` | 4-FIX |
| COR-016 | Attach | Zero-value dedup engine passed | `handlers/routes.go:127` | 4-FIX |
| COR-017 | QA-AI | Won't compile | `agents/qa_agent.go:306,313` | 6-FIX |
| COR-018 | QA-AI | verifyDatabase always returns true | `agents/qa_agent.go:381` | 6-FIX |
| COR-019 | Screensaver | .desktop file never installed | `install.sh:49` | SCREEN |
| COR-020 | KeyMgr | UTF-8 truncation bug | `cmd/main.go:329` | 5-FIX |

### Priority 3 — Quality (Must fix for production)

| ID | Component | Issue | Phase |
|----|-----------|-------|-------|
| QUA-001 | Core | 17+ skipped tests | 1-TEST |
| QUA-002 | Core | Weak E2E assertions | 1-TEST |
| QUA-003 | Core | Indexes_Performance.sql broken | 1-DB |
| QUA-004 | Core | document_handler.go 7,050 lines | 1-REFACTOR |
| QUA-005 | Chat | 14 TODO WebSocket broadcasts | 2-IMPL |
| QUA-006 | Chat | No database layer tests | 2-TEST |
| QUA-007 | Chat | 4 orphan model files | 2-DECIDE |
| QUA-008 | Chat | Status doc inflated (89% vs ~65%) | 2-DOC |
| QUA-009 | Attach | Status doc contradictory | 4-DOC |
| QUA-010 | Attach | No integration tests | 4-TEST |
| QUA-011 | L10n | BatchLocalizations inconsistent errors | 3-FIX |
| QUA-012 | L10n | 7 dead WebSocket methods | 3-CLEANUP |
| QUA-013 | QA-AI | "AI" label with zero AI | 6-RENAME |
| QUA-014 | QA-AI | Zero self-tests | 6-TEST |
| QUA-015 | Website | 3 stale API counts | 7-FIX |
| QUA-016 | Website | Missing OG tags | 7-FIX |
| QUA-017 | Website | Dark theme broken on 3 pages | 7-FIX |
| QUA-018 | KeyMgr | RSA 2048-bit (deprecating) | 5-UPGRADE |

---

## APPENDIX B: CONSTITUTION TEMPLATES PER MODULE

### B.1 Core Application — Key Constitution Rules

```markdown
## Core Constitution — Additional Rules

1. The /do endpoint MUST route to a real handler for every action constant in request.go
2. Every handler MUST write to and read from real database tables (no mock DB in production)
3. EventPublisher MUST NOT be NoOp in production configuration
4. Database schema version MUST be verified on startup
5. "Production Ready" label requires ALL 20 challenges passing
```

### B.2 Chat Service — Key Constitution Rules

```markdown
## Chat Constitution — Additional Rules

1. WebSocket connections MUST NOT crash — initialize all maps before use
2. CoreService URL MUST be a valid HTTP URL
3. Rate limiter MUST be shared across requests, not per-request
4. Room-scoped broadcasting MUST only send to room members
5. Role validation MUST reject unknown role strings
6. SQLCipher claims MUST have corresponding implementation or be removed from docs
```

### B.3 Localization Service — Key Constitution Rules

```markdown
## Localization Constitution — Additional Rules

1. encrypt()/decrypt() MUST either be fully implemented or clearly marked as STUB with error return
2. Version statistics MUST use correct database queries (not copy-paste of same function)
3. Error responses MUST use consistent format across all handlers
4. WebSocket CheckOrigin MUST enforce configured allowed origins
5. "Encrypted database" claims require actual encryption implementation
```

### B.4 Attachments Service — Key Constitution Rules

```markdown
## Attachments Constitution — Additional Rules

1. S3 uploads MUST stream data, not buffer entire file in memory
2. IMPLEMENTATION_STATUS.md MUST accurately reflect actual code state
3. Health check goroutines MUST NOT be duplicated
4. DeduplicationEngine MUST be properly initialized (not zero-value)
5. Storage adapter tests MUST test with real storage backends
```

### B.5 KeyManager — Key Constitution Rules

```markdown
## KeyManager Constitution — Additional Rules

1. "Encrypted storage" claims REQUIRE actual encryption implementation
2. Key values MUST NOT be printed to stdout by default
3. RSA key size MUST be 3072-bit minimum
4. Self-signed certificates MUST support custom SANs
5. keys.json MUST be encrypted at rest
```

### B.6 QA-AI — Key Constitution Rules

```markdown
## QA-AI Constitution — Additional Rules

1. The framework MUST compile and pass its own tests before testing other components
2. verifyDatabase() MUST query actual database, not return true unconditionally
3. "AI" label REQUIRES actual AI/LLM integration
4. IMPLEMENTATION_STATUS.md MUST NOT claim 100% for stub implementations
5. Hardcoded passwords MUST be replaced with environment variables
6. ConcurrentTests field MUST be implemented or removed
```

---

## IMPLEMENTATION TIMELINE SUMMARY

| Phase | Focus | Duration | Dependencies |
|-------|-------|----------|-------------|
| **Phase 0** | Ecosystem Constitution | 3-5 days | None |
| **Phase 1** | Core Application | 16-22 weeks | Phase 0 |
| **Phase 2** | Chat Service | 3-4 weeks | Phase 0 |
| **Phase 3** | Localization Service | 1-2 weeks | Phase 0 |
| **Phase 4** | Attachments Service | 3-4 weeks | Phase 0 |
| **Phase 5** | KeyManager | 1 week | Phase 0 |
| **Phase 6** | QA-AI Rebuild | 3-4 weeks | Phase 0 |
| **Phase 7** | Website | 1-2 weeks | Phase 0 |
| **Phase 8** | Cross-Service Integration | 2-3 weeks | Phases 2-6 |
| **Phase 9** | Unified Testing | 4-6 weeks (parallel) | Phase 0 |
| **Phase 10** | Documentation & Release | 2-3 weeks | Phases 1-8 |
| **TOTAL** | | **~38-52 weeks** | |

### Parallel Execution Strategy

```
Week 1:     Phase 0 (Constitution)
Week 1-4:   Phase 5 (KeyManager) ─┐
Week 1-2:   Phase 3 (L10n) ──────┤── Quick wins
Week 1-2:   Phase 7 (Website) ────┤
Week 2-5:   Phase 6 (QA-AI) ──────┤
Week 2-5:   Phase 2 (Chat) ───────┤── Medium effort
Week 2-5:   Phase 4 (Attachments) ┤
Week 2-52:  Phase 1 (Core) ───────┤── Largest effort (critical path)
Week 2-52:  Phase 9 (Testing) ────┤── Continuous parallel
Week 6-10:  Phase 8 (Integration) ┤── After service fixes
Week 8-12:  Phase 10 (Docs) ─────┘── Near end
```

---

## FINAL REMARKS

### The Bluff Summary

The HelixTrack ecosystem contains **genuinely substantial code** — over 225,000 lines of Go source across 5 microservices. The architecture is sound, the interfaces are clean, and the core abstractions (database, middleware, handlers) follow Go best practices.

However, the project suffers from **systematic completion inflation**:

- **Core** claims "100% Production Ready" but has 6 stub handlers and a no-op event publisher
- **Chat** claims "89% Production Ready" but WebSocket crashes and real-time features are TODO
- **KeyManager** claims "encrypted storage" but stores plaintext
- **QA-AI** claims "100% Complete" but won't compile and fakes database verification
- **Website** claims features (Open Graph, canonical URLs) that don't exist in the HTML
- **IMPLEMENTATION_STATUS.md** files across modules contradict actual code state

The anti-bluff constitution approach addresses this by:
1. **Binding rules** that prevent claiming "complete" without verification
2. **Positive test assertions** that catch fake passes
3. **Challenge tests** that verify end-to-end functionality
4. **Constitution documents** that all contributors must follow

**The single most important action is Phase 0 (Constitution)** — without binding rules, all subsequent phases risk re-introducing the same inflation patterns.

---

**END OF ECOSYSTEM PLAN**

*This document is part of the HelixTrack Project Constitution. All contributors and AI agents MUST read and follow these guidelines.*
