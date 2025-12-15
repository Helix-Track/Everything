# Desktop UI/UX Wireframe Specification

**Version**: 1.0.0
**Date**: 2025-10-18
**Platform**: Desktop (Tauri Application - Windows, macOS, Linux)
**Status**: Ready for DrawIO Implementation

---

## Overview

This document provides complete specifications for the Desktop-specific UI/UX wireframe. Use this as a blueprint to create `Desktop_UI_UX_Flow.drawio`.

---

## Desktop-Specific Design Patterns

### Desktop Components

- **Native Window**: System window controls (minimize, maximize, close)
- **Menu Bar**: Application menu (File, Edit, View, etc.)
- **System Tray**: Background operation with tray icon
- **Multiple Windows**: Support for multiple app windows
- **Native Dialogs**: File picker, system alerts
- **Keyboard Shortcuts**: Full keyboard navigation
- **Notifications**: Native OS notifications
- **Drag & Drop**: File drag and drop from system
- **Context Menus**: Right-click menus

### Window Dimensions
- **Default**: 1280 x 800 px (resizable)
- **Minimum**: 1024 x 600 px
- **Maximum**: Fullscreen
- **Remember**: Last window size and position

---

## Screen Flows

### 1. Application Window

#### 1.1 Main Window (Windows/Linux)
```
┌────────────────────────────────────────────────────────────────┐
│ HelixTrack                                        [―] [□] [×]  │ Window Title Bar
├────────────────────────────────────────────────────────────────┤
│ File  Edit  View  Go  Window  Help                            │ Menu Bar
├────┬───────────────────────────────────────────────────────────┤
│    │ [Top Bar]                                                 │
│    │ HelixTrack  [🔍 Search...]     🔔 ❓ [Theme] [👤 Avatar] │
│Nav ├───────────────────────────────────────────────────────────┤
│☰   │ Home > Dashboard                                          │
│    │ ─────────────────────────────────────────────────────────│
│🏠  │                                                           │
│Home│  Dashboard                                                │
│    │  ══════════                                               │
│📋  │                                                           │
│Proj│  Good morning, John Doe! 👋                               │
│    │                                                           │
│🎯  │  ┌───────────────────┐  ┌────────────────────────┐      │
│My  │  │ My Work Summary   │  │ Activity Stream        │      │
│Tick│  │ • 12 Open         │  │ [Activity Items...]    │      │
│    │  │ • 5 In Progress   │  │                        │      │
│📊  │  │ • 3 Blocked       │  │                        │      │
│Bd  │  │ • 8 To Review     │  │                        │      │
│    │  │ [Chart]           │  │                        │      │
│📅  │  └───────────────────┘  └────────────────────────┘      │
│Spr │                                                           │
│    │  [Recent Tickets Table...]                                │
│👥  │                                                           │
│Team│                                                           │
│    │                                                           │
│📖  │                                                           │
│Docs│                                                           │
│    │                                                           │
│───│                                                           │
│    │                                                           │
│📊  │                                                           │
│Rep │                                                           │
│    │                                                           │
│⚙️  │                                                           │
│Set │                                                           │
├────┴───────────────────────────────────────────────────────────┤
│ Status Bar: Connected to server • Last sync: 2 min ago   [☰] │ Status Bar
└────────────────────────────────────────────────────────────────┘
```

**Windows/Linux Design Elements**:
- Standard window title bar with controls
- Application menu bar
- Resizable window with grip
- Status bar at bottom
- System window decorations

#### 1.2 Main Window (macOS)
```
┌────────────────────────────────────────────────────────────────┐
│ [●][●][●]  HelixTrack                                         │ macOS Title Bar
├────────────────────────────────────────────────────────────────┤
│    │ [Top Bar - Integrated with window]                       │
│Nav │ HelixTrack  [🔍 Search...]     🔔 ❓ [Theme] [👤 Avatar]│
│☰   ├───────────────────────────────────────────────────────────┤
│    │ Home > Dashboard                                          │
│🏠  │ ─────────────────────────────────────────────────────────│
│Home│                                                           │
│    │  Dashboard                                                │
│📋  │  ══════════                                               │
│Proj│                                                           │
│    │  [Dashboard Content...]                                   │
│🎯  │                                                           │
│Tick│                                                           │
│    │                                                           │
│[...]                                                           │
│    │                                                           │
├────┴───────────────────────────────────────────────────────────┤
│ Status Bar: Connected • Last sync: 2 min ago             [☰] │
└────────────────────────────────────────────────────────────────┘
```

**macOS Design Elements**:
- Traffic light buttons (red, yellow, green)
- No menu bar in window (uses system menu bar)
- Toolbar can be customized
- Unified title and toolbar
- Vibrant blur effects (optional)

---

### 2. System Tray Integration

#### 2.1 System Tray Icon & Menu
```
┌──────────────────────────┐
│ [Tray Icon: HelixTrack]  │
│ (Shows badge with count) │
└──────────────────────────┘
         │
         ▼
┌──────────────────────────┐
│ HelixTrack               │
│ ─────────────────────── │
│ ✓ Connected              │
│                          │
│ 3 Unread Notifications   │
│ 5 Tickets Assigned       │
│ ─────────────────────── │
│ Show Dashboard           │
│ Quick Create Ticket      │
│ ─────────────────────── │
│ Settings                 │
│ About                    │
│ Quit HelixTrack          │
└──────────────────────────┘
```

**System Tray Features**:
- Persistent tray icon
- Badge for notifications (Windows/macOS)
- Quick actions menu
- Click to show/hide window
- Right-click for context menu

---

### 3. Native Menus

#### 3.1 Application Menu (File Menu Example)
```
File                     Edit                    View
├─ New                   ├─ Undo        Ctrl+Z   ├─ Sidebar        Ctrl+B
│  ├─ Ticket     Ctrl+N  ├─ Redo        Ctrl+Y   ├─ Fullscreen     F11
│  ├─ Project            ├─ ───────────          ├─ Zoom In         Ctrl++
│  ├─ Sprint             ├─ Cut         Ctrl+X   ├─ Zoom Out        Ctrl+-
│  └─ Document           ├─ Copy        Ctrl+C   ├─ Reset Zoom      Ctrl+0
├─ Open...       Ctrl+O  ├─ Paste       Ctrl+V   ├─ ───────────
├─ ─────────────         ├─ ───────────          ├─ Theme
├─ Save          Ctrl+S  ├─ Find        Ctrl+F   │  ├─ Light
├─ Save As...            ├─ Replace     Ctrl+H   │  ├─ Dark
├─ ─────────────         └─ Preferences Ctrl+,   │  └─ System
├─ Print         Ctrl+P                           └─ Refresh        F5
├─ ─────────────
└─ Exit          Alt+F4
```

**Menu Features**:
- Standard application menus
- Keyboard shortcuts displayed
- Separator lines
- Nested submenus
- Checkmarks for toggles
- Disabled items (grayed out)

---

### 4. Multi-Window Support

#### 4.1 Primary + Secondary Windows
```
┌──────────────────────┐    ┌──────────────────────┐
│ Main Window          │    │ Ticket Detail Window │
│ [Dashboard]          │    │ PROJ-123             │
│                      │    │                      │
│ [Ticket List]        │◀───│ [Full ticket view]   │
│                      │    │                      │
│ Click ticket →       │    │ [Comments]           │
│ Opens in new window  │    │ [Attachments]        │
│                      │    │                      │
└──────────────────────┘    └──────────────────────┘

┌──────────────────────┐
│ Settings Window      │
│ [Preferences]        │
│                      │
│ Always-on-top option │
│ Modal or floating    │
│                      │
└──────────────────────┘
```

**Multi-Window Features**:
- Multiple document interface (MDI)
- Floating windows
- Always-on-top option
- Window management (tile, cascade)
- Remember window positions
- Independent window themes

---

### 5. Native Dialogs

#### 5.1 File Picker (Native OS Dialog)
```
┌────────────────────────────────────────────┐
│ Open File                            [×]   │
├────────────────────────────────────────────┤
│ [◀][▶] [↑] Downloads ▼                   │
│                                            │
│ ┌────────────────────────────────────────┐│
│ │ 📁 Documents                           ││
│ │ 📁 Pictures                            ││
│ │ 📄 report.pdf                          ││
│ │ 📄 document.docx                       ││
│ └────────────────────────────────────────┘│
│                                            │
│ File name: [report.pdf              ]     │
│ File type: [All Files        ▼]           │
│                                            │
│                    [Cancel]     [Open]     │
└────────────────────────────────────────────┘
```

**Native Dialog Features**:
- OS-native file picker
- Recent locations
- Favorites/bookmarks
- Search functionality
- File type filters
- Multi-select support

---

### 6. Keyboard Shortcuts & Commands

#### 6.1 Command Palette
```
┌────────────────────────────────────────────┐
│ [🔍 Type a command...]                     │
├────────────────────────────────────────────┤
│ > create ticket                            │
│                                            │
│ ┌────────────────────────────────────────┐│
│ │ Create New Ticket          Ctrl+N      ││ Selected
│ ├────────────────────────────────────────┤│
│ │ Create New Project                     ││
│ │ Create New Sprint                      ││
│ │ Open Settings             Ctrl+,       ││
│ │ Toggle Sidebar            Ctrl+B       ││
│ │ Search Issues             Ctrl+K       ││
│ └────────────────────────────────────────┘│
└────────────────────────────────────────────┘
```

**Keyboard Shortcut Categories**:

**Global**:
- `Ctrl/Cmd + K`: Command palette / Quick search
- `Ctrl/Cmd + /`: Show keyboard shortcuts
- `Ctrl/Cmd + ,`: Settings
- `Ctrl/Cmd + Q`: Quit application
- `F11`: Fullscreen toggle

**Navigation**:
- `Ctrl/Cmd + B`: Toggle sidebar
- `Ctrl/Cmd + 1-9`: Switch tabs
- `Alt/Opt + ←/→`: Back/Forward
- `Ctrl/Cmd + W`: Close current tab/window

**Actions**:
- `Ctrl/Cmd + N`: New ticket
- `Ctrl/Cmd + S`: Save
- `Ctrl/Cmd + P`: Print
- `Ctrl/Cmd + F`: Find in page
- `Ctrl/Cmd + R`: Refresh

**Editing**:
- `Ctrl/Cmd + Z`: Undo
- `Ctrl/Cmd + Y`: Redo
- `Ctrl/Cmd + X/C/V`: Cut/Copy/Paste
- `Ctrl/Cmd + A`: Select all

---

### 7. Desktop-Specific Features

#### 7.1 Drag & Drop from System
```
┌────────────────────────────────────────────┐
│ Create Ticket                              │
├────────────────────────────────────────────┤
│ Title: [Bug in login                    ] │
│                                            │
│ Description:                               │
│ [Text area...]                             │
│                                            │
│ Attachments:                               │
│ ┌────────────────────────────────────────┐│
│ │ Drag files here or click to browse    ││
│ │                                        ││
│ │ ◀──── [Dragging file.png from system] ││ Drag & Drop
│ │                                        ││
│ └────────────────────────────────────────┘│
│                                            │
│ Attached: file.png (2.3 MB) [×]           │
│                                            │
│              [Cancel]        [Create]      │
└────────────────────────────────────────────┘
```

**Drag & Drop Features**:
- Drag files from file explorer
- Drag images from browser
- Drag text between windows
- Visual drop zones
- Progress indication for uploads

#### 7.2 Native Notifications
```
┌─────────────────────────────────┐
│ HelixTrack              [×]     │ Windows Notification
├─────────────────────────────────┤
│ New Ticket Assigned             │
│ PROJ-123: Bug in login          │
│ Assigned to you by Jane Smith   │
│                                 │
│ [View] [Dismiss]                │
└─────────────────────────────────┘

╔═══════════════════════════════╗
║ [Icon] HelixTrack             ║ macOS Notification
╠═══════════════════════════════╣
║ New Ticket Assigned           ║
║ PROJ-123: Bug in login        ║
║ Assigned to you by Jane Smith ║
╚═══════════════════════════════╝
```

**Notification Features**:
- Native OS notifications
- Action buttons
- Sound alerts
- Badge on dock/taskbar icon
- Do Not Disturb respect

---

### 8. Platform-Specific Differences

#### 8.1 Windows
- **Title Bar**: Standard with icon, title, min/max/close
- **Menu Bar**: In window
- **Taskbar**: Shows in taskbar with badge
- **System Tray**: Tray icon in notification area
- **Shortcuts**: Ctrl-based
- **Snap**: Windows snap assistance

#### 8.2 macOS
- **Title Bar**: Traffic lights (●●●)
- **Menu Bar**: System menu bar (top of screen)
- **Dock**: Shows in dock with badge
- **Toolbar**: Can be customized
- **Shortcuts**: Cmd-based
- **Gestures**: Trackpad gestures support

#### 8.3 Linux
- **Title Bar**: Varies by DE (GNOME, KDE, etc.)
- **Menu Bar**: Usually in window
- **Panel**: Shows in system panel
- **System Tray**: Varies by DE
- **Shortcuts**: Ctrl-based
- **Theming**: Respects system theme

---

### 9. Offline Capabilities

#### 9.1 Offline Mode Indicator
```
┌────────────────────────────────────────────┐
│ HelixTrack                      [―][□][×] │
├────────────────────────────────────────────┤
│ ⚠️  You are offline. Working in local mode │ Warning Banner
├────────────────────────────────────────────┤
│ [Dashboard - showing cached data]          │
│                                            │
│ Last synced: 5 minutes ago                 │
│ [Sync Now] button (disabled when offline) │
│                                            │
│ 📝 Local changes will sync when online (3) │
└────────────────────────────────────────────┘
```

**Offline Features**:
- Local SQLite database with SQL Cipher
- Automatic background sync
- Conflict resolution
- Queue local changes
- Visual indicators for offline state
- Manual sync trigger

---

### 10. Auto-Update System

```
┌────────────────────────────────────────────┐
│ Update Available                    [×]    │
├────────────────────────────────────────────┤
│ HelixTrack v2.0.0 is available            │
│ Current version: 1.5.0                     │
│                                            │
│ What's new:                                │
│ • Dark mode improvements                   │
│ • Performance enhancements                 │
│ • Bug fixes                                │
│                                            │
│ Release notes: [View full changelog]      │
│                                            │
│ [Download: 45 MB] ▓▓▓▓▓▓▓▓▓▓░░░░ 75%     │
│                                            │
│ Install on restart     [Later] [Install]   │
└────────────────────────────────────────────┘
```

**Auto-Update Features**:
- Background update checks
- Download progress
- Install on restart
- Rollback capability
- Release notes display

---

## Color Application (Same as Web)

### Light Theme
- **Primary**: #BCE63B
- **Secondary**: #7AA590
- **Background**: #FFFFFF
- **Surface**: #F8F9FA
- **Border**: #DEE2E6
- **Text**: #1A1A1A

### Dark Theme
- **Primary**: #BCE63B
- **Secondary**: #7AA590
- **Background**: #0D0D0D
- **Surface**: #1A1A1A
- **Border**: rgba(255,255,255,0.1)
- **Text**: #FFFFFF

---

## Implementation Notes

1. **Tauri 2.0+** for desktop runtime
2. **Angular 19+** for frontend (same as Web)
3. **SQLite with SQL Cipher** for local encrypted storage
4. **Native OS integration** via Tauri APIs
5. **Auto-update** via Tauri updater
6. **System tray** for background operation
7. **Native menus** for platform consistency
8. **Multi-window** support
9. **Keyboard shortcuts** for power users
10. **Offline-first** with sync

### Distribution Formats
- **Windows**: MSI installer, portable EXE
- **macOS**: DMG, app bundle
- **Linux**: AppImage, DEB, RPM

---

## Next Steps

1. Open DrawIO desktop or online editor
2. Create a new diagram named `Desktop_UI_UX_Flow.drawio`
3. Create pages for each section
4. Include platform-specific variations (Windows, macOS, Linux)
5. Use this specification to create the wireframes
6. Export to PNG using the export instructions in the main README

---

**Document Version**: 1.0.0
**Last Updated**: 2025-10-18
**Maintained By**: HelixTrack UI/UX Team
