# Android UI/UX Wireframe Specification

**Version**: 1.0.0
**Date**: 2025-10-18
**Platform**: Android (Material Design 3)
**Status**: Ready for DrawIO Implementation

---

## Overview

This document provides complete specifications for the Android-specific UI/UX wireframe. Use this as a blueprint to create `Android_UI_UX_Flow.drawio`.

---

## Android-Specific Design Patterns

### Material Design 3 Components

- **Navigation**: Bottom Navigation Bar (3-5 items)
- **App Bar**: Top App Bar with elevation and actions
- **FAB**: Floating Action Button for primary actions
- **Cards**: Material Cards with elevation and ripple effects
- **Dialogs**: Material Dialogs with elevation
- **Snackbar**: Bottom snackbar for notifications
- **Navigation Drawer**: Side drawer for secondary navigation
- **Status Bar**: Android status bar (battery, time, notifications)
- **Navigation Bar**: Android navigation bar (back, home, recents)

### Screen Dimensions
- **Phone Portrait**: 360 x 800 dp (standard)
- **Tablet Portrait**: 600 x 960 dp
- **Phone Landscape**: 800 x 360 dp

---

## Screen Flows

### 1. Authentication Flow

#### 1.1 Login Screen
```
┌─────────────────────────────────────────────┐
│ [Status Bar: 9:41 AM, WiFi, Battery]       │
├─────────────────────────────────────────────┤
│ [Top App Bar]                               │
│   HelixTrack Login                          │
├─────────────────────────────────────────────┤
│                                             │
│      [HelixTrack Logo]                      │
│      (Lime Green #BCE63B)                   │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ 📧 Email                            │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ 🔒 Password                         │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   [Remember me ☐]                          │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │     LOGIN (Material Button)         │  │
│   │     (Primary color background)      │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   Forgot Password? | Register              │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ Backend Server URL                  │  │
│   │ https://localhost:8080 [⚙️]         │  │
│   └─────────────────────────────────────┘  │
│                                             │
├─────────────────────────────────────────────┤
│ [Navigation Bar: ◀ ⚫ ▢]                    │
└─────────────────────────────────────────────┘
```

**Material Design Elements**:
- Outlined TextFields with Material styling
- Ripple effect on button press
- Status bar color matches primary color
- Elevation on card containing login form

**Interactions**:
- Tap LOGIN → Dashboard (if authenticated)
- Tap Forgot Password → Password Reset Flow
- Tap Register → Registration Screen
- Tap ⚙️ → Backend URL Configuration Dialog

#### 1.2 Registration Screen
```
┌─────────────────────────────────────────────┐
│ [Status Bar]                                │
├─────────────────────────────────────────────┤
│ [Top App Bar]                               │
│   ◀ Register New Account                    │
├─────────────────────────────────────────────┤
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ 👤 Full Name                        │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ 📧 Email                            │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ 👤 Username                         │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ 🔒 Password                         │  │
│   │    [Password strength meter]        │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ 🔒 Confirm Password                 │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   ☐ I agree to Terms & Conditions          │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │     REGISTER (Material Button)      │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   Already have an account? Login           │
│                                             │
├─────────────────────────────────────────────┤
│ [Navigation Bar]                            │
└─────────────────────────────────────────────┘
```

**Material Design Elements**:
- Top App Bar with back arrow
- Scrollable content if screen is small
- Linear password strength indicator
- Material checkbox for terms

---

### 2. Main Navigation

#### 2.1 Dashboard with Bottom Navigation
```
┌─────────────────────────────────────────────┐
│ [Status Bar]                                │
├─────────────────────────────────────────────┤
│ [Top App Bar]                               │
│   ☰ Dashboard              🔍 🔔 [Avatar]  │
├─────────────────────────────────────────────┤
│                                             │
│   Good morning, John! 👋                    │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ My Work Summary                     │  │
│   │ ───────────────────────────────────│  │
│   │ • 12 Open Tickets                   │  │
│   │ • 5 In Progress                     │  │
│   │ • 3 Blocked                         │  │
│   │ • 8 To Review                       │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ Recent Activity                     │  │
│   │ ───────────────────────────────────│  │
│   │ [Ticket Card - JIRA style]          │  │
│   │ [Ticket Card - JIRA style]          │  │
│   │ [Ticket Card - JIRA style]          │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   [Floating Action Button +]               │
│                                             │
├─────────────────────────────────────────────┤
│ [Bottom Navigation Bar]                     │
│  🏠         📋        📊         ⚙️         │
│ Home    Projects   Reports   Settings      │
│ (Selected: Home - Primary color)            │
└─────────────────────────────────────────────┘
```

**Material Design Elements**:
- Bottom Navigation Bar (5 items max)
- FAB positioned at bottom-right
- Cards with elevation and rounded corners
- Icon + Label in bottom nav
- Active item highlighted with primary color

**FAB Actions**:
- Quick create: Ticket, Project, Sprint
- Material Speed Dial on long press

#### 2.2 Navigation Drawer
```
┌──────────────────┐┌──────────────────────────┐
│                  ││ [Top App Bar]            │
│ [Avatar]         ││   Dashboard       🔍 🔔  │
│ John Doe         ││                          │
│ john@helix.com   ││                          │
│                  ││                          │
│ ────────────────││                          │
│                  ││                          │
│ 🏠 Dashboard     ││   [Dashboard Content]    │
│ 📋 Projects ▸    ││                          │
│ 🎯 My Tickets    ││                          │
│ 📊 Boards        ││                          │
│ 📅 Sprints       ││                          │
│ 👥 Teams         ││                          │
│ 📖 Documents     ││                          │
│                  ││                          │
│ ────────────────││                          │
│                  ││                          │
│ ⚙️ Settings      ││                          │
│ ❓ Help          ││                          │
│ 🚪 Logout        ││                          │
│                  ││                          │
└──────────────────┘└──────────────────────────┘
```

**Material Design Elements**:
- Standard drawer width (256dp)
- Header with user info and avatar
- Ripple effect on items
- Dividers between sections
- Icons aligned at 16dp from left

---

### 3. Projects Screen

#### 3.1 Project List (Grid View)
```
┌─────────────────────────────────────────────┐
│ [Status Bar]                                │
├─────────────────────────────────────────────┤
│ [Top App Bar]                               │
│   ☰ Projects              🔍 [Grid/List] ⋮ │
├─────────────────────────────────────────────┤
│                                             │
│   [Chip: All] [Chip: Active] [Chip: ...]  │
│                                             │
│   ┌──────────────┐  ┌──────────────┐       │
│   │ [Project 1]  │  │ [Project 2]  │       │
│   │              │  │              │       │
│   │ PROJ-KEY     │  │ PROJ-KEY     │       │
│   │ Project Name │  │ Project Name │       │
│   │              │  │              │       │
│   │ 45 Tickets   │  │ 23 Tickets   │       │
│   │ [Progress]   │  │ [Progress]   │       │
│   └──────────────┘  └──────────────┘       │
│                                             │
│   ┌──────────────┐  ┌──────────────┐       │
│   │ [Project 3]  │  │ [Project 4]  │       │
│   │              │  │              │       │
│   │ ...          │  │ ...          │       │
│   └──────────────┘  └──────────────┘       │
│                                             │
│                    [FAB +]                  │
│                                             │
├─────────────────────────────────────────────┤
│ [Bottom Navigation: Projects selected]      │
└─────────────────────────────────────────────┘
```

**Material Design Elements**:
- Filter Chips at top
- Grid layout (2 columns on phone, 4 on tablet)
- Material Cards with elevation
- Progress indicators (LinearProgressIndicator)
- FAB for creating new project

#### 3.2 Project Detail
```
┌─────────────────────────────────────────────┐
│ [Status Bar]                                │
├─────────────────────────────────────────────┤
│ [Top App Bar]                               │
│   ◀ PROJ-KEY                    ⭐ 📎 ⋮    │
├─────────────────────────────────────────────┤
│ [Hero Image/Color Banner - Primary Color]  │
│                                             │
│   Project Name                              │
│   Lead: John Doe                            │
│                                             │
├─────────────────────────────────────────────┤
│                                             │
│   [Tab Bar: Material]                       │
│   ┌─────┬──────┬──────┬────────┐           │
│   │Board│Issues│People│Settings│           │
│   └─────┴──────┴──────┴────────┘           │
│                                             │
│   [Tab Content - Swipeable]                 │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ Project Statistics                  │  │
│   │ • Total Tickets: 45                 │  │
│   │ • Open: 12                          │  │
│   │ • In Progress: 15                   │  │
│   │ • Done: 18                          │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   [Recent Activity Feed]                    │
│                                             │
├─────────────────────────────────────────────┤
│ [Bottom Navigation]                         │
└─────────────────────────────────────────────┘
```

**Material Design Elements**:
- Collapsing toolbar with parallax effect
- Material Tabs (scrollable if >3 tabs)
- Swipeable tab content
- Sticky tabs on scroll

---

### 4. Tickets/Issues Screen

#### 4.1 Ticket List with JIRA-Style Cards
```
┌─────────────────────────────────────────────┐
│ [Status Bar]                                │
├─────────────────────────────────────────────┤
│ [Top App Bar]                               │
│   ☰ Issues              🔍 [Filter] [Sort]│
├─────────────────────────────────────────────┤
│                                             │
│   [Active Filter Chips]                     │
│   [Assignee: Me ×] [Status: Open ×]        │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ 🐛 PROJ-123       🔴 Critical       │  │
│   │ ─────────────────────────────────  │  │
│   │ Bug in login authentication         │  │
│   │                                     │  │
│   │ [👤 John] [Open] [Sprint 5]        │  │
│   │ ⚡8  💬 5  📎 2  👁 3               │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ ✨ PROJ-124       🟡 Medium         │  │
│   │ ─────────────────────────────────  │  │
│   │ Add dark mode support               │  │
│   │                                     │  │
│   │ [👤 Jane] [In Progress] [Sprint 5] │  │
│   │ ⚡5  💬 12  📎 0  👁 5              │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   [More ticket cards...]                    │
│                                             │
│                    [FAB +]                  │
│                                             │
├─────────────────────────────────────────────┤
│ [Bottom Navigation]                         │
└─────────────────────────────────────────────┘
```

**Material Design Elements**:
- Material Cards with rounded corners
- Ripple effect on tap
- Swipe actions (swipe right to assign, left to change status)
- Pull to refresh
- Infinite scroll with pagination

**Ticket Card Components**:
- Type icon (🐛 bug, ✨ feature, ✓ task, 📖 epic)
- Ticket ID (monospace font)
- Priority badge (color-coded)
- Title (bold)
- Assignee avatar
- Status chip
- Sprint chip
- Metrics: Story points, Comments, Attachments, Watchers

#### 4.2 Ticket Detail
```
┌─────────────────────────────────────────────┐
│ [Status Bar]                                │
├─────────────────────────────────────────────┤
│ [Top App Bar]                               │
│   ◀ PROJ-123                    ⭐ ⋮       │
├─────────────────────────────────────────────┤
│                                             │
│   🐛 PROJ-123                               │
│   Bug in login authentication               │
│   🔴 Critical                               │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ Details                             │  │
│   │ ───────────────────────────────────│  │
│   │ Status:     [Open ▼]                │  │
│   │ Assignee:   [John Doe ▼]            │  │
│   │ Reporter:   Jane Smith              │  │
│   │ Sprint:     [Sprint 5 ▼]            │  │
│   │ Story Pts:  [8 ▼]                   │  │
│   │ Priority:   [Critical ▼]            │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ Description                         │  │
│   │ ───────────────────────────────────│  │
│   │ Users cannot log in when using     │  │
│   │ special characters in password...  │  │
│   └─────────────────────────────────────┘  │
│                                             │
│   [Tab Bar: Comments | Attachments | ...] │
│                                             │
│   [Comments Section with Material Cards]    │
│                                             │
│   ┌─────────────────────────────────────┐  │
│   │ 💬 Add Comment                      │  │
│   └─────────────────────────────────────┘  │
│                                             │
│                [FAB: Quick Actions]         │
│                                             │
├─────────────────────────────────────────────┤
│ [Bottom Navigation]                         │
└─────────────────────────────────────────────┘
```

**Material Design Elements**:
- Collapsing toolbar with ticket info
- Material dropdown menus for editable fields
- Tab layout for sections
- Expandable sections (Material Expansion Panels)
- FAB speed dial for quick actions (Edit, Assign, Move, etc.)

---

### 5. Board Views (JIRA-Style)

#### 5.1 Kanban Board
```
┌─────────────────────────────────────────────┐
│ [Status Bar]                                │
├─────────────────────────────────────────────┤
│ [Top App Bar]                               │
│   ☰ Board: Sprint 5         🔍 [Filter] ⋮ │
├─────────────────────────────────────────────┤
│                                             │
│ [Horizontal Scroll - Columns]               │
│                                             │
│ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐       │
│ │ TODO │ │ PROG │ │ TEST │ │ DONE │       │
│ │  (3) │ │  (5) │ │  (2) │ │  (8) │       │
│ ├──────┤ ├──────┤ ├──────┤ ├──────┤       │
│ │[Card]│ │[Card]│ │[Card]│ │[Card]│       │
│ │      │ │      │ │      │ │      │       │
│ │[Card]│ │[Card]│ │[Card]│ │[Card]│       │
│ │      │ │      │ │      │ │      │       │
│ │[Card]│ │[Card]│ │      │ │[Card]│       │
│ │      │ │      │ │      │ │      │       │
│ │      │ │[Card]│ │      │ │[Card]│       │
│ │      │ │      │ │      │ │      │       │
│ └──────┘ └──────┘ └──────┘ └──────┘       │
│                                             │
│   [Quick Filters]                           │
│   [Only My Issues] [High Priority]         │
│                                             │
├─────────────────────────────────────────────┤
│ [Bottom Navigation]                         │
└─────────────────────────────────────────────┘
```

**Material Design Elements**:
- Horizontal RecyclerView for columns
- Drag and drop between columns
- Material Cards for tickets
- Column headers with count badges
- Quick filter chips
- Pull to refresh

**Drag & Drop**:
- Long press to start drag
- Visual feedback during drag
- Drop zones highlighted
- Haptic feedback on drop

---

### 6. Settings Screen

#### 6.1 Settings with Material Lists
```
┌─────────────────────────────────────────────┐
│ [Status Bar]                                │
├─────────────────────────────────────────────┤
│ [Top App Bar]                               │
│   ◀ Settings                                │
├─────────────────────────────────────────────┤
│                                             │
│   APPEARANCE                                │
│   ─────────────────────────────────────────│
│   Theme                                     │
│   ○ Light  ● System  ○ Dark                │
│                                             │
│   Language                                  │
│   English                              ▸   │
│                                             │
│   ─────────────────────────────────────────│
│                                             │
│   NOTIFICATIONS                             │
│   ─────────────────────────────────────────│
│   Push Notifications            [Toggle ✓] │
│   Email Notifications           [Toggle ✓] │
│   Desktop Notifications         [Toggle  ] │
│                                             │
│   ─────────────────────────────────────────│
│                                             │
│   ACCOUNT                                   │
│   ─────────────────────────────────────────│
│   Profile                              ▸   │
│   Change Password                      ▸   │
│   Backend Server                       ▸   │
│                                             │
│   ─────────────────────────────────────────│
│                                             │
│   ABOUT                                     │
│   ─────────────────────────────────────────│
│   Version                    1.0.0          │
│   Privacy Policy                       ▸   │
│   Terms of Service                     ▸   │
│                                             │
├─────────────────────────────────────────────┤
│ [Bottom Navigation: Settings selected]      │
└─────────────────────────────────────────────┘
```

**Material Design Elements**:
- Preference categories with headers
- Material switches for toggles
- Radio buttons for theme selection
- List items with dividers
- Ripple effect on tappable items

---

## Android-Specific Features

### Gestures
- **Swipe**: Navigate between tabs, dismiss notifications
- **Long Press**: Start drag operation, show context menu
- **Pull Down**: Refresh lists
- **Pinch**: Zoom (where applicable)

### System Integration
- **Notifications**: Material design notifications with actions
- **Widgets**: Home screen widgets for quick stats
- **Shortcuts**: App shortcuts for quick actions
- **Share**: Android share sheet integration
- **Biometric**: Fingerprint/Face unlock for authentication

### Accessibility
- **TalkBack**: Screen reader support
- **Large Text**: Respect system font size
- **High Contrast**: Support high contrast mode
- **Touch Targets**: Minimum 48dp touch targets

---

## Color Application

### Light Theme
- **Primary**: #BCE63B (Buttons, FAB, selected states)
- **Secondary**: #7AA590 (Secondary actions, chips)
- **Surface**: #F8F9FA (Cards, dialogs)
- **Background**: #FFFFFF (Screen background)
- **On Primary**: #1A1A1A (Text on primary)

### Dark Theme
- **Primary**: #BCE63B (Same as light)
- **Secondary**: #7AA590 (Same as light)
- **Surface**: #1A1A1A (Cards, dialogs)
- **Background**: #0D0D0D (Screen background)
- **On Primary**: #1A1A1A (Text on primary)

---

## Implementation Notes

1. **Use Material Design 3 components** from Jetpack Compose
2. **Bottom navigation** for primary navigation (max 5 items)
3. **FAB** for primary action on each screen
4. **System bars** should match theme (status bar, navigation bar)
5. **Elevation** and **shadows** for visual hierarchy
6. **Ripple effects** on all interactive elements
7. **Motion**: Use Material motion system for transitions
8. **Typography**: Roboto font family (Material default)

---

## Next Steps

1. Open DrawIO desktop or online editor
2. Create a new diagram named `Android_UI_UX_Flow.drawio`
3. Create pages for each section (Authentication, Navigation, Projects, etc.)
4. Use this specification to create the wireframes
5. Export to PNG using the export instructions in the main README

---

**Document Version**: 1.0.0
**Last Updated**: 2025-10-18
**Maintained By**: HelixTrack UI/UX Team
