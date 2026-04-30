# HelixTrack Core — Comprehensive Production Readiness Plan

## Anti-Bluff Verified Implementation Roadmap

**Document Version:** 1.0.0  
**Date:** 2025-01-XX  
**Repository:** https://github.com/Helix-Track/Core  
**Scope:** Full codebase analysis, gap identification, phased remediation, testing constitution  
**Classification:** PROJECT CONSTITUTION — BINDING FOR ALL CONTRIBUTORS AND AI AGENTS  

---

## TABLE OF CONTENTS

1. [Executive Summary & Audit Findings](#1-executive-summary--audit-findings)
2. [Codebase Inventory & Current State](#2-codebase-inventory--current-state)
3. [Critical Issues Catalog (Anti-Bluff Detected)](#3-critical-issues-catalog-anti-bluff-detected)
4. [Phase 0: Foundation & Constitution](#4-phase-0-foundation--constitution)
5. [Phase 1: Database Schema Remediation](#5-phase-1-database-schema-remediation)
6. [Phase 2: Security Hardening](#6-phase-2-security-hardening)
7. [Phase 3: Core API Anti-Bluff Remediation](#7-phase-3-core-api-anti-bluff-remediation)
8. [Phase 4: Document Extension Completion](#8-phase-4-document-extension-completion)
9. [Phase 5: Testing Constitution & Anti-Bluff Test Strategy](#9-phase-5-testing-constitution--anti-bluff-test-strategy)
10. [Phase 6: Service Integration & Submodule Remediation](#10-phase-6-service-integration--submodule-remediation)
11. [Phase 7: Configuration System Overhaul](#11-phase-7-configuration-system-overhaul)
12. [Phase 8: Performance & Reliability](#12-phase-8-performance--reliability)
13. [Phase 9: UX & Enterprise Readiness](#13-phase-9-ux--enterprise-readiness)
14. [Phase 10: Documentation, Guides & Manuals](#14-phase-10-documentation-guides--manuals)
15. [Appendix A: Complete Configuration Reference](#appendix-a-complete-configuration-reference)
16. [Appendix B: Anti-Bluff Verification Checklist](#appendix-b-anti-bluff-verification-checklist)
17. [Appendix C: Test Type Coverage Matrix](#appendix-c-test-type-coverage-matrix)

---

## 1. EXECUTIVE SUMMARY & AUDIT FINDINGS

### 1.1 Audit Scope

This plan was produced after a comprehensive, line-by-line analysis of the entire HelixTrack Core repository and its submodules. The analysis covered:

| Category | Files Analyzed | Lines Reviewed |
|----------|---------------|----------------|
| Go source code (non-test) | ~200 files | 89,319 |
| Go test code | ~112 files | 90,395 |
| SQL DDL/Migration scripts | 32 files | 10,998 |
| Markdown documentation | ~150+ files | 102,635 |
| Configuration files | 7 JSON files | ~350 |
| Shell scripts & build files | ~30 files | ~2,000 |
| **TOTAL** | **~530+ files** | **~295,700 lines** |

### 1.2 Critical Verdict

**THE PROJECT IS NOT PRODUCTION READY.** Despite claiming "100% Production Ready" and "V1, V2, V3 Production Ready" across CLAUDE.md, README.md, and FINAL_VERIFICATION_REPORT.md, deep analysis reveals:

| Claim | Reality | Evidence |
|-------|---------|----------|
| "1,819+ tests, 98.8% pass rate" | 17+ tests are `t.Skip()`-ed, many tests use weak assertions (`assert.NotEqual(500, code)` instead of `assert.Equal(200, code)`) | `failover_manager_test.go:27,372,504,616,622` |
| "387 API Actions functional" | 6 document export handlers are stubs returning fake success; report execution is a placeholder; failover manager has unimplemented methods | `document_handler.go:4538-4750`, `report_handler.go:546` |
| "Enterprise-grade security" | Hardcoded JWT secret key in 2 files; wildcard CORS; permission bypass when disabled; RBAC middleware consumes request body | `middleware/jwt.go:95`, `server.go:325` |
| "Multi-database support" | Document DB uses SQLite-only `?` placeholders (breaks PostgreSQL); SQLCipher path is a no-op (identical driver); PostgreSQL session settings silently ignored | `database_documents_impl.go`, `optimized_database.go:183-189` |
| "100% Core + 95% Documents V2" | Documents V2 has 8-10 unaligned database fields per DOCUMENTS_V2_DATABASE_ISSUES.md; no handler or database layer tests | Known issues doc |
| "Full JIRA parity" | Workflow engine has no state transition logic; no real-time WebSocket hub; Chat service WebSocket unimplemented | `workflow_handler.go`, `Services/Chat/` |

### 1.3 Quantified Gap Summary

| Category | Claimed | Actual | Gap |
|----------|---------|--------|-----|
| Implemented API Actions | 387 | ~360 (27 stubs/TODO) | ~7% |
| Tests That Verify Real Behavior | 1,819 | ~1,500 (after removing skips, weak assertions) | ~17% |
| Production-Ready Services | 3 (Core, Chat, Localization) | 1 (Core only, with issues) | 67% |
| Database Tables with FK Constraints | 121 | ~32 (only Documents V2 + V5) | 74% |
| Configuration Files Valid | 7 | 4 (3 have errors) | 43% |
| Submodules Operational | 3 (Website, Chat, Localization) | 2 (Website empty) | 33% |

### 1.4 Risk Assessment

| Risk | Severity | Likelihood | Impact |
|------|----------|------------|--------|
| Security breach via hardcoded JWT secret | **CRITICAL** | **HIGH** (any deployment using defaults) | Full auth bypass |
| Data corruption via missing FK constraints | **CRITICAL** | **HIGH** (any write operation) | Orphaned records, referential integrity violation |
| Silent data loss via stub export handlers | **HIGH** | **HIGH** (any export action) | User trust erosion |
| PostgreSQL deployment failure | **HIGH** | **CERTAIN** (document DB) | Feature unavailable on Postgres |
| False test confidence (anti-bluff) | **HIGH** | **CURRENT** | Bugs reach production undetected |

---

## 2. CODEBASE INVENTORY & CURRENT STATE

### 2.1 Repository Structure

```
Core/
├── Application/                    # Go microservice (PRIMARY)
│   ├── main.go                     # 84 lines — entry point
│   ├── go.mod                      # 55 lines — Go 1.24, 11 direct deps
│   ├── go.sum                      # 118 lines — 46 unique deps
│   ├── internal/                   # 89,319 lines source
│   │   ├── config/                 # 267 lines — JSON config management
│   │   ├── database/               # 4,958 lines — DB abstraction + docs DB
│   │   ├── server/                 # 689 lines — Gin + HTTP/3
│   │   ├── logger/                 # 162 lines — Uber Zap + Lumberjack
│   │   ├── middleware/             # 1,120 lines — JWT, RBAC, CORS, rate limit
│   │   ├── services/               # 2,592 lines — Auth, JWT, permissions, etc.
│   │   ├── models/                 # 14,577 lines — 33+ model files
│   │   ├── handlers/               # 82,135 lines — 29+ handler files
│   │   ├── cache/                  # In-memory LRU cache
│   │   ├── client/                 # HTTP/3 client
│   │   ├── metrics/                # Metrics collection
│   │   ├── security/               # Input validation, CSRF, DDoS, brute force
│   │   │   └── engine/             # RBAC engine, permission resolver
│   │   └── websocket/              # WebSocket manager, publisher
│   ├── tests/                      # Integration + E2E tests
│   ├── scripts/                    # Build, test, deployment scripts
│   ├── qa-ai/                      # QA AI framework (skeleton — 0% feature testing)
│   ├── docker/                     # Docker configs (HAProxy, Postgres, Consul)
│   └── docs/                       # Architecture docs, deployment, diagrams
│
├── Database/                       # SQL schemas
│   ├── DDL/                        # V1 (63 tables), V2 (12), V3 (18), V4 (6), V5 (14)
│   ├── DDL/Extensions/             # Chats (6+9), Documents (2+21), Times (2)
│   ├── DDL/Services/               # Localization (6+2), Authentication (1)
│   └── Definition.sqlite           # 3.94 MB active DB
│
├── Configurations/                 # JSON configs (default, dev, SSL, empty, invalid)
├── Services/
│   ├── Chat/                       # ~7,500 LOC — Production Ready (105 tests)
│   └── Localization/               # ~8,000 LOC — Production Ready (116 tests)
│
├── Tools/KeyManager/               # ~700 LOC — Production Ready (33 tests)
├── Attachments-Service/            # ~5,220 LOC — 40% complete
├── Extensions/                     # STUB — only "Tbd." README
├── Upstreams/                      # Git remote configs (GitHub, GitFlic, Gitee)
├── Recipes/                        # Build/install hooks (mostly stubs)
├── Version/                        # v1.0.0-SNAPSHOT metadata
├── Website/                        # FAILED SUBMODULE — completely empty
│
├── CLAUDE.md                       # 693 lines — AI agent guidelines
├── AGENTS.md                       # 194 lines — Code style guidelines
├── README.md                       # 190 lines — Project overview
├── IMPLEMENTATION_SUMMARY.md       # 841 lines — Feature catalog
├── MISSING_FEATURES_REPORT.md      # 1,094 lines — Gap analysis
├── LICENSE                         # Apache 2.0
└── .gitmodules                     # Website submodule (SSH, fails without keys)
```

### 2.2 Technology Stack

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| Language | Go | 1.24 (toolchain go1.24.9) | Primary implementation |
| HTTP Framework | Gin Gonic | v1.10.0 | REST API server |
| JWT | golang-jwt/jwt | v5.2.0 | Token authentication |
| WebSocket | gorilla/websocket | v1.5.3 | Real-time communication |
| HTTP/3 | quic-go | v0.55.0 | QUIC protocol |
| Database (Dev) | go-sqlite3 | v1.14.22 | SQLite driver |
| Database (Prod) | lib/pq | v1.10.9 | PostgreSQL driver |
| Logging | uber-go/zap | v1.26.0 | Structured logging |
| Log Rotation | lumberjack | v2.2.1 | File rotation |
| UUID | google/uuid | v1.6.0 | ID generation |
| Crypto | golang.org/x/crypto | v0.41.0 | bcrypt, TLS |
| Testing | stretchr/testify | v1.9.0 | Assertions + mocks |
| Cache | Internal LRU | — | In-memory caching |
| Service Discovery | Consul (planned) | — | Not yet integrated |

### 2.3 Database Schema Versions

| Version | Tables | Key Features | Status |
|---------|--------|-------------|--------|
| V1 | 63 | Core entities: tickets, projects, comments, users, org hierarchy, boards, cycles, workflows | ✅ Defined |
| V2 | +12 (75 total) | Priorities, resolutions, versions, watchers, filters, custom fields | ✅ Defined |
| V3 | +18 (93 total) | Epics, subtasks, work logs, dashboards, security levels, voting, notifications, mentions | ✅ Defined |
| V4 | +6 (99 total) | History tracking, optimistic locking, entity locking | ✅ Defined |
| V5 | +14 (113 total) | Document-entity integration, knowledge bases, search indexes | ✅ Defined |
| Documents V2 | +21 (134 total) | Confluence-style document management | ✅ Defined |
| Chats V1 | +6 (140 total) | Chat rooms + 5 platform integrations | ✅ Defined (SQLite) |
| Chats V2 | +9 (149 total) | Enhanced chat with presence, reactions, attachments | ⚠️ PostgreSQL-only syntax |
| Times V1 | +2 (151 total) | Time tracking | ✅ Defined |

### 2.4 Configuration System

**File:** `Application/internal/config/config.go` (267 lines)

```
Config
├── Log
│   ├── log_path: string       (default: "/tmp/htCoreLogs")
│   ├── logfile_base_name: string
│   ├── log_size_limit: int    (default: 100000000 = 100MB)
│   └── level: string          (default: "info")
│
├── Listeners[]
│   ├── address: string        (default: "0.0.0.0")
│   ├── port: int              (default: 8080)
│   ├── https: bool            (default: false)
│   ├── cert_file: string
│   └── key_file: string
│
├── Plugins[]
│   ├── name: string
│   ├── dependencies[]: string
│   └── config: map
│
├── Database
│   ├── type: string           (default: "sqlite")
│   ├── sqlite_path: string    (default: "Database/Definition.sqlite")
│   ├── postgres_host: string
│   ├── postgres_port: int
│   ├── postgres_user: string
│   ├── postgres_password: string
│   ├── postgres_database: string
│   └── postgres_ssl_mode: string (default: "disable")
│
├── Services
│   ├── authentication: ServiceEndpoint
│   │   ├── enabled: bool      (default: false)
│   │   ├── url: string
│   │   └── timeout: int       (default: 30s)
│   ├── permissions: ServiceEndpoint (same structure)
│   ├── lokalisation: ServiceEndpoint (same structure)
│   └── extensions: map[string]ServiceEndpoint
│
└── WebSocket
    ├── enabled: bool          (default: false)
    ├── path: string           (default: "/ws")
    ├── readBufferSize: int    (default: 1024)
    ├── writeBufferSize: int   (default: 1024)
    ├── maxMessageSize: int    (default: 524288 = 512KB)
    ├── writeWaitSeconds: int  (default: 10)
    ├── pongWaitSeconds: int   (default: 60)
    ├── pingPeriodSeconds: int (default: 54)
    ├── maxClients: int        (default: 1000)
    ├── requireAuth: bool      (default: false)
    ├── allowOrigins[]: string (default: ["*"])
    ├── enableCompression: bool
    └── handshakeTimeout: int  (default: 10)
```

---

## 3. CRITICAL ISSUES CATALOG (ANTI-BLUFF DETECTED)

### 3.1 Security Vulnerabilities

#### ISSUE SEC-001: Hardcoded JWT Secret Key
- **Severity:** CRITICAL
- **Files:** `Application/internal/middleware/jwt.go:95`, `Application/internal/services/jwt_service.go:22`
- **Code:** `"helix-track-default-secret-key-change-in-production"`
- **Impact:** Any deployment using default config is vulnerable to JWT forgery. An attacker who knows this string (it's in the public repo) can forge any JWT token with any claims (admin role, any user).
- **Remediation:** Phase 2, Task 2.1

#### ISSUE SEC-002: Wildcard CORS
- **Severity:** CRITICAL
- **File:** `Application/internal/server/server.go:325`
- **Code:** `Access-Control-Allow-Origin: *`
- **Impact:** Any website can make authenticated requests to the API from a user's browser, enabling CSRF-style attacks.
- **Remediation:** Phase 2, Task 2.2

#### ISSUE SEC-003: Permission Bypass When Disabled
- **Severity:** HIGH
- **File:** `Application/internal/services/permission_service.go:66-67`
- **Code:** `return true, nil` when service disabled
- **Impact:** Production deployments that forget to enable permissions will have zero access control.
- **Remediation:** Phase 2, Task 2.3

#### ISSUE SEC-004: RBAC Middleware Consumes Request Body
- **Severity:** HIGH
- **File:** `Application/internal/middleware/rbac.go:271-280`
- **Code:** `c.ShouldBindJSON(&body)` in middleware
- **Impact:** After RBAC middleware processes the request, the handler receives an empty body, silently breaking all POST/PUT operations when RBAC is active.
- **Remediation:** Phase 2, Task 2.4

### 3.2 Anti-Bluff: Stub Implementations

#### ISSUE BLF-001: Document Export Handlers Are Stubs (6 handlers)
- **Severity:** CRITICAL
- **File:** `Application/internal/handlers/document_handler.go`
- **Lines:** 4448 (PDF), 4493 (Word), 4538 (HTML), 4579 (XML), 4620 (Markdown), 4661 (Plain Text), 4702 (JSON), 4743 (LaTeX)
- **Pattern:** Each returns `HTTP 200` with `{"message": "<format> export initiated"}` without doing any work.
- **Evidence:** `// TODO: Implement actual <format> generation logic` comments at each location.
- **Impact:** Users click "Export to PDF" and get a success message, but no file is generated.
- **Remediation:** Phase 3, Tasks 3.1-3.8

#### ISSUE BLF-002: Report Execution Is Placeholder
- **Severity:** HIGH
- **File:** `Application/internal/handlers/report_handler.go:546`
- **Code:** Returns `"Report execution not yet implemented - placeholder response"`
- **Impact:** Users cannot actually run reports; the feature is advertised as complete.
- **Remediation:** Phase 3, Task 3.9

#### ISSUE BLF-003: Default Event Publisher Is No-Op
- **Severity:** HIGH
- **File:** `Application/internal/handlers/handler.go:39`
- **Code:** `publisher: websocket.NewNoOpPublisher()`
- **File:** `Application/internal/websocket/publisher.go:80-97`
- **Impact:** All `PublishEntityEvent()` calls throughout the codebase silently discard events. Real-time notifications, activity streams, and live collaboration are non-functional in production.
- **Remediation:** Phase 3, Task 3.10

#### ISSUE BLF-004: Additional Stubs in Document Handler
- **File:** `Application/internal/handlers/document_handler.go:5853`
- **Code:** `// STUB HANDLERS (TO BE IMPLEMENTED)` — explicit section header
- **Impact:** Undetermined number of additional handlers after this line are stubs.
- **Remediation:** Phase 3, Task 3.11

#### ISSUE BLF-005: Auth Service Has Unimplemented Methods
- **File:** `Application/internal/services/auth_service.go:147,154`
- **Code:** `return nil, fmt.Errorf("not implemented")` for `ValidateToken()` and `IsEnabled()` on real AuthService
- **Impact:** The real AuthService cannot validate tokens. All tests use `MockAuthService` which always succeeds, creating false confidence.
- **Remediation:** Phase 6, Task 6.1

### 3.3 Database Issues

#### ISSUE DB-001: No Foreign Key Constraints in V1-V4 (80+ tables)
- **Severity:** CRITICAL
- **Files:** `Database/DDL/Definition.V1.sql` through `Definition.V4.sql`
- **Impact:** Referential integrity is not enforced at the database level. Orphaned records can accumulate. Cascading deletes don't work.
- **Evidence:** V2 line 507: *"Foreign key relationships are maintained at application level (Go code)"*
- **Remediation:** Phase 1, Task 1.1

#### ISSUE DB-002: Document DB Uses SQLite-Only Placeholders
- **Severity:** CRITICAL
- **File:** `Application/internal/database/database_documents_impl.go` (3,033 lines)
- **Impact:** All 80+ document database methods use `?` placeholders which are incompatible with PostgreSQL's `$1, $2` syntax. Any PostgreSQL deployment will fail for all document operations.
- **Remediation:** Phase 1, Task 1.2

#### ISSUE DB-003: SQLCipher Is No-Op
- **Severity:** HIGH
- **File:** `Application/internal/database/optimized_database.go:183-189`
- **Impact:** The "encrypted" SQLite path uses the same `sql.Open("sqlite3", ...)` driver call as the standard path. Encryption is never actually enabled unless a CGO-enabled build with SQLCipher is used, but the code doesn't differentiate.
- **Remediation:** Phase 1, Task 1.3

#### ISSUE DB-004: V4 History Tables Use Invalid INDEX Syntax
- **Severity:** HIGH
- **File:** `Database/DDL/Definition.V4.sql:71-74, 160-162`
- **Code:** `INDEX (ticket_id, version)` inside CREATE TABLE
- **Impact:** Invalid in SQLite and PostgreSQL. Schema creation will fail for V4 tables.
- **Remediation:** Phase 1, Task 1.4

#### ISSUE DB-005: Indexes_Performance.sql References Non-Existent Columns/Tables
- **Severity:** HIGH
- **File:** `Database/DDL/Indexes_Performance.sql`
- **Examples:** `ticket(status_id)` (should be `ticket_status_id`), `ticket(type_id)` (should be `ticket_type_id`), `audit_log` (should be `audit`), ~20 other references to non-existent columns
- **Impact:** All performance indexes fail to create, degrading production query performance.
- **Remediation:** Phase 1, Task 1.5

#### ISSUE DB-006: Duplicate Migration.V5.6.sql with Divergent Content
- **Severity:** MEDIUM
- **Files:** `Database/DDL/Migration.V5.6.sql` vs `Application/Database/DDL/Migration.V5.6.sql`
- **Impact:** The Application version recreates V1 tables (account, organization, team, etc.) that already exist, causing migration failures.
- **Remediation:** Phase 1, Task 1.6

#### ISSUE DB-007: PostgreSQL-Only SQL in SQLite-Targeted Extensions
- **Severity:** HIGH
- **Files:** `Database/DDL/Extensions/Chats/Definition.V2.sql`, `Services/Localization/Definition.V1.sql`
- **Impact:** Chat V2 and Localization schemas use `UUID`, `gen_random_uuid()`, `JSONB`, `GIN` indexes — all PostgreSQL-specific. Cannot be used with SQLite.
- **Remediation:** Phase 1, Task 1.7

#### ISSUE DB-008: V5 Migration Adds Tables Already in V1
- **Severity:** MEDIUM
- **File:** `Application/Database/DDL/Migration.V5.6.sql:98-240`
- **Impact:** `account`, `organization`, `team`, and 6 mapping tables are recreated, causing "table already exists" errors.
- **Remediation:** Phase 1, Task 1.8

### 3.4 Configuration Issues

#### ISSUE CFG-001: dev_with_ssl.json Uses Wrong Field Names
- **File:** `Configurations/dev_with_ssl.json`
- **Problem:** Uses `"cert"` and `"key"` but Go struct expects `"cert_file"` and `"key_file"`
- **Impact:** SSL config is silently ignored; HTTPS configuration doesn't work.
- **Remediation:** Phase 7, Task 7.1

#### ISSUE CFG-002: dev_with_ssl.json Has Empty Cert/Key Strings
- **File:** `Configurations/dev_with_ssl.json:13-14`
- **Problem:** `"cert": ""` and `"key": ""` — validation requires non-empty values when HTTPS=true
- **Impact:** Config fails validation, HTTPS cannot be tested.
- **Remediation:** Phase 7, Task 7.1

#### ISSUE CFG-003: empty.json and invalid.json Are Intentional Test Files
- **Files:** `Configurations/empty.json`, `Configurations/invalid.json`
- **Problem:** These are clearly test fixtures but stored alongside production configs without labeling
- **Impact:** Confusion; someone might try to use them as production configs.
- **Remediation:** Phase 7, Task 7.2

### 3.5 Code Quality Issues

#### ISSUE CQ-001: document_handler.go Is 7,050 Lines
- **File:** `Application/internal/handlers/document_handler.go`
- **Impact:** Violates single responsibility principle; extremely difficult to review, test, and maintain.
- **Remediation:** Phase 8, Task 8.1

#### ISSUE CQ-002: Manual String Contains Reimplementation
- **File:** `Application/internal/server/server.go:452-467`
- **Code:** `contains()` and `containsInMiddle()` manually reimplement `strings.Contains()`
- **Remediation:** Phase 8, Task 8.2

#### ISSUE CQ-003: Dead Code — HTTP3Server Never Used
- **File:** `Application/internal/server/http3_server.go` (96 lines)
- **Impact:** Defined but never instantiated in `main.go` or `server.go`.
- **Remediation:** Phase 8, Task 8.3

#### ISSUE CQ-004: Event ID Generation Can Collide
- **File:** `Application/internal/server/server.go:539`
- **Code:** `fmt.Sprintf("evt_%d", time.Now().UnixNano())`
- **Impact:** High-volume systems will produce duplicate event IDs.
- **Remediation:** Phase 8, Task 8.4

#### ISSUE CQ-005: Port Wraparound Math Error
- **File:** `Application/internal/server/server.go:385`
- **Code:** `1024 + (port - 65535 - 1)` — can produce negative numbers
- **Remediation:** Phase 8, Task 8.5

#### ISSUE CQ-006: Rate Limiter Goroutine Leak
- **File:** `Application/internal/middleware/performance.go`
- **Problem:** `rateLimiter.close()` is never called
- **Impact:** Background goroutine leaks on every middleware initialization.
- **Remediation:** Phase 8, Task 8.6

#### ISSUE CQ-007: Silent Error in Document Duplication
- **File:** `Application/internal/database/database_documents_impl.go:344`
- **Code:** `_ = d.CreateDocumentContent(newContent)` — error silently swallowed
- **Impact:** Document duplication may silently lose content.
- **Remediation:** Phase 8, Task 8.7

#### ISSUE CQ-008: gin.ReleaseMode Hardcoded
- **File:** `Application/internal/server/server.go:143`
- **Impact:** No way to enable debug mode for development.
- **Remediation:** Phase 7, Task 7.3

### 3.6 Testing Infrastructure Issues

#### ISSUE TST-001: 17+ Tests Are t.Skip()-ed
- **Files:** `failover_manager_test.go:27,372,504,616,622` (5 functions), plus ~12 more in `websocket/manager_integration_test.go`
- **Impact:** Test count is inflated without verifying anything.
- **Remediation:** Phase 5

#### ISSUE TST-002: E2E Tests Use Weak Assertions
- **File:** `tests/e2e/pm_workflows_test.go` throughout
- **Pattern:** `assert.NotEqual(t, http.StatusInternalServerError, resp.Code)` — only checks server didn't crash
- **Impact:** Tests pass even when operations fail with 400 Bad Request.
- **Remediation:** Phase 5

#### ISSUE TST-003: Handler Tests Don't Assert Success
- **File:** `internal/handlers/handler_test.go:586-615`
- **Pattern:** `assert.NotEqual(t, http.StatusUnauthorized, w.Code)` — only checks not 401/403
- **Evidence:** Comment on line 612-613: *"Database operations may fail due to missing tables in test DB"*
- **Impact:** Tests pass even when database operations fail.
- **Remediation:** Phase 5

#### ISSUE TST-004: Integration Tests Bypass Real Auth
- **File:** `tests/integration/api_integration_test.go:511-513`
- **Code:** MockAuthService accepts literal string `"valid-test-token"`
- **Impact:** Authentication is never tested in integration.
- **Remediation:** Phase 5

#### ISSUE TST-005: Self-Generated Verification Reports
- **Files:** `FINAL_VERIFICATION_REPORT.md` (724 lines), `COMPREHENSIVE_TEST_REPORT.md` (467 lines)
- **Problem:** Reports are generated by the same code they verify, using the same test run. No independent verification.
- **Remediation:** Phase 5

#### ISSUE TST-006: QA-AI Framework Is 0% Implemented
- **Files:** `qa-ai/IMPLEMENTATION_STATUS.md`, `qa-ai/agents/qa_agent.go:381`, `qa-ai/orchestrator/orchestrator.go:238`
- **Problem:** Framework shell exists but 0% actual API testing. 21 HTML reports exist with placeholder data.
- **Remediation:** Phase 5

### 3.7 Submodule & Service Issues

#### ISSUE SVC-001: Website Submodule Failed
- **Path:** `Website/`
- **Problem:** Empty directory; `.gitmodules` references SSH URL but no SSH keys available
- **Remediation:** Phase 6, Task 6.2

#### ISSUE SVC-002: Extensions Directory Is Empty Stub
- **Path:** `Extensions/`
- **Problem:** Only contains `README.md` with "Tbd."
- **Remediation:** Phase 6, Task 6.3

#### ISSUE SVC-003: Attachments Service 40% Complete
- **Path:** `Attachments-Service/`
- **Missing:** Storage layer integration, security integration, comprehensive testing, deployment configs
- **Remediation:** Phase 6, Task 6.4

#### ISSUE SVC-004: Chat Service WebSocket Hub Not Implemented
- **Path:** `Services/Chat/`
- **Missing:** WebSocket manager described in ARCHITECTURE.md; real-time features work via HTTP polling only
- **Remediation:** Phase 6, Task 6.5

#### ISSUE SVC-005: No Cross-Service Integration Tests
- **Impact:** No tests verify Chat↔Core, Localization↔Core, or Attachments↔Core communication
- **Remediation:** Phase 6, Task 6.6

---

## 4. PHASE 0: FOUNDATION & CONSTITUTION

**Duration:** 3-5 days  
**Priority:** MANDATORY (must complete before any other phase)

### 4.1 Task 0.1: Create Project Constitution

**File:** `CONSTITUTION.md` (NEW — project root)

**Content Requirements:**
```markdown
# HelixTrack Project Constitution

## Anti-Bluff Principle

1. NO TEST MAY PASS IF THE FEATURE IT TESTS DOES NOT ACTUALLY WORK.
2. A "passing test" that does not verify real behavior is a BUG, not a success.
3. All test assertions MUST verify concrete, observable outcomes — not just "no crash."
4. Stub implementations MUST return error codes (not success) and MUST be labeled `// STUB:`.
5. Every CLAUDE.md violation is a constitution violation.

## Testing Constitution

1. Every API action MUST have at least:
   a. One unit test verifying the handler processes input correctly
   b. One integration test verifying the full request→database→response cycle
   c. One negative test verifying proper error handling
2. Test assertions MUST be positive (assert.Equal(expected, actual)), not negative (assert.NotEqual(500, code))
3. t.Skip() is PROHIBITED except with documented justification and tracking issue
4. Mock services MUST be replaced with real services in integration tests
5. Code coverage below 80% for any package blocks merge

## Implementation Constitution

1. All features MUST work end-to-end before being marked "complete"
2. All handlers MUST write to and read from real database tables
3. No placeholder responses ("not yet implemented") in production code paths
4. All configuration options MUST be documented, validated, and tested
5. Dead code MUST be removed; TODO items MUST have tracking issues

## Security Constitution

1. No secrets in source code (including default passwords)
2. No wildcard CORS in production configurations
3. All external inputs MUST be validated and sanitized
4. All authentication MUST be tested with real tokens, not mocks
5. Permission checks MUST be enforced even when "disabled" in dev mode

## Documentation Constitution

1. All public API actions MUST be documented with request/response examples
2. All configuration options MUST be documented with defaults and constraints
3. README.md status claims MUST be verifiable by running the test suite
4. "Production Ready" label requires passing 100% of anti-bluff verified tests
```

### 4.2 Task 0.2: Update CLAUDE.md with Anti-Bluff Constitution

**File:** `CLAUDE.md` (MODIFY — append constitution section at end)

**Changes:**
- Add section `## Project Constitution` referencing `CONSTITUTION.md`
- Add section `## Anti-Bluff Rules` with the 5 core rules from above
- Change "Current Status: V1, V2, V3 Production Ready" to "Current Status: Under Remediation — See CONSTITUTION.md"
- Add: `## IMPORTANT: Before any code change, read CONSTITUTION.md`
- Remove all "100% COMPLETE" claims until verified by anti-bluff tests

### 4.3 Task 0.3: Update AGENTS.md with Constitution

**File:** `AGENTS.md` (MODIFY)

**Changes:**
- Add section `## Anti-Bluff Testing Requirements`
- Add rule: "Tests MUST assert positive outcomes, not just 'not error'"
- Add rule: "t.Skip() is prohibited without tracking issue"
- Add rule: "Mock services are for unit tests only; integration tests MUST use real services"
- Add: `## Pre-merge Checklist` including "All anti-bluff tests pass"

### 4.4 Task 0.4: Create Submodule Constitution Templates

**Files:** (NEW for each submodule)
- `Services/Chat/CONSTITUTION.md`
- `Services/Localization/CONSTITUTION.md`
- `Tools/KeyManager/CONSTITUTION.md`
- `Attachments-Service/CONSTITUTION.md`

**Content:** Reference root constitution + submodule-specific rules

### 4.5 Task 0.5: Remove Binaries and Backup Files from Repository

**Action:** Add to `.gitignore` and remove committed files:
- `Attachments-Service/attachments-service` (compiled binary)
- `Services/Localization/localization-service` (compiled binary)
- `Services/Localization/localization-service-test` (compiled binary)
- `Tools/KeyManager/keymanager` (compiled binary)
- `*.backup`, `*.bak` files
- `Database/Definition.sqlite.backup.*`

### 4.6 Task 0.6: Fix .gitmodules to Use HTTPS

**File:** `.gitmodules` (MODIFY)

**Change:**
```
[submodule "Website"]
    path = Website
-   url = git@github.com:Helix-Track/Website.git
+   url = https://github.com/Helix-Track/Website.git
```

### 4.7 Task 0.7: Consolidate Documentation

**Actions:**
- Remove or archive 80+ redundant status/summary markdown files
- Keep only: CONSTITUTION.md, CLAUDE.md, AGENTS.md, README.md, USER_MANUAL.md, DEPLOYMENT.md, CHANGELOG.md
- Archive: IMPLEMENTATION_SUMMARY.md, MISSING_FEATURES_REPORT.md, all *_SUMMARY.md, all *_REPORT.md (keep TEST reports)
- Create `Documentation/archive/` for historical docs

---

## 5. PHASE 1: DATABASE SCHEMA REMEDIATION

**Duration:** 2-3 weeks  
**Priority:** CRITICAL  
**Dependencies:** Phase 0 complete

### 5.1 Task 1.1: Add Foreign Key Constraints to V1-V4 Schemas

**Scope:** 80+ tables across Definition.V1.sql through Definition.V4.sql

**Tables Requiring FK Constraints (Priority Order):**

**Tier 1 — Core Entity Relationships (CRITICAL):**
| Child Table | Column | Parent Table | Parent Column |
|-------------|--------|-------------|---------------|
| ticket | project_id | project | id |
| ticket | ticket_type_id | ticket_type | id |
| ticket | ticket_status_id | ticket_status | id |
| ticket | workflow_id | workflow | id |
| ticket | user_id | user_default_mapping | id |
| ticket | priority_id | priority | id |
| ticket | resolution_id | resolution | id |
| ticket | epic_id | ticket | id (self-ref) |
| ticket | parent_ticket_id | ticket | id (self-ref) |
| ticket | security_level_id | security_level | id |
| ticket_project_mapping | ticket_id | ticket | id |
| ticket_project_mapping | project_id | project | id |
| comment | user_id | user_default_mapping | id |
| comment_ticket_mapping | comment_id | comment | id |
| comment_ticket_mapping | ticket_id | ticket | id |

**Tier 2 — Organizational Hierarchy (HIGH):**
| Child Table | Column | Parent Table |
|-------------|--------|-------------|
| organization | account_id | account |
| team | organization_id | organization |
| user_organization_mapping | user_id | user_default_mapping |
| user_organization_mapping | organization_id | organization |
| user_team_mapping | user_id | user_default_mapping |
| user_team_mapping | team_id | team |
| team_project_mapping | team_id | team |
| team_project_mapping | project_id | project |
| team_organization_mapping | team_id | team |
| team_organization_mapping | organization_id | organization |
| project_organization_mapping | project_id | project |
| project_organization_mapping | organization_id | organization |

**Tier 3 — Feature Relationships (MEDIUM):**
| Child Table | Column | Parent Table |
|-------------|--------|-------------|
| workflow_step | workflow_id | workflow |
| workflow_step | ticket_status_id | ticket_status |
| board_meta_data | board_id | board |
| cycle_project_mapping | cycle_id | cycle |
| cycle_project_mapping | project_id | project |
| component_ticket_mapping | component_id | component |
| label_ticket_mapping | label_id | label |
| repository_project_mapping | repository_id | repository |
| ticket_relationship | ticket_id | ticket |
| ticket_relationship | related_ticket_id | ticket |
| ticket_relationship | ticket_relationship_type_id | ticket_relationship_type |
| dashboard_widget | dashboard_id | dashboard |
| board_column | board_id | board |
| board_swimlane | board_id | board |
| board_quick_filter | board_id | board |
| work_log | ticket_id | ticket |
| work_log | user_id | user_default_mapping |
| project_role_user_mapping | project_role_id | project_role |
| project_role_user_mapping | project_id | project |
| security_level | project_id | project |
| security_level_permission_mapping | security_level_id | security_level |
| ticket_vote_mapping | ticket_id | ticket |
| ticket_vote_mapping | user_id | user_default_mapping |
| notification_rule | notification_scheme_id | notification_scheme |
| notification_rule | notification_event_id | notification_event |
| comment_mention_mapping | comment_id | comment |
| comment_mention_mapping | mentioned_user_id | user_default_mapping |
| filter_share_mapping | filter_id | filter |
| custom_field_option | custom_field_id | custom_field |
| ticket_custom_field_value | ticket_id | ticket |
| ticket_custom_field_value | custom_field_id | custom_field |
| version | project_id | project |
| ticket_affected_version_mapping | ticket_id | ticket |
| ticket_affected_version_mapping | version_id | version |
| ticket_fix_version_mapping | ticket_id | ticket |
| ticket_fix_version_mapping | version_id | version |
| ticket_watcher_mapping | ticket_id | ticket |
| ticket_watcher_mapping | user_id | user_default_mapping |

**Implementation Steps:**
1. Create new migration file `Database/DDL/Migration.V4.5_FK_Constraints.sql`
2. Add `ALTER TABLE ... ADD CONSTRAINT ... FOREIGN KEY (...) REFERENCES ...(...)` for each relationship
3. Add `ON DELETE CASCADE` where appropriate (e.g., ticket_project_mapping → ticket)
4. Add `ON DELETE SET NULL` where appropriate (e.g., ticket → ticket_type)
5. Test migration on copy of production database
6. Create rollback migration `Migration.V4.5_FK_Constraints_Rollback.sql`

**Testing:**
- Test FK constraint enforcement: INSERT into ticket with non-existent project_id MUST fail
- Test CASCADE delete: DELETE project MUST cascade to ticket_project_mapping
- Test SET NULL: DELETE ticket_type MUST set ticket.ticket_type_id to NULL
- Verify all existing data satisfies constraints

### 5.2 Task 1.2: Fix Document DB PostgreSQL Compatibility

**File:** `Application/internal/database/database_documents_impl.go` (3,033 lines)

**Problem:** All 80+ methods use `?` placeholders.

**Solution:** Implement a query normalizer that converts `?` → `$1, $2, ...` for PostgreSQL.

**Implementation:**
```go
// In database.go, add method:
func (d *db) normalizeQuery(query string) string {
    if d.dbType == "postgres" {
        var buf strings.Builder
        paramIndex := 1
        for _, ch := range query {
            if ch == '?' {
                buf.WriteString(fmt.Sprintf("$%d", paramIndex))
                paramIndex++
            } else {
                buf.WriteRune(ch)
            }
        }
        return buf.String()
    }
    return query
}
```

**Apply to:** Every `d.conn.Query()`, `d.conn.Exec()`, `d.conn.QueryRow()` call in `database_documents_impl.go`

**Testing:**
- Write a test that creates `OptimizedDatabase` with `type: "postgres"` and verifies all document queries use `$1, $2` syntax
- Write a test that verifies SQLite `?` syntax is preserved

### 5.3 Task 1.3: Fix SQLCipher Implementation

**File:** `Application/internal/database/optimized_database.go:183-189`

**Current Problem:**
```go
// "Encrypted" path (line 185):
conn, err := sql.Open("sqlite3", d.config.SQLitePath+"?_pragma_key="+key+"&_pragma_cipher_page_size=4096")
// "Standard" path (line 170):
conn, err := sql.Open("sqlite3", d.config.SQLitePath)
```

Both use `"sqlite3"` driver — no differentiation.

**Solution:**
1. Add build tag `//go:build sqlcipher` for encrypted build
2. Or: Use a separate CGO build process that links against SQLCipher
3. Or: Clearly document that SQLCipher requires a custom build and add runtime detection
4. At minimum: Rename the "encrypted" path to clearly indicate it requires SQLCipher CGO build

**Testing:**
- Test standard SQLite path works without SQLCipher
- Document that encrypted path requires `CGO_ENABLED=1` and SQLCipher library
- Add a runtime check that warns if encrypted mode is requested without SQLCipher support

### 5.4 Task 1.4: Fix V4 History Table INDEX Syntax

**File:** `Database/DDL/Definition.V4.sql:71-74, 160-162`

**Current (invalid):**
```sql
CREATE TABLE ticket_history (
    ...
    INDEX (ticket_id, version)  -- INVALID in SQLite/PostgreSQL
);
```

**Fix:**
```sql
CREATE TABLE ticket_history (
    ...
);
CREATE INDEX idx_ticket_history_ticket_version ON ticket_history(ticket_id, version);
```

**Apply to all 6 history tables:** ticket_history, project_history, comment_history, dashboard_history, board_history, entity_lock

**Testing:** Run schema creation against both SQLite and PostgreSQL and verify no errors.

### 5.5 Task 1.5: Fix Indexes_Performance.sql

**File:** `Database/DDL/Indexes_Performance.sql`

**Complete Remediation (all corrections):**

| Line | Current (Wrong) | Correct |
|------|----------------|---------|
| 16 | `ticket(status_id)` | `ticket(ticket_status_id)` |
| 31 | `ticket(type_id)` | `ticket(ticket_type_id)` |
| 44 | `ticket(board_id)` | `ticket_board_mapping(board_id)` (through mapping table) |
| 44 | `ticket(cycle_id)` | `ticket_cycle_mapping(cycle_id)` (through mapping table) |
| 48 | `ticket(parent_id)` | `ticket(parent_ticket_id)` |
| 55 | `project(team_id)` | `team_project_mapping(project_id)` |
| 59 | `project(key)` | `project(identifier)` |
| 72 | `workflow(project_id)` | Remove — workflow table has no project_id |
| 79 | `workflow_transition` | Remove — table doesn't exist |
| ~80 | `status` | Remove — table doesn't exist (it's `ticket_status`) |
| ~95 | `team_member_mapping` | Remove — table doesn't exist (it's `user_team_mapping`) |
| ~100 | `user` | Remove — table doesn't exist (it's `user_default_mapping`) |
| ~110 | `workflow_step(step_order)` | Keep — column exists |
| ~120 | `commit` | `repository_commit_ticket_mapping(ticket_id)` |
| ~130 | `ticket_component_mapping` | `component_ticket_mapping(component_id)` |
| 159 | `comment(ticket_id)` | `comment_ticket_mapping(ticket_id)` |
| 164 | `comment(author_id)` | Remove — comment table has no author_id |
| 171 | `asset(ticket_id)` | `asset_ticket_mapping(asset_id)` |
| 176 | `asset(uploaded_by)` | Remove — asset table has no uploaded_by |
| 207 | `audit_log` | `audit` (correct table name) |

**Additional indexes to ADD (missing):**
```sql
-- V2 tables
CREATE INDEX idx_ticket_watcher ON ticket_watcher_mapping(ticket_id, user_id);
CREATE INDEX idx_ticket_affected_version ON ticket_affected_version_mapping(ticket_id);
CREATE INDEX idx_ticket_fix_version ON ticket_fix_version_mapping(ticket_id);
CREATE INDEX idx_filter_owner ON filter(owner_id);
CREATE INDEX idx_custom_field_project ON custom_field(project_id);
CREATE INDEX idx_ticket_custom_field ON ticket_custom_field_value(ticket_id, custom_field_id);

-- V3 tables
CREATE INDEX idx_work_log_ticket ON work_log(ticket_id);
CREATE INDEX idx_work_log_user ON work_log(user_id);
CREATE INDEX idx_project_role_project ON project_role(project_id);
CREATE INDEX idx_security_level_project ON security_level(project_id);
CREATE INDEX idx_dashboard_owner ON dashboard(owner_id);
CREATE INDEX idx_dashboard_widget_dashboard ON dashboard_widget(dashboard_id);
CREATE INDEX idx_ticket_vote ON ticket_vote_mapping(ticket_id);
CREATE INDEX idx_notification_rule_scheme ON notification_rule(notification_scheme_id);
CREATE INDEX idx_comment_mention ON comment_mention_mapping(mentioned_user_id);

-- V4 tables
CREATE INDEX idx_ticket_history_ticket ON ticket_history(ticket_id);
CREATE INDEX idx_entity_lock ON entity_lock(entity_type, entity_id);
```

### 5.6 Task 1.6: Deduplicate Migration.V5.6.sql

**Action:**
1. Delete `Application/Database/DDL/Migration.V5.6.sql` (keep only `Database/DDL/`)
2. Or: Merge the security_audit and permission_cache additions from Application version into Database version, without the duplicate table recreations

### 5.7 Task 1.7: Create SQLite-Compatible Chats V2 Schema

**File:** `Database/DDL/Extensions/Chats/Definition.V2.sql`

**Action:** Create `Definition.V2.sqlite.sql` that replaces:
- `UUID` → `TEXT`
- `gen_random_uuid()` → application-generated UUID
- `JSONB` → `TEXT` (JSON stored as text)
- `GIN` indexes → standard indexes
- Remove `COMMENT ON` statements
- Remove `CHECK` constraints with PostgreSQL-specific functions

### 5.8 Task 1.8: Fix Test Data Schema Mismatch

**File:** `Application/Database/DDL/Test_Data_Users_Permissions.sql`

**Problem:** Uses table names (`users`, `organizations`, `projects`, `user_permissions`, `project_roles`, `team_members`) that don't match the actual DDL schema.

**Fix:** Rewrite to use actual table/column names:
- `users` → `user_default_mapping`
- `organizations` → `organization`
- `projects` → `project`
- `user_permissions` → `permission_user_mapping`
- `project_roles` → `project_role`
- `team_members` → `user_team_mapping`

---

## 6. PHASE 2: SECURITY HARDENING

**Duration:** 1-2 weeks  
**Priority:** CRITICAL  
**Dependencies:** Phase 0 complete

### 6.1 Task 2.1: Remove Hardcoded JWT Secret

**Files:**
- `Application/internal/middleware/jwt.go:95`
- `Application/internal/services/jwt_service.go:22`

**Current:**
```go
const defaultJWTSecret = "helix-track-default-secret-key-change-in-production"
```

**Fix:**
1. Remove the default secret entirely
2. Add `jwt_secret` field to Config struct (`config.go`)
3. Add validation: if JWT is enabled and no secret configured, FAIL startup with clear error
4. Add `jwt_secret` to `Configurations/default.json` with value `"CHANGE_ME_BEFORE_PRODUCTION"`
5. Add startup check: if `jwt_secret == "CHANGE_ME_BEFORE_PRODUCTION"`, log WARNING and refuse to start in non-dev mode

**Config Addition:**
```json
{
  "security": {
    "jwt_secret": "CHANGE_ME_BEFORE_PRODUCTION",
    "jwt_expiry_hours": 24,
    "jwt_issuer": "helixtrack-core",
    "enforce_production_secrets": true
  }
}
```

### 6.2 Task 2.2: Configurable CORS

**File:** `Application/internal/server/server.go:325`

**Fix:**
1. Add `cors` configuration section to Config:
```json
{
  "cors": {
    "allowed_origins": ["http://localhost:3000"],
    "allowed_methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    "allowed_headers": ["Content-Type", "Authorization", "X-Request-ID"],
    "allow_credentials": true,
    "max_age": 86400
  }
}
```
2. Replace wildcard CORS with configured values
3. In dev mode, default to `["http://localhost:*"]`
4. In production mode, require explicit origin list

### 6.3 Task 2.3: Permission Enforcement Even When Disabled

**File:** `Application/internal/services/permission_service.go:66-67`

**Current:**
```go
if !p.enabled {
    return true, nil  // ALL operations allowed!
}
```

**Fix:**
1. When disabled, still check for admin role in JWT claims
2. Log every permission bypass at WARN level
3. Add config option: `permissions.deny_when_disabled: true` (default: true in production)
4. Document that "disabled" means "delegated to JWT role check" not "all allowed"

### 6.4 Task 2.4: Fix RBAC Middleware Request Body Consumption

**File:** `Application/internal/middleware/rbac.go:271-280`

**Current:**
```go
func extractResourceID(c *gin.Context) (string, error) {
    if c.Request.Method == "POST" || c.Request.Method == "PUT" {
        var body map[string]interface{}
        if err := c.ShouldBindJSON(&body); err != nil {  // CONSUMES BODY
            return "", err
        }
        // ...
    }
}
```

**Fix:**
1. Read body with `io.ReadAll(c.Request.Body)`, then restore it:
```go
bodyBytes, _ := io.ReadAll(c.Request.Body)
c.Request.Body = io.NopCloser(bytes.NewBuffer(bodyBytes))
var body map[string]interface{}
json.Unmarshal(bodyBytes, &body)
```
2. Or: Extract resource ID from URL parameters instead of request body
3. Or: Use Gin's `c.GetRawData()` which doesn't consume the body permanently

### 6.5 Task 2.5: Add Request ID Tracking

**Action:**
1. Add middleware that generates unique request ID (UUID) for every request
2. Include request ID in all log statements
3. Return request ID in response headers (`X-Request-ID`)
4. Log request ID in audit entries

### 6.6 Task 2.6: Add Rate Limiting to Production Default

**File:** `Application/internal/middleware/performance.go`

**Action:**
1. Enable rate limiting by default in production configs
2. Add configurable per-endpoint rate limits
3. Add rate limit headers to responses (`X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`)

---

## 7. PHASE 3: CORE API ANTI-BLUFF REMEDIATION

**Duration:** 3-4 weeks  
**Priority:** CRITICAL  
**Dependencies:** Phase 1, Phase 2 complete

### 7.1 Task 3.1: Implement PDF Export

**File:** `Application/internal/handlers/document_handler.go:4448`

**Current:** Returns fake success
**Implementation:**
1. Add dependency: `github.com/jung-kurt/gofpdf` or use HTML→PDF via wkhtmltopdf
2. Implement `handleDocumentExportPDF()` that:
   a. Fetches document content from database
   b. Converts to PDF format
   c. Stores result in a temporary file or returns as binary response
   d. Returns actual download URL or streamed response
3. Add content-type header `application/pdf`
4. Add error handling for conversion failures

### 7.2 Task 3.2: Implement Word/DOCX Export

**File:** `Application/internal/handlers/document_handler.go:4493`

**Implementation:**
1. Add dependency: `github.com/unidoc/unioffice` or `github.com/nguyenthenguyen/docx`
2. Implement proper DOCX generation from document content
3. Return `application/vnd.openxmlformats-officedocument.wordprocessingml.document`

### 7.3 Task 3.3: Implement HTML Export

**File:** `Application/internal/handlers/document_handler.go:4538`

**Implementation:**
1. For documents stored in Markdown: Convert MD→HTML via `github.com/yuin/goldmark`
2. For documents stored in HTML: Return content directly with proper wrapping
3. For documents stored in plain text: Wrap in `<pre>` tags with proper escaping
4. Return `text/html`

### 7.4 Task 3.4: Implement Markdown Export

**File:** `Application/internal/handlers/document_handler.go:4620`

**Implementation:**
1. For documents stored in HTML: Convert HTML→MD via `github.com/JohannesKaufmann/html-to-markdown`
2. For documents stored in Markdown: Return content directly
3. For documents stored in plain text: Wrap in code blocks
4. Return `text/markdown`

### 7.5 Task 3.5: Implement XML Export

**File:** `Application/internal/handlers/document_handler.go:4579`

**Implementation:**
1. Define XML schema for documents (title, content, metadata, versions)
2. Implement XML serialization with `encoding/xml`
3. Return `application/xml`

### 7.6 Task 3.6: Implement JSON Export

**File:** `Application/internal/handlers/document_handler.go:4702`

**Implementation:**
1. Fetch complete document with all metadata, versions, and relationships
2. Serialize to structured JSON
3. Return `application/json`

### 7.7 Task 3.7: Implement Plain Text Export

**File:** `Application/internal/handlers/document_handler.go:4661`

**Implementation:**
1. For HTML content: Strip tags via `github.com/kavu/go_renaming` or similar
2. For Markdown: Strip formatting markers
3. Return `text/plain`

### 7.8 Task 3.8: Implement LaTeX Export

**File:** `Application/internal/handlers/document_handler.go:4743`

**Implementation:**
1. Convert document content to LaTeX syntax
2. Escape special characters (`%`, `$`, `&`, `#`, `_`, `{`, `}`, `~`, `^`)
3. Return `application/x-latex`

### 7.9 Task 3.9: Implement Report Execution

**File:** `Application/internal/handlers/report_handler.go:546`

**Current:** Returns `"Report execution not yet implemented - placeholder response"`

**Implementation:**
1. Define report query language (SQL-based or custom)
2. Implement query builder from report definition
3. Execute query against database
4. Format results (JSON, CSV, aggregated)
5. Cache results with TTL
6. Add pagination support
7. Add export options (CSV, PDF)

### 7.10 Task 3.10: Implement Real Event Publishing

**Files:**
- `Application/internal/handlers/handler.go:39` — Replace NoOpPublisher
- `Application/internal/websocket/publisher.go:80-97` — NoOpPublisher

**Implementation:**
1. In `main.go`, initialize `WebSocketEventPublisher` when WebSocket is enabled
2. Pass real publisher to Handler constructor
3. Implement event queue with persistence (database-backed)
4. Add retry logic for failed event deliveries
5. Add event ordering guarantees
6. Add tests verifying events are actually published

### 7.11 Task 3.11: Audit All Remaining Stubs

**Action:**
1. Search entire codebase for `STUB`, `TODO`, `PLACEHOLDER`, `not implemented`, `no-op`
2. For each occurrence, create a tracking issue
3. Classify each as:
   - **BLOCKING**: Feature advertised as complete but not implemented
   - **NON-BLOCKING**: Future enhancement, not yet advertised
4. Fix all BLOCKING stubs before marking any feature as complete

### 7.12 Task 3.12: Implement Subtask Completion Status Check

**File:** `Application/internal/handlers/subtask_handler.go:560`

**Current:** Placeholder for checking if all subtasks are complete
**Implementation:** Query all subtasks for a parent ticket, check if all have completion status

---

## 8. PHASE 4: DOCUMENT EXTENSION COMPLETION

**Duration:** 2-3 weeks  
**Priority:** HIGH  
**Dependencies:** Phase 1, Phase 2 complete

### 8.1 Task 4.1: Fix Documents V2 Database Field Alignment

**Reference:** `Application/DOCUMENTS_V2_DATABASE_ISSUES.md`

**Action:**
1. Compare every column in `Database/DDL/Extensions/Documents/Definition.V2.sql` with every struct field in `Application/internal/models/document*.go`
2. Align field names, types, and nullability
3. Fix 8-10 documented mismatches
4. Create migration script for any schema changes needed

### 8.2 Task 4.2: Implement Documents V2 Database Layer Tests

**Scope:** 80+ methods in `Application/internal/database/database_documents_impl.go`

**Requirements:**
- Each method MUST have at least one integration test using real SQLite database
- Tests MUST verify data is actually written to and read from the database
- Tests MUST cover error cases (non-existent IDs, constraint violations)
- Target: 90%+ coverage for database_documents_impl.go

### 8.3 Task 4.3: Implement Documents V2 Handler Tests

**Scope:** All handlers in `Application/internal/handlers/document_handler.go` (7,050 lines)

**Requirements:**
- Split document_handler.go into smaller files by feature area:
  - `document_handler_crud.go` — Basic CRUD
  - `document_handler_content.go` — Content management
  - `document_handler_version.go` — Version control
  - `document_handler_collaboration.go` — Comments, mentions, watchers
  - `document_handler_export.go` — All export formats
  - `document_handler_template.go` — Templates and blueprints
  - `document_handler_analytics.go` — Views, analytics
  - `document_handler_search.go` — Search functionality
- Each handler MUST have integration tests with real database

### 8.4 Task 4.4: Implement Document Search

**Action:**
1. Implement full-text search using SQLite FTS5 (already defined in Indexes_Performance.sql)
2. Implement search across document content, titles, and metadata
3. Add faceted search (by space, type, labels, date range)
4. Add relevance ranking

---

## 9. PHASE 5: TESTING CONSTITUTION & ANTI-BLUFF TEST STRATEGY

**Duration:** 4-6 weeks (ONGOING — runs parallel with all other phases)  
**Priority:** MANDATORY — BINDING CONSTITUTION  
**Dependencies:** Phase 0 complete

### 9.1 Anti-Bluff Testing Principles

**CONSTITUTIONAL RULE:** A test that passes when the feature is broken is itself a bug.

**The Three Pillars of Anti-Bluff Testing:**

1. **Positive Verification:** Tests MUST assert that the expected outcome occurred, not just that no error occurred.
   - WRONG: `assert.NotEqual(t, 500, code)` — passes if code is 400, 404, etc.
   - RIGHT: `assert.Equal(t, 200, code)` AND `assert.Contains(t, body, expectedData)`

2. **Data Verification:** Tests MUST verify data was actually persisted/modified in the database.
   - WRONG: Handler returns 200 without checking DB
   - RIGHT: Handler returns 200 AND `SELECT * FROM table WHERE id = ?` returns the expected data

3. **Side-Effect Verification:** Tests MUST verify observable side effects occurred.
   - Events published (not NoOp)
   - Audit logs written
   - Notifications triggered
   - Cache invalidated

### 9.2 Test Type Coverage Matrix

| Test Type | Purpose | Scope | Current | Target | Anti-Bluff? |
|-----------|---------|-------|---------|--------|-------------|
| **Unit Tests** | Verify individual functions/methods | Single function | ~1,500 | ~2,000 | Partial (uses mocks) |
| **Integration Tests** | Verify handler→database cycle | Single handler + real DB | ~50 | ~400 | MUST be anti-bluff |
| **API Contract Tests** | Verify request/response format | All 387 actions | ~30 | ~387 | YES |
| **E2E Workflow Tests** | Verify complete user workflows | Multi-step scenarios | ~10 | ~50 | YES |
| **Security Tests** | Verify auth, permissions, input validation | All auth paths | ~20 | ~100 | YES |
| **Performance Tests** | Verify latency, throughput | Critical paths | 0 | ~20 | Partial |
| **Chaos Tests** | Verify graceful degradation | Failure scenarios | 0 | ~30 | YES |
| **Migration Tests** | Verify DB schema changes | All migrations | 0 | ~15 | YES |
| **Cross-Service Tests** | Verify service communication | All service pairs | 0 | ~20 | YES |

### 9.3 Task 5.1: Rewrite All Handler Tests with Anti-Bluff Assertions

**File:** `Application/internal/handlers/handler_test.go`

**Current Pattern (WRONG):**
```go
// handler_test.go:586
c.Set("username", "testuser")
handler.handleCreate(c, &reqBody)
assert.NotEqual(t, http.StatusUnauthorized, w.Code)
assert.NotEqual(t, http.StatusForbidden, w.Code)
```

**Required Pattern (CORRECT):**
```go
c.Set("username", "testuser")
handler.handleCreate(c, &reqBody)
assert.Equal(t, http.StatusCreated, w.Code)  // Assert EXACT expected status

var resp models.Response
json.Unmarshal(w.Body.Bytes(), &resp)
assert.Equal(t, -1, resp.ErrorCode)  // Assert no error

// Verify data was actually persisted
var count int
db.QueryRow("SELECT COUNT(*) FROM ticket WHERE id = ?", resp.Data["id"]).Scan(&count)
assert.Equal(t, 1, count)  // Assert data in database
```

**Scope:** ALL handler test files (~50 files)

### 9.4 Task 5.2: Rewrite All E2E Tests with Positive Assertions

**File:** `tests/e2e/pm_workflows_test.go`

**Current Pattern (WRONG):**
```go
resp := app.makeRequest(...)
assert.NotEqual(t, http.StatusInternalServerError, resp.Code)
if resp.Code == http.StatusCreated { ... }  // Conditional — skips on failure
```

**Required Pattern (CORRECT):**
```go
resp := app.makeRequest(...)
assert.Equal(t, http.StatusCreated, resp.Code, "Expected 201 Created, got %d: %s", resp.Code, resp.Body.String())
var created map[string]interface{}
json.Unmarshal(resp.Body.Bytes(), &created)
assert.NotEmpty(t, created["id"], "Response must contain an ID")
ticket1ID = created["id"].(string)
```

### 9.5 Task 5.3: Replace Skipped Tests with Real Implementations

**Files:**
- `internal/services/failover_manager_test.go:27,372,504,616,622` (5 functions)
- `internal/websocket/manager_integration_test.go:195` (CSRF test)
- All other `t.Skip()` locations

**For each skipped test:**
1. Determine why it was skipped
2. If it needs real infrastructure (e.g., failover), create an integration test that can run in CI
3. If it was skipped due to missing implementation, file a blocking issue
4. Remove the `t.Skip()` and implement the test properly

### 9.6 Task 5.4: Implement API Contract Tests for All 387 Actions

**Scope:** Every action defined in `Application/internal/models/request.go`

**Test Template:**
```go
func TestAction_X(t *testing.T) {
    // Setup: Real database with seed data
    db := setupTestDatabase(t)
    defer db.Close()
    seedTestData(t, db)

    // Execute: Real HTTP request
    req := models.Request{
        Action: "X",
        Object: "Y",
        JWT:    "valid-test-token",
        Data:   map[string]interface{}{/* required fields */},
    }
    body, _ := json.Marshal(req)
    resp := httptest.NewRecorder()
    c, _ := gin.CreateTestContext(resp)
    c.Request = httptest.NewRequest("POST", "/do", bytes.NewReader(body))

    handler.handleX(c, &req)

    // Assert: Exact status code + response structure
    assert.Equal(t, http.StatusOK, resp.Code)

    var response models.Response
    json.Unmarshal(resp.Body.Bytes(), &response)
    assert.Equal(t, -1, response.ErrorCode)

    // Verify: Data actually in database
    row := db.QueryRow("SELECT COUNT(*) FROM table WHERE ...")
    var count int
    row.Scan(&count)
    assert.GreaterOrEqual(t, count, 1)
}
```

**Action Groups (387 total):**

| Group | Actions | Tests Needed |
|-------|---------|-------------|
| System (no auth) | version, jwtCapable, dbCapable, health | 4 |
| Generic CRUD | create, modify, remove, read, list (× 20 entities) | 100 |
| Priority | priorityCreate/Read/List/Modify/Remove | 5 |
| Resolution | resolutionCreate/Read/List/Modify/Remove | 5 |
| Version | 13 version actions | 13 |
| Watchers | watcherAdd/Remove/List | 3 |
| Filters | filterSave/Load/List/Share/Modify/Remove | 6 |
| Custom Fields | 13 customField actions | 13 |
| Workflow | 5 workflow + 5 workflowStep + 5 ticketStatus + 8 ticketType | 23 |
| Board | 12 board + 5 boardConfig | 17 |
| Cycle | 11 cycle actions | 11 |
| Epic | 7 epic actions | 7 |
| Subtask | 5 subtask actions | 5 |
| Work Log | 6 worklog actions | 6 |
| Project Role | 8 projectRole actions | 8 |
| Security Level | 8 securityLevel actions | 8 |
| Dashboard | 10 dashboard actions | 10 |
| Vote | 5 vote actions | 5 |
| Project Category | 6 projectCategory actions | 6 |
| Notification | 10 notification actions | 10 |
| Activity Stream | 5 activity actions | 5 |
| Mentions | 6 mention actions | 6 |
| Documents V2 | 90 document actions | 90 |
| **TOTAL** | | **387** |

### 9.7 Task 5.5: Implement Security Testing Suite

**Test Categories:**

1. **Authentication Tests (20 tests):**
   - JWT with valid token → 200
   - JWT with expired token → 401
   - JWT with invalid signature → 401
   - JWT with missing claims → 401
   - No JWT on protected endpoint → 401
   - JWT with wrong issuer → 401
   - Token refresh flow
   - Token revocation (if implemented)

2. **Authorization Tests (30 tests):**
   - Admin role can access all endpoints
   - User role cannot access admin endpoints
   - Guest role can only read
   - Project-level permissions
   - Organization-level permissions
   - Cross-project access denied
   - Permission inheritance (org → team → project)

3. **Input Validation Tests (30 tests):**
   - SQL injection attempts → sanitized
   - XSS attempts → sanitized
   - Path traversal attempts → blocked
   - Oversized payloads → 413
   - Malformed JSON → 400
   - Missing required fields → 400
   - Invalid enum values → 400
   - Negative numbers where positive required → 400

4. **RBAC Tests (20 tests):**
   - extractResourceID does NOT consume request body
   - Security levels enforced
   - Project roles enforced
   - Resource-based access control

### 9.8 Task 5.6: Implement Performance Tests

**Critical Paths to Benchmark:**

| Endpoint | Target Latency | Target Throughput |
|----------|---------------|-------------------|
| `/do` (version) | < 1ms | 50,000+ req/s |
| `/do` (create ticket) | < 10ms | 10,000+ req/s |
| `/do` (list tickets) | < 50ms | 5,000+ req/s |
| `/do` (search) | < 100ms | 1,000+ req/s |
| `/do` (document export) | < 5s | 100+ req/s |
| `/do` (report execution) | < 30s | 10+ req/s |

**Tools:** Go `testing.B` benchmarks + `go test -bench`

### 9.9 Task 5.7: Implement Chaos Tests

**Scenarios:**

1. **Database failure:** Kill SQLite/PostgreSQL mid-operation → verify graceful error
2. **Service unavailable:** Authentication service down → verify fallback behavior
3. **Network partition:** Simulate network timeout to permissions service
4. **Disk full:** Simulate write failure during file operations
5. **Concurrent writes:** 100 concurrent requests to same ticket → verify no corruption
6. **Large payload:** 10MB request body → verify proper handling
7. **Rapid restart:** Kill and restart server 10 times → verify no data loss

### 9.10 Task 5.8: Implement Migration Tests

**For each migration script:**
1. Start with V1 database
2. Apply migration
3. Verify new tables exist
4. Verify data integrity
5. Verify rollback works

### 9.11 Task 5.9: Create "Challenge" System

**Purpose:** Automated tests that detect bluff — they verify the feature actually works, not just that the code doesn't crash.

**Challenge Template:**
```go
// Challenge: Can a user actually create a ticket, modify it, add a comment,
// assign a watcher, and then retrieve the complete ticket with all relations?
func TestChallenge_CompleteTicketLifecycle(t *testing.T) {
    // This test MUST use a real database, real auth, and real permissions
    // It MUST NOT use any mocks

    // Step 1: Create a project
    project := createProject(t, "Test Project")

    // Step 2: Create a ticket in the project
    ticket := createTicket(t, project.ID, "Test Ticket", "Description")

    // Step 3: Modify the ticket
    modifyTicket(t, ticket.ID, map[string]interface{}{"title": "Modified Title"})

    // Step 4: Add a comment
    comment := addComment(t, ticket.ID, "Test comment")

    // Step 5: Add a watcher
    addWatcher(t, ticket.ID, "user2")

    // Step 6: Retrieve the complete ticket
    retrieved := getTicket(t, ticket.ID)

    // Step 7: Verify ALL data is correct
    assert.Equal(t, "Modified Title", retrieved.Title)
    assert.Len(t, retrieved.Comments, 1)
    assert.Equal(t, "Test comment", retrieved.Comments[0].Content)
    assert.Len(t, retrieved.Watchers, 1)
    assert.Equal(t, "user2", retrieved.Watchers[0].Username)

    // Step 8: Delete the ticket
    removeTicket(t, ticket.ID)

    // Step 9: Verify soft delete
    deleted := getTicket(t, ticket.ID)
    assert.True(t, deleted.Deleted)
}
```

**Required Challenges (minimum 20):**

| # | Challenge | Features Tested |
|---|-----------|----------------|
| 1 | Complete Ticket Lifecycle | Create → Modify → Comment → Watch → Retrieve → Delete |
| 2 | Full Project Setup | Create project → Add team → Assign users → Create tickets |
| 3 | Sprint Management | Create sprint → Add tickets → Update statuses → Complete sprint |
| 4 | Board Workflow | Create board → Configure columns → Move tickets through workflow |
| 5 | Permission Enforcement | Create users with different roles → Verify access control |
| 6 | Document Lifecycle | Create space → Create page → Edit → Version → Export → Delete |
| 7 | Custom Fields | Create field → Set value → Query → Modify → Remove |
| 8 | Filter System | Save filter → Share → Load → Apply → Verify results |
| 9 | Version Management | Create version → Assign to tickets → Release → Archive |
| 10 | Notification Chain | Create ticket → Verify watchers notified → Verify audit log |
| 11 | Epic Management | Create epic → Assign stories → Update epic status → Verify |
| 12 | Subtask Hierarchy | Create parent → Create children → Complete all → Verify parent |
| 13 | Work Logging | Log time → Query by ticket → Query by user → Aggregate |
| 14 | Security Levels | Create level → Grant access → Verify enforcement → Revoke |
| 15 | Dashboard Widgets | Create dashboard → Add widgets → Verify data → Share |
| 16 | Voting System | Vote on ticket → Count votes → Check voter list → Unvote |
| 17 | Export Verification | Create document → Export to all formats → Verify each is valid |
| 18 | Search System | Create multiple docs → Search → Verify relevance order |
| 19 | Report Execution | Create report → Execute → Verify results match query |
| 20 | Concurrent Operations | 100 parallel ticket creates → Verify all succeeded → No corruption |

### 9.12 Task 5.10: Implement Independent Verification Pipeline

**Purpose:** Tests run by a separate system (not the developer's) to verify claims.

**Implementation:**
1. Create `scripts/verify-production-ready.sh` that:
   a. Builds from clean checkout
   b. Runs ALL tests (including challenges)
   c. Verifies exact pass count matches expected
   d. Verifies coverage meets minimum thresholds
   e. Checks for stubs/TODOs in production code
   f. Generates independent verification report
2. This script MUST be runnable by CI/CD and produce a pass/fail verdict
3. "Production Ready" label requires this script to pass

### 9.13 Task 5.11: Anti-Bluff Test Execution Rules (CONSTITUTIONAL)

These rules MUST be enforced for ALL test execution:

1. **Test count must match:** The reported test count MUST equal the actual number of test functions that ran (including skipped ones as failures)
2. **No silent skips:** `t.Skip()` MUST increment a "SKIPPED" counter that is compared against expected zero
3. **Coverage is meaningful:** Only code paths exercised by tests with positive assertions count toward coverage
4. **Challenge tests are gate:** All 20 challenges MUST pass before any release
5. **Independent verification:** The verification pipeline MUST NOT share code with the system under test

---

## 10. PHASE 6: SERVICE INTEGRATION & SUBMODULE REMEDIATION

**Duration:** 2-3 weeks  
**Priority:** HIGH  
**Dependencies:** Phase 0, Phase 1 complete

### 10.1 Task 6.1: Implement Real AuthService

**File:** `Application/internal/services/auth_service.go:147,154`

**Action:**
1. Implement `ValidateToken()` on real `httpAuthService`:
   - Make HTTP/3 request to Authentication service
   - Verify JWT signature using shared secret
   - Extract claims
   - Cache validated tokens with TTL
2. Implement `IsEnabled()` on real `httpAuthService`
3. Add integration test with mock Authentication service

### 10.2 Task 6.2: Fix Website Submodule

**Action:**
1. Change `.gitmodules` to HTTPS URL
2. Run `git submodule update --init --recursive`
3. If Website repo is empty, create placeholder landing page
4. Add CI check that verifies submodule is initialized

### 10.3 Task 6.3: Define Extensions Architecture

**Path:** `Extensions/`

**Action:**
1. Replace "Tbd." README with actual architecture document
2. Define extension interface:
```go
type Extension interface {
    Name() string
    Version() string
    RegisterRoutes(router *gin.RouterGroup)
    MigrateDatabase(db Database) error
    ValidateConfig(config map[string]interface{}) error
    HealthCheck() error
}
```
3. Create extension loader in main application
4. Document how to create new extensions

### 10.4 Task 6.4: Complete Attachments Service

**Path:** `Attachments-Service/`

**Remaining Work (from 40% to 100%):**

1. **Database Operations (remaining 40%):**
   - Storage endpoint CRUD
   - Quota management
   - Access log recording
   - Presigned URL generation
   - Cleanup job scheduling

2. **Storage Layer Integration:**
   - End-to-end upload → store → download flow
   - S3/MinIO integration testing
   - Deduplication engine implementation
   - Reference counter implementation

3. **Security Layer:**
   - ClamAV integration (or API-based scanning)
   - File type validation (magic bytes, not just extension)
   - Image bomb detection
   - Rate limiting per-user and per-IP

4. **Testing:**
   - Unit tests for all remaining handlers
   - Integration tests for upload/download flow
   - E2E tests with real S3/MinIO
   - Security tests (malicious files, oversized uploads)

5. **Deployment:**
   - Dockerfile
   - docker-compose.yml with all dependencies
   - Health check endpoint
   - Configuration documentation

### 10.5 Task 6.5: Implement Chat WebSocket Hub

**Path:** `Services/Chat/`

**Missing Components:**
1. WebSocket connection manager
2. Room-based message broadcasting
3. Typing indicators
4. Presence tracking
5. Read receipts
6. Message reactions via WebSocket
7. Reconnection handling with message replay

**Testing:**
- WebSocket integration tests using `gorilla/websocket` test client
- Concurrent connection tests
- Message ordering tests
- Reconnection tests

### 10.6 Task 6.6: Implement Cross-Service Integration Tests

**Test Matrix:**

| Service Pair | Test Scenario | Endpoint |
|-------------|---------------|----------|
| Core ↔ Chat | Create ticket → verify chat notification | HTTP |
| Core ↔ Localization | Request with locale → verify localized response | HTTP/3 |
| Core ↔ Attachments | Upload attachment → attach to ticket → download | HTTP |
| Chat ↔ Localization | Chat message with locale → verify translation | HTTP/3 |
| All Services | Health check across all services | HTTP |

---

## 11. PHASE 7: CONFIGURATION SYSTEM OVERHAUL

**Duration:** 1 week  
**Priority:** MEDIUM  
**Dependencies:** Phase 0 complete

### 11.1 Task 7.1: Fix All Configuration Files

| File | Issue | Fix |
|------|-------|-----|
| `Configurations/dev_with_ssl.json` | Wrong field names (`cert`/`key` vs `cert_file`/`key_file`) | Rename to `cert_file`/`key_file` |
| `Configurations/dev_with_ssl.json` | Empty cert/key strings | Add placeholder paths or remove HTTPS listeners |
| `Configurations/empty.json` | Fails validation | Move to `Configurations/test-fixtures/` |
| `Configurations/invalid.json` | 0 bytes | Move to `Configurations/test-fixtures/` |

### 11.2 Task 7.2: Add Missing Configuration Options

**New configuration sections to add:**

```json
{
  "security": {
    "jwt_secret": "CHANGE_ME_BEFORE_PRODUCTION",
    "jwt_expiry_hours": 24,
    "jwt_issuer": "helixtrack-core",
    "bcrypt_cost": 12,
    "cors": {
      "allowed_origins": ["http://localhost:3000"],
      "allowed_methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
      "allowed_headers": ["Content-Type", "Authorization"],
      "allow_credentials": true,
      "max_age": 86400
    },
    "rate_limiting": {
      "enabled": true,
      "requests_per_second": 1000,
      "burst": 2000
    }
  },
  "server": {
    "mode": "release",
    "read_timeout_seconds": 30,
    "write_timeout_seconds": 30,
    "idle_timeout_seconds": 60,
    "max_header_bytes": 1048576,
    "graceful_shutdown_seconds": 30
  },
  "database": {
    "connection_pool": {
      "max_open": 25,
      "max_idle": 5,
      "max_lifetime_minutes": 60,
      "max_idle_time_minutes": 15
    },
    "encryption": {
      "enabled": false,
      "key": "",
      "cipher_page_size": 4096
    }
  }
}
```

### 11.3 Task 7.3: Add Config-Driven Debug Mode

**File:** `Application/internal/server/server.go:143`

**Fix:** Read `server.mode` from config:
```go
mode := cfg.Server.Mode
if mode == "" {
    mode = "release"
}
gin.SetMode(gin.Mode(mode))
```

### 11.4 Task 7.4: Add Configuration Validation Tests

**Test every configuration file:**
- `default.json` MUST pass validation
- `dev.json` MUST pass validation
- `dev_with_ssl.json` MUST pass validation (after fix)
- `dev_with_websocket.json` MUST pass validation
- `Configurations/test-fixtures/empty.json` MUST fail validation (expected)
- `Configurations/test-fixtures/invalid.json` MUST fail JSON parsing (expected)

### 11.5 Task 7.5: Create Configuration Documentation

**File:** `Application/docs/CONFIGURATION_REFERENCE.md` (NEW)

**Must document:**
- Every configuration option with type, default, range, description
- Environment variable overrides (if any)
- Examples for common scenarios (dev, staging, production)
- Security considerations for each option

---

## 12. PHASE 8: PERFORMANCE & RELIABILITY

**Duration:** 2 weeks  
**Priority:** MEDIUM  
**Dependencies:** Phase 1, Phase 2 complete

### 12.1 Task 8.1: Split document_handler.go

**File:** `Application/internal/handlers/document_handler.go` (7,050 lines)

**Split into:**
| New File | Lines (est.) | Content |
|----------|-------------|---------|
| `document_handler.go` | ~200 | Router setup, common helpers |
| `document_handler_crud.go` | ~800 | Create, Read, Update, Delete |
| `document_handler_content.go` | ~600 | Content management |
| `document_handler_version.go` | ~800 | Version control, diff, rollback |
| `document_handler_collaboration.go` | ~700 | Comments, mentions, watchers, reactions |
| `document_handler_export.go` | ~1,200 | All export formats |
| `document_handler_template.go` | ~500 | Templates, blueprints, wizards |
| `document_handler_analytics.go` | ~400 | Views, analytics, popularity |
| `document_handler_search.go` | ~300 | Search, indexing |

### 12.2 Task 8.2: Remove Manual String Contains

**File:** `Application/internal/server/server.go:452-467`

**Fix:** Replace `contains()` and `containsInMiddle()` with `strings.Contains()`

### 12.3 Task 8.3: Decide on HTTP3Server

**Options:**
1. **Remove it** if not planned for use (recommended if no HTTP/3 requirement)
2. **Integrate it** into main server startup flow if HTTP/3 is a core feature
3. **Document it** as a future feature and move to a separate package

### 12.4 Task 8.4: Fix Event ID Generation

**File:** `Application/internal/server/server.go:539`

**Fix:**
```go
eventID := uuid.New().String()  // Instead of fmt.Sprintf("evt_%d", time.Now().UnixNano())
```

### 12.5 Task 8.5: Fix Port Wraparound

**File:** `Application/internal/server/server.go:385`

**Fix:**
```go
port = 1024 + (port - 65535 + 65535 - 1024) % (65535 - 1024)
// Or simpler:
if port > 65535 {
    port = 1024 + (port % (65535 - 1024))
}
```

### 12.6 Task 8.6: Fix Rate Limiter Goroutine Leak

**File:** `Application/internal/middleware/performance.go`

**Fix:** Add cleanup in server shutdown:
```go
func (r *rateLimiter) Close() {
    close(r.done)  // Signal cleanup goroutine to stop
}
```
Call `Close()` in server Shutdown handler.

### 12.7 Task 8.7: Fix Silent Error in Document Duplication

**File:** `Application/internal/database/database_documents_impl.go:344`

**Fix:**
```go
if err := d.CreateDocumentContent(newContent); err != nil {
    return nil, fmt.Errorf("failed to duplicate document content: %w", err)
}
```

### 12.8 Task 8.8: Add Graceful Shutdown for All Goroutines

**Action:** Audit all goroutine launches and ensure each has a cleanup path:
- Rate limiter cleanup
- Health checker stop
- Network discovery stop
- WebSocket connection cleanup
- Failover manager stop

---

## 13. PHASE 9: UX & ENTERPRISE READINESS

**Duration:** 2-3 weeks  
**Priority:** HIGH  
**Dependencies:** Phase 3, Phase 5 in progress

### 13.1 Task 9.1: Define API Error Response Standards

**Current Issue:** Error responses are inconsistent across handlers.

**Standard:**
```json
{
  "errorCode": 1001,
  "errorMessage": "Invalid request: missing required field 'title'",
  "errorMessageLocalised": "Неверный запрос: отсутствует обязательное поле 'title'",
  "errorDetails": [
    {
      "field": "title",
      "issue": "required",
      "message": "Field 'title' is required"
    }
  ],
  "requestId": "req_abc123",
  "timestamp": "2025-01-15T10:30:00Z"
}
```

### 13.2 Task 9.2: Implement Pagination for All List Endpoints

**Standard:**
```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "pageSize": 50,
    "totalItems": 1500,
    "totalPages": 30,
    "hasNext": true,
    "hasPrev": false
  }
}
```

**Apply to:** All `*List` actions (list, ticketList, projectList, etc.)

### 13.3 Task 9.3: Implement Field Selection (Sparse Fieldsets)

**Allow clients to request only specific fields:**
```
POST /do
{
  "action": "ticketRead",
  "data": {"id": "123", "fields": ["id", "title", "status"]}
}
```

### 13.4 Task 9.4: Implement Sorting for List Endpoints

```
POST /do
{
  "action": "ticketList",
  "data": {"sort": {"field": "created", "order": "desc"}}
}
```

### 13.5 Task 9.5: Implement Batch Operations

```
POST /do
{
  "action": "ticketBulkModify",
  "data": {
    "ids": ["id1", "id2", "id3"],
    "changes": {"status": "done"}
  }
}
```

### 13.6 Task 9.6: Add OpenAPI/Swagger Specification

**Action:**
1. Generate OpenAPI 3.0 spec from all action definitions
2. Add Swagger UI endpoint (`/docs`)
3. Add API playground for testing

---

## 14. PHASE 10: DOCUMENTATION, GUIDES & MANUALS

**Duration:** 2-3 weeks  
**Priority:** HIGH  
**Dependencies:** Phase 3 in progress, Phase 5 in progress

### 14.1 Task 10.1: Create Complete Configuration Reference

**File:** `Application/docs/CONFIGURATION_REFERENCE.md`

**Structure:**
```markdown
# HelixTrack Core Configuration Reference

## Overview
## Quick Start
## Configuration File Locations
## Environment Variables

## Section: log
### log_path
- Type: string
- Default: "/tmp/htCoreLogs"
- Description: Directory for log file output
- Validation: Must be a writable directory path
- Example: "/var/log/helixtrack"

### logfile_base_name
- Type: string
- Default: "htCore"
- Description: Base name for log files (rotation appends timestamp)
- Example: "htcore-production"

### log_size_limit
- Type: integer (bytes)
- Default: 100000000 (100 MB)
- Range: 1048576 (1 MB) to 10737418240 (10 GB)
- Description: Maximum size of a single log file before rotation
- Example: 524288000 (500 MB)

### level
- Type: string (enum)
- Default: "info"
- Valid values: "debug", "info", "warn", "error", "fatal", "panic"
- Description: Minimum log level. Messages below this level are discarded.
- Production recommendation: "info" or "warn"
- Development recommendation: "debug"

## Section: listeners[]
### address
- Type: string
- Default: "0.0.0.0"
- Description: Bind address for the HTTP server
- Security: "0.0.0.0" listens on all interfaces (use "127.0.0.1" for local-only)
- Example: "0.0.0.0"

### port
- Type: integer
- Default: 8080
- Range: 1-65535
- Description: TCP port for the HTTP server
- Security: Ports below 1024 require root/admin privileges
- Example: 8080

### https
- Type: boolean
- Default: false
- Description: Enable HTTPS/TLS for this listener
- Requirements: cert_file and key_file must be specified
- Example: true

### cert_file
- Type: string
- Default: "" (empty)
- Description: Path to TLS certificate file (PEM format)
- Required when: https is true
- Validation: File must exist and be readable
- Example: "/etc/ssl/certs/helixtrack.crt"

### key_file
- Type: string
- Default: "" (empty)
- Description: Path to TLS private key file (PEM format)
- Required when: https is true
- Validation: File must exist and be readable
- Security: File must have restricted permissions (600)
- Example: "/etc/ssl/private/helixtrack.key"

## Section: database
### type
- Type: string (enum)
- Default: "sqlite"
- Valid values: "sqlite", "postgres"
- Description: Database backend type
- Production recommendation: "postgres"

### sqlite_path
- Type: string
- Default: "Database/Definition.sqlite"
- Description: Path to SQLite database file
- Required when: type is "sqlite"
- Example: "/var/lib/helixtrack/data.sqlite"

### postgres_host
- Type: string
- Default: "localhost"
- Description: PostgreSQL server hostname
- Required when: type is "postgres"
- Example: "db.internal.example.com"

### postgres_port
- Type: integer
- Default: 5432
- Description: PostgreSQL server port
- Example: 5432

### postgres_user
- Type: string
- Default: ""
- Description: PostgreSQL username
- Required when: type is "postgres"
- Security: Use dedicated database user with minimum privileges
- Example: "helixtrack_app"

### postgres_password
- Type: string
- Default: ""
- Description: PostgreSQL password
- Required when: type is "postgres"
- Security: MUST be set via environment variable or secrets manager, never in config file
- Example: "${POSTGRES_PASSWORD}" (environment variable substitution)

### postgres_database
- Type: string
- Default: ""
- Description: PostgreSQL database name
- Required when: type is "postgres"
- Example: "helixtrack_production"

### postgres_ssl_mode
- Type: string (enum)
- Default: "disable"
- Valid values: "disable", "require", "verify-ca", "verify-full"
- Description: PostgreSQL SSL mode
- Production recommendation: "verify-full"
- Example: "verify-full"

## Section: services.authentication
### enabled
- Type: boolean
- Default: false
- Description: Enable external authentication service
- Security: Must be true for production deployments
- Example: true

### url
- Type: string (URL)
- Default: ""
- Description: HTTP/3 QUIC URL of the authentication service
- Required when: enabled is true
- Format: "https://hostname:port"
- Example: "https://auth.internal:8443"

### timeout
- Type: integer (seconds)
- Default: 30
- Range: 1-300
- Description: Request timeout for authentication service calls
- Example: 15

## Section: services.permissions
(Same structure as authentication)

## Section: services.lokalisation
(Same structure as authentication)

## Section: WebSocket
### enabled
- Type: boolean
- Default: false
- Description: Enable WebSocket support for real-time features
- Requirements: A WebSocket-capable reverse proxy (e.g., HAProxy, Nginx)
- Example: true

### path
- Type: string
- Default: "/ws"
- Description: WebSocket endpoint path
- Example: "/ws"

### readBufferSize
- Type: integer (bytes)
- Default: 1024
- Description: WebSocket read buffer size
- Range: 512-65536
- Example: 4096

### writeBufferSize
- Type: integer (bytes)
- Default: 1024
- Description: WebSocket write buffer size
- Range: 512-65536
- Example: 4096

### maxMessageSize
- Type: integer (bytes)
- Default: 524288 (512 KB)
- Range: 1024-10485760 (10 MB)
- Description: Maximum WebSocket message size
- Example: 1048576 (1 MB)

### writeWaitSeconds
- Type: integer (seconds)
- Default: 10
- Description: Timeout for writing messages to WebSocket connection
- Example: 10

### pongWaitSeconds
- Type: integer (seconds)
- Default: 60
- Description: Time to wait for pong response before considering connection dead
- Example: 60

### pingPeriodSeconds
- Type: integer (seconds)
- Default: 54 (must be less than pongWaitSeconds)
- Description: Interval between ping messages
- Validation: MUST be less than pongWaitSeconds
- Example: 54

### maxClients
- Type: integer
- Default: 1000
- Range: 1-100000
- Description: Maximum concurrent WebSocket connections
- Example: 5000

### requireAuth
- Type: boolean
- Default: false
- Description: Require JWT authentication for WebSocket connections
- Production recommendation: true
- Example: true

### allowOrigins
- Type: string array
- Default: ["*"]
- Description: Allowed WebSocket origins
- Security: MUST NOT be ["*"] in production
- Example: ["https://helixtrack.example.com"]

### enableCompression
- Type: boolean
- Default: false
- Description: Enable per-message compression for WebSocket
- Example: true

### handshakeTimeout
- Type: integer (seconds)
- Default: 10
- Description: WebSocket handshake timeout
- Example: 10

## Complete Example Configurations

### Development
[full dev.json with comments]

### Staging
[full staging.json with comments]

### Production
[full production.json with comments]
```

### 14.2 Task 10.2: Rewrite USER_MANUAL.md with Complete API Reference

**File:** `Application/docs/USER_MANUAL.md`

**Structure (for each of 387 actions):**
```markdown
## actionName

### Description
What this action does.

### Authentication
Required: Yes/No
Required Role: admin/user/guest
Required Permission: READ/CREATE/UPDATE/DELETE

### Request
```json
{
  "action": "actionName",
  "jwt": "<valid-jwt-token>",
  "object": "entityType",
  "data": {
    "field1": "value1",
    "field2": 123
  }
}
```

### Request Fields
| Field | Type | Required | Description | Default |
|-------|------|----------|-------------|---------|
| field1 | string | Yes | Description | — |
| field2 | integer | No | Description | 0 |

### Response (Success)
```json
{
  "errorCode": -1,
  "errorMessage": "",
  "data": {
    "id": "uuid",
    ...
  }
}
```

### Response (Error)
```json
{
  "errorCode": 3001,
  "errorMessage": "Entity not found",
  "errorMessageLocalised": "Сущность не найдена"
}
```

### Error Codes
| Code | Meaning |
|------|---------|
| -1 | Success |
| 1001 | Invalid request |
| 3001 | Entity not found |

### Example (curl)
```bash
curl -X POST http://localhost:8080/do \
  -H "Content-Type: application/json" \
  -d '{"action":"actionName","jwt":"...","data":{...}}'
```
```

### 14.3 Task 10.3: Rewrite DEPLOYMENT.md

**File:** `Application/docs/DEPLOYMENT.md`

**Sections:**
1. System Requirements
2. Installation Methods (binary, Docker, source)
3. Database Setup (SQLite, PostgreSQL)
4. Configuration Guide
5. TLS/SSL Setup
6. Service Architecture Deployment
7. Reverse Proxy Configuration (Nginx, HAProxy, Caddy)
8. Scaling Guide (horizontal, vertical)
9. Monitoring & Health Checks
10. Backup & Recovery
11. Migration Guide (between versions)
12. Troubleshooting

### 14.4 Task 10.4: Create CHANGELOG.md

**File:** `CHANGELOG.md` (NEW)

**Format:** Keep a Changelog (https://keepachangelog.com/)

### 14.5 Task 10.5: Create CONTRIBUTING.md

**File:** `CONTRIBUTING.md` (NEW)

**Sections:**
1. Code of Conduct
2. Development Setup
3. Pull Request Process
4. Anti-Bluff Testing Requirements (reference CONSTITUTION.md)
5. Code Style (reference AGENTS.md)
6. Commit Message Format
7. Documentation Requirements

---

## APPENDIX A: COMPLETE CONFIGURATION REFERENCE

See Section 14.1 (Task 10.1) for the full configuration reference specification.

---

## APPENDIX B: ANTI-BLUFF VERIFICATION CHECKLIST

Use this checklist to verify that EVERY feature is truly functional, not just claimed.

### B.1 Code-Level Checks

- [ ] No `t.Skip()` in test files without tracking issue
- [ ] No `// TODO: Implement` in handler code that is called in production
- [ ] No `// STUB` comments in production code paths
- [ ] No `fmt.Errorf("not implemented")` in methods reachable from handlers
- [ ] No `NoOpPublisher` used as default publisher in production config
- [ ] No hardcoded secrets (search for "secret", "password", "key" in source)
- [ ] No wildcard CORS in production configs
- [ ] No empty JSON responses where data is expected

### B.2 Test-Level Checks

- [ ] All handler tests assert EXACT status codes (not "not 500")
- [ ] All integration tests use real database (not mock)
- [ ] All integration tests verify data in database after operation
- [ ] All E2E tests verify complete workflow (not just "no crash")
- [ ] All security tests use real tokens (not mock "valid-test-token")
- [ ] Test coverage ≥ 80% for every package
- [ ] All Challenge tests pass

### B.3 Database-Level Checks

- [ ] All FK constraints defined (V1-V4)
- [ ] All indexes created successfully
- [ ] Migration scripts run without errors on fresh database
- [ ] Migration rollback scripts tested
- [ ] SQLite and PostgreSQL both work for all operations
- [ ] No orphaned records after CRUD operations
- [ ] No data loss after concurrent operations

### B.4 Documentation-Level Checks

- [ ] README.md claims match test results
- [ ] CLAUDE.md "Production Ready" label verified by anti-bluff tests
- [ ] Every configuration option documented with defaults
- [ ] Every API action documented with request/response examples
- [ ] No contradictory documentation (e.g., "100% Complete" with known TODOs)

### B.5 Service-Level Checks

- [ ] All submodules initialized and building
- [ ] All services start without errors
- [ ] Health checks return healthy for all services
- [ ] Cross-service communication works
- [ ] Graceful shutdown works for all services

---

## APPENDIX C: TEST TYPE COVERAGE MATRIX

### C.1 Current vs Target Coverage

| Package | Unit Tests | Integration Tests | E2E Tests | Challenges | Current Coverage | Target Coverage |
|---------|-----------|-------------------|-----------|------------|-----------------|-----------------|
| config | 15 ✅ | 0 | 0 | 0 | 100% | 100% |
| database | 14 ✅ | 0 | 0 | 0 | ~80% | 95% |
| optimized_database | ~20 ✅ | 0 | 0 | 0 | ~70% | 90% |
| database_documents | ~30 ✅ | 0 ⚠️ | 0 | 0 | ~50% (models only) | 90% |
| server | 10 ✅ | 0 | 0 | 0 | ~80% | 95% |
| logger | 12 ✅ | 0 | 0 | 0 | 100% | 100% |
| middleware/jwt | 12 ✅ | 0 | 0 | 0 | ~90% | 95% |
| middleware/rbac | ~20 ✅ | 0 ⚠️ | 0 | 0 | ~70% | 95% |
| middleware/performance | ~15 ✅ | 0 | 0 | 0 | ~60% | 90% |
| services/auth | 20 ✅ | 0 ⚠️ | 0 | 0 | ~80% | 95% |
| services/permission | ~25 ✅ | 0 ⚠️ | 0 | 0 | ~75% | 95% |
| services/failover | ~15 ⚠️ | 0 ❌ | 0 | 0 | ~50% (5 skipped) | 90% |
| services/health | ~15 ✅ | 0 | 0 | 0 | ~70% | 90% |
| models/* | ~400 ✅ | N/A | N/A | N/A | ~90% | 95% |
| handlers/handler | ~20 ✅ | 0 ⚠️ | 0 | 0 | ~60% (weak asserts) | 90% |
| handlers/document | ~100 ✅ | 0 ❌ | 0 | 0 | ~50% (models only) | 90% |
| handlers/* (other) | ~200 ✅ | 0 ⚠️ | 0 | 0 | ~65% | 90% |
| security/* | ~100 ✅ | 0 | 0 | 0 | ~80% | 90% |
| tests/integration | 0 | ~10 ⚠️ | N/A | N/A | Weak | Strong |
| tests/e2e | 0 | N/A | ~10 ⚠️ | N/A | Weak | Strong |
| **TOTAL** | **~900** | **~10** | **~10** | **0** | **~71%** | **≥90%** |

### C.2 Challenge Coverage Matrix

| # | Challenge | Entities Tested | Status |
|---|-----------|----------------|--------|
| 1 | Complete Ticket Lifecycle | ticket, project, comment, watcher | ❌ Not Implemented |
| 2 | Full Project Setup | project, team, user, ticket | ❌ Not Implemented |
| 3 | Sprint Management | cycle, ticket, project | ❌ Not Implemented |
| 4 | Board Workflow | board, board_column, ticket | ❌ Not Implemented |
| 5 | Permission Enforcement | permission, user, role | ❌ Not Implemented |
| 6 | Document Lifecycle | document, document_content, document_version | ❌ Not Implemented |
| 7 | Custom Fields | custom_field, ticket_custom_field_value | ❌ Not Implemented |
| 8 | Filter System | filter, ticket | ❌ Not Implemented |
| 9 | Version Management | version, ticket, project | ❌ Not Implemented |
| 10 | Notification Chain | notification_scheme, notification_rule, audit | ❌ Not Implemented |
| 11 | Epic Management | ticket (epic), ticket (story) | ❌ Not Implemented |
| 12 | Subtask Hierarchy | ticket (parent), ticket (subtask) | ❌ Not Implemented |
| 13 | Work Logging | work_log, ticket, user | ❌ Not Implemented |
| 14 | Security Levels | security_level, user, project | ❌ Not Implemented |
| 15 | Dashboard Widgets | dashboard, dashboard_widget | ❌ Not Implemented |
| 16 | Voting System | ticket_vote_mapping, ticket | ❌ Not Implemented |
| 17 | Export Verification | document, export handlers | ❌ Not Implemented |
| 18 | Search System | document, FTS5 index | ❌ Not Implemented |
| 19 | Report Execution | report, report_meta_data | ❌ Not Implemented |
| 20 | Concurrent Operations | ticket (bulk creates) | ❌ Not Implemented |

---

## IMPLEMENTATION TIMELINE SUMMARY

| Phase | Duration | Dependencies | Key Deliverables |
|-------|----------|-------------|------------------|
| **Phase 0: Foundation** | 3-5 days | None | Constitution, CLAUDE.md, AGENTS.md updates |
| **Phase 1: Database** | 2-3 weeks | Phase 0 | FK constraints, PG compatibility, fixed indexes |
| **Phase 2: Security** | 1-2 weeks | Phase 0 | No hardcoded secrets, configurable CORS, RBAC fix |
| **Phase 3: Anti-Bluff API** | 3-4 weeks | Phase 1, 2 | Real exports, report execution, event publishing |
| **Phase 4: Documents V2** | 2-3 weeks | Phase 1, 2 | DB alignment, handler tests, search |
| **Phase 5: Testing** | 4-6 weeks (parallel) | Phase 0 | Anti-bluff tests, challenges, 387 contract tests |
| **Phase 6: Services** | 2-3 weeks | Phase 1 | Real auth, attachments, chat WebSocket |
| **Phase 7: Configuration** | 1 week | Phase 0 | Fixed configs, new options, documentation |
| **Phase 8: Performance** | 2 weeks | Phase 1, 2 | Code cleanup, goroutine fixes, benchmarks |
| **Phase 9: UX** | 2-3 weeks | Phase 3, 5 | Pagination, sorting, OpenAPI spec |
| **Phase 10: Documentation** | 2-3 weeks | Phase 3, 5 | Config reference, API docs, deployment guide |
| **TOTAL** | **~22-30 weeks** | | **Production-ready, anti-bluff verified** |

### Parallel Execution Strategy

```
Week 1-1.5:  Phase 0 (Foundation)
Week 1.5-5:  Phase 1 (Database) ─────┐
Week 1.5-3:  Phase 2 (Security) ─────┤
Week 1.5-3:  Phase 7 (Config) ───────┤── Sequential
                                     │
Week 3-8:    Phase 3 (Anti-Bluff API) ┤
Week 3-5:    Phase 4 (Documents V2) ──┤
Week 3-5:    Phase 6 (Services) ──────┤── Parallel
Week 3-5:    Phase 8 (Performance) ───┤
                                     │
Week 1.5-22: Phase 5 (Testing) ──────┤── Continuous (parallel with all)
                                     │
Week 6-9:    Phase 9 (UX) ───────────┤── After Phase 3
Week 6-9:    Phase 10 (Docs) ────────┘── After Phase 3
```

### Critical Path

The critical path is: **Phase 0 → Phase 1 → Phase 3 → Phase 5 → Phase 10**

All other phases can run in parallel but cannot be considered "complete" until the critical path is done and all anti-bluff tests pass.

---

## FINAL REMARKS

This plan represents the minimum required work to make HelixTrack Core truly production-ready and anti-bluff-proofed. The key insight from this analysis is that **the project's claims significantly exceed its actual implementation**. The anti-bluff principle must be embedded in the project's constitution and enforced through automated verification.

**The most important action items are:**

1. **Constitution first** (Phase 0) — Establish rules that prevent future bluff
2. **Database integrity** (Phase 1) — FK constraints prevent data corruption
3. **Security hardening** (Phase 2) — Remove all default secrets and wildcard CORS
4. **Real implementations** (Phase 3) — Replace all stubs with working code
5. **Anti-bluff tests** (Phase 5) — Verify everything actually works

No feature should be marked "Production Ready" or "100% Complete" unless ALL of the following are true:
- Implementation is complete (no stubs, no TODOs in code paths)
- Tests verify real behavior (positive assertions, database verification)
- Challenges pass (end-to-end workflow verification)
- Documentation matches reality (no overclaiming)
- Independent verification pipeline passes

---

**END OF PLAN**

*This document is part of the HelixTrack Project Constitution. All contributors and AI agents MUST read and follow these guidelines.*
