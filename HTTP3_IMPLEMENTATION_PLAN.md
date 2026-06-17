# HTTP/3 / QUIC Implementation Plan for HelixTrack Clients

**Date:** 2025-10-19
**Status:** Implementation Roadmap
**Priority:** HIGH

---

## Executive Summary

After comprehensive verification of HTTP/3 / QUIC implementation across all HelixTrack clients, this document provides a clear roadmap for achieving full HTTP/3 support in ALL clients.

**Current Status:**
- ✅ **Android-Client**: Production Ready (Cronet with QUIC)
- ✅ **iOS-Client**: Functional (Auto-negotiating HTTP/3)
- ⚠️ **Web-Client**: Non-functional (hypothetical browser APIs)
- ❌ **Desktop-Client**: Incomplete (placeholder Rust backend)

---

## 1. Web-Client Implementation (4-6 hours)

### Issue
The current implementation uses hypothetical browser APIs (`window.CronetEngine`, `window.Http3Transport`) that don't exist in any browser. Browsers handle HTTP/3 automatically at the network layer.

### Solution
Remove hypothetical API code and document browser HTTP/3 behavior.

### Browser HTTP/3 Support (Automatic)

**How browsers handle HTTP/3:**
1. Server advertises HTTP/3 via `Alt-Svc` header
2. Browser automatically upgrades to HTTP/3 if supported
3. No JavaScript API required or available
4. Transparent to application code

**Browser Support:**
- Chrome 87+ (2020): Full HTTP/3 support
- Firefox 88+ (2021): Full HTTP/3 support
- Safari 14+ (2020): Full HTTP/3 support
- Edge 87+ (2020): Full HTTP/3 support

### Implementation Steps

#### Step 1: Simplify HTTP3QuicService (2 hours)

**File:** `web_client/src/app/core/services/http3-quic.service.ts`

**Changes:**
```typescript
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

/**
 * HTTP/3 QUIC Service for HelixTrack Web Client
 *
 * NOTE: Browsers handle HTTP/3 automatically at the network layer.
 * This service provides a unified API interface and detects browser HTTP/3 support.
 *
 * HTTP/3 is automatically used if:
 * 1. Server supports HTTP/3 and advertises via Alt-Svc header
 * 2. Browser supports HTTP/3 (Chrome 87+, Firefox 88+, Safari 14+)
 * 3. Connection uses HTTPS
 */
@Injectable({
  providedIn: 'root'
})
export class Http3QuicService {
  private readonly serverUrl: string;
  private readonly http3Support: boolean;

  constructor(
    private http: HttpClient,
    private backendConfigService: BackendConfigService
  ) {
    this.serverUrl = this.backendConfigService.getBackendUrl();
    this.http3Support = this.detectHttp3Support();

    if (this.http3Support) {
      console.log('✅ Browser supports HTTP/3 - will use if server supports');
    } else {
      console.warn('⚠️ Browser does not support HTTP/3 - falling back to HTTP/2 or HTTP/1.1');
    }
  }

  /**
   * Detect if browser supports HTTP/3
   * Checks for Chrome/Edge, Firefox, or Safari with minimum versions
   */
  private detectHttp3Support(): boolean {
    const ua = navigator.userAgent;

    // Chrome/Edge 87+
    if (/Chrome\/(\d+)/.test(ua)) {
      const version = parseInt(RegExp.$1);
      return version >= 87;
    }

    // Firefox 88+
    if (/Firefox\/(\d+)/.test(ua)) {
      const version = parseInt(RegExp.$1);
      return version >= 88;
    }

    // Safari 14+
    if (/Version\/(\d+).*Safari/.test(ua)) {
      const version = parseInt(RegExp.$1);
      return version >= 14;
    }

    return false;
  }

  /**
   * Make API request - browser will automatically use HTTP/3 if available
   */
  request<T>(action: string, data?: any, jwt?: string): Observable<T> {
    const body = {
      action,
      jwt,
      data,
      locale: 'en'
    };

    return this.http.post<T>(`${this.serverUrl}/do`, body);
  }

  /**
   * Get HTTP/3 status
   */
  getHttp3Status(): {
    browserSupport: boolean;
    serverUrl: string;
  } {
    return {
      browserSupport: this.http3Support,
      serverUrl: this.serverUrl
    };
  }
}
```

#### Step 2: Remove HTTP3QuicInterceptor (1 hour)

**File:** `web_client/src/app/core/interceptors/http3-quic.interceptor.ts`

**Action:** Delete file - not needed for browser-based HTTP/3

**File:** `web_client/src/app/core/interceptors/index.ts`

**Changes:** Remove HTTP3QuicInterceptor from exports

#### Step 3: Update App Config (30 min)

**File:** `web_client/src/app/app.config.ts`

**Changes:** Remove HTTP3QuicInterceptor provider

#### Step 4: Add Server-Side HTTP/3 Support (2 hours)

**File:** `core/Application/main.go` (Backend)

**Changes:** Configure Go server to advertise HTTP/3 support

```go
import (
    "github.com/quic-go/quic-go/http3"
)

// In server configuration
http3Server := &http3.Server{
    Addr:    ":443",
    Handler: router,
}

// Serve HTTP/3 alongside HTTP/2
go http3Server.ListenAndServe()
```

---

## 2. Desktop-Client Implementation (8-12 hours)

### Issue
Tauri backend has placeholder `send_quic_request()` function that doesn't implement actual QUIC protocol. Dependencies (quinn, h3) are declared but unused.

### Solution
Implement full QUIC client in Rust backend using quinn and h3 crates.

### Implementation Steps

#### Step 1: Implement QUIC Client (6 hours)

**File:** `desktop_client/src-tauri/src/quic_client.rs` (NEW)

**Create full QUIC client implementation:**
```rust
use quinn::{Endpoint, ClientConfig};
use rustls::{Certificate, ClientConfig as RustlsConfig};
use std::sync::Arc;
use serde::{Deserialize, Serialize};

pub struct QuicClient {
    endpoint: Endpoint,
    server_addr: String,
}

impl QuicClient {
    pub async fn new(server_url: &str) -> Result<Self, Box<dyn std::error::Error>> {
        // Configure QUIC endpoint
        let mut endpoint = Endpoint::client("0.0.0.0:0".parse()?)?;

        // Configure TLS with certificate pinning
        let mut tls_config = RustlsConfig::builder()
            .with_safe_defaults()
            .with_root_certificates(/* Add root certs */)
            .with_no_client_auth();

        let client_config = ClientConfig::new(Arc::new(tls_config));
        endpoint.set_default_client_config(client_config);

        Ok(Self {
            endpoint,
            server_addr: server_url.to_string(),
        })
    }

    pub async fn send_request<T: Serialize, R: for<'de> Deserialize<'de>>(
        &self,
        request: T,
    ) -> Result<R, Box<dyn std::error::Error>> {
        // Connect to server
        let connection = self.endpoint.connect(&self.server_addr.parse()?, "localhost")?.await?;

        // Open bi-directional stream
        let (mut send, mut recv) = connection.open_bi().await?;

        // Serialize and send request
        let request_bytes = serde_json::to_vec(&request)?;
        send.write_all(&request_bytes).await?;
        send.finish().await?;

        // Receive response
        let response_bytes = recv.read_to_end(10 * 1024 * 1024).await?; // 10MB max
        let response: R = serde_json::from_slice(&response_bytes)?;

        Ok(response)
    }
}
```

#### Step 2: Update Tauri Commands (2 hours)

**File:** `desktop_client/src-tauri/src/lib.rs`

**Changes:**
```rust
use crate::quic_client::QuicClient;
use serde::{Deserialize, Serialize};
use tokio::sync::Mutex;
use std::sync::Arc;

#[derive(Serialize, Deserialize)]
struct ApiRequest {
    action: String,
    jwt: Option<String>,
    data: Option<serde_json::Value>,
}

#[derive(Serialize, Deserialize)]
struct ApiResponse {
    errorCode: i32,
    errorMessage: Option<String>,
    data: Option<serde_json::Value>,
}

struct AppState {
    quic_client: Arc<Mutex<Option<QuicClient>>>,
}

#[tauri::command]
async fn send_quic_request(
    url: String,
    request_data: ApiRequest,
    state: tauri::State<'_, Arc<AppState>>,
) -> Result<ApiResponse, String> {
    // Get or create QUIC client
    let mut client_guard = state.quic_client.lock().await;

    if client_guard.is_none() {
        *client_guard = Some(
            QuicClient::new(&url)
                .await
                .map_err(|e| format!("Failed to create QUIC client: {}", e))?
        );
    }

    let client = client_guard.as_ref().unwrap();

    // Send request via QUIC
    client.send_request(request_data)
        .await
        .map_err(|e| format!("QUIC request failed: {}", e))
}

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    let app_state = Arc::new(AppState {
        quic_client: Arc::new(Mutex::new(None)),
    });

    tauri::Builder::default()
        .manage(app_state)
        .invoke_handler(tauri::generate_handler![send_quic_request])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
```

#### Step 3: Update Cargo Dependencies (30 min)

**File:** `desktop_client/src-tauri/Cargo.toml`

**Add missing dependencies:**
```toml
[dependencies]
quinn = "0.11"
rustls = "0.23"
tokio = { version = "1.40", features = ["full"] }
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
```

#### Step 4: Update Frontend Service (1 hour)

**File:** `desktop_client/src/app/core/services/http3-quic.service.ts`

**Ensure proper Tauri invoke usage:**
```typescript
async request<T>(action: string, data?: any, jwt?: string): Promise<T> {
    const request = {
        action,
        jwt,
        data,
        locale: 'en'
    };

    try {
        const response = await invoke<ApiResponse>('send_quic_request', {
            url: this.config.serverUrl,
            requestData: request
        });

        if (response.errorCode !== -1) {
            throw new Error(response.errorMessage || 'API error');
        }

        return response.data as T;
    } catch (error) {
        console.error('QUIC request failed:', error);
        throw error;
    }
}
```

---

## 3. Android-Client Completion (1-2 hours)

### Issue
Production certificate pins not configured.

### Solution
Add production certificate SHA-256 pins to NetworkModule.

**File:** `android_client/app/src/main/java/com/helixtrack/android/di/NetworkModule.kt`

**Steps:**

1. Generate certificate pins:
```bash
openssl s_client -connect api.helixtrack.com:443 | \
    openssl x509 -pubkey -noout | \
    openssl pkey -pubin -outform der | \
    openssl dgst -sha256 -binary | \
    base64
```

2. Update CertificatePinner:
```kotlin
fun provideCertificatePinner(): CertificatePinner {
    return CertificatePinner.Builder()
        .add("api.helixtrack.com", "sha256/ACTUAL_PIN_HERE")
        .add("api.helixtrack.com", "sha256/BACKUP_PIN_HERE")  // Backup certificate
        .build()
}
```

---

## 4. iOS-Client Enhancement (2-3 hours)

### Issue
HTTP/3 support is implicit (auto-negotiated). Can be made more explicit.

### Solution
Configure URLSession to prefer HTTP/3 explicitly.

**File:** `ios_client/Sources/HelixTrack/Services/APIService.swift`

**Add explicit HTTP/3 configuration:**
```swift
private init() {
    let configuration = URLSessionConfiguration.default
    configuration.allowsCellularAccess = true
    configuration.allowsExpensiveNetworkAccess = true
    configuration.allowsConstrainedNetworkAccess = true

    // Prefer HTTP/3 explicitly
    configuration.multipathServiceType = .handover
    configuration.httpMaximumConnectionsPerHost = 1

    // HTTP/3 specific settings (iOS 15+)
    if #available(iOS 15.0, *) {
        configuration.assumesHTTP3Capable = true  // Prefer HTTP/3
    }

    // Certificate pinning
    #if DEBUG
    self.certificatePinningDelegate = CertificatePinningDelegate(enablePinning: false)
    #else
    self.certificatePinningDelegate = CertificatePinningDelegate(enablePinning: true)
    #endif

    self.session = URLSession(
        configuration: configuration,
        delegate: self.certificatePinningDelegate,
        delegateQueue: nil
    )

    self.baseURL = URL(string: UserDefaults.standard.string(forKey: "backendURL") ?? "https://localhost:8080")!
    self.authToken = KeychainManager.shared.retrieve(forKey: "authToken")
}
```

---

## 5. Communication Validation Tests

### Test Coverage

Create comprehensive tests for each client to validate:
1. HTTP/3 protocol usage
2. Fallback to HTTP/2 when HTTP/3 unavailable
3. Certificate pinning
4. Request/response handling
5. Error scenarios

### Implementation Locations

- **Web-Client:** `src/app/core/services/http3-quic.service.spec.ts`
- **Desktop-Client:** `src/app/core/services/http3-quic.service.spec.ts` + Rust tests
- **Android-Client:** `app/src/test/java/com/helixtrack/android/NetworkModuleTest.kt`
- **iOS-Client:** `Tests/HelixTrackTests/APIServiceTests.swift`

---

## Implementation Timeline

| Task | Priority | Estimated Time | Status |
|------|----------|---------------|--------|
| Web-Client HTTP/3 Fix | HIGH | 4-6 hours | Pending |
| Desktop-Client QUIC Implementation | HIGH | 8-12 hours | Pending |
| Android-Client Certificate Pins | MEDIUM | 1-2 hours | Pending |
| iOS-Client HTTP/3 Enhancement | LOW | 2-3 hours | Pending |
| Communication Validation Tests | HIGH | 4-6 hours | Pending |
| Backend HTTP/3 Support | HIGH | 2-3 hours | Pending |

**Total Estimated Time:** 21-32 hours

---

## Success Criteria

All clients must:
- ✅ Use HTTP/3 / QUIC when server supports it
- ✅ Fall back gracefully to HTTP/2 or HTTP/1.1
- ✅ Implement certificate pinning (production)
- ✅ Pass all communication validation tests
- ✅ Handle network errors properly
- ✅ Support timeouts and retries
- ✅ Log protocol version in use

---

## References

- **Verification Reports:**
  - `/home/milosvasic/Projects/HelixTrack/HTTP3_QUIC_CRONET_VERIFICATION_REPORT.md`
  - `/home/milosvasic/Projects/HelixTrack/HTTP3_IMPLEMENTATION_SUMMARY.txt`
  - `/home/milosvasic/Projects/HelixTrack/HTTP3_VERIFICATION_INDEX.md`

- **External Documentation:**
  - [Chrome HTTP/3 Support](https://chromestatus.com/feature/5663479813365760)
  - [Quinn QUIC Implementation](https://github.com/quinn-rs/quinn)
  - [Cronet Documentation](https://developer.android.com/develop/connectivity/cronet)
  - [iOS URLSession HTTP/3](https://developer.apple.com/documentation/foundation/urlsessionconfiguration)

---

**Document Version:** 1.0
**Last Updated:** 2025-10-19
**Status:** Ready for Implementation
