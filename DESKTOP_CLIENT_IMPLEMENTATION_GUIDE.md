# Desktop-Client Documents V2 - Implementation Guide

**Architecture**: Tauri 2.0 + Angular 19 (shares Web-Client code)
**Strategy**: Reuse 90% of Web-Client, add Tauri-specific features
**Estimated Effort**: 4-6 hours (after Web-Client is complete)

---

## Overview

The Desktop-Client uses Tauri (Rust backend) + Angular (same as Web-Client frontend). This means we can **copy almost all Web-Client code** and just add desktop-specific features.

---

## Step 1: Copy Web-Client Documents Feature

### 1.1 Copy the entire documents directory

```bash
# From project root
cp -r web_client/src/app/features/documents desktop_client/src/app/features/documents
```

This copies:
- All models
- DocumentService
- All components
- Routing module
- Module declaration

### 1.2 Verify imports

Check that all imports work in Desktop-Client. Since both use Angular 19, they should be identical.

---

## Step 2: Add Tauri Backend Commands (Rust)

### 2.1 Create document storage commands

**File**: `desktop_client/src-tauri/src/documents.rs`

```rust
use tauri::State;
use serde::{Deserialize, Serialize};
use std::fs;
use std::path::PathBuf;

#[derive(Debug, Serialize, Deserialize)]
pub struct DocumentDraft {
    pub id: String,
    pub title: String,
    pub content: String,
    pub last_modified: i64,
}

/// Save document draft to local file system
#[tauri::command]
pub async fn save_document_draft(
    draft: DocumentDraft,
    app_handle: tauri::AppHandle,
) -> Result<(), String> {
    let app_dir = app_handle
        .path_resolver()
        .app_local_data_dir()
        .ok_or("Failed to get app data directory")?;

    let drafts_dir = app_dir.join("drafts");
    fs::create_dir_all(&drafts_dir).map_err(|e| e.to_string())?;

    let file_path = drafts_dir.join(format!("{}.json", draft.id));
    let json = serde_json::to_string_pretty(&draft).map_err(|e| e.to_string())?;

    fs::write(file_path, json).map_err(|e| e.to_string())?;

    Ok(())
}

/// Load document draft from local file system
#[tauri::command]
pub async fn load_document_draft(
    document_id: String,
    app_handle: tauri::AppHandle,
) -> Result<Option<DocumentDraft>, String> {
    let app_dir = app_handle
        .path_resolver()
        .app_local_data_dir()
        .ok_or("Failed to get app data directory")?;

    let file_path = app_dir.join("drafts").join(format!("{}.json", document_id));

    if !file_path.exists() {
        return Ok(None);
    }

    let json = fs::read_to_string(file_path).map_err(|e| e.to_string())?;
    let draft: DocumentDraft = serde_json::from_str(&json).map_err(|e| e.to_string())?;

    Ok(Some(draft))
}

/// Delete document draft
#[tauri::command]
pub async fn delete_document_draft(
    document_id: String,
    app_handle: tauri::AppHandle,
) -> Result<(), String> {
    let app_dir = app_handle
        .path_resolver()
        .app_local_data_dir()
        .ok_or("Failed to get app data directory")?;

    let file_path = app_dir.join("drafts").join(format!("{}.json", document_id));

    if file_path.exists() {
        fs::remove_file(file_path).map_err(|e| e.to_string())?;
    }

    Ok(())
}

/// Export document to file
#[tauri::command]
pub async fn export_document_to_file(
    title: String,
    content: String,
    format: String, // "md", "pdf", "html"
) -> Result<String, String> {
    use tauri::api::dialog::blocking::FileDialogBuilder;

    let extension = match format.as_str() {
        "md" => "md",
        "pdf" => "pdf",
        "html" => "html",
        _ => return Err("Unsupported format".to_string()),
    };

    let file_path = FileDialogBuilder::new()
        .set_file_name(&format!("{}.{}", title, extension))
        .save_file()
        .ok_or("User cancelled")?;

    fs::write(&file_path, content).map_err(|e| e.to_string())?;

    Ok(file_path.to_string_lossy().to_string())
}

/// List all local drafts
#[tauri::command]
pub async fn list_document_drafts(
    app_handle: tauri::AppHandle,
) -> Result<Vec<DocumentDraft>, String> {
    let app_dir = app_handle
        .path_resolver()
        .app_local_data_dir()
        .ok_or("Failed to get app data directory")?;

    let drafts_dir = app_dir.join("drafts");

    if !drafts_dir.exists() {
        return Ok(Vec::new());
    }

    let mut drafts = Vec::new();

    for entry in fs::read_dir(drafts_dir).map_err(|e| e.to_string())? {
        let entry = entry.map_err(|e| e.to_string())?;
        let path = entry.path();

        if path.extension().and_then(|s| s.to_str()) == Some("json") {
            let json = fs::read_to_string(&path).map_err(|e| e.to_string())?;
            let draft: DocumentDraft = serde_json::from_str(&json).map_err(|e| e.to_string())?;
            drafts.push(draft);
        }
    }

    // Sort by last modified (newest first)
    drafts.sort_by(|a, b| b.last_modified.cmp(&a.last_modified));

    Ok(drafts)
}
```

### 2.2 Register Tauri commands

**File**: `desktop_client/src-tauri/src/main.rs`

```rust
mod documents;

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![
            // Existing commands...

            // Document commands
            documents::save_document_draft,
            documents::load_document_draft,
            documents::delete_document_draft,
            documents::export_document_to_file,
            documents::list_document_drafts,
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
```

---

## Step 3: Create Tauri Service (Angular)

### 3.1 Create TauriDocumentService

**File**: `desktop_client/src/app/features/documents/services/tauri-document.service.ts`

```typescript
import { Injectable } from '@angular/core';
import { invoke } from '@tauri-apps/api/tauri';

export interface DocumentDraft {
  id: string;
  title: string;
  content: string;
  last_modified: number;
}

@Injectable({
  providedIn: 'root'
})
export class TauriDocumentService {

  /**
   * Save document draft to local file system
   */
  async saveDraft(draft: DocumentDraft): Promise<void> {
    await invoke('save_document_draft', { draft });
  }

  /**
   * Load document draft from local file system
   */
  async loadDraft(documentId: string): Promise<DocumentDraft | null> {
    return await invoke<DocumentDraft | null>('load_document_draft', {
      documentId
    });
  }

  /**
   * Delete document draft
   */
  async deleteDraft(documentId: string): Promise<void> {
    await invoke('delete_document_draft', { documentId });
  }

  /**
   * Export document to file with native file dialog
   */
  async exportToFile(
    title: string,
    content: string,
    format: 'md' | 'pdf' | 'html'
  ): Promise<string> {
    return await invoke<string>('export_document_to_file', {
      title,
      content,
      format
    });
  }

  /**
   * List all local drafts
   */
  async listDrafts(): Promise<DocumentDraft[]> {
    return await invoke<DocumentDraft[]>('list_document_drafts');
  }
}
```

### 3.2 Update DocumentEditorComponent

Add Tauri-specific features to the editor:

```typescript
import { TauriDocumentService } from '../../services/tauri-document.service';

export class DocumentEditorComponent implements OnInit {
  constructor(
    // ... existing dependencies
    private tauriDocumentService: TauriDocumentService
  ) {}

  ngOnInit() {
    // ... existing code

    // Load local draft if exists
    this.loadLocalDraft();
  }

  async loadLocalDraft() {
    const draft = await this.tauriDocumentService.loadDraft(this.documentId);
    if (draft && draft.last_modified > this.document.updatedAt) {
      // Local draft is newer, ask user if they want to restore it
      this.showDraftRestoreDialog(draft);
    }
  }

  async saveLocalDraft() {
    const draft: DocumentDraft = {
      id: this.documentId,
      title: this.document.title,
      content: this.contentMarkdown,
      last_modified: Date.now()
    };

    await this.tauriDocumentService.saveDraft(draft);
  }

  async exportToFileSystem() {
    try {
      const filePath = await this.tauriDocumentService.exportToFile(
        this.document.title,
        this.contentMarkdown,
        'md'
      );
      // Show success notification
      console.log('Exported to:', filePath);
    } catch (err) {
      console.error('Export failed:', err);
    }
  }
}
```

---

## Step 4: Desktop-Specific Features

### 4.1 System Tray Integration

**File**: `desktop_client/src-tauri/tauri.conf.json`

```json
{
  "tauri": {
    "systemTray": {
      "iconPath": "icons/tray-icon.png",
      "iconAsTemplate": true,
      "menuOnLeftClick": false
    }
  }
}
```

**Add system tray logic in main.rs**:

```rust
use tauri::{CustomMenuItem, SystemTray, SystemTrayMenu, SystemTrayEvent};

fn main() {
    let quit = CustomMenuItem::new("quit".to_string(), "Quit");
    let show = CustomMenuItem::new("show".to_string(), "Show");
    let tray_menu = SystemTrayMenu::new()
        .add_item(show)
        .add_item(quit);

    let system_tray = SystemTray::new().with_menu(tray_menu);

    tauri::Builder::default()
        .system_tray(system_tray)
        .on_system_tray_event(|app, event| match event {
            SystemTrayEvent::LeftClick { .. } => {
                let window = app.get_window("main").unwrap();
                window.show().unwrap();
                window.set_focus().unwrap();
            }
            SystemTrayEvent::MenuItemClick { id, .. } => {
                match id.as_str() {
                    "quit" => {
                        std::process::exit(0);
                    }
                    "show" => {
                        let window = app.get_window("main").unwrap();
                        window.show().unwrap();
                        window.set_focus().unwrap();
                    }
                    _ => {}
                }
            }
            _ => {}
        })
        // ... rest of builder
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
```

### 4.2 Native Notifications

```typescript
import { sendNotification } from '@tauri-apps/api/notification';

async notifyDocumentSaved(title: string) {
  await sendNotification({
    title: 'Document Saved',
    body: `${title} has been saved successfully`
  });
}
```

### 4.3 Keyboard Shortcuts

**File**: `desktop_client/src-tauri/tauri.conf.json`

```json
{
  "tauri": {
    "windows": [
      {
        "shortcuts": {
          "global": [
            {
              "shortcut": "CmdOrCtrl+S",
              "command": "save_document"
            },
            {
              "shortcut": "CmdOrCtrl+E",
              "command": "toggle_preview"
            }
          ]
        }
      }
    ]
  }
}
```

---

## Step 5: Build Configuration

### 5.1 Update package.json

```json
{
  "scripts": {
    "tauri:dev": "tauri dev",
    "tauri:build": "tauri build",
    "tauri:build:release": "tauri build --release"
  }
}
```

### 5.2 Build for all platforms

```bash
# Development
npm run tauri:dev

# Production build
npm run tauri:build

# Build for specific platform
npm run tauri:build -- --target x86_64-pc-windows-msvc    # Windows
npm run tauri:build -- --target x86_64-apple-darwin        # macOS Intel
npm run tauri:build -- --target aarch64-apple-darwin       # macOS Apple Silicon
npm run tauri:build -- --target x86_64-unknown-linux-gnu   # Linux
```

---

## Step 6: Testing Checklist

- [ ] All Web-Client components work in desktop app
- [ ] Tauri commands work (save draft, load draft, export)
- [ ] Native file dialogs work
- [ ] System tray integration works
- [ ] Keyboard shortcuts work
- [ ] Notifications work
- [ ] Build process works for all platforms
- [ ] Auto-updater works (optional)

---

## Key Differences from Web-Client

| Feature | Web-Client | Desktop-Client |
|---------|-----------|----------------|
| **Local Storage** | LocalStorage/IndexedDB | File system (Rust) |
| **File Export** | Browser download | Native file dialog |
| **Notifications** | Browser notifications | System notifications |
| **Shortcuts** | Browser-based | Global shortcuts |
| **Offline Drafts** | Limited | Full file system access |
| **System Integration** | None | Tray icon, auto-start |

---

## Dependencies

Add Tauri API packages:

```bash
npm install @tauri-apps/api @tauri-apps/cli
```

Rust dependencies in `Cargo.toml`:

```toml
[dependencies]
tauri = { version = "2.0", features = [] }
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
```

---

## Estimated Timeline

- Copy Web-Client code: 30 minutes
- Create Tauri commands (Rust): 2 hours
- Create TauriDocumentService (Angular): 1 hour
- Integrate desktop features: 1 hour
- Testing: 1 hour
- Build configuration: 30 minutes

**Total**: 5-6 hours

---

## Resources

- **Tauri Documentation**: https://tauri.app/v1/guides/
- **Tauri API**: https://tauri.app/v1/api/js/
- **Example Apps**: https://github.com/tauri-apps/tauri/tree/dev/examples

---

## Next Steps

1. ✅ Complete Web-Client first
2. Copy Web-Client documents feature to Desktop-Client
3. Create Tauri backend commands (Rust)
4. Create TauriDocumentService (Angular)
5. Add desktop-specific features (tray, notifications, shortcuts)
6. Test on all platforms
7. Configure build and packaging

**Result**: Desktop app with all Web-Client features + native file system integration
