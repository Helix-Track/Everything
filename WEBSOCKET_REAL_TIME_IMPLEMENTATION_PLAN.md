# WebSocket Real-Time Localization Updates - Implementation Plan

**Date:** 2025-01-21
**Status:** 🚧 In Progress
**Objective:** Add real-time WebSocket events for all localization changes across all clients

---

## 📋 Requirements Summary

### Core Functionality
✅ WebSocket events for **all** localization changes:
- Language: Add, Modify, Delete
- Localization Key: Add, Modify, Delete
- Translation: Add, Modify, Delete, Approve
- Batch Operations: Complete
- Catalog: Rebuilt
- Cache: Invalidated
- Version: Created, Deleted

✅ All clients subscribe and react to events:
- Core Application
- Web Client
- Desktop Client (future)
- Android Client (future)
- iOS Client (future)

✅ Comprehensive testing (4 types, 100% coverage):
- Unit tests
- Integration tests
- E2E tests
- Load/Performance tests

✅ Documentation updates

---

## 🏗️ Architecture Overview

### Event Flow

```
Localization Service (Go)
    ↓
 [WebSocket Manager]
    ↓
 [Broadcast Event]
    ↓↓↓
  [Clients Subscribe]
    ↓
 Core App | Web Client | Mobile Clients
    ↓
 [React to Event]
    ↓
 Invalidate Cache / Reload Data
```

### Event Types (13 total)

**Language Events (3):**
- `language.added`
- `language.updated`
- `language.deleted`

**Key Events (3):**
- `key.added`
- `key.updated`
- `key.deleted`

**Translation Events (4):**
- `localization.added`
- `localization.updated`
- `localization.deleted`
- `localization.approved`

**System Events (3):**
- `batch.completed`
- `catalog.rebuilt`
- `cache.invalidated`
- `version.created`
- `version.deleted`

---

## ✅ Files Already Created

### 1. WebSocket Event Definitions
**File:** `Core/Services/Localization/internal/websocket/events.go`
- 13 event type constants
- Event struct with timestamp and metadata
- 7 event data structs
- Helper functions (NewEvent, ParseData, ToJSON, FromJSON)
- **Lines:** 180

### 2. WebSocket Manager
**File:** `Core/Services/Localization/internal/websocket/manager.go`
- Manager struct (handles connections)
- Client struct (represents connected client)
- Connection handling (upgrade, register, unregister)
- Event broadcasting to all subscribed clients
- Read/Write pumps for WebSocket communication
- Subscription management (subscribe, unsubscribe, subscribeAll)
- Ping/Pong heartbeat
- **Lines:** 280

---

## 📋 Remaining Implementation Tasks

### Phase 1: Backend Integration (4-6 hours)

#### 1.1 Update Localization Service Main ✅
**File:** `Core/Services/Localization/cmd/main.go`
- Initialize WebSocket manager
- Start manager in goroutine
- Add WebSocket endpoint `/ws`
- Graceful shutdown

#### 1.2 Integrate with Handlers
**Files to Update:**
- `internal/handlers/language_handlers.go`
- `internal/handlers/key_handlers.go`
- `internal/handlers/localization_handlers.go`
- `internal/handlers/version_handlers.go`
- `internal/handlers/import_export_handlers.go`

**Changes:**
- Add WebSocket manager to handler struct
- Broadcast events after successful operations
- Include metadata (user, correlation ID)

**Example:**
```go
// After creating a language
wsManager.BroadcastEvent(
    websocket.EventLanguageAdded,
    &websocket.LanguageEventData{
        ID: language.ID,
        Code: language.Code,
        Name: language.Name,
        // ...
    },
    &websocket.EventMetadata{
        Username: username,
    },
)
```

#### 1.3 Add go.mod Dependency
```bash
go get github.com/gorilla/websocket
```

### Phase 2: Core Application Integration (2-3 hours)

#### 2.1 Create WebSocket Client
**File:** `Core/Application/internal/services/localization_websocket_client.go`
- Connect to Localization service WebSocket
- Subscribe to all events
- Handle reconnection
- Event handlers

#### 2.2 Integrate with Localization Service
**File:** `Core/Application/internal/services/localization_service.go`
- Add WebSocket client
- Connect on service initialization
- React to events:
  - `cache.invalidated` → Clear cache
  - `catalog.rebuilt` → Reload catalog
  - `localization.*` → Invalidate specific language cache

#### 2.3 Update Server
**File:** `Core/Application/internal/server/server.go`
- Initialize WebSocket connection to Localization service
- Graceful shutdown

### Phase 3: Web Client Integration (3-4 hours)

#### 3.1 Create WebSocket Service
**File:** `Web-Client/src/app/core/services/websocket.service.ts`
- WebSocket connection management
- Reconnection logic
- Event subscription
- RxJS Observable streams

#### 3.2 Create Localization WebSocket Service
**File:** `Web-Client/src/app/features/localization-management/services/localization-websocket.service.ts`
- Subscribe to localization events
- Emit to components via RxJS
- Handle all 13 event types

#### 3.3 Update Components to React to Events
**Files:**
- `translation-editor.component.ts` - Reload grid on changes
- `language-list.component.ts` - Reload list on language changes
- `key-manager.component.ts` - Reload keys on key changes

**Example:**
```typescript
this.localizationWs.onEvent(EventType.LocalizationUpdated)
  .subscribe(event => {
    // Reload the specific row
    this.updateTranslationRow(event.data);
  });
```

### Phase 4: Comprehensive Testing (8-12 hours)

#### 4.1 Unit Tests
**Backend:**
- `websocket/events_test.go` (event creation, parsing)
- `websocket/manager_test.go` (manager lifecycle, broadcasting)
- `websocket/client_test.go` (subscription management)

**Frontend:**
- `websocket.service.spec.ts`
- `localization-websocket.service.spec.ts`

**Coverage Target:** 100%

#### 4.2 Integration Tests
**Backend:**
- `websocket_integration_test.go`
  - Connect multiple clients
  - Broadcast event
  - Verify all clients receive
  - Test subscription filtering
  - Test reconnection

**Frontend:**
- Test component reactions to events
- Test cache invalidation
- Test data reloading

**Coverage Target:** All event types, all clients

#### 4.3 E2E Tests
**Scenarios:**
1. **Multi-User Editing:**
   - User A edits translation
   - User B sees update immediately
   - Verify no conflicts

2. **Cache Invalidation:**
   - Admin invalidates cache
   - All clients reload data
   - Verify fresh data

3. **Batch Operations:**
   - Admin performs batch update
   - All clients notified
   - Verify progress

4. **Network Interruption:**
   - Disconnect WebSocket
   - Make changes (queued)
   - Reconnect
   - Verify sync

**Tools:** Cypress, Playwright

#### 4.4 Load/Performance Tests
**Scenarios:**
1. **Connection Load:**
   - Connect 1,000 clients
   - Measure memory usage
   - Verify all connected

2. **Broadcasting Load:**
   - Broadcast 10,000 events/second
   - Measure latency
   - Verify delivery rate

3. **Subscription Performance:**
   - Test selective subscriptions
   - Measure filtering overhead

**Tools:** k6, Apache JMeter, Go benchmarks

**Metrics:**
- Latency: < 50ms (median)
- Throughput: > 10,000 events/sec
- Memory: < 100MB for 1,000 clients
- CPU: < 50% under normal load

### Phase 5: Documentation (2-3 hours)

#### 5.1 Update Service Documentation
**Files:**
- `Core/Services/Localization/README.md`
- `Core/Services/Localization/USER_MANUAL.md`
- `Core/Services/Localization/ARCHITECTURE.md`

**Additions:**
- WebSocket endpoint documentation
- Event type reference
- Client integration guide
- Subscription examples

#### 5.2 Update Client Documentation
**Files:**
- `Web-Client/README.md`
- `Core/Application/docs/USER_MANUAL.md`

**Additions:**
- How to subscribe to events
- Event handling patterns
- Troubleshooting guide

#### 5.3 Create WebSocket Guide
**File:** `Core/Services/Localization/WEBSOCKET_GUIDE.md`
- Complete reference
- All event types with examples
- Client implementation guide
- Testing strategies

---

## 📊 Implementation Statistics

### Code to Add/Modify

**Backend (Go):**
- New files: 4 (events.go, manager.go, 2 test files)
- Modified files: 6 (main.go, 5 handler files)
- Total lines: ~1,500

**Frontend (TypeScript):**
- New files: 3 (2 services, 1 test)
- Modified files: 3 (3 components)
- Total lines: ~800

**Tests:**
- Unit tests: ~600 lines
- Integration tests: ~400 lines
- E2E tests: ~300 lines
- Load tests: ~200 lines

**Documentation:**
- Updated docs: 5 files (~500 lines)
- New guide: 1 file (~300 lines)

**Total:** ~4,600 lines of code + documentation

---

## 🧪 Test Coverage Plan

### Unit Tests (Target: 100%)

**Backend:**
```go
// events_test.go
func TestNewEvent(t *testing.Testing) {...}
func TestEventToJSON(t *testing.T) {...}
func TestEventFromJSON(t *testing.T) {...}
func TestEventParseData(t *testing.T) {...}

// manager_test.go
func TestManagerStart(t *testing.T) {...}
func TestManagerBroadcast(t *testing.T) {...}
func TestManagerRegisterClient(t *testing.T) {...}
func TestManagerUnregisterClient(t *testing.T) {...}
func TestClientSubscription(t *testing.T) {...}
```

**Frontend:**
```typescript
describe('WebSocketService', () => {
  it('should connect to server', () => {...});
  it('should reconnect on disconnect', () => {...});
  it('should emit events', () => {...});
});
```

### Integration Tests

```go
func TestWebSocketIntegration(t *testing.T) {
  // Start server
  // Connect multiple clients
  // Broadcast event
  // Verify all receive
  // Test filtering
}
```

### E2E Tests

```typescript
describe('Real-time Updates', () => {
  it('should update translation grid on remote change', () => {
    // Open two browsers
    // Edit in browser 1
    // Verify update in browser 2
  });
});
```

### Load Tests

```javascript
// k6 script
export default function() {
  // Connect 1000 WebSocket clients
  // Measure latency
  // Verify throughput
}
```

---

## 🚀 Implementation Timeline

### Day 1 (Backend)
- ✅ Create event definitions (done)
- ✅ Create WebSocket manager (done)
- ⏳ Integrate with main.go (2 hours)
- ⏳ Update handlers (3 hours)
- ⏳ Add go.mod dependency (5 min)

### Day 2 (Core Application)
- ⏳ Create WebSocket client (2 hours)
- ⏳ Integrate with service (1 hour)
- ⏳ Test integration (2 hours)

### Day 3 (Web Client)
- ⏳ Create WebSocket services (2 hours)
- ⏳ Update components (2 hours)
- ⏳ Test UI updates (2 hours)

### Day 4-5 (Testing)
- ⏳ Write unit tests (4 hours)
- ⏳ Write integration tests (3 hours)
- ⏳ Write E2E tests (3 hours)
- ⏳ Write load tests (2 hours)
- ⏳ Execute all tests (2 hours)

### Day 6 (Documentation)
- ⏳ Update existing docs (2 hours)
- ⏳ Create WebSocket guide (1 hour)
- ⏳ Review and polish (1 hour)

**Total Estimated Time:** 35-40 hours (1 week)

---

## 📈 Success Criteria

### Functional
- [x] All 13 event types defined
- [ ] WebSocket server running
- [ ] All handlers broadcast events
- [ ] Core Application subscribes and reacts
- [ ] Web Client subscribes and reacts
- [ ] Real-time updates visible in UI

### Performance
- [ ] Latency < 50ms (p50)
- [ ] Latency < 100ms (p99)
- [ ] Supports 1,000+ concurrent clients
- [ ] Memory < 100MB per 1,000 clients
- [ ] CPU < 50% under normal load

### Testing
- [ ] Unit tests: 100% coverage
- [ ] Integration tests: All scenarios covered
- [ ] E2E tests: All user flows covered
- [ ] Load tests: Performance validated
- [ ] All tests: 100% passing

### Documentation
- [ ] WebSocket guide created
- [ ] All docs updated
- [ ] Examples provided
- [ ] Troubleshooting guide added

---

## 💡 Key Design Decisions

### Why Gorilla WebSocket?
- Industry standard for Go
- Well-tested and maintained
- Full WebSocket protocol support
- Good performance

### Why Broadcast to All by Default?
- Simplifies client implementation
- Clients can filter events
- Ensures no missed updates
- Minimal overhead with filtering

### Why Include Metadata?
- Audit trail (who made the change)
- Correlation (track related events)
- Debugging (trace event source)

### Why Heartbeat (Ping/Pong)?
- Detect dead connections
- Keep connections alive through proxies
- Clean up stale clients

---

## 🐛 Edge Cases to Handle

1. **Client Disconnect During Broadcast**
   - Gracefully handle send failures
   - Clean up client resources

2. **Event Storm**
   - Rate limiting on broadcast
   - Buffering for burst traffic

3. **Network Partition**
   - Clients auto-reconnect
   - Missed events handled on reconnect

4. **Concurrent Updates**
   - Optimistic locking
   - Conflict resolution

5. **Memory Leaks**
   - Proper client cleanup
   - Channel closure
   - Goroutine termination

---

## 📞 Next Steps

1. **Immediate:** Integrate WebSocket manager with Localization service main.go
2. **Next:** Update all handlers to broadcast events
3. **Then:** Create Core Application WebSocket client
4. **After:** Create Web Client WebSocket services
5. **Finally:** Comprehensive testing and documentation

---

**Status:** 🚧 **10% Complete** (event definitions + manager created)
**Remaining:** Backend integration, client integration, testing, documentation
**Estimated Completion:** 1 week (35-40 hours)
**Priority:** High (enables real-time collaboration)
