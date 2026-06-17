# Web-Client Documents V2 - Implementation Guide

**Status**: 25% Complete (Models, Service, 1 Component)
**Remaining**: 4 Angular Components + Routing + Integration

---

## ✅ Completed (This Session)

### 1. Document Models (4 files, ~900 lines)
- ✅ `document.model.ts` - Document interface, enums, utilities
- ✅ `document-space.model.ts` - DocumentSpace interface, validation
- ✅ `document-version.model.ts` - DocumentVersion interface, helpers
- ✅ `index.ts` - Barrel export

### 2. DocumentService (1 file, ~450 lines)
- ✅ Complete API integration with 90+ actions
- ✅ RxJS state management with BehaviorSubjects
- ✅ All CRUD operations for Spaces, Documents, Versions
- ✅ Locking, Export, Analytics

### 3. DocumentSpaceListComponent (3 files, ~750 lines)
- ✅ `document-space-list.component.ts` - TypeScript logic
- ✅ `document-space-list.component.html` - Template with Material Design
- ✅ `document-space-list.component.scss` - Styling
- **Features**: List view, favorites, search, create dialog, empty states

---

## ⏳ Remaining Components (Follow Same Pattern)

### Component 1: DocumentListComponent

**Purpose**: Show documents within a space

**Files to Create**:
```
src/app/features/documents/components/document-list/
├── document-list.component.ts
├── document-list.component.html
└── document-list.component.scss
```

**TypeScript Structure** (`document-list.component.ts`):
```typescript
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { DocumentService } from '../../services/document.service';
import { Document, DocumentSpace } from '../../models';

@Component({
  selector: 'app-document-list',
  templateUrl: './document-list.component.html',
  styleUrls: ['./document-list.component.scss']
})
export class DocumentListComponent implements OnInit {
  spaceId: string = '';
  space: DocumentSpace | null = null;
  documents: Document[] = [];
  filteredDocuments: Document[] = [];
  searchQuery = '';
  isLoading = false;
  error: string | null = null;

  // View modes
  viewMode: 'list' | 'tree' | 'grid' = 'list';

  // Create document dialog
  showCreateDialog = false;
  newDocumentTitle = '';

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private documentService: DocumentService
  ) {}

  ngOnInit(): void {
    this.route.params.subscribe(params => {
      this.spaceId = params['spaceId'];
      this.loadSpace();
      this.loadDocuments();
    });
  }

  loadSpace(): void {
    this.documentService.getDocumentSpace(this.spaceId).subscribe({
      next: (space) => this.space = space,
      error: (err) => this.error = 'Failed to load space'
    });
  }

  loadDocuments(): void {
    this.isLoading = true;
    this.documentService.getDocuments(this.spaceId).subscribe({
      next: (docs) => {
        this.documents = docs;
        this.applyFilter();
        this.isLoading = false;
      },
      error: (err) => {
        this.error = 'Failed to load documents';
        this.isLoading = false;
      }
    });
  }

  applyFilter(): void {
    const query = this.searchQuery.toLowerCase();
    this.filteredDocuments = query
      ? this.documents.filter(d =>
          d.title.toLowerCase().includes(query) ||
          d.contentMarkdown.toLowerCase().includes(query)
        )
      : this.documents;
  }

  openDocument(doc: Document): void {
    this.router.navigate(['/documents/editor', doc.id]);
  }

  createDocument(): void {
    if (!this.newDocumentTitle.trim()) return;

    this.documentService.createDocument({
      spaceId: this.spaceId,
      title: this.newDocumentTitle,
      contentMarkdown: ''
    }).subscribe({
      next: (doc) => {
        this.showCreateDialog = false;
        this.newDocumentTitle = '';
        this.router.navigate(['/documents/editor', doc.id]);
      },
      error: (err) => console.error('Failed to create document', err)
    });
  }
}
```

**HTML Template** - Include:
- Header with space name and back button
- Search bar
- View mode toggle (list/tree/grid)
- Document cards with: title, preview, metadata, status indicators
- Create document FAB button
- Empty state
- Create dialog

**SCSS Styling** - Follow DocumentSpaceListComponent pattern with card grid

---

### Component 2: DocumentEditorComponent

**Purpose**: Markdown editor with live preview

**Files to Create**:
```
src/app/features/documents/components/document-editor/
├── document-editor.component.ts
├── document-editor.component.html
└── document-editor.component.scss
```

**Key Features**:
- Monaco Editor or CodeMirror for markdown editing
- Live HTML preview panel
- Split-view mode toggle
- Auto-save (every 3 seconds)
- Manual save with change comment
- Lock/unlock document
- Export menu (PDF, HTML)
- Version history link
- Markdown toolbar (bold, italic, headers, lists, etc.)

**TypeScript Logic**:
```typescript
export class DocumentEditorComponent implements OnInit {
  documentId: string = '';
  document: Document | null = null;
  contentMarkdown = '';
  contentHtml = '';

  // Editor state
  viewMode: 'edit' | 'preview' | 'split' = 'split';
  hasUnsavedChanges = false;
  isSaving = false;
  autoSaveTimer: any;

  // Lock state
  isLocked = false;
  lockedBy = '';

  ngOnInit() {
    this.route.params.subscribe(params => {
      this.documentId = params['documentId'];
      this.loadDocument();
    });
  }

  loadDocument() {
    this.documentService.getDocument(this.documentId).subscribe({
      next: (doc) => {
        this.document = doc;
        this.contentMarkdown = doc.contentMarkdown;
        this.updatePreview();
        this.tryLockDocument();
      }
    });
  }

  onContentChange() {
    this.hasUnsavedChanges = true;
    this.updatePreview();
    this.scheduleAutoSave();
  }

  scheduleAutoSave() {
    clearTimeout(this.autoSaveTimer);
    this.autoSaveTimer = setTimeout(() => this.autoSave(), 3000);
  }

  autoSave() {
    if (!this.hasUnsavedChanges) return;

    this.documentService.updateDocumentContent({
      documentId: this.documentId,
      contentMarkdown: this.contentMarkdown
    }).subscribe({
      next: () => {
        this.hasUnsavedChanges = false;
        this.isSaving = false;
      }
    });
  }

  updatePreview() {
    // TODO: Convert markdown to HTML
    // Use marked.js or showdown.js library
    this.contentHtml = this.convertMarkdownToHtml(this.contentMarkdown);
  }

  tryLockDocument() {
    this.documentService.lockDocument(this.documentId, 30).subscribe({
      next: (doc) => {
        this.isLocked = true;
        this.document = doc;
      }
    });
  }

  exportToPdf() {
    this.documentService.exportDocumentToPdf(this.documentId).subscribe({
      next: (blob) => {
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `${this.document?.title || 'document'}.pdf`;
        a.click();
      }
    });
  }
}
```

**HTML Structure**:
- Top toolbar: Save button, view mode toggles, lock status, export menu
- Editor area:
  - Split mode: Monaco editor (left) + HTML preview (right)
  - Edit mode: Monaco editor (full width)
  - Preview mode: HTML preview (full width)
- Markdown formatting toolbar
- Status bar: Auto-save status, word count, cursor position

**Monaco Editor Integration**:
```bash
npm install ngx-monaco-editor monaco-editor
```

Add to `app.module.ts`:
```typescript
import { MonacoEditorModule } from 'ngx-monaco-editor';

@NgModule({
  imports: [
    MonacoEditorModule.forRoot()
  ]
})
```

---

### Component 3: DocumentVersionHistoryComponent

**Purpose**: Show version history with revert capability

**Files to Create**:
```
src/app/features/documents/components/document-version-history/
├── document-version-history.component.ts
├── document-version-history.component.html
└── document-version-history.component.scss
```

**Features**:
- Version list (sorted by version number desc)
- Version cards showing: number, author, timestamp, change comment, change type
- Current version indicator
- Revert button with confirmation dialog
- Compare versions (optional)

**Implementation**: Follow Android DocumentVersionHistoryScreen pattern

---

### Component 4: MarkdownToolbarComponent

**Purpose**: Formatting toolbar for markdown editor

**Files to Create**:
```
src/app/features/documents/components/markdown-toolbar/
├── markdown-toolbar.component.ts
├── markdown-toolbar.component.html
└── markdown-toolbar.component.scss
```

**Buttons**:
- Bold, Italic, Strikethrough
- Headers (H1-H6 dropdown)
- Code (inline and block)
- Link, Image
- Lists (bullet, numbered, task)
- Quote, Horizontal rule
- Table

**Output Events**:
```typescript
@Output() format = new EventEmitter<MarkdownFormat>();

insertBold() {
  this.format.emit({ type: 'bold', value: '**' });
}

insertHeader(level: number) {
  this.format.emit({ type: 'header', value: '#'.repeat(level) });
}
```

---

## Routing Module

**File**: `src/app/features/documents/documents-routing.module.ts`

```typescript
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { DocumentSpaceListComponent } from './components/document-space-list/document-space-list.component';
import { DocumentListComponent } from './components/document-list/document-list.component';
import { DocumentEditorComponent } from './components/document-editor/document-editor.component';
import { DocumentVersionHistoryComponent } from './components/document-version-history/document-version-history.component';

const routes: Routes = [
  {
    path: '',
    component: DocumentSpaceListComponent
  },
  {
    path: ':spaceId',
    component: DocumentListComponent
  },
  {
    path: 'editor/:documentId',
    component: DocumentEditorComponent
  },
  {
    path: 'versions/:documentId',
    component: DocumentVersionHistoryComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class DocumentsRoutingModule {}
```

---

## Documents Module

**File**: `src/app/features/documents/documents.module.ts`

```typescript
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MaterialModule } from '@app/shared/material.module'; // Import all Material components

import { DocumentsRoutingModule } from './documents-routing.module';
import { DocumentService } from './services/document.service';

import { DocumentSpaceListComponent } from './components/document-space-list/document-space-list.component';
import { DocumentListComponent } from './components/document-list/document-list.component';
import { DocumentEditorComponent } from './components/document-editor/document-editor.component';
import { DocumentVersionHistoryComponent } from './components/document-version-history/document-version-history.component';
import { MarkdownToolbarComponent } from './components/markdown-toolbar/markdown-toolbar.component';

@NgModule({
  declarations: [
    DocumentSpaceListComponent,
    DocumentListComponent,
    DocumentEditorComponent,
    DocumentVersionHistoryComponent,
    MarkdownToolbarComponent
  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MaterialModule,
    DocumentsRoutingModule
  ],
  providers: [
    DocumentService
  ]
})
export class DocumentsModule {}
```

---

## App Routing Integration

**File**: `src/app/app-routing.module.ts`

Add lazy-loaded documents route:

```typescript
const routes: Routes = [
  // ... existing routes
  {
    path: 'documents',
    loadChildren: () => import('./features/documents/documents.module').then(m => m.DocumentsModule)
  }
];
```

---

## Navigation Menu Integration

Add Documents menu item to your main navigation (sidebar or header):

```html
<!-- In your navigation component -->
<mat-list-item routerLink="/documents" routerLinkActive="active">
  <mat-icon matListIcon>description</mat-icon>
  <span matLine>Documents</span>
</mat-list-item>
```

---

## Dependencies

Install required packages:

```bash
# Markdown rendering
npm install marked @types/marked

# Monaco Editor (or CodeMirror)
npm install ngx-monaco-editor monaco-editor

# Markdown parsing/rendering
npm install showdown @types/showdown

# Or use ngx-markdown
npm install ngx-markdown
```

---

## Testing Checklist

- [ ] DocumentSpaceListComponent
  - [ ] List all spaces
  - [ ] Search/filter works
  - [ ] Create space dialog validation
  - [ ] Toggle favorites
  - [ ] Navigate to document list

- [ ] DocumentListComponent
  - [ ] Load documents for space
  - [ ] Search documents
  - [ ] View mode toggle (list/tree/grid)
  - [ ] Create document
  - [ ] Navigate to editor

- [ ] DocumentEditorComponent
  - [ ] Load document content
  - [ ] Edit markdown
  - [ ] Live preview updates
  - [ ] Split-view mode
  - [ ] Auto-save works
  - [ ] Manual save with comment
  - [ ] Lock/unlock
  - [ ] Export to PDF/HTML

- [ ] DocumentVersionHistoryComponent
  - [ ] Load version list
  - [ ] Show version metadata
  - [ ] Revert to version
  - [ ] Compare versions (optional)

- [ ] Routing
  - [ ] All routes work
  - [ ] Parameters passed correctly
  - [ ] Navigation between screens

---

## Estimated Completion Time

- DocumentListComponent: 3-4 hours
- DocumentEditorComponent: 5-6 hours (includes Monaco integration)
- DocumentVersionHistoryComponent: 2-3 hours
- MarkdownToolbarComponent: 2-3 hours
- Routing + Integration: 1-2 hours
- Testing: 2-3 hours

**Total**: 15-21 hours

---

## Next Steps

1. Create DocumentListComponent (follow pattern above)
2. Create DocumentEditorComponent with Monaco
3. Create DocumentVersionHistoryComponent
4. Create MarkdownToolbarComponent
5. Setup routing module
6. Integrate into app routing
7. Add navigation menu item
8. Test end-to-end workflows
9. Add offline storage (optional - LocalStorage for drafts)
10. Comprehensive testing

---

**Reference Implementation**: Android-Client (`DOCUMENTS_ANDROID_INTEGRATION_STATUS.md`)
**Backend API**: Core (`core/Application/docs/USER_MANUAL.md` - Documents V2 section)
