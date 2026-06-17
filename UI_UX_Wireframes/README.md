# HelixTrack UI/UX Wireframes

**Version**: 2.0.0
**Date**: 2025-10-18
**Status**: Master Wireframe Complete

---

## Overview

This directory contains comprehensive UI/UX wireframe diagrams for all HelixTrack client applications, showing complete user flows, screen connections, and interaction patterns aligned with JIRA and Confluence design patterns.

---

## Files

### Master Wireframe

| File | Description | Status |
|------|-------------|--------|
| **Master_UI_UX_Flow.drawio** | Complete master wireframe with all flows | ✅ Complete |
| **Master_UI_UX_Flow.png** | PNG export of master wireframe | ⏳ Manual export recommended (see instructions below) |

### Platform-Specific Wireframes

| File | Description | Status |
|------|-------------|--------|
| **Android_Wireframe_Specification.md** | Complete Android wireframe blueprint | ✅ Complete |
| **Android_UI_UX_Flow.drawio** | Android-specific screens and flows | ⏳ To be created from spec |
| **Android_UI_UX_Flow.png** | PNG export | ⏳ To be created |
| **iOS_Wireframe_Specification.md** | Complete iOS wireframe blueprint | ✅ Complete |
| **iOS_UI_UX_Flow.drawio** | iOS-specific screens and flows | ⏳ To be created from spec |
| **iOS_UI_UX_Flow.png** | PNG export | ⏳ To be created |
| **Web_Wireframe_Specification.md** | Complete Web wireframe blueprint | ✅ Complete |
| **Web_UI_UX_Flow.drawio** | Web client screens and flows | ⏳ To be created from spec |
| **Web_UI_UX_Flow.png** | PNG export | ⏳ To be created |
| **Desktop_Wireframe_Specification.md** | Complete Desktop wireframe blueprint | ✅ Complete |
| **Desktop_UI_UX_Flow.drawio** | Desktop client screens and flows | ⏳ To be created from spec |
| **Desktop_UI_UX_Flow.png** | PNG export | ⏳ To be created |

---

## Master Wireframe Contents

The `Master_UI_UX_Flow.drawio` contains the following sections:

### 1. Authentication Flow
- Login screen with email/password
- Registration screen with validation
- Password reset flow
- Error states and success flows

### 2. Main Navigation
- Dashboard with widgets
- Sidebar navigation (collapsible)
- Top navigation bar
- Breadcrumb navigation
- Mobile bottom tabs

### 3. Project Management (JIRA-style)
- Project list (grid and list views)
- Project detail with metrics
- Project creation form
- Project settings
- Team member management

### 4. Ticket/Issue Management (JIRA-style)
- Ticket list with filters
- Ticket card design (type, ID, priority, assignee, metrics)
- Ticket detail view with full information
- Create ticket form with all fields
- Ticket editing and transitions

### 5. Board Views (JIRA-style)
- Kanban board with columns
- Scrum board with sprints
- Backlog management
- Drag-and-drop interactions
- Filters and quick filters

### 6. Documents (Confluence-style)
- Document space list
- Document list within space
- Document editor (Edit/Preview/Split modes)
- Version history
- Comments and collaboration

### 7. Settings & Profile
- User profile management
- Account settings
- Theme toggle (Light/Dark/Auto)
- Notification preferences
- Integrations

### 8. Navigation Flows
- Complete user journeys
- Alternative paths
- Error handling flows
- Platform-specific variations

---

## Viewing the Wireframes

### Option 1: draw.io Desktop App

1. Download and install [draw.io Desktop](https://github.com/jgraph/drawio-desktop/releases)
2. Open the `.drawio` files in the application
3. Navigate between pages using the tabs at the bottom

### Option 2: draw.io Online

1. Go to [https://app.diagrams.net/](https://app.diagrams.net/)
2. Click "Open Existing Diagram"
3. Select the `.drawio` file from this directory
4. Navigate and edit as needed

### Option 3: VS Code Extension

1. Install the "Draw.io Integration" extension in VS Code
2. Open `.drawio` files directly in VS Code editor
3. Full editing capabilities within your IDE

---

## Exporting to PNG

### Using draw.io Desktop App

1. Open the `.drawio` file
2. File → Export as → PNG
3. Configure:
   - Resolution: 300 DPI (print quality)
   - Transparent: No
   - Selection only: No (export full page)
4. Save to same directory

### Using Core Export Script

The Core has a script for batch exporting:

```bash
cd core/Application/scripts
./export-drawio-to-png.sh /path/to/diagram.drawio
```

This will create a `.png` file next to the `.drawio` file.

### Using Command Line (headless)

```bash
# Install draw.io CLI
npm install -g @diagram/drawio-cli

# Export to PNG
drawio -x -f png -o Master_UI_UX_Flow.png Master_UI_UX_Flow.drawio
```

---

## Wireframe Guidelines

### Color Scheme

| Element | Color | Hex | Usage |
|---------|-------|-----|-------|
| **Primary** | Lime Green | #BCE63B | Main actions, active states |
| **Secondary** | Teal | #7AA590 | Secondary actions, info |
| **Accent** | Mint | #B2E3C2 | Highlights, success |
| **Surface** | Light Gray | #F8F9FA | Backgrounds, panels |
| **Border** | Gray | #DEE2E6 | Dividers, outlines |
| **Text** | Dark Gray | #1A1A1A | Primary text |

### Typography

- **Headings**: Bold, 14-16pt
- **Body**: Regular, 10-12pt
- **Monospace**: Courier New, 10pt (for code/IDs)

### Component Notation

```
[Button]          - Clickable button
[Input field]     - Text input
☐ / ☑            - Checkbox (unchecked/checked)
○ / ●            - Radio button (unselected/selected)
▸ / ▾            - Expandable item (collapsed/expanded)
[Icon] Text       - Icon with label
┌─────────────┐   - Card/panel border
│             │
└─────────────┘
```

### Icon Legend

```
🐛 = Bug
✨ = Feature/Story
✓ = Task
📖 = Epic
🔴 = Critical priority
🟠 = High priority
🟡 = Medium priority
🟢 = Low priority
📊 = Status indicator
⚡ = Story points
💬 = Comments
📎 = Attachments
👁 = Watchers
👤 = User/Assignee
```

---

## Creating Platform-Specific Wireframes

Comprehensive wireframe specification documents have been created for each platform. These documents provide complete blueprints with ASCII art diagrams, platform-specific patterns, and detailed implementation notes.

### 1. Review the Platform Specification

Each platform has a detailed specification document:
- `Android_Wireframe_Specification.md` - Material Design 3 patterns
- `iOS_Wireframe_Specification.md` - iOS Human Interface Guidelines
- `Web_Wireframe_Specification.md` - Browser desktop patterns
- `Desktop_Wireframe_Specification.md` - Native desktop application patterns

### 2. Create DrawIO Diagram from Specification

Open DrawIO and create a new diagram following the specification:
- Use the ASCII art layouts as visual guides
- Follow platform-specific component guidelines
- Include all screens and flows documented in the spec

### 3. Customize for Platform

**Android**:
- Add Material Design 3 specific components (FAB, Snackbar)
- Show bottom navigation (3-5 items)
- Include Android-specific gestures (swipe, long-press)
- Show Material ripple effects
- Include status bar and navigation bar

**iOS**:
- Add iOS-specific components (Tab bar, Navigation bar)
- Show large titles
- Include iOS-specific gestures (swipe back)
- Show SF Symbols
- Include home indicator

**Web**:
- Show full sidebar navigation
- Include breadcrumb navigation
- Show desktop-specific layouts
- Include hover states
- Show tooltips

**Desktop (Tauri)**:
- Show native window controls (minimize, maximize, close)
- Include menu bar
- Show system tray icon
- Include keyboard shortcuts
- Show multi-window scenarios

### 3. Add Platform-Specific Flows

- Platform-specific authentication (biometric, etc.)
- Platform-specific settings
- Platform-specific integrations
- Offline modes (where applicable)

---

## Wireframe Review Checklist

When reviewing wireframes, verify:

- [ ] All screens are included
- [ ] Navigation flows are complete
- [ ] Error states are documented
- [ ] Empty states are shown
- [ ] Loading states are indicated
- [ ] Confirmation dialogs included
- [ ] Form validation shown
- [ ] Responsive layouts documented
- [ ] Accessibility considerations noted
- [ ] Platform-specific patterns followed
- [ ] JIRA/Confluence alignment maintained
- [ ] Color scheme consistent
- [ ] Typography consistent
- [ ] Icon usage consistent

---

## Implementation Notes

### Priority Screens (Implement First)

1. **Authentication** (Login, Register, Reset)
2. **Dashboard** (Home screen with widgets)
3. **Project List** (Grid and list views)
4. **Ticket List** (JIRA-style with cards)
5. **Ticket Detail** (Full information view)
6. **Board View** (Kanban at minimum)

### Secondary Screens (Implement Second)

7. **Create Ticket** (Quick create dialog)
8. **Create Project** (Project setup wizard)
9. **Document List** (Confluence-style)
10. **Settings** (Theme, notifications, profile)

### Advanced Screens (Implement Last)

11. **Document Editor** (Full markdown editor)
12. **Sprint Board** (Scrum-specific)
13. **Reports** (Analytics and charts)
14. **Advanced Search** (Filters and JQL)

---

## Collaboration

### Sharing Wireframes

**For Stakeholders**:
- Export to PNG for easy viewing
- Create PDF with all pages
- Host on web (diagrams.net sharing)

**For Designers**:
- Share `.drawio` files directly
- Use version control (Git)
- Include comments in diagram

**For Developers**:
- Link wireframes in tickets
- Reference specific screens in PRs
- Update as implementation evolves

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0.0 | 2025-10-18 | Master wireframe created with all core flows |
| - | - | Platform-specific wireframes planned |

---

## Next Steps

1. ✅ Create master wireframe (DONE)
2. ⏳ Export master wireframe to PNG
3. ⏳ Create Android-specific wireframe
4. ⏳ Create iOS-specific wireframe
5. ⏳ Create Web-specific wireframe
6. ⏳ Create Desktop-specific wireframe
7. ⏳ Export all wireframes to PNG
8. ⏳ Review with stakeholders
9. ⏳ Update based on feedback
10. ⏳ Use as implementation reference

---

## References

- **UI/UX Master Specification**: `../UI_UX_MASTER_SPECIFICATION.md`
- **Implementation Roadmap**: `../UI_UX_IMPLEMENTATION_ROADMAP.md`
- **JIRA Design Patterns**: [Atlassian Design System](https://atlassian.design/)
- **Material Design 3**: [Material Design Guidelines](https://m3.material.io/)
- **iOS HIG**: [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)

---

**Document Version**: 1.0.0
**Last Updated**: 2025-10-18
**Maintained By**: HelixTrack UI/UX Team

---
