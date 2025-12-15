# Web UI/UX Wireframe Specification

**Version**: 1.0.0
**Date**: 2025-10-18
**Platform**: Web Browser (Desktop)
**Status**: Ready for DrawIO Implementation

---

## Overview

This document provides complete specifications for the Web-specific UI/UX wireframe. Use this as a blueprint to create `Web_UI_UX_Flow.drawio`.

---

## Web-Specific Design Patterns

### Web Components

- **Navigation**: Persistent left sidebar (collapsible)
- **Top Bar**: Global header with search, notifications, profile
- **Breadcrumbs**: Hierarchical navigation
- **Tabs**: Horizontal tabs for sections
- **Modals**: Centered modal dialogs
- **Tooltips**: Hover tooltips for additional info
- **Dropdowns**: Multi-level dropdown menus
- **Panels**: Collapsible side panels
- **Data Tables**: Sortable, filterable tables
- **Cards**: Information cards in grid layouts

### Screen Dimensions
- **Desktop**: 1920 x 1080 px (Full HD, standard)
- **Laptop**: 1366 x 768 px (common)
- **Large Display**: 2560 x 1440 px (2K)
- **Responsive**: Min width 1024px

---

## Screen Flows

### 1. Authentication Flow

#### 1.1 Login Screen
```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                     │
│                                                                     │
│               ┌─────────────────────────────────────┐              │
│               │                                     │              │
│               │     [HelixTrack Logo]               │              │
│               │     (Lime Green #BCE63B)            │              │
│               │                                     │              │
│               │  Welcome to HelixTrack              │              │
│               │  Project Management & Issue Tracking│              │
│               │                                     │              │
│               │  ┌──────────────────────────────┐  │              │
│               │  │ 📧 Email Address             │  │              │
│               │  └──────────────────────────────┘  │              │
│               │                                     │              │
│               │  ┌──────────────────────────────┐  │              │
│               │  │ 🔒 Password                  │  │              │
│               │  └──────────────────────────────┘  │              │
│               │                                     │              │
│               │  [ ] Remember me                    │              │
│               │                                     │              │
│               │  ┌──────────────────────────────┐  │              │
│               │  │     LOG IN                   │  │              │
│               │  │  (Primary button, full width)│  │              │
│               │  └──────────────────────────────┘  │              │
│               │                                     │              │
│               │  Forgot password?  |  Create account│              │
│               │                                     │              │
│               │  ───────────────────────────────── │              │
│               │                                     │              │
│               │  Backend Server Configuration       │              │
│               │  ┌──────────────────────────────┐  │              │
│               │  │ https://localhost:8080   ⚙️  │  │              │
│               │  └──────────────────────────────┘  │              │
│               │                                     │              │
│               └─────────────────────────────────────┘              │
│                                                                     │
│                   © 2025 HelixTrack. Open Source Project           │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

**Web Design Elements**:
- Centered card layout (max-width: 450px)
- Clean, minimal design
- Full-width inputs with icons
- Checkbox for remember me
- Text links for secondary actions
- Footer with copyright

**Interactions**:
- Enter key submits form
- Tab navigation between fields
- Click "Forgot password?" → Modal dialog
- Click "Create account" → Registration page
- Click ⚙️ → Backend config modal

---

### 2. Main Layout

#### 2.1 Dashboard with Sidebar Navigation
```
┌────────┬────────────────────────────────────────────────────────────┐
│        │ [Top Bar]                                                  │
│        │ HelixTrack    [🔍 Search...]    🔔 ❓ [Theme] [👤 Avatar] │
│        ├────────────────────────────────────────────────────────────┤
│        │ Home > Dashboard                                           │
│        │ ──────────────────────────────────────────────────────────│
│        │                                                            │
│ [Nav]  │  Dashboard                                                 │
│  ☰     │  ══════════                                                │
│        │                                                            │
│ 🏠 Home│  Good morning, John Doe! 👋                                │
│        │                                                            │
│ 📋 Proj│  ┌────────────────────────┐  ┌────────────────────────┐  │
│   ucts │  │ My Work Summary        │  │ Activity Stream        │  │
│        │  │                        │  │                        │  │
│ 🎯 My  │  │ • 12 Open Tickets      │  │ [Activity Items...]    │  │
│   Tix  │  │ • 5 In Progress        │  │                        │  │
│        │  │ • 3 Blocked            │  │ [Activity Items...]    │  │
│ 📊 Bds │  │ • 8 To Review          │  │                        │  │
│        │  │                        │  │ [Activity Items...]    │  │
│ 📅 Spr │  │ [Chart/Visual]         │  │                        │  │
│        │  │                        │  │                        │  │
│ 👥 Tea │  └────────────────────────┘  └────────────────────────┘  │
│        │                                                            │
│ 📖 Doc │  ┌──────────────────────────────────────────────────────┐│
│        │  │ Recent Tickets                                       ││
│ ───────│  │ ═══════════════                                      ││
│        │  │                                                       ││
│ 📊 Rep │  │ [Ticket Table - sortable, filterable]                ││
│        │  │ ┌──┬─────┬──────────────┬─────────┬──────┬─────────┐││
│ ⚙️ Set │  │ │ID│Type │Title         │Status   │Assign│Priority │││
│        │  │ ├──┼─────┼──────────────┼─────────┼──────┼─────────┤││
│ ───────│  │ │▼ │🐛   │Login bug...  │Open     │John  │Critical │││
│        │  │ │  │✨   │Dark mode...  │Progress │Jane  │Medium   │││
│        │  │ │  │✓    │Update docs..│Done     │Bob   │Low      │││
│ 🚪 Log │  │ └──┴─────┴──────────────┴─────────┴──────┴─────────┘││
│   out  │  │                                                       ││
│        │  │ [Pagination: 1 2 3 ... 10]                [Show: 25▼]││
│        │  └──────────────────────────────────────────────────────┘│
└────────┴────────────────────────────────────────────────────────────┘
```

**Web Design Elements**:
- Fixed sidebar (240px width, collapsible to icons only)
- Top bar with global actions
- Breadcrumb navigation
- Card-based dashboard widgets
- Data tables with sorting and filtering
- Grid layout (2-3 columns)
- Hover states on all interactive elements

**Sidebar**:
- Collapsible (click ☰ or button at bottom)
- Active item highlighted
- Icons + labels
- Grouped sections with dividers
- Sticky position

**Top Bar**:
- Global search (Ctrl+K shortcut)
- Notifications with badge count
- Help icon
- Theme toggle
- User avatar with dropdown menu

---

### 3. Projects Screen

#### 3.1 Project List (Grid & Table Views)
```
┌────────┬────────────────────────────────────────────────────────────┐
│ [Nav]  │ Home > Projects                              [+ New Project]│
│        │ ──────────────────────────────────────────────────────────│
│        │                                                            │
│        │ Projects                                                   │
│        │ ════════                                                   │
│        │                                                            │
│        │ [🔍 Search projects...]  [Filter▼]  [Sort▼]  [Grid][List]│
│        │                                                            │
│        │ [Chip: All] [Chip: Active] [Chip: Archived]              │
│        │                                                            │
│        │ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐      │
│        │ │ PROJ-KEY     │ │ PROJ-KEY     │ │ PROJ-KEY     │      │
│        │ │ ──────────── │ │ ──────────── │ │ ──────────── │      │
│        │ │ Project Name │ │ Project Name │ │ Project Name │      │
│        │ │              │ │              │ │              │      │
│        │ │ Lead: John   │ │ Lead: Jane   │ │ Lead: Bob    │      │
│        │ │ 45 Tickets   │ │ 23 Tickets   │ │ 67 Tickets   │      │
│        │ │ 75% Complete │ │ 30% Complete │ │ 90% Complete │      │
│        │ │ ▓▓▓▓▓▓▓░░░  │ │ ▓▓▓░░░░░░░  │ │ ▓▓▓▓▓▓▓▓▓░  │      │
│        │ │              │ │              │ │              │      │
│        │ │ [View] [Edit]│ │ [View] [Edit]│ │ [View] [Edit]│      │
│        │ └──────────────┘ └──────────────┘ └──────────────┘      │
│        │                                                            │
│        │ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐      │
│        │ │ [Project 4]  │ │ [Project 5]  │ │ [Project 6]  │      │
│        │ └──────────────┘ └──────────────┘ └──────────────┘      │
│        │                                                            │
│        │ [Pagination: 1 2 3 ... 10]                                │
└────────┴────────────────────────────────────────────────────────────┘
```

**Web Design Elements**:
- Toolbar with search, filters, view toggles
- Filter chips
- Grid view (3-4 columns) or List view toggle
- Cards with hover effects
- Progress bars
- Action buttons
- Pagination or infinite scroll

#### 3.2 Project Detail (Tabbed Interface)
```
┌────────┬────────────────────────────────────────────────────────────┐
│ [Nav]  │ Home > Projects > PROJ-KEY                        [⋯ More]│
│        │ ──────────────────────────────────────────────────────────│
│        │                                                            │
│        │ [Project Banner - Primary Color]                          │
│        │ PROJ-KEY                                                   │
│        │ Project Name                                               │
│        │ Lead: John Doe  •  Team: 5 members  •  Created: Jan 2025  │
│        │ [⭐ Star]  [🔔 Watch]  [📎 Attachments]                   │
│        │                                                            │
│        │ ┌───────┬───────┬────────┬──────────┬──────────┐         │
│        │ │ Board │Issues │ People │ Settings │ Activity │         │
│        │ └───────┴───────┴────────┴──────────┴──────────┘         │
│        │ ══════════════════════════════════════════════════════════│
│        │                                                            │
│        │ [Tab Content - Board View]                                 │
│        │                                                            │
│        │ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐         │
│        │ │ TODO    │ │ PROGRESS│ │ TESTING │ │  DONE   │         │
│        │ │ (3)     │ │ (5)     │ │ (2)     │ │ (8)     │         │
│        │ ├─────────┤ ├─────────┤ ├─────────┤ ├─────────┤         │
│        │ │[Ticket] │ │[Ticket] │ │[Ticket] │ │[Ticket] │         │
│        │ │[Ticket] │ │[Ticket] │ │[Ticket] │ │[Ticket] │         │
│        │ │[Ticket] │ │[Ticket] │ │         │ │[Ticket] │         │
│        │ │         │ │[Ticket] │ │         │ │[Ticket] │         │
│        │ │         │ │[Ticket] │ │         │ │[Ticket] │         │
│        │ │ [+Add]  │ │ [+Add]  │ │ [+Add]  │ │[Ticket] │         │
│        │ └─────────┘ └─────────┘ └─────────┘ └─────────┘         │
│        │                                                            │
│        │ [Quick Filters: ☐ Only My Issues  ☐ High Priority]       │
└────────┴────────────────────────────────────────────────────────────┘
```

**Web Design Elements**:
- Project header banner
- Quick actions row
- Horizontal tabs
- Kanban board with drag-and-drop
- Quick filters (checkboxes)
- Add buttons in columns

---

### 4. Tickets/Issues Screen

#### 4.1 Ticket List with Advanced Filtering
```
┌────────┬────────────────────────────────────────────────────────────┐
│ [Nav]  │ Home > Issues                          [🔍 Search]  [+ New]│
│        │ ──────────────────────────────────────────────────────────│
│        │                                                            │
│        │ Issues                                                     │
│        │ ══════                                                     │
│        │                                                            │
│ [Filt] │ ┌────────────────────────────────────────────────────────┐│
│  ers   │ │ Filter:  [Project▼] [Status▼] [Assignee▼] [Type▼]     ││
│        │ │ Active: [Assignee: Me ×] [Status: Open ×]              ││
│ Proj   │ └────────────────────────────────────────────────────────┘│
│ ☐ All  │                                                            │
│ ☑ PRJ1 │ ┌──┬────┬─────────────────┬────────┬────────┬──────────┐ │
│ ☐ PRJ2 │ │✓│ID  │Title            │Status  │Assignee│Priority  │ │
│        │ ├──┼────┼─────────────────┼────────┼────────┼──────────┤ │
│ Status │ │ │🐛 │Login bug...     │Open    │John    │🔴Critical│ │
│ ☐ All  │ │ │✨ │Dark mode...     │Progress│Jane    │🟡Medium  │ │
│ ☑ Open │ │ │✓  │Update docs...   │Done    │Bob     │🟢Low     │ │
│ ☐ Prog │ │ │📖 │User guide...    │Open    │Sarah   │🟠High    │ │
│ ☐ Done │ │ │🐛 │Database err...  │Progress│Mike    │🔴Critical│ │
│        │ │ │...│...              │...     │...     │...       │ │
│ Type   │ └──┴────┴─────────────────┴────────┴────────┴──────────┘ │
│ ☐ All  │                                                            │
│ ☑ Bug  │ Showing 1-25 of 145 issues          [< 1 2 3 ... 6 >]    │
│ ☐ Feat │ [Bulk Actions: ▼ Change Status | Assign | Delete]        │
│ ☐ Task │                                                            │
└────────┴────────────────────────────────────────────────────────────┘
```

**Web Design Elements**:
- Left sidebar with filter panels
- Collapsible filter sections
- Multi-select checkboxes
- Active filter chips (removable)
- Data table with:
  - Row selection (checkboxes)
  - Sortable columns
  - Clickable rows
  - Hover highlighting
  - Priority color coding
- Bulk actions dropdown
- Pagination controls

#### 4.2 Ticket Detail (Two-Column Layout)
```
┌────────┬──────────────────────────────────┬───────────────────────┐
│ [Nav]  │ Home > Issues > PROJ-123         │ [Right Panel]         │
│        │ ────────────────────────────────│                       │
│        │                                  │ Details               │
│        │ 🐛 PROJ-123                      │ ═══════               │
│        │ Bug in login authentication      │                       │
│        │ [Edit] [Assign] [Move] [Delete] │ Status                │
│        │                                  │ [Open ▼]              │
│        │ ───────────────────────────────│                       │
│        │                                  │ Assignee              │
│        │ Description                      │ [👤 John Doe ▼]       │
│        │ ───────────────────────────────│                       │
│        │ Users cannot log in when using  │ Reporter              │
│        │ special characters in password. │ Jane Smith            │
│        │ Steps to reproduce:             │                       │
│        │ 1. Navigate to login page       │ Sprint                │
│        │ 2. Enter email with + character │ [Sprint 5 ▼]          │
│        │ 3. Click login                   │                       │
│        │ 4. Error appears                 │ Story Points          │
│        │                                  │ [8 ▼]                 │
│        │ Expected: Login successful       │                       │
│        │ Actual: Error message shown      │ Priority              │
│        │                                  │ [🔴 Critical ▼]       │
│        │ ───────────────────────────────│                       │
│        │                                  │ Labels                │
│        │ ┌───────┬──────────┬─────────┐ │ [+Add label]          │
│        │ │Comment│Attachment│ Activity │ │ • bug                 │
│        │ └───────┴──────────┴─────────┘ │ • authentication      │
│        │                                  │                       │
│        │ [Tab Content - Comments]         │ ───────────────────  │
│        │                                  │                       │
│        │ 💬 Add Comment                   │ Watchers              │
│        │ ┌────────────────────────────┐  │ [+Add watcher]        │
│        │ │ [Rich text editor toolbar] │  │ • John Doe            │
│        │ │ [Comment text area...]     │  │ • Jane Smith          │
│        │ │                            │  │ • Bob Johnson         │
│        │ │ [@mention] [#ticket] [!]  │  │                       │
│        │ └────────────────────────────┘  │ Time Tracking         │
│        │ [Cancel] [Comment]               │ Logged: 8h            │
│        │                                  │ Remaining: 4h         │
│        │ ───────────────────────────────│ [Log work]            │
│        │                                  │                       │
│        │ [Previous comment thread...]     │ Links                 │
│        │                                  │ • Relates to #124     │
└────────┴──────────────────────────────────┴───────────────────────┘
```

**Web Design Elements**:
- Three-column layout:
  - Left: Sidebar navigation
  - Middle: Main content (wide)
  - Right: Details panel (sticky)
- Action buttons row
- Rich text editor for comments
- Tabbed sections
- Editable fields (dropdown selects)
- Two-column right panel for metadata

---

### 5. Board Views (Full-Width Kanban)

```
┌────────┬────────────────────────────────────────────────────────────┐
│ [Nav]  │ Home > Boards > Sprint 5              [🔍] [Filter] [⚙️]  │
│        │ ──────────────────────────────────────────────────────────│
│        │                                                            │
│        │ Sprint 5 Board                                             │
│        │ ════════════════                                           │
│        │ Mar 1 - Mar 14, 2025  •  5 of 18 tickets completed        │
│        │                                                            │
│        │ [Filters: ☐ Only My Issues  ☐ High Priority  ☐ Blocker]  │
│        │                                                            │
│        │ ┌───────────┐┌───────────┐┌───────────┐┌───────────┐    │
│        │ │ TODO      ││IN PROGRESS││  TESTING  ││   DONE    │    │
│        │ │ (3)       ││  (5)      ││   (2)     ││   (8)     │    │
│        │ ├───────────┤├───────────┤├───────────┤├───────────┤    │
│        │ │┌─────────┐││┌─────────┐││┌─────────┐││┌─────────┐│    │
│        │ ││🐛 PRJ-1 │││🐛 PRJ-2 │││✨ PRJ-5 │││✓ PRJ-10 ││    │
│        │ ││Login... ││││API...   ││││Dark...  ││││Docs...  ││    │
│        │ ││🔴[👤]⚡8 │││🟡[👤]⚡5 │││🟡[👤]⚡3 │││🟢[👤]⚡2 ││    │
│        │ │└─────────┘││└─────────┘││└─────────┘││└─────────┘│    │
│        │ │┌─────────┐││┌─────────┐││┌─────────┐││┌─────────┐│    │
│        │ ││✨ PRJ-3 │││✓ PRJ-6  │││          │││✓ PRJ-11 ││    │
│        │ ││Feature..││││Task...  │││          │││Task...  ││    │
│        │ ││🟡[👤]⚡5 │││🟢[👤]⚡2 │││          │││🟢[👤]⚡1 ││    │
│        │ │└─────────┘││└─────────┘││          ││└─────────┘│    │
│        │ │┌─────────┐││┌─────────┐││          ││┌─────────┐│    │
│        │ ││📖 PRJ-4 │││🐛 PRJ-7 │││          │││...      ││    │
│        │ ││Epic...  │││Bug...   │││          │││         ││    │
│        │ ││🟠[👤]⚡13│││🔴[👤]⚡8 │││          │││         ││    │
│        │ │└─────────┘││└─────────┘││          ││└─────────┘│    │
│        │ │           ││┌─────────┐││          ││           │    │
│        │ │ [+ Add]   │││...      │││ [+ Add]  ││ [+ Add]   │    │
│        │ └───────────┘└───────────┘└───────────┘└───────────┘    │
└────────┴────────────────────────────────────────────────────────────┘
```

**Web Design Elements**:
- Full-width board layout
- Column headers with ticket counts
- Drag-and-drop between columns
- Ticket cards with:
  - Type icon
  - ID and title
  - Priority indicator
  - Assignee avatar
  - Story points
- Add new ticket button in each column
- Quick filters above board
- Board settings menu

---

### 6. Settings Screen

```
┌────────┬────────────────────────────────────────────────────────────┐
│ [Nav]  │ Home > Settings                                            │
│        │ ──────────────────────────────────────────────────────────│
│        │                                                            │
│ [Tabs] │ ┌─────────┬────────┬──────────┬─────────┬──────────┐     │
│        │ │ Profile │ Account│Appearance│Notifs   │ Advanced │     │
│        │ └─────────┴────────┴──────────┴─────────┴──────────┘     │
│ • Prof │ ══════════════════════════════════════════════════════════│
│ • Acct │                                                            │
│ • App  │ [Tab Content - Appearance]                                 │
│ • Noti │                                                            │
│ • Adv  │ Theme                                                      │
│        │ ───────────────────────────────────────────────────────   │
│        │ ○ Light          ● System (Auto)         ○ Dark           │
│        │ [Preview card showing current theme]                      │
│        │                                                            │
│        │ Language                                                   │
│        │ ───────────────────────────────────────────────────────   │
│        │ [English (US) ▼]                                          │
│        │                                                            │
│        │ Display                                                    │
│        │ ───────────────────────────────────────────────────────   │
│        │ Compact mode                              [Toggle Off]    │
│        │ Show avatar images                         [Toggle On]    │
│        │ Reduce animations                         [Toggle Off]    │
│        │                                                            │
│        │ Time & Date                                                │
│        │ ───────────────────────────────────────────────────────   │
│        │ Timezone:  [UTC-5 (Eastern Time) ▼]                      │
│        │ Date format: [MM/DD/YYYY ▼]                               │
│        │ Time format: [12-hour ▼]                                  │
│        │                                                            │
│        │ [Save Changes]                                             │
└────────┴────────────────────────────────────────────────────────────┘
```

**Web Design Elements**:
- Left sidebar with settings categories
- Horizontal tabs for sub-sections
- Form groups with labels
- Radio buttons for theme
- Dropdown selects
- Toggle switches
- Preview cards
- Save button (bottom or sticky)

---

## Web-Specific Features

### Keyboard Shortcuts
- **Ctrl/Cmd + K**: Global search
- **Ctrl/Cmd + /**: Keyboard shortcuts help
- **N**: New ticket (when on tickets page)
- **E**: Edit current item
- **Esc**: Close modal
- **Tab/Shift+Tab**: Navigation

### Responsive Behavior
- **Sidebar**: Collapses to icons on smaller screens
- **Tables**: Horizontal scroll on mobile
- **Modals**: Full-screen on mobile
- **Cards**: Reflow from grid to single column

### Browser Features
- **Bookmarkable URLs**: Every page has unique URL
- **Back/Forward**: Browser history support
- **Page Title**: Updates with current page
- **Favicon**: Shows notification badge
- **Tab State**: Preserves scroll position

### Accessibility
- **Keyboard Navigation**: Full keyboard support
- **Screen Readers**: ARIA labels and landmarks
- **Focus Indicators**: Visible focus states
- **Skip Links**: Skip to main content
- **Color Contrast**: WCAG AA compliance

---

## Color Application

### Light Theme
- **Primary**: #BCE63B (Links, buttons, active states)
- **Secondary**: #7AA590 (Secondary buttons, badges)
- **Background**: #FFFFFF (Page background)
- **Surface**: #F8F9FA (Cards, modals, sidebar)
- **Border**: #DEE2E6 (Dividers, card borders)
- **Text**: #1A1A1A (Primary text)
- **Text Secondary**: #6C757D (Captions, metadata)

### Dark Theme
- **Primary**: #BCE63B (Same)
- **Secondary**: #7AA590 (Same)
- **Background**: #0D0D0D (Page background)
- **Surface**: #1A1A1A (Cards, modals, sidebar)
- **Border**: rgba(255,255,255,0.1) (Dividers)
- **Text**: #FFFFFF (Primary text)
- **Text Secondary**: #ADB5BD (Captions, metadata)

---

## Typography

### Font Family
- **Primary**: 'Inter', system-ui, -apple-system, sans-serif
- **Monospace**: 'SF Mono', 'Roboto Mono', monospace

### Size Scale
- **Display**: 48px (Hero headings)
- **H1**: 32px (Page titles)
- **H2**: 24px (Section headings)
- **H3**: 20px (Sub-headings)
- **Body**: 16px (Primary text)
- **Small**: 14px (Captions, metadata)
- **Tiny**: 12px (Labels, footnotes)

---

## Implementation Notes

1. **Angular Material** or similar component library
2. **Responsive Grid**: 12-column system
3. **Sidebar**: Persistent, collapsible (240px → 60px)
4. **Top Bar**: Fixed, height 64px
5. **Content**: Max-width 1600px, centered
6. **Spacing**: 8px base unit (8, 16, 24, 32, 48)
7. **Shadows**: Subtle elevations for cards
8. **Transitions**: 200-300ms ease-in-out
9. **Icons**: Material Icons or similar
10. **Forms**: Consistent spacing, inline validation

---

## Next Steps

1. Open DrawIO desktop or online editor
2. Create a new diagram named `Web_UI_UX_Flow.drawio`
3. Create pages for each section
4. Use this specification to create the wireframes
5. Export to PNG using the export instructions in the main README

---

**Document Version**: 1.0.0
**Last Updated**: 2025-10-18
**Maintained By**: HelixTrack UI/UX Team
