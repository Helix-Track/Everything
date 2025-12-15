# AI-Powered Translation Wizard - Implementation Plan

**Date:** 2025-01-21
**Status:** 🚀 Ready to Implement
**Objective:** Add AI-powered automatic translation with wizard interface for seamless language addition

---

## 🎯 Feature Overview

### Core Capabilities

1. **Language & Country Wizard**
   - Visual wizard interface for selecting languages/countries
   - Support for all ISO 639-1 languages (184+)
   - Support for all ISO 3166-1 countries (249+)
   - Language variants (e.g., en-US, en-GB, fr-FR, fr-CA)

2. **AI Translation Engine**
   - Automatic translation from English (or first available language)
   - Multiple AI providers:
     - OpenAI GPT-4 (primary)
     - Google Translate API (fallback)
     - DeepL API (premium option)
   - Context-aware translation (preserves placeholders)
   - Quality scoring and validation

3. **Real-Time Notifications**
   - WebSocket events to all connected clients
   - Progress updates during translation
   - Completion notifications
   - Error alerts

4. **Automatic Client Updates**
   - Clients auto-detect new languages
   - UI components dynamically add columns
   - Cache invalidation triggers reload
   - Seamless integration

---

## 🏗️ Architecture

### Component Structure

```
Web Client Wizard
    ↓
POST /v1/admin/languages/wizard
    ↓
Localization Service
    ↓
1. Create Language Entry
2. Trigger AI Translation
    ↓
AI Translation Service
    ↓
3. Translate All Keys
4. Save Translations
5. Build Catalog
    ↓
WebSocket Broadcast
    ↓
All Clients (Core, Web, Mobile)
    ↓
Invalidate Cache & Reload
```

---

## 📁 Implementation Files

### Phase 1: Language & Country Data (2 hours)

#### 1.1 ISO Language/Country Data
**File:** `Core/Services/Localization/data/languages.json`
```json
[
  {
    "code": "en",
    "name": "English",
    "nativeName": "English",
    "countries": ["US", "GB", "CA", "AU", "NZ"],
    "isRTL": false
  },
  {
    "code": "ar",
    "name": "Arabic",
    "nativeName": "العربية",
    "countries": ["SA", "EG", "AE", "MA", "DZ"],
    "isRTL": true
  }
  // ... 184+ languages
]
```

**File:** `Core/Services/Localization/data/countries.json`
```json
[
  {
    "code": "US",
    "name": "United States",
    "nativeName": "United States",
    "languages": ["en", "es"]
  },
  {
    "code": "FR",
    "name": "France",
    "nativeName": "France",
    "languages": ["fr"]
  }
  // ... 249+ countries
]
```

#### 1.2 Wizard Data Endpoint
**File:** `Core/Services/Localization/internal/handlers/wizard_handlers.go`
```go
// GET /v1/admin/wizard/languages - Get all available languages
// GET /v1/admin/wizard/countries - Get all countries
// GET /v1/admin/wizard/variants/:languageCode - Get language variants
```

### Phase 2: AI Translation Service (6-8 hours)

#### 2.1 AI Translation Interface
**File:** `Core/Services/Localization/internal/ai/translator.go`
```go
package ai

type Translator interface {
    Translate(text, sourceLanguage, targetLanguage string) (string, error)
    TranslateBatch(texts []string, sourceLanguage, targetLanguage string) ([]string, error)
    GetSupportedLanguages() []string
    GetQualityScore(translation string) float64
}

type OpenAITranslator struct {
    apiKey string
    model  string // gpt-4, gpt-3.5-turbo
}

type GoogleTranslator struct {
    apiKey string
}

type DeepLTranslator struct {
    apiKey string
}
```

#### 2.2 Translation Engine
**File:** `Core/Services/Localization/internal/ai/engine.go`
```go
package ai

type TranslationEngine struct {
    primaryTranslator   Translator
    fallbackTranslator  Translator
    logger              *zap.Logger
}

type TranslationRequest struct {
    SourceLanguage string
    TargetLanguage string
    Keys           []LocalizationKey
    SourceTexts    map[string]string
}

type TranslationResult struct {
    Language       string
    Translations   map[string]string
    QualityScores  map[string]float64
    Duration       time.Duration
    Provider       string
}

func (e *TranslationEngine) TranslateAll(req *TranslationRequest) (*TranslationResult, error)
```

#### 2.3 Placeholder Preservation
**File:** `Core/Services/Localization/internal/ai/placeholder.go`
```go
// Preserve {name}, {count}, etc. in translations
func PreservePlaceholders(text string) (string, map[string]string)
func RestorePlaceholders(translated string, placeholders map[string]string) string
```

### Phase 3: Wizard API Endpoints (4-6 hours)

#### 3.1 Wizard Endpoint
**File:** `Core/Services/Localization/internal/handlers/wizard_handlers.go`
```go
// POST /v1/admin/languages/wizard
type WizardRequest struct {
    Language        string   `json:"language"`        // "fr"
    Country         string   `json:"country"`         // "FR"
    Variant         string   `json:"variant"`         // "fr-FR"
    Name            string   `json:"name"`            // "French (France)"
    NativeName      string   `json:"nativeName"`      // "Français (France)"
    SourceLanguage  string   `json:"sourceLanguage"`  // "en" or "auto"
    AIProvider      string   `json:"aiProvider"`      // "openai", "google", "deepl"
    AutoActivate    bool     `json:"autoActivate"`    // true/false
}

type WizardResponse struct {
    JobID          string  `json:"jobId"`
    Status         string  `json:"status"`          // "started", "processing", "completed", "failed"
    Language       string  `json:"language"`
    EstimatedTime  int     `json:"estimatedTime"`   // seconds
    Progress       float64 `json:"progress"`        // 0-100
}
```

#### 3.2 Progress Tracking
**File:** `Core/Services/Localization/internal/jobs/translation_job.go`
```go
type TranslationJob struct {
    ID             string
    Language       string
    Status         string
    Progress       float64
    StartedAt      time.Time
    CompletedAt    *time.Time
    TotalKeys      int
    TranslatedKeys int
    FailedKeys     int
    QualityScore   float64
}

// GET /v1/admin/jobs/:jobId - Get job status
// GET /v1/admin/jobs - List all jobs
// DELETE /v1/admin/jobs/:jobId - Cancel job
```

### Phase 4: Web Client Wizard UI (8-10 hours)

#### 4.1 Wizard Component
**File:** `Web-Client/src/app/features/localization-management/components/language-wizard/language-wizard.component.ts`

**Wizard Steps:**
1. **Language Selection**
   - Search and filter from 184+ languages
   - Show native names
   - Indicate RTL support

2. **Country/Variant Selection**
   - Select country (optional)
   - Choose variant (e.g., en-US vs en-GB)
   - Preview language code

3. **Translation Settings**
   - Choose source language (auto-detect or manual)
   - Select AI provider (OpenAI, Google, DeepL)
   - Set quality threshold
   - Enable/disable auto-activation

4. **Review & Confirm**
   - Summary of selections
   - Estimated translation time
   - Cost estimate (for paid APIs)

5. **Progress Tracking**
   - Real-time progress bar
   - Live updates via WebSocket
   - Key-by-key status
   - Cancel option

6. **Completion**
   - Success summary
   - Quality score
   - Review translations link
   - Add another language option

#### 4.2 Wizard Service
**File:** `Web-Client/src/app/features/localization-management/services/language-wizard.service.ts`
```typescript
export class LanguageWizardService {
  // Data loading
  getAvailableLanguages(): Observable<LanguageOption[]>
  getCountries(languageCode: string): Observable<Country[]>
  getVariants(languageCode: string, countryCode: string): Observable<Variant[]>

  // Wizard submission
  startWizard(request: WizardRequest): Observable<WizardResponse>

  // Progress tracking
  getJobStatus(jobId: string): Observable<TranslationJob>
  subscribeToJobProgress(jobId: string): Observable<JobProgressEvent>

  // Cancel
  cancelJob(jobId: string): Observable<void>
}
```

### Phase 5: WebSocket Integration (3-4 hours)

#### 5.1 New Event Types
**File:** `Core/Services/Localization/internal/websocket/events.go`
```go
const (
    // Wizard events
    EventWizardStarted     EventType = "wizard.started"
    EventWizardProgress    EventType = "wizard.progress"
    EventWizardCompleted   EventType = "wizard.completed"
    EventWizardFailed      EventType = "wizard.failed"

    // Translation events
    EventTranslationStarted   EventType = "translation.started"
    EventTranslationProgress  EventType = "translation.progress"
    EventTranslationCompleted EventType = "translation.completed"
)

type WizardProgressEventData struct {
    JobID          string  `json:"jobId"`
    Language       string  `json:"language"`
    Progress       float64 `json:"progress"`
    TotalKeys      int     `json:"totalKeys"`
    TranslatedKeys int     `json:"translatedKeys"`
    CurrentKey     string  `json:"currentKey"`
}
```

#### 5.2 Client Handlers
**Core Application:**
```go
// Listen for wizard.completed
// → Invalidate cache for new language
// → Reload language list
```

**Web Client:**
```typescript
// Listen for wizard.progress
// → Update progress bar
// → Show current key being translated

// Listen for wizard.completed
// → Show success message
// → Reload translation grid
// → Add new language column
```

### Phase 6: Comprehensive Testing (12-16 hours)

#### 6.1 Unit Tests (4 hours)

**Backend:**
```go
// ai/translator_test.go
func TestOpenAITranslator_Translate(t *testing.T)
func TestOpenAITranslator_TranslateBatch(t *testing.T)
func TestOpenAITranslator_PreservePlaceholders(t *testing.T)
func TestGoogleTranslator_Fallback(t *testing.T)

// ai/engine_test.go
func TestTranslationEngine_TranslateAll(t *testing.T)
func TestTranslationEngine_QualityScoring(t *testing.T)

// handlers/wizard_handlers_test.go
func TestWizardHandler_CreateLanguage(t *testing.T)
func TestWizardHandler_StartTranslation(t *testing.T)
func TestWizardHandler_ProgressTracking(t *testing.T)

// jobs/translation_job_test.go
func TestTranslationJob_Lifecycle(t *testing.T)
func TestTranslationJob_CancellationGraceful(t *testing.T)
```

**Frontend:**
```typescript
// language-wizard.service.spec.ts
describe('LanguageWizardService', () => {
  it('should load available languages', () => {})
  it('should start wizard', () => {})
  it('should track progress', () => {})
  it('should handle errors', () => {})
})

// language-wizard.component.spec.ts
describe('LanguageWizardComponent', () => {
  it('should navigate through steps', () => {})
  it('should validate selections', () => {})
  it('should submit wizard', () => {})
  it('should show progress', () => {})
})
```

**Target:** 100% line coverage

#### 6.2 Integration Tests (4 hours)

**Scenarios:**
```go
func TestWizardIntegration(t *testing.T) {
    // 1. Start wizard with French
    // 2. Verify language created
    // 3. Verify AI translation called
    // 4. Verify all keys translated
    // 5. Verify catalog built
    // 6. Verify WebSocket events sent
    // 7. Verify cache invalidated
}

func TestWizardWithMultipleClients(t *testing.T) {
    // 1. Connect 3 WebSocket clients
    // 2. Start wizard
    // 3. Verify all clients receive progress updates
    // 4. Verify all clients receive completion event
    // 5. Verify all clients reload data
}

func TestWizardCancellation(t *testing.T) {
    // 1. Start wizard
    // 2. Cancel after 50% progress
    // 3. Verify graceful shutdown
    // 4. Verify partial data handled correctly
}

func TestWizardErrorHandling(t *testing.T) {
    // 1. Simulate AI API failure
    // 2. Verify fallback translator used
    // 3. If all fail, verify error event sent
    // 4. Verify rollback of partial data
}
```

**Target:** All event flows covered

#### 6.3 E2E Tests (4 hours)

**User Flows:**
```typescript
describe('Language Wizard E2E', () => {
  it('should add French via wizard', () => {
    // 1. Navigate to wizard
    // 2. Select French language
    // 3. Select France country
    // 4. Choose OpenAI provider
    // 5. Submit wizard
    // 6. Watch progress bar
    // 7. Verify completion
    // 8. Navigate to translation editor
    // 9. Verify French column added
    // 10. Verify translations populated
  })

  it('should handle multiple users adding languages simultaneously', () => {
    // 1. Open two browsers
    // 2. Browser 1: Add Spanish
    // 3. Browser 2: Add German
    // 4. Both see progress
    // 5. Both see completion
    // 6. Both see new languages in grid
  })

  it('should cancel wizard midway', () => {
    // 1. Start wizard
    // 2. Click cancel at 50%
    // 3. Verify cancellation
    // 4. Verify no partial data
  })
})
```

**Tools:** Cypress, Playwright

**Target:** All user flows covered

#### 6.4 Load/Performance Tests (4 hours)

**Scenarios:**
```javascript
// k6 script
export default function() {
  // Test 1: Translation speed
  // - Translate 100 keys to 10 languages
  // - Measure: < 30s total time

  // Test 2: Concurrent wizards
  // - Start 10 wizards simultaneously
  // - Measure: All complete without errors

  // Test 3: WebSocket scalability
  // - 1000 clients watching wizard progress
  // - Measure: < 100ms latency for events

  // Test 4: AI API rate limiting
  // - Exceed AI API limits
  // - Verify: Graceful queuing and retry
}
```

**Metrics:**
- Translation speed: < 30s for 100 keys
- Wizard throughput: 10 concurrent wizards
- WebSocket latency: < 100ms
- API resilience: 100% graceful handling

**Target:** All performance benchmarks met

### Phase 7: Documentation (3-4 hours)

#### 7.1 Update Existing Docs

**File:** `Core/Services/Localization/USER_MANUAL.md`
- Add wizard endpoint documentation
- Add AI translation configuration
- Add troubleshooting guide

**File:** `Core/Services/Localization/README.md`
- Add AI translation feature overview
- Add wizard usage examples

**File:** `Web-Client/README.md`
- Add wizard UI documentation
- Add screenshots

#### 7.2 Create New Docs

**File:** `Core/Services/Localization/AI_TRANSLATION_GUIDE.md`
- Complete AI translation reference
- Provider comparison (OpenAI vs Google vs DeepL)
- Cost analysis
- Quality guidelines
- Best practices

**File:** `Core/Services/Localization/WIZARD_USER_GUIDE.md`
- Step-by-step wizard usage
- Screenshots of each step
- Common issues and solutions
- FAQ

#### 7.3 Update Website

**File:** `Core/Website/features/localization.html`
- Add AI translation section
- Add wizard demo video/GIF
- Add language coverage statistics

**File:** `Core/Website/docs/ai-translation.html`
- Technical documentation
- API reference
- Integration examples

---

## 📊 Implementation Timeline

### Week 1: Core Implementation
**Day 1-2:** Language/Country data + Wizard API (6-8 hours)
**Day 3-4:** AI Translation Service (8-10 hours)
**Day 5:** WebSocket integration (4 hours)

### Week 2: Frontend + Testing
**Day 1-2:** Wizard UI (10-12 hours)
**Day 3:** Unit tests (4 hours)
**Day 4:** Integration + E2E tests (8 hours)
**Day 5:** Load tests (4 hours)

### Week 3: Documentation + Polish
**Day 1-2:** Documentation (6-8 hours)
**Day 3:** Website updates (4 hours)
**Day 4-5:** Polish and bug fixes (8 hours)

**Total:** 60-70 hours (3 weeks)

---

## 💰 Cost Considerations

### AI API Costs

**OpenAI GPT-4:**
- Cost: $0.03 per 1K tokens
- Avg translation: 50 tokens per key
- 100 keys = 5,000 tokens = $0.15
- 1,000 keys = 50,000 tokens = $1.50

**Google Translate:**
- Cost: $20 per 1M characters
- Avg translation: 30 characters per key
- 100 keys = 3,000 characters = $0.06
- 1,000 keys = 30,000 characters = $0.60

**DeepL:**
- Cost: €20 per 1M characters (free tier: 500K/month)
- Similar to Google Translate

**Recommendation:**
- Primary: OpenAI GPT-4 (best quality)
- Fallback: Google Translate (cost-effective)
- Premium: DeepL (best for European languages)

---

## 🎯 Success Criteria

### Functional
- [ ] Wizard lists all 184+ languages
- [ ] AI translation works for all providers
- [ ] Placeholder preservation works correctly
- [ ] WebSocket events broadcast to all clients
- [ ] Clients auto-update when new language added
- [ ] Progress tracking accurate
- [ ] Cancellation graceful

### Quality
- [ ] Translation quality score > 0.8 (80%)
- [ ] Placeholder accuracy: 100%
- [ ] Context preservation: Validated

### Performance
- [ ] Translation speed: < 30s for 100 keys
- [ ] Wizard throughput: 10 concurrent
- [ ] WebSocket latency: < 100ms
- [ ] API resilience: 100% uptime

### Testing
- [ ] Unit tests: 100% coverage
- [ ] Integration tests: All flows covered
- [ ] E2E tests: All user scenarios covered
- [ ] Load tests: All benchmarks met
- [ ] All tests: 100% passing

### Documentation
- [ ] User guide created
- [ ] Technical docs updated
- [ ] Website updated
- [ ] Examples provided

---

## 🚀 Quick Win: MVP Version

### Phase 1 MVP (1 week, 30 hours)

**Simplified Scope:**
- Support 20 most common languages (not all 184)
- Single AI provider (OpenAI only)
- Basic wizard (no country/variant selection)
- Manual activation (no auto-activate)
- Basic progress tracking (no real-time)

**Benefits:**
- Faster delivery
- Prove concept
- Gather feedback
- Iterate based on usage

**Then Expand:**
- Add more languages incrementally
- Add additional AI providers
- Add advanced wizard features
- Add real-time progress

---

## 📝 Configuration

### Environment Variables
```env
# AI Providers
OPENAI_API_KEY=sk-...
GOOGLE_TRANSLATE_API_KEY=...
DEEPL_API_KEY=...

# AI Settings
AI_PRIMARY_PROVIDER=openai
AI_FALLBACK_PROVIDER=google
AI_QUALITY_THRESHOLD=0.8
AI_MAX_RETRIES=3
AI_TIMEOUT=30s

# Wizard Settings
WIZARD_MAX_CONCURRENT_JOBS=10
WIZARD_JOB_TIMEOUT=600s
WIZARD_AUTO_ACTIVATE=false
```

---

**Status:** 📋 **Ready to Implement**
**Estimated Time:** 60-70 hours (3 weeks)
**Priority:** High (game-changing feature)
**Impact:** 🚀 **Revolutionary** (AI + Wizard + Real-time)
