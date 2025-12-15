# Markor Markdown Editor Integration Guide

**Date**: 2025-10-18
**Purpose**: Integration of Markor markdown editor into HelixTrack client applications
**Target Platforms**: Android, Web (Angular), Desktop (Tauri), iOS
**Requirement**: 100% test coverage, 100% success rate

---

## Table of Contents

1. [Overview](#overview)
2. [Markor Repository Setup](#markor-repository-setup)
3. [Integration Strategy](#integration-strategy)
4. [Platform-Specific Implementation](#platform-specific-implementation)
5. [Document Storage Strategy](#document-storage-strategy)
6. [Testing Requirements](#testing-requirements)
7. [API Integration](#api-integration)

---

## Overview

### What is Markor?

**Markor** is a powerful, open-source markdown editor for Android with the following features:
- Rich markdown editing with syntax highlighting
- Real-time preview
- File management
- Export capabilities
- Offline support
- Lightweight and fast

**Repository**: https://github.com/gsantner/markor
**License**: Apache 2.0 (compatible with HelixTrack)
**Language**: Kotlin/Java (Android)
**Stars**: 7k+ (actively maintained)

### Why Markor?

1. **Proven Technology**: Battle-tested with thousands of users
2. **Open Source**: Can be modified and integrated freely
3. **Performance**: Lightweight and efficient
4. **Feature-Rich**: Supports all markdown features we need
5. **Active Development**: Regular updates and bug fixes

### Integration Goals

- **Android**: Direct integration (Markor is native Android)
- **Web**: Port editing logic to TypeScript/Angular
- **Desktop**: Reuse Web components with Tauri enhancements
- **iOS**: Port editing logic to Swift/SwiftUI

---

## Markor Repository Setup

### Step 1: Clone Markor

```bash
# Clone the repository
git clone https://github.com/gsantner/markor.git
cd markor

# Checkout latest stable release
git checkout $(git describe --tags --abbrev=0)

# View repository structure
tree -L 2 app/src/main
```

### Step 2: Analyze Codebase

**Key Directories to Examine**:

```
markor/
├── app/src/main/java/net/gsantner/markor/
│   ├── editor/          # ⭐ Core editor components
│   ├── format/          # ⭐ Markdown format handling
│   ├── ui/              # ⭐ UI components
│   ├── util/            # Utility functions
│   ├── model/           # Data models
│   └── activity/        # Activities (Android-specific)
├── app/src/main/res/    # Resources (layouts, strings, etc.)
└── app/build.gradle     # Dependencies
```

**Core Components to Extract**:

1. **Editor Core** (`editor/`):
   - `TextViewUndoRedo.java` - Undo/redo functionality
   - `HighlightingEditor.java` - Syntax highlighting
   - `MarkorWebViewClient.java` - Preview rendering

2. **Format Handling** (`format/`):
   - `MarkdownTextConverter.java` - Markdown processing
   - `MarkdownTextActions.java` - Editor actions (bold, italic, etc.)
   - `MarkdownHighlighter.java` - Syntax highlighting rules

3. **Preview** (`ui/`):
   - `WebViewRenderer.java` - Markdown to HTML conversion
   - Preview templates and CSS

### Step 3: Identify Dependencies

```gradle
// From app/build.gradle
dependencies {
    // Markdown processing
    implementation 'com.vladsch.flexmark:flexmark:x.x.x'
    implementation 'com.vladsch.flexmark:flexmark-ext-tables:x.x.x'
    implementation 'com.vladsch.flexmark:flexmark-ext-autolink:x.x.x'

    // Syntax highlighting
    implementation 'com.github.tiagohm.MarkdownView:library:x.x.x'

    // Document actual versions used in Markor
}
```

---

## Integration Strategy

### Phase 1: Android Client (Native Integration)

**Approach**: Direct integration of Markor components

**Steps**:
1. Extract Markor editor module
2. Create HelixTrack Android library with Markor
3. Integrate with existing Android client
4. Add HelixTrack-specific features (save to API, versioning, collaboration)
5. Write comprehensive tests

**Timeline**: 2-3 weeks

---

### Phase 2: Web Client (Angular Port)

**Approach**: Port Markor logic to TypeScript/Angular

**Steps**:
1. Analyze Markor's markdown processing logic
2. Create Angular service for markdown editing
3. Use existing TypeScript markdown libraries:
   - `marked` - Markdown parsing
   - `highlight.js` - Syntax highlighting
   - `turndown` - HTML to Markdown conversion
4. Build Angular component with Material UI
5. Add real-time preview (split-pane editor)
6. Integrate with HelixTrack API
7. Write comprehensive tests

**Technology Stack**:
```typescript
// package.json additions
{
  "dependencies": {
    "marked": "^11.0.0",           // Markdown parsing
    "highlight.js": "^11.9.0",     // Syntax highlighting
    "turndown": "^7.1.2",          // HTML to Markdown
    "ngx-markdown": "^17.0.0",     // Angular Markdown component
    "@angular/material": "^17.0.0" // UI components
  }
}
```

**Timeline**: 3-4 weeks

---

### Phase 3: Desktop Client (Tauri + Angular)

**Approach**: Reuse Web Client components with desktop enhancements

**Steps**:
1. Reuse Angular markdown editor component from Web Client
2. Add Tauri-specific features:
   - File system access (read/write local markdown files)
   - Native file picker
   - Faster rendering with Rust backend
3. Offline support with local database
4. Write comprehensive tests

**Tauri Enhancements**:
```rust
// src-tauri/src/commands.rs
#[tauri::command]
async fn save_markdown_file(path: String, content: String) -> Result<(), String> {
    // Save markdown file to local filesystem
}

#[tauri::command]
async fn load_markdown_file(path: String) -> Result<String, String> {
    // Load markdown file from local filesystem
}

#[tauri::command]
async fn export_markdown_pdf(content: String) -> Result<Vec<u8>, String> {
    // Convert markdown to PDF using Rust libraries
}
```

**Timeline**: 2-3 weeks (leveraging Web Client work)

---

### Phase 4: iOS Client (Swift Port)

**Approach**: Port Markor logic to Swift/SwiftUI

**Steps**:
1. Analyze Markor's markdown processing logic
2. Use Swift markdown libraries:
   - `Down` - Markdown parsing and rendering
   - `SwiftyMarkdown` - Markdown styling
   - `Highlightr` - Syntax highlighting
3. Build SwiftUI markdown editor component
4. Add real-time preview
5. Integrate with HelixTrack API
6. Write comprehensive tests

**Technology Stack**:
```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/johnxnguyen/Down.git", from: "0.11.0"),
    .package(url: "https://github.com/SimonFairbairn/SwiftyMarkdown.git", from: "1.2.4"),
    .package(url: "https://github.com/raspu/Highlightr.git", from: "2.1.2")
]
```

**Timeline**: 3-4 weeks

---

## Platform-Specific Implementation

### Android Client Implementation

**Module Structure**:
```
Android-Client/
├── app/src/main/java/com/helixtrack/
│   ├── editor/
│   │   ├── MarkdownEditorActivity.kt      # Main editor activity
│   │   ├── MarkdownEditorView.kt          # Custom editor view
│   │   ├── MarkdownHighlighter.kt         # Syntax highlighting
│   │   ├── MarkdownPreviewFragment.kt     # Live preview
│   │   └── MarkdownTextActions.kt         # Editor actions (bold, etc.)
│   ├── document/
│   │   ├── DocumentRepository.kt          # API integration
│   │   ├── DocumentViewModel.kt           # ViewModel
│   │   └── DocumentCache.kt               # Offline support
│   └── markor/                            # Extracted Markor components
│       ├── TextViewUndoRedo.kt
│       ├── HighlightingEditor.kt
│       └── WebViewRenderer.kt
└── app/src/test/                          # Tests
    ├── editor/                            # Editor tests
    └── document/                          # Document tests
```

**Key Classes**:

```kotlin
// MarkdownEditorActivity.kt
class MarkdownEditorActivity : AppCompatActivity() {
    private lateinit var editor: MarkdownEditorView
    private lateinit var preview: MarkdownPreviewFragment
    private lateinit var viewModel: DocumentViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Initialize Markor-based editor
        editor = MarkdownEditorView(this)
        editor.setText(viewModel.currentDocument.contentMarkdown)

        // Set up real-time preview
        editor.addTextChangedListener { text ->
            preview.updateMarkdown(text.toString())
        }

        // Set up save to HelixTrack API
        editor.setOnSaveListener {
            viewModel.saveDocument(editor.text.toString())
        }
    }
}

// DocumentRepository.kt
class DocumentRepository(private val apiService: HelixTrackApiService) {
    suspend fun saveDocument(documentId: String, content: String): Result<Document> {
        return try {
            val request = DocumentUpdateRequest(
                action = "documentUpdate",
                jwt = authToken,
                data = mapOf(
                    "id" to documentId,
                    "content_markdown" to content,
                    "content_type" to "markdown"
                )
            )
            val response = apiService.doAction(request)
            Result.success(response.data.toDocument())
        } catch (e: Exception) {
            Result.failure(e)
        }
    }
}
```

---

### Web Client Implementation

**Module Structure**:
```
Web-Client/src/app/
├── features/documents/
│   ├── components/
│   │   ├── markdown-editor/
│   │   │   ├── markdown-editor.component.ts         # Main editor
│   │   │   ├── markdown-editor.component.html
│   │   │   ├── markdown-editor.component.scss
│   │   │   ├── markdown-editor.component.spec.ts   # Tests
│   │   │   ├── markdown-toolbar.component.ts        # Toolbar
│   │   │   └── markdown-preview.component.ts        # Preview pane
│   │   ├── document-list/
│   │   ├── document-details/
│   │   └── space-browser/
│   ├── services/
│   │   ├── markdown.service.ts                      # Markdown processing
│   │   ├── document-api.service.ts                  # API integration
│   │   └── document-cache.service.ts                # Offline support
│   └── models/
│       ├── document.model.ts
│       └── markdown-editor.model.ts
└── shared/
    └── utils/
        ├── markdown-parser.ts                       # Markdown utilities
        └── syntax-highlighter.ts                     # Highlighting
```

**Key Components**:

```typescript
// markdown-editor.component.ts
import { Component, Input, Output, EventEmitter } from '@angular/core';
import { marked } from 'marked';
import { MarkdownService } from '../../services/markdown.service';

@Component({
  selector: 'app-markdown-editor',
  templateUrl: './markdown-editor.component.html',
  styleUrls: ['./markdown-editor.component.scss']
})
export class MarkdownEditorComponent {
  @Input() content: string = '';
  @Output() contentChange = new EventEmitter<string>();
  @Output() save = new EventEmitter<string>();

  showPreview: boolean = false;
  previewHtml: string = '';

  constructor(private markdownService: MarkdownService) {}

  onContentChange(newContent: string): void {
    this.content = newContent;
    this.contentChange.emit(newContent);

    // Update preview in real-time
    if (this.showPreview) {
      this.previewHtml = this.markdownService.render(newContent);
    }
  }

  togglePreview(): void {
    this.showPreview = !this.showPreview;
    if (this.showPreview) {
      this.previewHtml = this.markdownService.render(this.content);
    }
  }

  onSave(): void {
    this.save.emit(this.content);
  }

  // Toolbar actions
  insertBold(): void {
    this.insertMarkdown('**', '**', 'bold text');
  }

  insertItalic(): void {
    this.insertMarkdown('*', '*', 'italic text');
  }

  insertLink(): void {
    this.insertMarkdown('[', '](url)', 'link text');
  }

  insertImage(): void {
    this.insertMarkdown('![', '](image-url)', 'alt text');
  }

  private insertMarkdown(before: string, after: string, placeholder: string): void {
    // Insert markdown syntax at cursor position
    const textarea = document.querySelector('textarea');
    if (!textarea) return;

    const start = textarea.selectionStart;
    const end = textarea.selectionEnd;
    const selectedText = this.content.substring(start, end) || placeholder;

    const newContent =
      this.content.substring(0, start) +
      before + selectedText + after +
      this.content.substring(end);

    this.onContentChange(newContent);
  }
}

// markdown.service.ts
import { Injectable } from '@angular/core';
import { marked } from 'marked';
import * as DOMPurify from 'dompurify';

@Injectable({
  providedIn: 'root'
})
export class MarkdownService {
  constructor() {
    // Configure marked options
    marked.setOptions({
      gfm: true,              // GitHub Flavored Markdown
      breaks: true,           // Line breaks
      pedantic: false,
      smartLists: true,
      smartypants: true
    });
  }

  render(markdown: string): string {
    // Parse markdown to HTML
    const rawHtml = marked.parse(markdown) as string;

    // Sanitize HTML to prevent XSS
    return DOMPurify.sanitize(rawHtml);
  }

  convertHtmlToMarkdown(html: string): string {
    // Use turndown for HTML to Markdown conversion
    const turndownService = new TurndownService();
    return turndownService.turndown(html);
  }
}

// document-api.service.ts
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Document, DocumentRequest } from '../models/document.model';

@Injectable({
  providedIn: 'root'
})
export class DocumentApiService {
  private apiUrl = 'https://localhost:8080/do';

  constructor(private http: HttpClient) {}

  saveDocument(documentId: string, content: string, jwt: string): Observable<Document> {
    const request: DocumentRequest = {
      action: 'documentUpdate',
      jwt: jwt,
      data: {
        id: documentId,
        content_markdown: content,
        content_type: 'markdown'
      }
    };

    return this.http.post<Document>(this.apiUrl, request);
  }

  getDocument(documentId: string, jwt: string): Observable<Document> {
    const request: DocumentRequest = {
      action: 'documentRead',
      jwt: jwt,
      data: { id: documentId }
    };

    return this.http.post<Document>(this.apiUrl, request);
  }
}
```

**HTML Template**:

```html
<!-- markdown-editor.component.html -->
<div class="markdown-editor-container">
  <!-- Toolbar -->
  <mat-toolbar class="editor-toolbar">
    <button mat-icon-button (click)="insertBold()" matTooltip="Bold">
      <mat-icon>format_bold</mat-icon>
    </button>
    <button mat-icon-button (click)="insertItalic()" matTooltip="Italic">
      <mat-icon>format_italic</mat-icon>
    </button>
    <button mat-icon-button (click)="insertLink()" matTooltip="Insert Link">
      <mat-icon>link</mat-icon>
    </button>
    <button mat-icon-button (click)="insertImage()" matTooltip="Insert Image">
      <mat-icon>image</mat-icon>
    </button>
    <span class="spacer"></span>
    <button mat-icon-button (click)="togglePreview()" matTooltip="Toggle Preview">
      <mat-icon>{{ showPreview ? 'code' : 'visibility' }}</mat-icon>
    </button>
    <button mat-raised-button color="primary" (click)="onSave()">
      <mat-icon>save</mat-icon> Save
    </button>
  </mat-toolbar>

  <!-- Editor/Preview Panes -->
  <div class="editor-content" [class.split-view]="showPreview">
    <!-- Editor Pane -->
    <div class="editor-pane">
      <textarea
        class="markdown-textarea"
        [(ngModel)]="content"
        (ngModelChange)="onContentChange($event)"
        placeholder="Write your markdown here..."
      ></textarea>
    </div>

    <!-- Preview Pane -->
    <div class="preview-pane" *ngIf="showPreview">
      <div class="markdown-preview" [innerHTML]="previewHtml"></div>
    </div>
  </div>
</div>
```

---

### Desktop Client Implementation

**Approach**: Reuse Web Client components + Tauri enhancements

```typescript
// Desktop-Client/src/app/features/documents/services/desktop-document.service.ts
import { Injectable } from '@angular/core';
import { invoke } from '@tauri-apps/api/tauri';

@Injectable({
  providedIn: 'root'
})
export class DesktopDocumentService {
  async saveToLocalFile(path: string, content: string): Promise<void> {
    await invoke('save_markdown_file', { path, content });
  }

  async loadFromLocalFile(path: string): Promise<string> {
    return await invoke('load_markdown_file', { path });
  }

  async exportToPdf(content: string): Promise<Uint8Array> {
    return await invoke('export_markdown_pdf', { content });
  }
}
```

**Rust Backend** (Tauri):

```rust
// Desktop-Client/src-tauri/src/commands.rs
use std::fs;
use tauri::command;

#[command]
pub async fn save_markdown_file(path: String, content: String) -> Result<(), String> {
    fs::write(&path, content)
        .map_err(|e| format!("Failed to save file: {}", e))
}

#[command]
pub async fn load_markdown_file(path: String) -> Result<String, String> {
    fs::read_to_string(&path)
        .map_err(|e| format!("Failed to load file: {}", e))
}

#[command]
pub async fn export_markdown_pdf(content: String) -> Result<Vec<u8>, String> {
    // Use a Rust PDF library like `printpdf` or `genpdf`
    // Convert markdown to PDF
    todo!("Implement PDF export")
}
```

---

### iOS Client Implementation

**Module Structure**:
```
iOS-Client/Sources/
├── Features/
│   └── Documents/
│       ├── Views/
│       │   ├── MarkdownEditorView.swift            # Main editor
│       │   ├── MarkdownToolbarView.swift           # Toolbar
│       │   ├── MarkdownPreviewView.swift           # Preview
│       │   └── DocumentListView.swift              # Document list
│       ├── ViewModels/
│       │   ├── DocumentViewModel.swift             # ViewModel
│       │   └── MarkdownEditorViewModel.swift       # Editor ViewModel
│       ├── Services/
│       │   ├── MarkdownService.swift               # Markdown processing
│       │   └── DocumentAPIService.swift            # API integration
│       └── Models/
│           ├── Document.swift
│           └── MarkdownEditor.swift
└── Tests/
    └── DocumentsTests/                              # Tests
```

**Key Components**:

```swift
// MarkdownEditorView.swift
import SwiftUI
import Down

struct MarkdownEditorView: View {
    @StateObject private var viewModel: MarkdownEditorViewModel
    @State private var showPreview = false

    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            MarkdownToolbarView(
                onBold: { viewModel.insertBold() },
                onItalic: { viewModel.insertItalic() },
                onLink: { viewModel.insertLink() },
                onImage: { viewModel.insertImage() },
                onPreview: { showPreview.toggle() },
                onSave: { viewModel.save() }
            )

            // Editor/Preview
            if showPreview {
                HSplitView {
                    // Editor pane
                    TextEditor(text: $viewModel.content)
                        .font(.system(.body, design: .monospaced))

                    // Preview pane
                    MarkdownPreviewView(markdown: viewModel.content)
                }
            } else {
                // Full editor
                TextEditor(text: $viewModel.content)
                    .font(.system(.body, design: .monospaced))
            }
        }
        .navigationTitle(viewModel.document.title)
    }
}

// MarkdownService.swift
import Foundation
import Down

class MarkdownService {
    func render(markdown: String) -> String {
        do {
            let down = Down(markdownString: markdown)
            return try down.toHTML()
        } catch {
            return "Error rendering markdown: \\(error)"
        }
    }

    func renderAttributedString(markdown: String) -> NSAttributedString? {
        do {
            let down = Down(markdownString: markdown)
            return try down.toAttributedString()
        } catch {
            return nil
        }
    }
}

// DocumentAPIService.swift
import Foundation

class DocumentAPIService {
    private let baseURL = "https://localhost:8080/do"

    func saveDocument(id: String, content: String, jwt: String) async throws -> Document {
        let request = DocumentRequest(
            action: "documentUpdate",
            jwt: jwt,
            data: [
                "id": id,
                "content_markdown": content,
                "content_type": "markdown"
            ]
        )

        let (data, _) = try await URLSession.shared.data(for: createURLRequest(request))
        return try JSONDecoder().decode(Document.self, from: data)
    }

    private func createURLRequest(_ request: DocumentRequest) -> URLRequest {
        var urlRequest = URLRequest(url: URL(string: baseURL)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(request)
        return urlRequest
    }
}
```

---

## Document Storage Strategy

### Primary Storage Format: Markdown

**Database Schema**:
```sql
-- document_content table
CREATE TABLE document_content (
    id TEXT PRIMARY KEY,
    document_id TEXT NOT NULL,
    version INTEGER NOT NULL,
    content_type TEXT NOT NULL,        -- 'markdown', 'html', 'plain', 'storage'
    content_text TEXT,                 -- Markdown source (primary)
    content_html TEXT,                 -- Rendered HTML (cached)
    created INTEGER NOT NULL,
    modified INTEGER NOT NULL,
    FOREIGN KEY (document_id) REFERENCES document(id)
);
```

### Content Type Conversions

**Markdown → HTML**:
```go
// Backend conversion
func (h *Handler) convertMarkdownToHTML(markdown string) string {
    // Use Goldmark or Blackfriday
    md := goldmark.New(
        goldmark.WithExtensions(
            extension.GFM,
            extension.Table,
            extension.Linkify,
            extension.Strikethrough,
        ),
    )

    var buf bytes.Buffer
    if err := md.Convert([]byte(markdown), &buf); err != nil {
        return ""
    }
    return buf.String()
}
```

**HTML → Markdown**:
```go
func (h *Handler) convertHTMLToMarkdown(html string) string {
    // Use html-to-markdown converter
    return htmlToMarkdown.Convert(html)
}
```

### API Actions for Format Conversion

```json
{
  "action": "documentContentConvert",
  "jwt": "...",
  "data": {
    "document_id": "doc-123",
    "from_format": "html",
    "to_format": "markdown"
  }
}
```

---

## Testing Requirements

### Test Coverage Goal: 100%

**Test Categories** (All Platforms):

1. **Markdown Editing Tests**
   - Text input and display
   - Cursor positioning
   - Selection handling
   - Undo/redo functionality
   - Auto-save

2. **Format Conversion Tests**
   - Markdown → HTML
   - HTML → Markdown
   - Markdown → Plain Text
   - Plain Text → Markdown
   - Edge cases (special characters, nested structures)

3. **Editor Action Tests**
   - Bold text insertion
   - Italic text insertion
   - Link insertion
   - Image insertion
   - Code block insertion
   - List creation
   - Table creation

4. **Preview Tests**
   - Real-time rendering
   - Scroll synchronization
   - Syntax highlighting
   - Image rendering
   - Link handling

5. **API Integration Tests**
   - Document save
   - Document load
   - Version creation
   - Conflict resolution
   - Error handling

6. **Collaboration Tests**
   - Comments
   - Mentions (@username)
   - Watchers
   - Reactions

7. **Export Tests**
   - Export to PDF
   - Export to DOCX
   - Export to HTML
   - Export to XML
   - Export to Markdown (with formatting preserved)

8. **Performance Tests**
   - Large document handling (10MB+)
   - Real-time preview performance
   - Syntax highlighting performance
   - Save/load speed

### Test Execution: 100% Success Rate Required

**Example Test Structure** (Android):

```kotlin
// MarkdownEditorTest.kt
@RunWith(AndroidJUnit4::class)
class MarkdownEditorTest {

    @Test
    fun testBoldTextInsertion() {
        val editor = MarkdownEditorView(context)
        editor.setText("Hello World")
        editor.setSelection(0, 5) // Select "Hello"

        editor.insertBold()

        assertEquals("**Hello** World", editor.text.toString())
    }

    @Test
    fun testMarkdownToHtmlConversion() {
        val markdown = "# Title\\n\\n**Bold** and *italic*"
        val html = markdownService.render(markdown)

        assertTrue(html.contains("<h1>Title</h1>"))
        assertTrue(html.contains("<strong>Bold</strong>"))
        assertTrue(html.contains("<em>italic</em>"))
    }

    @Test
    fun testDocumentSaveAndLoad() = runBlocking {
        val document = Document(
            id = "test-doc-1",
            title = "Test Document",
            contentMarkdown = "# Test\\nContent"
        )

        val saved = repository.saveDocument(document)
        assertTrue(saved.isSuccess)

        val loaded = repository.getDocument("test-doc-1")
        assertTrue(loaded.isSuccess)
        assertEquals("# Test\\nContent", loaded.getOrNull()?.contentMarkdown)
    }
}
```

---

## API Integration

### Document CRUD Operations

**Create Document**:
```json
{
  "action": "documentCreate",
  "jwt": "eyJhbGciOiJ...",
  "data": {
    "title": "My First Document",
    "space_id": "space-123",
    "type_id": "type-page",
    "content_markdown": "# Welcome\\n\\nThis is my first document.",
    "content_type": "markdown"
  }
}
```

**Update Document**:
```json
{
  "action": "documentUpdate",
  "jwt": "eyJhbGciOiJ...",
  "data": {
    "id": "doc-123",
    "content_markdown": "# Updated Content\\n\\nNew content here.",
    "content_type": "markdown",
    "version": 2
  }
}
```

**Get Document**:
```json
{
  "action": "documentRead",
  "jwt": "eyJhbGciOiJ...",
  "data": {
    "id": "doc-123"
  }
}
```

**Response**:
```json
{
  "errorCode": -1,
  "errorMessage": "",
  "data": {
    "id": "doc-123",
    "title": "My First Document",
    "space_id": "space-123",
    "type_id": "type-page",
    "content": {
      "content_markdown": "# Updated Content\\n\\nNew content here.",
      "content_html": "<h1>Updated Content</h1><p>New content here.</p>",
      "content_type": "markdown"
    },
    "version": 2,
    "created": 1704067200,
    "modified": 1704153600
  }
}
```

### Real-Time Collaboration

**Add Watcher**:
```json
{
  "action": "documentWatcherAdd",
  "jwt": "eyJhbGciOiJ...",
  "data": {
    "document_id": "doc-123",
    "user_id": "user-456"
  }
}
```

**Add Comment**:
```json
{
  "action": "documentCommentAdd",
  "jwt": "eyJhbGciOiJ...",
  "data": {
    "document_id": "doc-123",
    "comment": "Great work! Love the new section.",
    "parent_id": null
  }
}
```

**Add Mention**:
```json
{
  "action": "documentMentionCreate",
  "jwt": "eyJhbGciOiJ...",
  "data": {
    "version_id": "ver-789",
    "mentioned_user_id": "user-456",
    "mentioning_user_id": "user-123",
    "context": "Check out this update @john.doe"
  }
}
```

---

## Implementation Timeline

### Total Estimated Time: 10-14 weeks

| Platform | Timeline | Priority |
|----------|----------|----------|
| **Android** | 2-3 weeks | High |
| **Web (Angular)** | 3-4 weeks | High |
| **Desktop (Tauri)** | 2-3 weeks | Medium |
| **iOS (Swift)** | 3-4 weeks | Medium |
| **Testing & QA** | 2-3 weeks | Critical |

---

## Checklist for Each Platform

- [ ] Clone and analyze Markor repository
- [ ] Extract/port core markdown editing logic
- [ ] Implement syntax highlighting
- [ ] Implement real-time preview
- [ ] Build toolbar with common actions (bold, italic, link, image, etc.)
- [ ] Integrate with HelixTrack API (save/load documents)
- [ ] Implement offline support (local caching)
- [ ] Add version control support
- [ ] Add collaboration features (comments, mentions, watchers)
- [ ] Implement export functionality (PDF, DOCX, HTML, etc.)
- [ ] Write comprehensive tests (100% coverage)
- [ ] Achieve 100% test success rate
- [ ] Performance testing (large documents, real-time preview)
- [ ] Security testing (XSS prevention in preview)
- [ ] User acceptance testing

---

## Conclusion

This guide provides a comprehensive roadmap for integrating Markor markdown editor into all HelixTrack client applications. The phased approach ensures:

1. **Native Android experience** using Markor directly
2. **Consistent Web/Desktop experience** with Angular/Tauri
3. **Native iOS experience** with Swift/SwiftUI port
4. **100% test coverage** across all platforms
5. **100% test success rate** for reliability
6. **Markdown-first storage** strategy for simplicity

By following this guide, all client developers will have a clear path to implementing powerful, consistent markdown editing across all HelixTrack platforms.

---

**Document Version**: 1.0
**Last Updated**: 2025-10-18
**Status**: Ready for Implementation
