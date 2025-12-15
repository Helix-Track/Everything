# iOS-Client Documents V2 - Implementation Guide

**Platform**: iOS 15+ with Swift 5.5+, SwiftUI 3.0+
**Architecture**: MVVM with Combine, Core Data for local storage
**Estimated Effort**: 18-22 hours

---

## Overview

The iOS-Client requires a complete independent implementation in Swift/SwiftUI. This guide provides step-by-step instructions with code templates.

---

## Phase 1: Document Models (Swift Codable)

### File Structure

```
iOS-Client/Sources/Features/Documents/
├── Models/
│   ├── Document.swift
│   ├── DocumentSpace.swift
│   ├── DocumentVersion.swift
│   └── DocumentEnums.swift
├── Services/
│   ├── DocumentService.swift
│   └── DocumentStorageService.swift
├── ViewModels/
│   ├── DocumentSpaceListViewModel.swift
│   ├── DocumentListViewModel.swift
│   └── DocumentEditorViewModel.swift
└── Views/
    ├── DocumentSpaceListView.swift
    ├── DocumentListView.swift
    ├── DocumentEditorView.swift
    ├── DocumentVersionHistoryView.swift
    └── MarkdownEditorView.swift
```

### 1.1 Document Model

**File**: `iOS-Client/Sources/Features/Documents/Models/Document.swift`

```swift
import Foundation

struct Document: Codable, Identifiable {
    // Core fields
    let id: String
    let spaceId: String
    var title: String
    var contentMarkdown: String
    var contentHtml: String?

    // Hierarchy
    var parentDocumentId: String?
    var hierarchyPath: String?
    var hierarchyLevel: Int
    var sortOrder: Int

    // Document type and status
    var documentType: DocumentType
    var status: DocumentStatus

    // Versioning
    var versionNumber: Int
    var isLatestVersion: Bool

    // Locking
    var isLocked: Bool
    var lockedBy: String?
    var lockedAt: Date?
    var lockExpiresAt: Date?

    // Permissions
    var permissions: [String]
    var visibility: DocumentVisibility

    // Metadata
    let createdBy: String
    let createdAt: Date
    var updatedBy: String
    var updatedAt: Date
    var modifiedBy: String
    var modifiedAt: Date

    // Statistics
    var viewCount: Int
    var editCount: Int
    var commentCount: Int
    var attachmentCount: Int

    // Labels and tags
    var labels: [String]?
    var tags: [String]?

    // Custom fields
    var customFields: [String: AnyCodable]?

    // Client-only fields
    var isSynced: Bool?
    var pendingSync: Bool?
    var localModifiedAt: Date?
    var conflictVersion: Int?

    // Coding keys for snake_case backend
    enum CodingKeys: String, CodingKey {
        case id
        case spaceId = "space_id"
        case title
        case contentMarkdown = "content_markdown"
        case contentHtml = "content_html"
        case parentDocumentId = "parent_document_id"
        case hierarchyPath = "hierarchy_path"
        case hierarchyLevel = "hierarchy_level"
        case sortOrder = "sort_order"
        case documentType = "document_type"
        case status
        case versionNumber = "version_number"
        case isLatestVersion = "is_latest_version"
        case isLocked = "is_locked"
        case lockedBy = "locked_by"
        case lockedAt = "locked_at"
        case lockExpiresAt = "lock_expires_at"
        case permissions
        case visibility
        case createdBy = "created_by"
        case createdAt = "created_at"
        case updatedBy = "updated_by"
        case updatedAt = "updated_at"
        case modifiedBy = "modified_by"
        case modifiedAt = "modified_at"
        case viewCount = "view_count"
        case editCount = "edit_count"
        case commentCount = "comment_count"
        case attachmentCount = "attachment_count"
        case labels
        case tags
        case customFields = "custom_fields"
        case isSynced = "is_synced"
        case pendingSync = "pending_sync"
        case localModifiedAt = "local_modified_at"
        case conflictVersion = "conflict_version"
    }

    // Helper methods
    func isCurrentlyLocked() -> Bool {
        guard isLocked, let expiresAt = lockExpiresAt else { return false }
        return expiresAt > Date()
    }

    func isLockedByUser(username: String) -> Bool {
        return isLocked && lockedBy == username
    }

    func needsSync() -> Bool {
        return pendingSync == true || isSynced == false
    }
}

// AnyCodable for custom fields
struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else {
            value = NSNull()
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case let intValue as Int:
            try container.encode(intValue)
        case let doubleValue as Double:
            try container.encode(doubleValue)
        case let stringValue as String:
            try container.encode(stringValue)
        case let boolValue as Bool:
            try container.encode(boolValue)
        default:
            try container.encodeNil()
        }
    }
}
```

### 1.2 Document Enums

**File**: `iOS-Client/Sources/Features/Documents/Models/DocumentEnums.swift`

```swift
import Foundation

enum DocumentType: String, Codable {
    case page
    case blogPost = "blog_post"
    case template
    case whiteboard
    case unknown
}

enum DocumentStatus: String, Codable {
    case draft
    case published
    case archived
    case deleted
}

enum DocumentVisibility: String, Codable {
    case `public`
    case `internal`
    case `private`
    case restricted
}

enum SpaceType: String, Codable {
    case personal
    case team
    case project
    case knowledge
    case unknown
}

enum SpaceStatus: String, Codable {
    case active
    case archived
    case deleted
}

enum ChangeType: String, Codable {
    case create
    case edit
    case revert
    case merge
    case `import`
    case unknown
}
```

### 1.3 DocumentSpace Model

**File**: `iOS-Client/Sources/Features/Documents/Models/DocumentSpace.swift`

```swift
import Foundation

struct DocumentSpace: Codable, Identifiable {
    let id: String
    let key: String
    var name: String
    var description: String?

    var projectId: String?

    var spaceType: SpaceType
    var status: SpaceStatus

    var permissions: [String]
    var defaultPermissions: [String]?

    var icon: String?
    var color: String?

    let createdBy: String
    let createdAt: Date
    var updatedBy: String
    var updatedAt: Date

    var documentCount: Int
    var memberCount: Int
    var viewCount: Int

    var isArchived: Bool
    var isFavorite: Bool?
    var lastAccessedAt: Date?

    var defaultTemplate: String?
    var availableTemplates: [String]?

    var isSynced: Bool?
    var localModifiedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id, key, name, description
        case projectId = "project_id"
        case spaceType = "space_type"
        case status, permissions
        case defaultPermissions = "default_permissions"
        case icon, color
        case createdBy = "created_by"
        case createdAt = "created_at"
        case updatedBy = "updated_by"
        case updatedAt = "updated_at"
        case documentCount = "document_count"
        case memberCount = "member_count"
        case viewCount = "view_count"
        case isArchived = "is_archived"
        case isFavorite = "is_favorite"
        case lastAccessedAt = "last_accessed_at"
        case defaultTemplate = "default_template"
        case availableTemplates = "available_templates"
        case isSynced = "is_synced"
        case localModifiedAt = "local_modified_at"
    }

    // Helper methods
    func hasPermission(_ permission: String) -> Bool {
        return permissions.contains(permission) || permissions.contains("admin")
    }

    func isActive() -> Bool {
        return status == .active && !isArchived
    }
}
```

### 1.4 DocumentVersion Model

**File**: `iOS-Client/Sources/Features/Documents/Models/DocumentVersion.swift`

```swift
import Foundation

struct DocumentVersion: Codable, Identifiable {
    let id: String
    let documentId: String
    let versionNumber: Int

    let content: String
    let title: String

    var changeComment: String?
    let changeType: ChangeType
    let isAutoSave: Bool
    let isMajorVersion: Bool

    let createdBy: String
    let createdAt: Date

    var contentHash: String?
    let contentSize: Int

    var versionLabel: String?
    var labels: [String]?

    var isSynced: Bool?
    var localFilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case documentId = "document_id"
        case versionNumber = "version_number"
        case content, title
        case changeComment = "change_comment"
        case changeType = "change_type"
        case isAutoSave = "is_auto_save"
        case isMajorVersion = "is_major_version"
        case createdBy = "created_by"
        case createdAt = "created_at"
        case contentHash = "content_hash"
        case contentSize = "content_size"
        case versionLabel = "version_label"
        case labels
        case isSynced = "is_synced"
        case localFilePath = "local_file_path"
    }

    func getVersionLabel() -> String {
        return versionLabel ?? "v\(versionNumber)"
    }

    func isMajor() -> Bool {
        return isMajorVersion || changeType == .create
    }
}
```

---

## Phase 2: Document Service (API Client)

### File: `iOS-Client/Sources/Features/Documents/Services/DocumentService.swift`

```swift
import Foundation
import Combine

class DocumentService {
    static let shared = DocumentService()

    private let baseURL = "https://localhost:8080/api"
    private let session: URLSession

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: configuration)
    }

    // MARK: - Document Spaces

    func getDocumentSpaces() -> AnyPublisher<[DocumentSpace], Error> {
        return doAction(action: "documentSpaceList", data: [:])
    }

    func getDocumentSpace(id: String) -> AnyPublisher<DocumentSpace, Error> {
        return doAction(action: "documentSpaceGet", data: ["space_id": id])
    }

    func createDocumentSpace(
        key: String,
        name: String,
        description: String?,
        spaceType: SpaceType
    ) -> AnyPublisher<DocumentSpace, Error> {
        var data: [String: Any] = [
            "key": key,
            "name": name,
            "space_type": spaceType.rawValue
        ]
        if let desc = description {
            data["description"] = desc
        }

        return doAction(action: "documentSpaceCreate", data: data)
    }

    // MARK: - Documents

    func getDocuments(spaceId: String) -> AnyPublisher<[Document], Error> {
        return doAction(action: "documentList", data: ["space_id": spaceId])
    }

    func getDocument(id: String) -> AnyPublisher<Document, Error> {
        return doAction(action: "documentGet", data: ["document_id": id])
    }

    func createDocument(
        spaceId: String,
        title: String,
        content: String
    ) -> AnyPublisher<Document, Error> {
        let data: [String: Any] = [
            "space_id": spaceId,
            "title": title,
            "content_markdown": content
        ]

        return doAction(action: "documentCreate", data: data)
    }

    func updateDocumentContent(
        documentId: String,
        content: String,
        changeComment: String?
    ) -> AnyPublisher<Document, Error> {
        var data: [String: Any] = [
            "document_id": documentId,
            "content_markdown": content
        ]
        if let comment = changeComment {
            data["change_comment"] = comment
        }

        return doAction(action: "documentUpdateContent", data: data)
    }

    func deleteDocument(id: String) -> AnyPublisher<Void, Error> {
        return doActionVoid(action: "documentDelete", data: ["document_id": id])
    }

    // MARK: - Document Locking

    func lockDocument(id: String, durationMinutes: Int = 30) -> AnyPublisher<Document, Error> {
        let data: [String: Any] = [
            "document_id": id,
            "duration_minutes": durationMinutes
        ]

        return doAction(action: "documentLock", data: data)
    }

    func unlockDocument(id: String) -> AnyPublisher<Document, Error> {
        return doAction(action: "documentUnlock", data: ["document_id": id])
    }

    // MARK: - Versions

    func getDocumentVersions(documentId: String) -> AnyPublisher<[DocumentVersion], Error> {
        return doAction(action: "documentVersionList", data: ["document_id": documentId])
    }

    func revertToVersion(documentId: String, versionId: String) -> AnyPublisher<Document, Error> {
        let data: [String: Any] = [
            "document_id": documentId,
            "version_id": versionId
        ]

        return doAction(action: "documentVersionRevert", data: data)
    }

    // MARK: - Export

    func exportDocumentToPDF(id: String) -> AnyPublisher<Data, Error> {
        return doActionData(action: "documentExportPdf", data: ["document_id": id])
    }

    func exportDocumentToHTML(id: String) -> AnyPublisher<String, Error> {
        return doAction(action: "documentExportHtml", data: ["document_id": id])
    }

    // MARK: - Helper Methods

    private func doAction<T: Decodable>(
        action: String,
        data: [String: Any]
    ) -> AnyPublisher<T, Error> {
        guard let url = URL(string: "\(baseURL)/do") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        let jwt = getJWT()
        let payload: [String: Any] = [
            "action": action,
            "jwt": jwt,
            "data": data
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        return session.dataTaskPublisher(for: request)
            .tryMap { data, response -> T in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }

                let apiResponse = try JSONDecoder().decode(APIResponse<T>.self, from: data)

                if apiResponse.errorCode != -1 {
                    throw NSError(
                        domain: "DocumentService",
                        code: apiResponse.errorCode,
                        userInfo: [NSLocalizedDescriptionKey: apiResponse.errorMessage]
                    )
                }

                return apiResponse.data
            }
            .eraseToAnyPublisher()
    }

    private func doActionVoid(action: String, data: [String: Any]) -> AnyPublisher<Void, Error> {
        // Similar to doAction but returns Void
        guard let url = URL(string: "\(baseURL)/do") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        let jwt = getJWT()
        let payload: [String: Any] = [
            "action": action,
            "jwt": jwt,
            "data": data
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        return session.dataTaskPublisher(for: request)
            .tryMap { data, response -> Void in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return ()
            }
            .eraseToAnyPublisher()
    }

    private func doActionData(action: String, data: [String: Any]) -> AnyPublisher<Data, Error> {
        // For binary responses (PDF export)
        guard let url = URL(string: "\(baseURL)/do") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        let jwt = getJWT()
        let payload: [String: Any] = [
            "action": action,
            "jwt": jwt,
            "data": data
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        return session.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .eraseToAnyPublisher()
    }

    private func getJWT() -> String {
        // TODO: Get JWT from KeyChain or UserDefaults
        return UserDefaults.standard.string(forKey: "jwt") ?? ""
    }
}

// API Response structure
struct APIResponse<T: Decodable>: Decodable {
    let errorCode: Int
    let errorMessage: String
    let data: T

    enum CodingKeys: String, CodingKey {
        case errorCode
        case errorMessage
        case data
    }
}
```

---

## Phase 3: SwiftUI Views

### 3.1 DocumentSpaceListView

**File**: `iOS-Client/Sources/Features/Documents/Views/DocumentSpaceListView.swift`

```swift
import SwiftUI

struct DocumentSpaceListView: View {
    @StateObject private var viewModel = DocumentSpaceListViewModel()
    @State private var showingCreateSheet = false

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading spaces...")
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                        viewModel.loadSpaces()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Favorites section
                            if !viewModel.favoriteSpaces.isEmpty {
                                VStack(alignment: .leading) {
                                    SectionHeader(title: "Favorites", icon: "star.fill")
                                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                                        ForEach(viewModel.favoriteSpaces) { space in
                                            SpaceCard(space: space)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }

                            // All spaces section
                            VStack(alignment: .leading) {
                                SectionHeader(title: "All Spaces", icon: "folder.fill")
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                                    ForEach(viewModel.filteredSpaces) { space in
                                        SpaceCard(space: space)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Documents")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingCreateSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .searchable(text: $viewModel.searchQuery)
            .sheet(isPresented: $showingCreateSheet) {
                CreateSpaceView { space in
                    viewModel.createSpace(space)
                }
            }
        }
        .onAppear {
            viewModel.loadSpaces()
        }
    }
}

struct SpaceCard: View {
    let space: DocumentSpace

    var body: some View {
        NavigationLink(destination: DocumentListView(spaceId: space.id)) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: getIcon(for: space.spaceType))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color(hex: space.color ?? "#0066cc"))
                        .cornerRadius(8)

                    Spacer()

                    if space.isFavorite == true {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }

                Text(space.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(space.key)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fontDesign(.monospaced)

                if let description = space.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                HStack {
                    Label("\(space.documentCount)", systemImage: "doc.fill")
                    Spacer()
                    Label("\(space.memberCount)", systemImage: "person.2.fill")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }

    func getIcon(for type: SpaceType) -> String {
        switch type {
        case .personal: return "person.fill"
        case .team: return "person.3.fill"
        case .project: return "folder.fill"
        case .knowledge: return "book.fill"
        case .unknown: return "questionmark"
        }
    }
}
```

---

## Phase 4: ViewModels

### File: `iOS-Client/Sources/Features/Documents/ViewModels/DocumentSpaceListViewModel.swift`

```swift
import Foundation
import Combine

class DocumentSpaceListViewModel: ObservableObject {
    @Published var spaces: [DocumentSpace] = []
    @Published var filteredSpaces: [DocumentSpace] = []
    @Published var favoriteSpaces: [DocumentSpace] = []
    @Published var searchQuery: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let documentService = DocumentService.shared

    init() {
        // Observe search query changes
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.filterSpaces(query: query)
            }
            .store(in: &cancellables)
    }

    func loadSpaces() {
        isLoading = true
        errorMessage = nil

        documentService.getDocumentSpaces()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] spaces in
                    self?.spaces = spaces.filter { $0.isActive() }
                    self?.favoriteSpaces = spaces.filter { $0.isFavorite == true }
                    self?.filterSpaces(query: self?.searchQuery ?? "")
                }
            )
            .store(in: &cancellables)
    }

    func createSpace(_ space: DocumentSpace) {
        // Implementation similar to loadSpaces
    }

    private func filterSpaces(query: String) {
        if query.isEmpty {
            filteredSpaces = spaces
        } else {
            filteredSpaces = spaces.filter { space in
                space.name.localizedCaseInsensitiveContains(query) ||
                space.key.localizedCaseInsensitiveContains(query) ||
                (space.description?.localizedCaseInsensitiveContains(query) ?? false)
            }
        }
    }
}
```

---

## Summary and Next Steps

This guide provides:
✅ Complete Swift models with Codable
✅ DocumentService with Combine publishers
✅ SwiftUI view structure
✅ ViewModel pattern with @Published properties

**Remaining Implementation** (15-20 hours):
1. Complete all 5 SwiftUI views
2. Complete all ViewModels
3. Core Data integration for offline storage
4. Background sync with URLSession background tasks
5. Markdown rendering (use MarkdownUI or Down library)
6. Comprehensive testing

**Libraries to Add**:
```swift
// Package.swift dependencies
.package(url: "https://github.com/gonzalezreal/MarkdownUI", from: "2.0.0"),
.package(url: "https://github.com/iwasrobbed/Down", from: "0.11.0")
```

**Estimated Timeline**:
- Models & Service: 4-5 hours ✅ (provided above)
- ViewModels: 3-4 hours
- SwiftUI Views: 6-8 hours
- Core Data: 3-4 hours
- Background Sync: 2-3 hours
- Testing: 2-3 hours

**Total**: 20-27 hours for complete iOS implementation
