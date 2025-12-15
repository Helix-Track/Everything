# iOS UI/UX Wireframe Specification

**Version**: 1.0.0
**Date**: 2025-10-18
**Platform**: iOS (Human Interface Guidelines)
**Status**: Ready for DrawIO Implementation

---

## Overview

This document provides complete specifications for the iOS-specific UI/UX wireframe. Use this as a blueprint to create `iOS_UI_UX_Flow.drawio`.

---

## iOS-Specific Design Patterns

### iOS Components

- **Navigation**: Tab Bar (bottom, 5 items max)
- **Nav Bar**: Navigation Bar with large titles
- **Toolbar**: Bottom toolbar for contextual actions
- **Sheets**: Modal sheets for forms and secondary content
- **Alerts**: iOS-style alerts and action sheets
- **Lists**: iOS-style lists with separators
- **SF Symbols**: iOS system icons
- **Home Indicator**: Bottom home indicator bar
- **Status Bar**: iOS status bar (time, battery, network)

### Screen Dimensions
- **iPhone**: 390 x 844 pt (iPhone 14/15)
- **iPhone Pro**: 393 x 852 pt (iPhone 14/15 Pro)
- **iPad**: 820 x 1180 pt (iPad Pro 11")

---

## Screen Flows

### 1. Authentication Flow

#### 1.1 Login Screen
```
┌─────────────────────────────────────────────┐
│ [Status Bar: 9:41, WiFi, Battery]          │
│                                             │
│                                             │
│      [HelixTrack Logo]                      │
│      (Lime Green #BCE63B)                   │
│                                             │
│   Welcome to HelixTrack                     │
│   (Large Title, SF Pro Display)             │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ 📧  Email                           │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ 🔒  Password                        │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   Remember me     [Toggle]                  │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │          Log In                     │  │
│   │    (iOS Button, primary color)      │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   Forgot Password? | Register               │
│   (Text Links, primary color)               │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ Backend Server                      │  │
│   │ https://localhost:8080        ⓘ    │  │
│   └─────────────────────────────────────┘  │
│                                             │
│                                             │
│ [Home Indicator ▬]                          │
└─────────────────────────────────────────────┘
```

**iOS Design Elements**:
- Large, centered logo
- Grouped list style for input fields
- iOS rounded text fields
- iOS toggle switch
- Rounded button with fill
- SF Symbols for icons
- Home indicator at bottom

**Interactions**:
- Tap Log In → Dashboard (with slide animation)
- Tap Forgot Password → Password Reset Sheet
- Tap Register → Registration Screen (push navigation)
- Tap ⓘ → Backend URL Config Sheet

#### 1.2 Registration Screen
```
┌─────────────────────────────────────────────┐
│ [Status Bar]                                │
│ ┌─────────────────────────────────────────┐│
│ │ < Back          Register       Cancel   ││
│ └─────────────────────────────────────────┘│
│                                             │
│   Create Account                            │
│   (Large Title)                             │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ 👤  Full Name                       │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ 📧  Email                           │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ 👤  Username                        │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ 🔒  Password                        │  │
│   │    [Strength: Strong ✓]             │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ 🔒  Confirm Password                │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   ☐ I agree to Terms & Conditions           │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │          Register                   │  │
│   └─────────────────────────────────────┘  │
│                                             │
│ [Home Indicator]                            │
└─────────────────────────────────────────────┘
```

**iOS Design Elements**:
- Navigation bar with back button and Cancel
- Large title "Create Account"
- Inline validation feedback
- iOS checkbox style
- Scrollable content

---

### 2. Main Navigation

#### 2.1 Dashboard with Tab Bar
```
┌─────────────────────────────────────────────┐
│ [Status Bar]                                │
│ ┌─────────────────────────────────────────┐│
│ │ Dashboard                    🔍 🔔 [👤] ││
│ │ (Large Title, bold)                     ││
│ └─────────────────────────────────────────┘│
│                                             │
│   Good morning, John! 👋                    │
│   (Subtitle, SF Pro)                        │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ My Work Summary                     │  │
│   │                                     │  │
│   │  12 Open     •    5 In Progress     │  │
│   │   3 Blocked  •    8 To Review       │  │
│   │                                     │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   Recent Activity                           │
│   (Section Header)                          │
│   ┌─────────────────────────────────────┐  │
│   │ [Ticket Card - iOS style]           │  │
│   └─────────────────────────────────────┘  │
│   ┌─────────────────────────────────────┐  │
│   │ [Ticket Card - iOS style]           │  │
│   └─────────────────────────────────────┘  │
│   ┌─────────────────────────────────────┐  │
│   │ [Ticket Card - iOS style]           │  │
│   └─────────────────────────────────────┘  │
│                                             │
├─────────────────────────────────────────────┤
│ [Tab Bar]                                   │
│  🏠         📋        📊         ⚙️         │
│ Home    Projects   Reports   Settings      │
│ (Selected: Home - primary color)            │
│                                             │
│ [Home Indicator]                            │
└─────────────────────────────────────────────┘
```

**iOS Design Elements**:
- Large title that collapses on scroll
- Tab bar at bottom (max 5 tabs)
- SF Symbols for icons
- Cards with iOS-style shadows
- Section headers
- No floating buttons (use toolbar or nav bar actions)

**Navigation Patterns**:
- Swipe right to go back
- Pull down to refresh
- Swipe between tabs (optional)

#### 2.2 Navigation with Sidebar (iPad)
```
┌──────────┬──────────────────────────────────┐
│          │ [Navigation Bar]                 │
│  Sidebar │ Dashboard           🔍 🔔 [👤]  │
│          │                                  │
│ 🏠 Home  │                                  │
│ 📋 Proj  │  [Dashboard Content]             │
│ 🎯 Tick  │                                  │
│ 📊 Board │                                  │
│ 📅 Spri  │                                  │
│ 👥 Teams │                                  │
│ 📖 Docs  │                                  │
│          │                                  │
│ ─────── │                                  │
│ ⚙️ Sett  │                                  │
│          │                                  │
└──────────┴──────────────────────────────────┘
```

**iPad-Specific**:
- Split view with sidebar
- Compact sidebar option
- Multi-column layouts
- Slide over and split view support

---

### 3. Projects Screen

#### 3.1 Project List
```
┌─────────────────────────────────────────────┐
│ [Status Bar]                                │
│ ┌─────────────────────────────────────────┐│
│ │ < Back   Projects              + [Grid]││
│ │ (Large Title)                           ││
│ └─────────────────────────────────────────┘│
│                                             │
│   [Search Bar]                              │
│   🔍 Search projects                        │
│                                             │
│   Active Projects                           │
│   ─────────────────────────────────────────│
│   ┌─────────────────────────────────────┐  │
│   │ PROJ-KEY                      >     │  │
│   │ Project Name                        │  │
│   │ 45 tickets • Lead: John Doe         │  │
│   └─────────────────────────────────────┘  │
│   ┌─────────────────────────────────────┐  │
│   │ PROJ-KEY                      >     │  │
│   │ Project Name                        │  │
│   │ 23 tickets • Lead: Jane Smith       │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   Archived Projects                         │
│   ─────────────────────────────────────────│
│   ┌─────────────────────────────────────┐  │
│   │ OLD-KEY                       >     │  │
│   │ Old Project                         │  │
│   └─────────────────────────────────────┘  │
│                                             │
├─────────────────────────────────────────────┤
│ [Tab Bar: Projects selected]                │
│ [Home Indicator]                            │
└─────────────────────────────────────────────┘
```

**iOS Design Elements**:
- List style with separators
- Chevron indicators (>)
- Section headers
- Swipe actions (swipe left to archive, right to favorite)
- Search bar below nav bar
- + button in nav bar for new project

#### 3.2 Project Detail
```
┌─────────────────────────────────────────────┐
│ [Status Bar]                                │
│ ┌─────────────────────────────────────────┐│
│ │ < Projects  PROJ-KEY           ⋯       ││
│ └─────────────────────────────────────────┘│
│                                             │
│   Project Name                              │
│   (Large Title)                             │
│                                             │
│   Lead: John Doe  •  Team: 5 members        │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ [Segmented Control]                 │  │
│   │ Board | Issues | People | Settings  │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   [Tab Content - Swipeable]                 │
│                                             │
│   Statistics                                │
│   ─────────────────────────────────────────│
│   ┌─────────────────────────────────────┐  │
│   │ Total: 45    Open: 12    Done: 18   │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   Recent Activity                           │
│   ─────────────────────────────────────────│
│   [Activity Items...]                       │
│                                             │
├─────────────────────────────────────────────┤
│ [Tab Bar]                                   │
│ [Home Indicator]                            │
└─────────────────────────────────────────────┘
```

**iOS Design Elements**:
- Segmented control for tabs
- Swipeable between segments
- Grouped statistics cards
- List-style activity feed
- Menu button (⋯) for actions

---

### 4. Tickets/Issues Screen

#### 4.1 Ticket List (iOS Style)
```
┌─────────────────────────────────────────────┐
│ [Status Bar]                                │
│ ┌─────────────────────────────────────────┐│
│ │ Issues                      🔍 [Filter] ││
│ │ (Large Title)                           ││
│ └─────────────────────────────────────────┘│
│                                             │
│   [Search Bar]                              │
│   🔍 Search issues                          │
│                                             │
│   My Issues                                 │
│   ─────────────────────────────────────────│
│   ┌─────────────────────────────────────┐  │
│   │ 🐛 PROJ-123              🔴        >│  │
│   │ Bug in login authentication         │  │
│   │ ─────────────────────────────────  │  │
│   │ [👤] Open • Sprint 5 • ⚡8          │  │
│   └─────────────────────────────────────┘  │
│   ┌─────────────────────────────────────┐  │
│   │ ✨ PROJ-124              🟡        >│  │
│   │ Add dark mode support               │  │
│   │ ─────────────────────────────────  │  │
│   │ [👤] In Progress • Sprint 5 • ⚡5   │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   All Issues                                │
│   ─────────────────────────────────────────│
│   [More ticket items...]                    │
│                                             │
├─────────────────────────────────────────────┤
│ [Tab Bar]                                   │
│ [Home Indicator]                            │
└─────────────────────────────────────────────┘
```

**iOS Design Elements**:
- Sectioned list (My Issues, All Issues)
- Swipe actions:
  - Swipe right: Assign to me
  - Swipe left: Change status, Delete
- Context menu on long press
- Pull to refresh
- Chevron for navigation

**Ticket Card Components**:
- Type icon (SF Symbol)
- Ticket ID (monospace, SF Mono)
- Priority indicator (colored circle)
- Title
- Metadata row: Assignee, Status, Sprint, Points

#### 4.2 Ticket Detail
```
┌─────────────────────────────────────────────┐
│ [Status Bar]                                │
│ ┌─────────────────────────────────────────┐│
│ │ < Back   PROJ-123               ⋯ ⭐   ││
│ └─────────────────────────────────────────┘│
│                                             │
│   🐛 PROJ-123                               │
│   Bug in login authentication               │
│   🔴 Critical                               │
│                                             │
│   Details                                   │
│   ─────────────────────────────────────────│
│   Status          Open                    >│
│   Assignee        John Doe                >│
│   Reporter        Jane Smith               │
│   Sprint          Sprint 5                >│
│   Story Points    8                       >│
│   Priority        Critical                >│
│                                             │
│   Description                               │
│   ─────────────────────────────────────────│
│   ┌─────────────────────────────────────┐  │
│   │ Users cannot log in when using     │  │
│   │ special characters in password...  │  │
│   │                                     │  │
│   │ [Read more...]                      │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ [Segmented Control]                 │  │
│   │ Comments | Attachments | Activity   │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   [Tab Content]                             │
│                                             │
├─────────────────────────────────────────────┤
│ [Toolbar: Add Comment | Attach | Share]    │
│ [Home Indicator]                            │
└─────────────────────────────────────────────┘
```

**iOS Design Elements**:
- Grouped list for details
- Tap to edit with sheets/pickers
- Segmented control for sections
- Bottom toolbar for actions
- Context menu on ⋯ button

---

### 5. Board Views (JIRA-Style)

#### 5.1 Kanban Board
```
┌─────────────────────────────────────────────┐
│ [Status Bar]                                │
│ ┌─────────────────────────────────────────┐│
│ │ < Back   Board: Sprint 5        [Filter]││
│ └─────────────────────────────────────────┘│
│                                             │
│   [Horizontal Scroll - Columns]             │
│                                             │
│ ┌───────┐ ┌───────┐ ┌───────┐ ┌───────┐  │
│ │ TODO  │ │  IN   │ │ TEST  │ │ DONE  │  │
│ │  (3)  │ │ PROG  │ │  (2)  │ │  (8)  │  │
│ ├───────┤ │  (5)  │ ├───────┤ ├───────┤  │
│ │[Card] │ ├───────┤ │[Card] │ │[Card] │  │
│ │       │ │[Card] │ │       │ │       │  │
│ │[Card] │ │       │ │[Card] │ │[Card] │  │
│ │       │ │[Card] │ │       │ │       │  │
│ │[Card] │ │       │ │       │ │[Card] │  │
│ │       │ │[Card] │ │       │ │       │  │
│ │       │ │       │ │       │ │[Card] │  │
│ │       │ │[Card] │ │       │ │       │  │
│ └───────┘ └───────┘ └───────┘ └───────┘  │
│                                             │
├─────────────────────────────────────────────┤
│ [Toolbar: My Issues | High Priority | +]   │
│ [Home Indicator]                            │
└─────────────────────────────────────────────┘
```

**iOS Design Elements**:
- Horizontal scroll view for columns
- Drag and drop with haptic feedback
- Column headers with counts
- iOS-style cards with shadows
- Bottom toolbar for filters and quick add
- Pull to refresh

**Drag & Drop**:
- Long press to lift card
- Visual elevation during drag
- Drop zones with spring animation
- Haptic feedback on drop

---

### 6. Settings Screen

#### 6.1 Settings (iOS Style)
```
┌─────────────────────────────────────────────┐
│ [Status Bar]                                │
│ ┌─────────────────────────────────────────┐│
│ │ < Back        Settings                  ││
│ │ (Large Title)                           ││
│ └─────────────────────────────────────────┘│
│                                             │
│   Appearance                                │
│   ─────────────────────────────────────────│
│   Theme               Light            >   │
│   Language            English          >   │
│                                             │
│   Notifications                             │
│   ─────────────────────────────────────────│
│   Push Notifications         [Toggle ✓]    │
│   Email Notifications        [Toggle ✓]    │
│   Desktop Notifications      [Toggle  ]    │
│   Sounds                     [Toggle ✓]    │
│                                             │
│   Account                                   │
│   ─────────────────────────────────────────│
│   Profile                              >   │
│   Change Password                      >   │
│   Backend Server                       >   │
│                                             │
│   About                                     │
│   ─────────────────────────────────────────│
│   Version                    1.0.0         │
│   Privacy Policy                       >   │
│   Terms of Service                     >   │
│                                             │
├─────────────────────────────────────────────┤
│ [Tab Bar: Settings selected]                │
│ [Home Indicator]                            │
└─────────────────────────────────────────────┘
```

**iOS Design Elements**:
- Grouped list style
- Section headers
- iOS toggle switches
- Chevron indicators for navigation
- Detail text aligned right

**Theme Selection Sheet**:
```
┌─────────────────────────────────────────────┐
│                                             │
│   ═══                                       │
│                                             │
│   Select Theme                              │
│                                             │
│   ○  Light                                  │
│   ●  System (Automatic)                     │
│   ○  Dark                                   │
│                                             │
│   [Done]                                    │
│                                             │
└─────────────────────────────────────────────┘
```

---

## iOS-Specific Features

### Gestures
- **Swipe Right**: Go back (edge swipe)
- **Swipe Actions**: Context actions on list items
- **Pull Down**: Refresh
- **Long Press**: Context menu / lift for drag
- **3D Touch**: Peek and pop (older devices)
- **Haptic**: Feedback on important actions

### System Integration
- **Widgets**: Home screen and Lock screen widgets
- **Shortcuts**: Siri shortcuts for quick actions
- **Share Sheet**: iOS share integration
- **Spotlight**: App content searchable
- **Handoff**: Continue on other devices
- **Face ID / Touch ID**: Biometric authentication

### Accessibility
- **VoiceOver**: Full screen reader support
- **Dynamic Type**: Respect system font sizes
- **Reduce Motion**: Respect animation preferences
- **High Contrast**: Support high contrast mode
- **Voice Control**: Full voice navigation

---

## Color Application

### Light Mode
- **Primary**: #BCE63B (Tint color, buttons, selected states)
- **Secondary**: #7AA590 (Secondary actions)
- **Background**: #FFFFFF (System background)
- **Grouped Background**: #F2F2F7 (iOS grouped background)
- **Label**: #000000 (Primary text)
- **Secondary Label**: #3C3C43 (60% opacity)

### Dark Mode
- **Primary**: #BCE63B (Same as light)
- **Secondary**: #7AA590 (Same as light)
- **Background**: #000000 (System background)
- **Grouped Background**: #1C1C1E (iOS grouped background dark)
- **Label**: #FFFFFF (Primary text)
- **Secondary Label**: #EBEBF5 (60% opacity)

---

## Typography

### SF Pro Font Family
- **Large Title**: 34pt, Bold
- **Title 1**: 28pt, Regular
- **Title 2**: 22pt, Regular
- **Title 3**: 20pt, Regular
- **Headline**: 17pt, Semibold
- **Body**: 17pt, Regular
- **Callout**: 16pt, Regular
- **Subhead**: 15pt, Regular
- **Footnote**: 13pt, Regular
- **Caption 1**: 12pt, Regular
- **Caption 2**: 11pt, Regular

### SF Mono (Monospace)
- Use for ticket IDs, code, technical data
- Same size scale as SF Pro

---

## Implementation Notes

1. **Use SwiftUI** for modern iOS development
2. **Tab Bar** for primary navigation (max 5 tabs)
3. **Navigation Bar** with large titles that collapse
4. **Bottom sheets** for modal content
5. **Grouped lists** for settings and forms
6. **SF Symbols** for all icons
7. **iOS animations**: Spring animations, page transitions
8. **Safe Area**: Respect safe area insets
9. **Dark Mode**: Full dark mode support
10. **iPad**: Support split view, slide over, and pointer

---

## Next Steps

1. Open DrawIO desktop or online editor
2. Create a new diagram named `iOS_UI_UX_Flow.drawio`
3. Create pages for each section (Authentication, Navigation, Projects, etc.)
4. Use this specification to create the wireframes
5. Export to PNG using the export instructions in the main README

---

**Document Version**: 1.0.0
**Last Updated**: 2025-10-18
**Maintained By**: HelixTrack UI/UX Team
