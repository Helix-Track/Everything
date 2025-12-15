# Documents Feature - Integration Implementation Plan

**Date**: 2025-10-18
**Purpose**: Step-by-step plan to integrate Documents V2 into existing HelixTrack client modules
**Status**: Ready for Implementation

---

## Overview

We have **existing client modules** that need to be extended with Documents V2 functionality:

### Existing Modules
```
HelixTrack/
├── Core/Application/          ✅ Documents V2 backend COMPLETE (100%)
├── Android-Client/            ⚪ Needs Documents integration
├── Web-Client/                ⚪ Needs Documents integration
├── Desktop-Client/            ⚪ Needs Documents integration
└── iOS-Client/                ⚪ Needs Documents integration
```

### Markor Integration
```
/home/milosvasic/Projects/markor/   ✅ Cloned and analyzed
```

---

## Integration Strategy

### Phase 1: Android-Client (Weeks 1-3)
**Direct Markor integration** - Extract and integrate markdown editing components

### Phase 2: Web-Client (Weeks 4-7)
**TypeScript/Angular port** - Implement markdown editing in Angular

### Phase 3: Desktop-Client (Weeks 8-10)
**Reuse Web-Client** - Add Tauri-specific enhancements

### Phase 4: iOS-Client (Weeks 11-14)
**Swift port** - Implement markdown editing in SwiftUI

---

## Android-Client Integration

### Current Structure
```
Android-Client/
├── app/
│   ├── build.gradle
│   └── src/main/
│       ├── java/com/helixtrack/
│       │   ├── activities/
│       │   ├── fragments/
│       │   ├── viewmodels/
│       │   ├── repositories/
│       │   ├── models/
│       │   └── services/
│       └── res/
│           ├── layout/
│           ├── menu/
│           └── values/
```

### Integration Steps

#### Step 1: Add Dependencies (build.gradle)

```gradle
// Android-Client/app/build.gradle

dependencies {
    // Existing dependencies...

    // Markdown processing (from Markor)
    implementation "com.vladsch.flexmark:flexmark:0.64.8"
    implementation "com.vladsch.flexmark:flexmark-ext-tables:0.64.8"
    implementation "com.vladsch.flexmark:flexmark-ext-gfm-tasklist:0.64.8"
    implementation "com.vladsch.flexmark:flexmark-ext-emoji:0.64.8"
    implementation "com.vladsch.flexmark:flexmark-ext-autolink:0.64.8"
    implementation "com.vladsch.flexmark:flexmark-ext-strikethrough:0.64.8"
    implementation "com.vladsch.flexmark:flexmark-ext-footnotes:0.64.8"

    // Room Database (for offline storage)
    implementation "androidx.room:room-runtime:2.5.2"
    kapt "androidx.room:room-compiler:2.5.2"
    implementation "androidx.room:room-ktx:2.5.2"

    // WorkManager (for background sync)
    implementation "androidx.work:work-runtime-ktx:2.8.1"
}
```

#### Step 2: Copy Markor Components

```bash
# Copy core editor components from Markor
cp /home/milosvasic/Projects/markor/app/src/main/java/net/gsantner/markor/frontend/textview/HighlightingEditor.java \\
   Android-Client/app/src/main/java/com/helixtrack/editor/

cp /home/milosvasic/Projects/markor/app/src/main/java/net/gsantner/markor/frontend/textview/SyntaxHighlighterBase.java \\
   Android-Client/app/src/main/java/com/helixtrack/editor/

cp /home/milosvasic/Projects/markor/app/src/main/java/net/gsantner/markor/format/markdown/MarkdownSyntaxHighlighter.java \\
   Android-Client/app/src/main/java/com/helixtrack/editor/markdown/

cp /home/milosvasic/Projects/markor/app/src/main/java/net/gsantner/markor/format/markdown/MarkdownTextConverter.java \\
   Android-Client/app/src/main/java/com/helixtrack/editor/markdown/

cp /home/milosvasic/Projects/markor/app/src/main/java/net/gsantner/markor/format/markdown/MarkdownActionButtons.java \\
   Android-Client/app/src/main/java/com/helixtrack/editor/markdown/
```

#### Step 3: Create Document Models

```kotlin
// Android-Client/app/src/main/java/com/helixtrack/models/Document.kt
package com.helixtrack.models

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "documents")
data class Document(
    @PrimaryKey val id: String,
    val title: String,
    val spaceId: String,
    val typeId: String,
    val contentMarkdown: String,
    val contentHtml: String? = null,
    val version: Int,
    val creatorId: String,
    val created: Long,
    val modified: Long,
    val isPublished: Boolean,
    val isArchived: Boolean,
    val isDeleted: Boolean,
    val isSynced: Boolean = true,
    val lastSyncTime: Long = 0
)
```

#### Step 4: Create Database DAO

```kotlin
// Android-Client/app/src/main/java/com/helixtrack/database/DocumentDao.kt
package com.helixtrack.database

import androidx.room.*
import com.helixtrack.models.Document
import kotlinx.coroutines.flow.Flow

@Dao
interface DocumentDao {
    @Query("SELECT * FROM documents WHERE isDeleted = 0 ORDER BY modified DESC")
    fun getAllDocuments(): Flow<List<Document>>

    @Query("SELECT * FROM documents WHERE id = :documentId")
    suspend fun getById(documentId: String): Document?

    @Query("SELECT * FROM documents WHERE spaceId = :spaceId AND isDeleted = 0 LIMIT :limit OFFSET :offset")
    suspend fun getBySpaceId(spaceId: String, limit: Int, offset: Int): List<Document>

    @Query("SELECT * FROM documents WHERE isSynced = 0")
    suspend fun getPendingSync(): List<Document>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(document: Document)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(documents: List<Document>)

    @Update
    suspend fun update(document: Document)

    @Query("DELETE FROM documents WHERE id = :documentId")
    suspend fun delete(documentId: String)
}
```

#### Step 5: Create API Service

```kotlin
// Android-Client/app/src/main/java/com/helixtrack/services/DocumentApiService.kt
package com.helixtrack.services

import com.helixtrack.models.ApiRequest
import com.helixtrack.models.ApiResponse
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.POST

interface DocumentApiService {
    @POST("/do")
    suspend fun doAction(@Body request: ApiRequest): Response<ApiResponse>
}

data class ApiRequest(
    val action: String,
    val jwt: String,
    val locale: String? = null,
    val `object`: String? = null,
    val data: Map<String, Any?>
)

data class ApiResponse(
    val errorCode: Int,
    val errorMessage: String,
    val errorMessageLocalised: String?,
    val data: Map<String, Any?>
)
```

#### Step 6: Create Repository

```kotlin
// Android-Client/app/src/main/java/com/helixtrack/repositories/DocumentRepository.kt
package com.helixtrack.repositories

import com.helixtrack.database.DocumentDao
import com.helixtrack.models.Document
import com.helixtrack.services.ApiRequest
import com.helixtrack.services.DocumentApiService
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.withContext
import javax.inject.Inject

class DocumentRepository @Inject constructor(
    private val apiService: DocumentApiService,
    private val documentDao: DocumentDao,
    private val authService: AuthService
) {

    fun getAllDocuments(): Flow<List<Document>> {
        return documentDao.getAllDocuments()
    }

    suspend fun createDocument(
        title: String,
        spaceId: String,
        contentMarkdown: String
    ): Result<Document> = withContext(Dispatchers.IO) {
        try {
            val request = ApiRequest(
                action = "documentCreate",
                jwt = authService.getJwt(),
                data = mapOf(
                    "title" to title,
                    "space_id" to spaceId,
                    "type_id" to "type-page",
                    "content_markdown" to contentMarkdown,
                    "content_type" to "markdown"
                )
            )

            val response = apiService.doAction(request)

            if (response.isSuccessful && response.body()?.errorCode == -1) {
                val document = parseDocument(response.body()!!.data)
                documentDao.insert(document)
                Result.success(document)
            } else {
                Result.failure(Exception(response.body()?.errorMessage ?: "Unknown error"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    suspend fun updateDocument(
        documentId: String,
        contentMarkdown: String,
        currentVersion: Int
    ): Result<Document> = withContext(Dispatchers.IO) {
        try {
            // Save to local cache first
            val cached = documentDao.getById(documentId)
            cached?.let {
                val updated = it.copy(
                    contentMarkdown = contentMarkdown,
                    modified = System.currentTimeMillis() / 1000,
                    isSynced = false
                )
                documentDao.update(updated)
            }

            // Send to backend
            val request = ApiRequest(
                action = "documentUpdate",
                jwt = authService.getJwt(),
                data = mapOf(
                    "id" to documentId,
                    "content_markdown" to contentMarkdown,
                    "content_type" to "markdown",
                    "version" to currentVersion
                )
            )

            val response = apiService.doAction(request)

            if (response.isSuccessful && response.body()?.errorCode == -1) {
                val document = parseDocument(response.body()!!.data).copy(isSynced = true)
                documentDao.update(document)
                Result.success(document)
            } else if (response.body()?.errorCode == 3005) {
                Result.failure(VersionConflictException())
            } else {
                Result.failure(Exception(response.body()?.errorMessage ?: "Update failed"))
            }
        } catch (e: Exception) {
            Result.failure(e)
        }
    }

    private fun parseDocument(data: Map<String, Any?>): Document {
        @Suppress("UNCHECKED_CAST")
        val content = data["content"] as? Map<String, Any?>

        return Document(
            id = data["id"] as String,
            title = data["title"] as String,
            spaceId = data["space_id"] as String,
            typeId = data["type_id"] as String,
            contentMarkdown = content?.get("content_markdown") as? String ?: "",
            contentHtml = content?.get("content_html") as? String,
            version = (data["version"] as Number).toInt(),
            creatorId = data["creator_id"] as? String ?: "",
            created = (data["created"] as Number).toLong(),
            modified = (data["modified"] as Number).toLong(),
            isPublished = data["is_published"] as? Boolean ?: false,
            isArchived = data["is_archived"] as? Boolean ?: false,
            isDeleted = data["deleted"] as? Boolean ?: false,
            isSynced = true,
            lastSyncTime = System.currentTimeMillis() / 1000
        )
    }
}

class VersionConflictException : Exception("Document version conflict")
```

#### Step 7: Create Document Editor Activity

```kotlin
// Android-Client/app/src/main/java/com/helixtrack/activities/DocumentEditorActivity.kt
package com.helixtrack.activities

import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.helixtrack.R
import com.helixtrack.databinding.ActivityDocumentEditorBinding
import com.helixtrack.editor.HighlightingEditor
import com.helixtrack.editor.markdown.MarkdownSyntaxHighlighter
import com.helixtrack.viewmodels.DocumentViewModel
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

@AndroidEntryPoint
class DocumentEditorActivity : AppCompatActivity() {

    private lateinit var binding: ActivityDocumentEditorBinding
    private val viewModel: DocumentViewModel by viewModels()
    private lateinit var editor: HighlightingEditor
    private var autoSaveJob: Job? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityDocumentEditorBinding.inflate(layoutInflater)
        setContentView(binding.root)

        val documentId = intent.getStringExtra("DOCUMENT_ID") ?: return finish()

        setupEditor()
        setupToolbar()
        observeViewModel()
        viewModel.loadDocument(documentId)
    }

    private fun setupEditor() {
        editor = binding.editor
        val highlighter = MarkdownSyntaxHighlighter(this)
        editor.setHighlighter(highlighter)

        editor.addTextChangedListener(object : TextWatcher {
            override fun afterTextChanged(s: Editable?) {
                scheduleAutoSave()
            }
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {}
        })
    }

    private fun setupToolbar() {
        setSupportActionBar(binding.toolbar)
        supportActionBar?.setDisplayHomeAsUpEnabled(true)

        // Setup markdown toolbar buttons
        binding.btnBold.setOnClickListener { insertBold() }
        binding.btnItalic.setOnClickListener { insertItalic() }
        binding.btnLink.setOnClickListener { insertLink() }
        binding.btnImage.setOnClickListener { insertImage() }
    }

    private fun observeViewModel() {
        lifecycleScope.launch {
            viewModel.document.collect { document ->
                document?.let {
                    supportActionBar?.title = it.title
                    editor.setText(it.contentMarkdown)
                }
            }
        }

        lifecycleScope.launch {
            viewModel.saveStatus.collect { status ->
                binding.statusText.text = status
            }
        }
    }

    private fun scheduleAutoSave() {
        autoSaveJob?.cancel()
        autoSaveJob = lifecycleScope.launch {
            delay(5000)
            viewModel.saveDocument(editor.text.toString())
        }
    }

    private fun insertBold() {
        // Implement markdown insertion
    }

    private fun insertItalic() {
        // Implement markdown insertion
    }

    private fun insertLink() {
        // Implement markdown insertion
    }

    private fun insertImage() {
        // Implement markdown insertion
    }
}
```

#### Step 8: Create Layout Resources

```xml
<!-- Android-Client/app/src/main/res/layout/activity_document_editor.xml -->
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical">

    <com.google.android.material.appbar.AppBarLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content">

        <androidx.appcompat.widget.Toolbar
            android:id="@+id/toolbar"
            android:layout_width="match_parent"
            android:layout_height="?attr/actionBarSize"
            android:background="?attr/colorPrimary"
            android:theme="@style/ThemeOverlay.AppCompat.Dark.ActionBar"
            app:popupTheme="@style/ThemeOverlay.AppCompat.Light" />

        <HorizontalScrollView
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:scrollbars="none">

            <LinearLayout
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:orientation="horizontal"
                android:padding="8dp">

                <ImageButton
                    android:id="@+id/btn_bold"
                    android:layout_width="48dp"
                    android:layout_height="48dp"
                    android:contentDescription="Bold"
                    android:src="@drawable/ic_format_bold" />

                <ImageButton
                    android:id="@+id/btn_italic"
                    android:layout_width="48dp"
                    android:layout_height="48dp"
                    android:contentDescription="Italic"
                    android:src="@drawable/ic_format_italic" />

                <ImageButton
                    android:id="@+id/btn_link"
                    android:layout_width="48dp"
                    android:layout_height="48dp"
                    android:contentDescription="Insert Link"
                    android:src="@drawable/ic_link" />

                <ImageButton
                    android:id="@+id/btn_image"
                    android:layout_width="48dp"
                    android:layout_height="48dp"
                    android:contentDescription="Insert Image"
                    android:src="@drawable/ic_image" />

            </LinearLayout>
        </HorizontalScrollView>

    </com.google.android.material.appbar.AppBarLayout>

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:background="@color/status_bar_background"
        android:orientation="horizontal"
        android:padding="8dp">

        <TextView
            android:id="@+id/status_text"
            android:layout_width="0dp"
            android:layout_height="wrap_content"
            android:layout_weight="1"
            android:text="Ready"
            android:textSize="12sp" />

    </LinearLayout>

    <com.helixtrack.editor.HighlightingEditor
        android:id="@+id/editor"
        android:layout_width="match_parent"
        android:layout_height="0dp"
        android:layout_weight="1"
        android:fontFamily="monospace"
        android:gravity="top|start"
        android:hint="Write your markdown here..."
        android:padding="16dp"
        android:textSize="14sp" />

</LinearLayout>
```

#### Step 9: Add Navigation

```kotlin
// In existing MainActivity or navigation component
fun navigateToDocumentEditor(documentId: String) {
    val intent = Intent(this, DocumentEditorActivity::class.java)
    intent.putExtra("DOCUMENT_ID", documentId)
    startActivity(intent)
}
```

---

## Web-Client Integration

### Current Structure
```
Web-Client/
├── angular.json
├── package.json
├── src/
│   ├── app/
│   │   ├── core/
│   │   │   ├── services/
│   │   │   ├── models/
│   │   │   └── interceptors/
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   ├── projects/
│   │   │   ├── tickets/
│   │   │   └── boards/
│   │   ├── shared/
│   │   └── layouts/
│   └── assets/
```

### Integration Steps

#### Step 1: Add Dependencies

```bash
# Web-Client/
cd Web-Client
npm install marked highlight.js turndown dompurify
npm install --save-dev @types/marked @types/dompurify
```

#### Step 2: Create Documents Feature Module

```bash
# Generate documents feature module
ng generate module features/documents --routing
ng generate service features/documents/services/document
ng generate service features/documents/services/markdown
ng generate component features/documents/components/markdown-editor
ng generate component features/documents/components/document-list
ng generate component features/documents/pages/editor-page
```

#### Step 3: Update package.json

```json
{
  "dependencies": {
    "marked": "^11.0.0",
    "highlight.js": "^11.9.0",
    "turndown": "^7.1.2",
    "dompurify": "^3.0.6",
    "@angular/cdk": "^17.0.0",
    "@angular/material": "^17.0.0"
  }
}
```

#### Step 4: Create Document Models

```typescript
// Web-Client/src/app/core/models/document.model.ts
export interface Document {
  id: string;
  title: string;
  spaceId: string;
  typeId: string;
  contentMarkdown: string;
  contentHtml?: string;
  version: number;
  creatorId: string;
  created: number;
  modified: number;
  isPublished: boolean;
  isArchived: boolean;
  isDeleted: boolean;
}
```

#### Step 5: Create Document Service

**(See Web Client Integration section in main architecture document for complete code)**

#### Step 6: Add Routes

```typescript
// Web-Client/src/app/features/documents/documents-routing.module.ts
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { DocumentListComponent } from './pages/document-list/document-list.component';
import { EditorPageComponent } from './pages/editor-page/editor-page.component';

const routes: Routes = [
  { path: '', component: DocumentListComponent },
  { path: 'editor/:id', component: EditorPageComponent },
  { path: 'new', component: EditorPageComponent }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class DocumentsRoutingModule { }
```

#### Step 7: Update Main App Routing

```typescript
// Web-Client/src/app/app-routing.module.ts
const routes: Routes = [
  // ... existing routes
  {
    path: 'documents',
    loadChildren: () => import('./features/documents/documents.module')
      .then(m => m.DocumentsModule)
  }
];
```

---

## Desktop-Client Integration

### Strategy
**Reuse Web-Client components + Add Tauri enhancements**

#### Step 1: Copy Web-Client Components

```bash
# Desktop-Client already shares Angular codebase with Web-Client
# Add Tauri-specific commands
```

#### Step 2: Add Tauri Commands

**(See Desktop Client Integration section in main architecture document)**

#### Step 3: Update Tauri Configuration

```json
// Desktop-Client/src-tauri/tauri.conf.json
{
  "tauri": {
    "allowlist": {
      "all": false,
      "fs": {
        "all": true,
        "scope": ["$DOCUMENT/**", "$APPDATA/**"]
      },
      "dialog": {
        "all": true
      },
      "shell": {
        "open": true
      }
    }
  }
}
```

---

## iOS-Client Integration

### Current Structure
```
iOS-Client/
├── Package.swift
└── Sources/
    ├── App/
    ├── Features/
    ├── Services/
    └── Models/
```

### Integration Steps

#### Step 1: Add Dependencies

```swift
// iOS-Client/Package.swift
dependencies: [
    .package(url: "https://github.com/johnxnguyen/Down.git", from: "0.11.0"),
    .package(url: "https://github.com/SimonFairbairn/SwiftyMarkdown.git", from: "1.2.4")
]
```

#### Step 2: Create Document Models

**(See iOS Client Integration section in main architecture document)**

---

## Testing Integration

### Per Platform

**Android**:
```bash
cd Android-Client
./gradlew test
./gradlew connectedAndroidTest
```

**Web**:
```bash
cd Web-Client
npm test
npm run test:e2e
```

**Desktop**:
```bash
cd Desktop-Client
npm test
npm run tauri:test
```

**iOS**:
```bash
cd iOS-Client
swift test
./run-full-tests.sh
```

---

## Timeline Summary

| Platform | Duration | Status |
|----------|----------|--------|
| Android  | 3 weeks  | Ready to start |
| Web      | 4 weeks  | Ready to start |
| Desktop  | 3 weeks  | Ready to start (after Web) |
| iOS      | 4 weeks  | Ready to start |
| **Total**| **14 weeks** | Full integration |

---

## Success Criteria

✅ **All platforms** can create, read, update, delete documents
✅ **Markdown editing** with syntax highlighting on all platforms
✅ **Auto-save** functionality working
✅ **Offline support** with local caching
✅ **Real-time sync** with backend
✅ **Version control** and conflict resolution
✅ **100% test coverage** for all new code
✅ **100% test success rate** across all platforms

---

**Next Steps**: Begin with Android-Client integration (Phase 1)
