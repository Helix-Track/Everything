# HelixTrack - Master UI/UX Specification

**Version**: 2.0.0
**Date**: 2025-10-18
**Status**: Complete Cross-Platform Specification

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Brand Identity](#brand-identity)
3. [Design Principles](#design-principles)
4. [Color System](#color-system)
5. [Typography](#typography)
6. [Component Library](#component-library)
7. [Layout System](#layout-system)
8. [Navigation Patterns](#navigation-patterns)
9. [Theme System](#theme-system)
10. [Platform-Specific Guidelines](#platform-specific-guidelines)
11. [Accessibility](#accessibility)
12. [Responsive Design](#responsive-design)
13. [Animation & Transitions](#animation--transitions)
14. [Icon System](#icon-system)
15. [Data Visualization](#data-visualization)
16. [Form Design](#form-design)
17. [Error Handling](#error-handling)
18. [Loading States](#loading-states)
19. [Empty States](#empty-states)
20. [JIRA/Confluence Alignment](#jiraconfluence-alignment)

---

## Executive Summary

This document defines the complete UI/UX specification for HelixTrack across all platforms (Android, Web, Desktop, iOS). It ensures:

- **Consistent Brand Identity** across all touchpoints
- **Modern UI Standards** following Material Design 3, iOS Human Interface Guidelines
- **JIRA/Confluence Alignment** for familiar user experience
- **Accessibility** (WCAG 2.1 AA compliance)
- **Responsive Design** for all screen sizes
- **Theme Support** (Light/Dark) with system detection
- **Unified Component Library** shared across platforms

### Key Objectives

1. ✅ **Brand Consistency**: Use HelixTrack colors (#BCE63B primary, #7AA590 secondary)
2. ✅ **Modern Standards**: Material Design 3, iOS HIG, Web Accessibility
3. ✅ **JIRA Familiarity**: Match JIRA/Confluence workflows and patterns
4. ✅ **Theme Support**: Light and dark themes on all platforms
5. ✅ **Accessibility**: WCAG 2.1 AA compliance minimum
6. ✅ **Performance**: 60fps animations, <100ms interactions

---

## Brand Identity

### Vision

HelixTrack is the **modern, open-source JIRA alternative for the free world** - combining enterprise-grade features with intuitive design and complete transparency.

### Brand Attributes

- **Professional**: Enterprise-ready capabilities
- **Open**: Transparent, community-driven
- **Modern**: Clean, contemporary interface
- **Powerful**: Feature-rich without complexity
- **Accessible**: Easy to learn, hard to master

### Brand Personality

| Attribute | Description |
|-----------|-------------|
| **Innovative** | Cutting-edge technology, forward-thinking |
| **Reliable** | Stable, tested, production-ready |
| **Friendly** | Approachable, helpful, supportive |
| **Efficient** | Fast, streamlined, productive |
| **Transparent** | Open-source, clear communication |

---

## Color System

### Primary Colors (from Website)

Extracted from `Core/Website/docs/style.css`:

```css
--primary-color: #BCE63B;      /* Bright Lime Green - Main brand color */
--secondary-color: #7AA590;    /* Muted Teal - Supporting color */
--accent-color: #B2E3C2;       /* Light Mint - Highlights */
```

### Extended Palette

#### Light Theme Palette

| Color Name | Hex | RGB | Usage |
|------------|-----|-----|-------|
| **Primary** | `#BCE63B` | `188, 230, 59` | Primary actions, headers, accents |
| **Primary Hover** | `#A9D02C` | `169, 208, 44` | Hover state for primary elements |
| **Primary Active** | `#96BA1D` | `150, 186, 29` | Active/pressed state |
| **Secondary** | `#7AA590` | `122, 165, 144` | Secondary actions, info |
| **Secondary Hover** | `#6A9580` | `106, 149, 128` | Hover state |
| **Secondary Active** | `#5A8570` | `90, 133, 112` | Active state |
| **Accent** | `#B2E3C2` | `178, 227, 194` | Highlights, success states |
| **Background** | `#FFFFFF` | `255, 255, 255` | Main background |
| **Surface** | `#F8F9FA` | `248, 249, 250` | Card backgrounds, panels |
| **Surface Variant** | `#E9ECEF` | `233, 236, 239` | Alternate surfaces |
| **Text Primary** | `#1A1A1A` | `26, 26, 26` | Main text |
| **Text Secondary** | `#6C757D` | `108, 117, 125` | Secondary text |
| **Text Disabled** | `#ADB5BD` | `173, 181, 189` | Disabled text |
| **Border** | `#DEE2E6` | `222, 226, 230` | Borders, dividers |
| **Error** | `#DC3545` | `220, 53, 69` | Error states |
| **Warning** | `#FFC107` | `255, 193, 7` | Warning states |
| **Success** | `#28A745` | `40, 167, 69` | Success states |
| **Info** | `#17A2B8` | `23, 162, 184` | Info states |

#### Dark Theme Palette

| Color Name | Hex | RGB | Usage |
|------------|-----|-----|-------|
| **Primary** | `#BCE63B` | `188, 230, 59` | Primary actions (same as light) |
| **Primary Hover** | `#A9D02C` | `169, 208, 44` | Hover state |
| **Primary Active** | `#96BA1D` | `150, 186, 29` | Active state |
| **Secondary** | `#7AA590` | `122, 165, 144` | Secondary actions |
| **Secondary Hover** | `#8AB5A0` | `138, 181, 160` | Hover state (lighter in dark) |
| **Secondary Active** | `#9AC5B0` | `154, 197, 176` | Active state |
| **Accent** | `#B2E3C2` | `178, 227, 194` | Highlights |
| **Background** | `#0D0D0D` | `13, 13, 13` | Main background |
| **Surface** | `#1A1A1A` | `26, 26, 26` | Card backgrounds, panels |
| **Surface Variant** | `#2D2D2D` | `45, 45, 45` | Alternate surfaces |
| **Text Primary** | `#FFFFFF` | `255, 255, 255` | Main text |
| **Text Secondary** | `#ADB5BD` | `173, 181, 189` | Secondary text |
| **Text Disabled** | `#6C757D` | `108, 117, 125` | Disabled text |
| **Border** | `rgba(255,255,255,0.1)` | - | Borders, dividers |
| **Error** | `#FF6B6B` | `255, 107, 107` | Error states (brighter) |
| **Warning** | `#FFD93D` | `255, 217, 61` | Warning states (brighter) |
| **Success** | `#51CF66` | `81, 207, 102` | Success states (brighter) |
| **Info** | `#4DABF7` | `77, 171, 247` | Info states (brighter) |

### Semantic Colors

#### Status Colors (Both Themes)

| Status | Light | Dark | Usage |
|--------|-------|------|-------|
| **Open** | `#17A2B8` | `#4DABF7` | Open tickets |
| **In Progress** | `#FFC107` | `#FFD93D` | Active work |
| **Done** | `#28A745` | `#51CF66` | Completed items |
| **Blocked** | `#DC3545` | `#FF6B6B` | Blocked items |
| **On Hold** | `#6C757D` | `#ADB5BD` | Paused items |

#### Priority Colors

| Priority | Light | Dark | Usage |
|----------|-------|------|-------|
| **Critical** | `#721C24` | `#C92A2A` | Highest priority |
| **High** | `#DC3545` | `#FF6B6B` | High priority |
| **Medium** | `#FFC107` | `#FFD93D` | Medium priority |
| **Low** | `#17A2B8` | `#4DABF7` | Low priority |
| **Trivial** | `#6C757D` | `#ADB5BD` | Lowest priority |

### Gradients

```css
/* Primary Gradient */
--gradient-primary: linear-gradient(135deg, #BCE63B 0%, #7AA590 100%);

/* Secondary Gradient */
--gradient-secondary: linear-gradient(135deg, #7AA590 0%, #B2E3C2 100%);

/* Accent Gradient */
--gradient-accent: linear-gradient(135deg, #B2E3C2 0%, #BCE63B 100%);

/* Dark Gradient (for hero sections) */
--gradient-dark: linear-gradient(135deg, #1A1A1A 0%, #2D2D2D 100%);
```

### Color Usage Guidelines

1. **Primary Color (#BCE63B)**:
   - Main CTAs (Call-to-Action buttons)
   - Active navigation items
   - Key interactive elements
   - Headers and titles (when emphasized)

2. **Secondary Color (#7AA590)**:
   - Secondary actions
   - Info notifications
   - Supporting UI elements
   - Alternative buttons

3. **Accent Color (#B2E3C2)**:
   - Success states
   - Highlights
   - Selected items (subtle)
   - Decorative elements

4. **Neutral Colors**:
   - Text: Primary text (#1A1A1A light, #FFFFFF dark)
   - Backgrounds: White/Light gray (light), Dark grays (dark)
   - Borders: Subtle grays

---

## Typography

### Font Families

#### Primary Font: **Inter**

- **Usage**: Body text, UI elements, forms
- **Weights**: 400 (Regular), 500 (Medium), 600 (Semi-Bold), 700 (Bold)
- **Fallback**: `-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif`

#### Display Font: **Poppins**

- **Usage**: Headings, titles, marketing content
- **Weights**: 400 (Regular), 600 (Semi-Bold), 700 (Bold), 800 (Extra-Bold)
- **Fallback**: `'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif`

#### Monospace Font: **'Courier New'** / **'SF Mono'** / **'Roboto Mono'**

- **Usage**: Code blocks, technical content, IDs
- **Weight**: 400 (Regular)

### Type Scale

#### Desktop/Web (16px base)

| Level | Size | Line Height | Weight | Usage |
|-------|------|-------------|--------|-------|
| **H1** | 48px (3rem) | 56px (1.17) | 800 | Hero titles |
| **H2** | 40px (2.5rem) | 48px (1.2) | 700 | Section titles |
| **H3** | 32px (2rem) | 40px (1.25) | 700 | Subsection titles |
| **H4** | 24px (1.5rem) | 32px (1.33) | 600 | Card titles |
| **H5** | 20px (1.25rem) | 28px (1.4) | 600 | List headers |
| **H6** | 18px (1.125rem) | 24px (1.33) | 600 | Minor headers |
| **Body Large** | 18px (1.125rem) | 28px (1.56) | 400 | Emphasized body |
| **Body** | 16px (1rem) | 24px (1.5) | 400 | Default text |
| **Body Small** | 14px (0.875rem) | 20px (1.43) | 400 | Secondary text |
| **Caption** | 12px (0.75rem) | 16px (1.33) | 400 | Captions, labels |
| **Overline** | 11px (0.688rem) | 16px (1.45) | 500 | Uppercase labels |

#### Mobile/Tablet (Responsive Scale)

| Level | Size | Line Height | Weight | Usage |
|-------|------|-------------|--------|-------|
| **H1** | 32-40px | 40-48px | 800 | Hero titles (clamp) |
| **H2** | 28-32px | 36-40px | 700 | Section titles |
| **H3** | 24-28px | 32-36px | 700 | Subsection titles |
| **H4** | 20-24px | 28-32px | 600 | Card titles |
| **H5** | 18-20px | 24-28px | 600 | List headers |
| **H6** | 16-18px | 22-24px | 600 | Minor headers |
| **Body** | 14-16px | 20-24px | 400 | Default text |
| **Body Small** | 12-14px | 18-20px | 400 | Secondary text |
| **Caption** | 11-12px | 16px | 400 | Captions |

### Typography Guidelines

1. **Hierarchy**: Use size, weight, and color to establish clear hierarchy
2. **Line Length**: 50-75 characters per line for optimal readability
3. **Line Height**: 1.4-1.6 for body text, tighter for headings
4. **Letter Spacing**: -0.01em for large headings, 0 for body
5. **Contrast**: Minimum 4.5:1 for body text, 3:1 for large text (WCAG AA)

---

## Component Library

### Buttons

#### Button Variants

1. **Primary Button**:
   - Background: Primary color (#BCE63B)
   - Text: White or dark (based on contrast)
   - Border: None
   - Shadow: Medium elevation
   - Hover: Darken 10%, lift 2px
   - Active: Darken 20%, scale 0.98

2. **Secondary Button**:
   - Background: Secondary color (#7AA590)
   - Text: White
   - Border: None
   - Shadow: Small elevation
   - Hover: Darken 10%, lift 2px

3. **Outline Button**:
   - Background: Transparent
   - Text: Primary color
   - Border: 2px solid primary
   - Hover: Background primary, text white

4. **Ghost Button**:
   - Background: Transparent
   - Text: Text primary
   - Border: None
   - Hover: Background surface variant

5. **Danger Button**:
   - Background: Error color
   - Text: White
   - Border: None
   - Shadow: Medium
   - Usage: Destructive actions

#### Button Sizes

| Size | Height | Padding | Font Size | Icon Size |
|------|--------|---------|-----------|-----------|
| **Large** | 48px | 16px 32px | 16px | 24px |
| **Medium** | 40px | 12px 24px | 14px | 20px |
| **Small** | 32px | 8px 16px | 13px | 16px |
| **X-Small** | 24px | 6px 12px | 12px | 14px |

#### Button States

```css
/* Normal */
.btn {
  transition: all 0.2s ease;
}

/* Hover */
.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0,0,0,0.15);
}

/* Active */
.btn:active {
  transform: scale(0.98);
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

/* Focus */
.btn:focus {
  outline: 2px solid var(--primary-color);
  outline-offset: 2px;
}

/* Disabled */
.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  transform: none;
}
```

### Input Fields

#### Text Input

```
┌─────────────────────────────────────┐
│ Label (12px, Semi-Bold)             │
├─────────────────────────────────────┤
│ [Icon] Placeholder text...          │
│        ▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔              │
├─────────────────────────────────────┤
│ Helper text or error (12px)         │
└─────────────────────────────────────┘
```

**Specifications**:
- Height: 40px (medium), 48px (large)
- Padding: 12px horizontal, 10px vertical
- Border: 1px solid border color
- Border Radius: 8px
- Font: 14px regular

**States**:
- Default: Border color border (#DEE2E6)
- Focus: Border color primary (#BCE63B), 2px width
- Error: Border color error (#DC3545)
- Disabled: Opacity 0.5, cursor not-allowed
- Read-only: Background surface variant

#### Select Dropdown

Similar to text input with dropdown icon (chevron-down).

#### Textarea

Same as text input but:
- Minimum height: 80px
- Resize: vertical only
- Line height: 1.5

#### Checkbox

```
□  Label text
▣  Label text (indeterminate)
☑  Label text (checked)
```

- Size: 20×20px
- Border: 2px solid border color
- Border Radius: 4px
- Check mark: Primary color
- Focus: Outline 2px primary

#### Radio Button

```
○  Option 1
◉  Option 2 (selected)
```

- Size: 20×20px diameter
- Border: 2px solid border color
- Inner circle: Primary color (8×8px)
- Focus: Outline 2px primary

#### Toggle Switch

```
Off:  ⬜──○
On:   ──○⬛  (primary color)
```

- Width: 44px, Height: 24px
- Border Radius: 12px
- Handle: 18×18px circle, 3px margin
- Transition: 0.2s ease

### Cards

#### Standard Card

```
┌─────────────────────────────────────┐
│ ┌─────┐ Card Title        [Actions]│
│ │Icon │ Secondary text              │
│ └─────┘                             │
│                                     │
│ Card content goes here...           │
│                                     │
│ ─────────────────────────────────  │
│ Footer actions or metadata          │
└─────────────────────────────────────┘
```

**Specifications**:
- Background: Surface color
- Border: 1px solid border color (optional)
- Border Radius: 12px
- Shadow: `0 2px 4px rgba(0,0,0,0.1)`
- Padding: 20px
- Hover: Lift 4px, shadow `0 4px 8px rgba(0,0,0,0.15)`

#### Ticket Card (JIRA-style)

```
┌─────────────────────────────────────┐
│ [TYPE] PROJ-123          [Priority] │
│ Ticket title goes here              │
│                                     │
│ Assignee | Status | Sprint          │
│ ─────────────────────────────────  │
│ ⚡4 points  💬3  📎2  👁1            │
└─────────────────────────────────────┘
```

**Components**:
- Type icon (Bug, Story, Task, Epic)
- Ticket ID (monospace)
- Priority indicator (color-coded)
- Title (truncate with ellipsis)
- Metadata row (assignee avatar, status badge, sprint)
- Footer metrics (story points, comments, attachments, watchers)

### Lists

#### Standard List

```
┌─────────────────────────────────────┐
│ ○ List item 1                       │
│ ○ List item 2                       │
│ ○ List item 3                       │
└─────────────────────────────────────┘
```

- Line height: 40px
- Padding: 8px 16px
- Hover: Background surface variant
- Active: Background primary (10% opacity)

#### Interactive List (with actions)

```
┌─────────────────────────────────────┐
│ [Icon] Item title           [⋮]     │
│        Secondary text               │
│ ───────────────────────────────────│
│ [Icon] Item title           [⋮]     │
│        Secondary text               │
└─────────────────────────────────────┘
```

- Dividers: 1px border color
- Actions: Kebab menu (⋮) on hover
- Selection: Checkbox on left

### Tables

#### Data Table

```
┌─────┬─────────────┬──────────┬─────────┐
│ ☑   │ Name        │ Status   │ Actions │
├─────┼─────────────┼──────────┼─────────┤
│ ☑   │ Item 1      │ Active   │ [⋮]     │
│ □   │ Item 2      │ Inactive │ [⋮]     │
│ □   │ Item 3      │ Pending  │ [⋮]     │
└─────┴─────────────┴──────────┴─────────┘
```

**Specifications**:
- Header: Background surface variant, bold text
- Row height: 48px
- Padding: 12px horizontal
- Border: 1px solid border color (horizontal only)
- Hover: Background surface variant
- Selected: Background primary (5% opacity)
- Sortable: Arrow icon in header

### Modals/Dialogs

#### Standard Modal

```
╔═════════════════════════════════════╗
║ Modal Title                      [×]║
╠═════════════════════════════════════╣
║                                     ║
║ Modal content goes here...          ║
║                                     ║
║                                     ║
╠═════════════════════════════════════╣
║            [Cancel]  [Confirm]      ║
╚═════════════════════════════════════╝
```

**Specifications**:
- Overlay: Background dark (50% opacity), blur 4px
- Modal: Background surface, rounded 16px
- Max width: 600px (small), 900px (large)
- Padding: 24px
- Shadow: `0 20px 40px rgba(0,0,0,0.3)`
- Animation: Fade + scale from center

### Navigation

#### Top Navigation Bar

```
┌─────────────────────────────────────────────────┐
│ [Logo] Nav Item 1  Nav Item 2  Nav Item 3      │
│                          Search  [Avatar] [⚙️] │
└─────────────────────────────────────────────────┘
```

**Specifications**:
- Height: 64px
- Background: Surface color, backdrop blur
- Shadow: `0 2px 4px rgba(0,0,0,0.1)`
- Position: Fixed top, z-index 1000
- Logo: 40px height

#### Sidebar Navigation

```
┌─────────────────┐
│ [≡] HelixTrack  │
├─────────────────┤
│ ▸ Dashboard     │
│ ▾ Projects      │
│   • Project A   │
│   • Project B   │
│ ▸ Tickets       │
│ ▸ Reports       │
├─────────────────┤
│ [+] New Ticket  │
└─────────────────┘
```

**Specifications**:
- Width: 240px (expanded), 64px (collapsed)
- Background: Surface color
- Border: 1px solid border color (right)
- Item height: 40px
- Padding: 8px 16px
- Active: Background primary (10% opacity), border-left 4px primary

#### Breadcrumbs

```
Home > Projects > Project A > Tickets > PROJ-123
```

**Specifications**:
- Font size: 14px
- Separator: `>` or `/` (6px margin)
- Color: Text secondary
- Hover: Text primary
- Active: Text primary, semi-bold

### Badges

#### Status Badge

```
[Open] [In Progress] [Done] [Closed]
```

**Specifications**:
- Height: 24px
- Padding: 4px 8px
- Border radius: 4px (semi-rounded) or 12px (fully rounded)
- Font: 12px semi-bold, uppercase
- Colors: Semantic (status colors)

#### Notification Badge

```
[3]  (Red circle with count)
```

**Specifications**:
- Size: 20×20px (minimum)
- Background: Error color
- Text: White, 11px bold
- Position: Top-right of parent element

### Avatars

#### User Avatar

```
┌───┐
│ AB │  (Initials if no image)
└───┘
```

**Sizes**:
- X-Small: 24×24px
- Small: 32×32px
- Medium: 40×40px
- Large: 56×56px
- X-Large: 80×80px

**Specifications**:
- Border radius: 50% (circle)
- Border: 2px solid surface (for contrast)
- Fallback: Initials on primary color background

### Tooltips

```
┌─────────────────┐
│ Tooltip text    │
└────────┬────────┘
         ▼ (Pointing to element)
```

**Specifications**:
- Background: Dark (#1A1A1A)
- Text: White, 12px
- Padding: 6px 12px
- Border radius: 6px
- Max width: 200px
- Arrow: 6px triangle
- Delay: 500ms
- Animation: Fade in 150ms

### Progress Indicators

#### Linear Progress Bar

```
[████████──────────] 60%
```

**Specifications**:
- Height: 6px (small), 8px (medium), 12px (large)
- Background: Border color
- Fill: Primary color (or semantic color)
- Border radius: Full (3px/4px/6px)
- Animation: Smooth width transition 300ms

#### Circular Progress (Spinner)

```
    ⟳
```

**Specifications**:
- Size: 24px (small), 40px (medium), 64px (large)
- Stroke width: 3px
- Color: Primary color
- Animation: Rotate 360deg, 1s linear infinite

#### Skeleton Loader

```
┌─────────────────────────────────────┐
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                │
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    │
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                │
└─────────────────────────────────────┘
```

**Specifications**:
- Background: Surface variant
- Animation: Shimmer effect (gradient sweep)
- Border radius: Match element

---

## Layout System

### Grid System

#### 12-Column Grid

```
┌─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┬─┐
│ │ │ │ │ │ │ │ │ │ │ │ │
└─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┴─┘
```

**Specifications**:
- Columns: 12
- Gutter: 16px (mobile), 24px (tablet), 32px (desktop)
- Max width: 1200px (container), 1440px (wide container)
- Breakpoints:
  - Mobile: 0-767px (4-column)
  - Tablet: 768px-1023px (8-column)
  - Desktop: 1024px+ (12-column)

### Spacing Scale

Based on 8px base unit (8-point grid):

| Name | Value | Usage |
|------|-------|-------|
| **xs** | 4px | Tight spacing (icon margins) |
| **sm** | 8px | Small spacing (list items) |
| **md** | 16px | Medium spacing (cards, buttons) |
| **lg** | 24px | Large spacing (sections) |
| **xl** | 32px | Extra large (major sections) |
| **2xl** | 48px | Huge spacing (page sections) |
| **3xl** | 64px | Massive spacing (hero sections) |

### Container Widths

| Breakpoint | Container Width |
|------------|-----------------|
| **Mobile (< 768px)** | 100% - 32px padding |
| **Tablet (768-1023px)** | 100% - 64px padding |
| **Desktop (1024-1439px)** | 1200px |
| **Wide (1440px+)** | 1440px |

### Page Layouts

#### Standard Page Layout

```
┌─────────────────────────────────────┐
│ Top Navigation Bar (64px)           │
├──────┬──────────────────────────────┤
│ Side │ Main Content Area            │
│ Nav  │                              │
│ 240px│                              │
│      │                              │
│      │                              │
└──────┴──────────────────────────────┘
```

#### Dashboard Layout (JIRA-style)

```
┌─────────────────────────────────────┐
│ Top Navigation + Breadcrumbs        │
├──────┬──────────────────────────────┤
│Filter│ ┌──────┬──────┬──────────┐   │
│Panel │ │Widget│Widget│  Widget  │   │
│      │ └──────┴──────┴──────────┘   │
│      │ ┌────────────┬────────────┐  │
│      │ │  Widget    │  Widget    │  │
│      │ └────────────┴────────────┘  │
└──────┴──────────────────────────────┘
```

#### Detail Page Layout

```
┌─────────────────────────────────────┐
│ Top Navigation + Breadcrumbs        │
├─────────────────────────────────────┤
│ ┌─────────────────────┬───────────┐ │
│ │ Main Content        │  Sidebar  │ │
│ │ (2/3 width)         │ (1/3)     │ │
│ │                     │           │ │
│ │                     │           │ │
│ └─────────────────────┴───────────┘ │
└─────────────────────────────────────┘
```

---

## Navigation Patterns

### Primary Navigation

Following JIRA patterns:

1. **Top Bar**:
   - Logo (home link)
   - Main nav items (Dashboard, Projects, Tickets, Reports, etc.)
   - Search (global)
   - User menu (avatar + dropdown)
   - Settings icon
   - Notifications

2. **Sidebar (Collapsible)**:
   - Recent items
   - Favorites (starred)
   - Project list (tree view)
   - Quick actions
   - Collapse toggle

3. **Breadcrumbs**:
   - Always visible below top bar
   - Show hierarchy: Home > Projects > Project Name > Item
   - Clickable at each level

### Navigation States

```
Normal:     Item Name
Hover:      Item Name (background variant)
Active:     Item Name (primary color + left border)
Disabled:   Item Name (50% opacity)
```

### Mobile Navigation

```
┌─────────────────────────────────────┐
│ [≡] HelixTrack       [Search] [⚙️] │
├─────────────────────────────────────┤
│                                     │
│ Content area                        │
│                                     │
├─────────────────────────────────────┤
│ [Dashboard] [Projects] [Tickets]    │
└─────────────────────────────────────┘
```

**Mobile Nav Specifications**:
- Hamburger menu (left)
- Bottom tab bar (4-5 items)
- Slide-out drawer for full menu
- Swipe gestures supported

---

## Theme System

### Theme Detection

```typescript
// Detect system preference
const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

// Listen for changes
window.matchMedia('(prefers-color-scheme: dark)')
  .addEventListener('change', e => {
    const newTheme = e.matches ? 'dark' : 'light';
    applyTheme(newTheme);
  });
```

### Theme Storage

```typescript
// Store user preference
localStorage.setItem('theme', 'dark'); // or 'light' or 'auto'

// Load on app init
const storedTheme = localStorage.getItem('theme') || 'auto';
```

### Theme Application

#### CSS Variables Approach

```css
:root {
  --primary: #BCE63B;
  --background: #FFFFFF;
  --text: #1A1A1A;
  /* ... */
}

[data-theme="dark"] {
  --background: #0D0D0D;
  --text: #FFFFFF;
  /* Primary stays same */
}
```

#### Theme Toggle Component

```
┌──────────────────┐
│ Theme            │
│ ○ Light          │
│ ● Dark           │
│ ○ Auto (System)  │
└──────────────────┘
```

### Platform-Specific Implementations

#### Android (Material Design 3)

```kotlin
// MaterialTheme with dynamic colors
MaterialTheme(
    colorScheme = if (isDarkTheme) {
        darkColorScheme(
            primary = Color(0xFFBCE63B),
            background = Color(0xFF0D0D0D),
            // ...
        )
    } else {
        lightColorScheme(
            primary = Color(0xFFBCE63B),
            background = Color(0xFFFFFFFF),
            // ...
        )
    }
)
```

#### Web/Desktop (CSS)

```css
body {
  background: var(--background);
  color: var(--text);
  transition: background 0.3s ease, color 0.3s ease;
}
```

#### iOS (SwiftUI)

```swift
@Environment(\.colorScheme) var colorScheme

var backgroundColor: Color {
    colorScheme == .dark ? Color(hex: "0D0D0D") : Color.white
}
```

---

## Platform-Specific Guidelines

### Android (Material Design 3)

**Key Principles**:
- Material Design 3 components
- Ripple effects on all interactive elements
- FAB (Floating Action Button) for primary actions
- Bottom sheets for actions
- Snackbars for feedback

**Components**:
- `TopAppBar` with menu + search
- `NavigationBar` (bottom)
- `NavigationDrawer` (side)
- `FloatingActionButton`
- `Card` with elevation
- `TextField` with Material styling
- `Button` variants (Filled, Outlined, Text)

**Navigation**:
- Navigation component with backstack
- Bottom navigation for 3-5 top-level destinations
- Drawer for secondary navigation

### Web (Material/Bootstrap inspired)

**Key Principles**:
- Responsive design (mobile-first)
- Keyboard navigation
- ARIA labels for accessibility
- Progressive enhancement
- Fast load times

**Components**:
- Navbar (fixed top)
- Sidebar (collapsible)
- Cards with hover effects
- Modals (center-screen)
- Toast notifications (top-right)
- Form validation (inline)

**Navigation**:
- Top navbar (persistent)
- Sidebar (collapsible on mobile)
- Breadcrumbs below navbar
- Footer links

### Desktop (Tauri + Web)

**Key Principles**:
- Native window controls
- System menu bar integration
- Keyboard shortcuts (global)
- Drag and drop
- Native file dialogs

**Additional Features**:
- Title bar with native controls
- Menu bar (File, Edit, View, etc.)
- System tray icon
- Notifications (OS-level)
- Deep linking

### iOS (Human Interface Guidelines)

**Key Principles**:
- Large titles
- SF Symbols for icons
- SwiftUI native components
- Haptic feedback
- Pull-to-refresh
- Swipe gestures

**Components**:
- `NavigationView` with large titles
- `List` with inset grouped style
- `Form` for input screens
- `Sheet` for modals
- `Alert` for confirmations
- `ContextMenu` for long-press

**Navigation**:
- Tab bar (bottom, 4-5 items)
- Navigation stack with back button
- Modal sheets for tasks
- Swipe back gesture

---

## Accessibility

### WCAG 2.1 AA Compliance

#### Color Contrast

| Element | Minimum Ratio | Target Ratio |
|---------|---------------|--------------|
| Normal Text | 4.5:1 | 7:1 (AAA) |
| Large Text (18px+) | 3:1 | 4.5:1 (AAA) |
| UI Components | 3:1 | 4.5:1 |
| Graphical Objects | 3:1 | 4.5:1 |

**Contrast Checking**:
- Primary (#BCE63B) on Dark (#1A1A1A): 9.8:1 ✅
- Primary (#BCE63B) on White (#FFFFFF): 1.9:1 ❌ (needs dark text)
- Secondary (#7AA590) on White: 2.4:1 ❌ (needs adjustment)

#### Keyboard Navigation

- All interactive elements: `tabindex` order
- Focus indicators: 2px outline, primary color
- Skip links: "Skip to main content"
- Shortcut keys: Document all shortcuts

#### Screen Reader Support

- Semantic HTML: `<header>`, `<nav>`, `<main>`, `<article>`, `<aside>`, `<footer>`
- ARIA labels: `aria-label`, `aria-labelledby`, `aria-describedby`
- ARIA roles: `role="button"`, `role="navigation"`, etc.
- Alt text: All images and icons

#### Focus Management

```css
:focus-visible {
  outline: 2px solid var(--primary);
  outline-offset: 2px;
  border-radius: 4px;
}

*:focus:not(:focus-visible) {
  outline: none;
}
```

#### Motion & Animation

- Respect `prefers-reduced-motion`
- Disable animations for users who prefer reduced motion
- Provide alternative feedback (color, text)

```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## Responsive Design

### Breakpoints

| Name | Min Width | Max Width | Columns | Gutter |
|------|-----------|-----------|---------|--------|
| **Mobile** | 0px | 767px | 4 | 16px |
| **Tablet** | 768px | 1023px | 8 | 24px |
| **Desktop** | 1024px | 1439px | 12 | 32px |
| **Wide** | 1440px | ∞ | 12 | 32px |

### Responsive Patterns

#### Stack to Columns

```
Mobile:      Desktop:
┌─────────┐  ┌────┬────┬────┐
│  Item 1 │  │Item│Item│Item│
├─────────┤  │ 1  │ 2  │ 3  │
│  Item 2 │  └────┴────┴────┘
├─────────┤
│  Item 3 │
└─────────┘
```

#### Hide/Show

```
Mobile:      Desktop:
┌─────────┐  ┌─────┬────────┐
│  Main   │  │Side │  Main  │
│ Content │  │ bar │ Content│
└─────────┘  └─────┴────────┘
(Sidebar in drawer)
```

#### Reflow Text

- Mobile: 100% width, single column
- Tablet: 100% width, wider column
- Desktop: Max 75ch width for readability

### Touch Targets

- Minimum size: 44×44px (iOS), 48×48px (Android)
- Spacing: 8px minimum between targets
- Increase on mobile: Use larger buttons/inputs

---

## Animation & Transitions

### Timing Functions

```css
--ease-in: cubic-bezier(0.4, 0, 1, 1);
--ease-out: cubic-bezier(0, 0, 0.2, 1);
--ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
--bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55);
```

### Duration Scale

| Duration | Usage |
|----------|-------|
| **50ms** | Micro-interactions (tooltips) |
| **100ms** | Small movements (hover) |
| **200ms** | Standard transitions (buttons) |
| **300ms** | Medium animations (modals fade) |
| **500ms** | Large animations (page transitions) |
| **1000ms** | Hero animations |

### Common Animations

#### Fade In/Out

```css
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

.fade-in {
  animation: fadeIn 300ms ease-out;
}
```

#### Slide In

```css
@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

#### Scale (Modal)

```css
@keyframes scaleIn {
  from {
    opacity: 0;
    transform: scale(0.9);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}
```

#### Ripple (Material)

```css
@keyframes ripple {
  to {
    transform: scale(4);
    opacity: 0;
  }
}

.ripple {
  animation: ripple 600ms ease-out;
}
```

---

## Icon System

### Icon Library

**Primary**: [Material Design Icons](https://materialdesignicons.com/) (Material Symbols)
**iOS**: SF Symbols
**Size Scale**: 16px, 20px, 24px, 32px, 48px, 64px

### Icon Usage

| Context | Size | Usage |
|---------|------|-------|
| **Button Icon** | 20px | Inside buttons |
| **List Icon** | 24px | Next to list items |
| **Header Icon** | 32px | Section headers |
| **Hero Icon** | 48-64px | Empty states, illustrations |

### Icon Colors

- **Default**: Text secondary color
- **Active**: Primary color
- **Disabled**: Text disabled color
- **Error**: Error color
- **Success**: Success color

---

## Data Visualization

### Charts

**Library**: Chart.js (Web/Desktop), MPAndroidChart (Android), Charts (iOS)

#### Common Chart Types

1. **Line Chart**: Trends over time (burndown, velocity)
2. **Bar Chart**: Comparisons (tickets by status, priority)
3. **Pie Chart**: Proportions (time spent, ticket distribution)
4. **Donut Chart**: Similar to pie, with center space for total
5. **Stacked Bar**: Multiple dimensions (sprints with status breakdown)

#### Chart Colors

Use theme colors for consistency:
- Primary data: Primary color (#BCE63B)
- Secondary data: Secondary color (#7AA590)
- Tertiary data: Accent color (#B2E3C2)
- Additional series: Error, Warning, Info, Success colors

### Tables with Data

- **Sortable headers**: Arrow icon (up/down)
- **Filters**: Filter icon + dropdown
- **Pagination**: Bottom, show items per page
- **Row actions**: Kebab menu or action buttons on hover

---

## Form Design

### Form Layout

#### Vertical (Preferred)

```
┌─────────────────────────────────────┐
│ Label                               │
│ [Input field]                       │
│                                     │
│ Label                               │
│ [Input field]                       │
│                                     │
│ [Cancel] [Submit]                   │
└─────────────────────────────────────┘
```

#### Horizontal (Compact)

```
┌─────────────────────────────────────┐
│ Label:        [Input field]         │
│ Long Label:   [Input field]         │
│                         [Submit]    │
└─────────────────────────────────────┘
```

### Form Validation

#### Inline Validation (Immediate)

```
┌─────────────────────────────────────┐
│ Email                               │
│ [invalid-email@]                    │
│ ❌ Invalid email format              │
└─────────────────────────────────────┘
```

#### Success State

```
┌─────────────────────────────────────┐
│ Email                               │
│ [user@example.com]                  │
│ ✅ Email is valid                    │
└─────────────────────────────────────┘
```

#### On Submit (Summary)

```
┌─────────────────────────────────────┐
│ ❌ Please fix the following errors: │
│  • Email is required                │
│  • Password must be 8+ characters   │
│  • Username is already taken        │
└─────────────────────────────────────┘
```

### Required Fields

- Asterisk (*) after label: "Email *"
- Or note at top: "* Required fields"

### Helper Text

```
┌─────────────────────────────────────┐
│ Password                            │
│ [••••••••]                          │
│ ℹ Must be at least 8 characters     │
└─────────────────────────────────────┘
```

---

## Error Handling

### Error Levels

1. **Field Error**: Inline, red text below field
2. **Form Error**: Summary box at top of form
3. **Toast/Snackbar**: Temporary notification (5s)
4. **Modal**: Critical errors (session expired)
5. **Page Error**: Full page (404, 500)

### Error Messages

**Good**:
- "Email is required"
- "Password must be at least 8 characters"
- "Failed to save ticket. Please try again."

**Bad**:
- "Error: validation_error_001"
- "Something went wrong"
- "NULL pointer exception at line 42"

### Error Page (404/500)

```
┌─────────────────────────────────────┐
│         :(                          │
│                                     │
│    Page Not Found (404)             │
│                                     │
│  The page you're looking for        │
│  doesn't exist or has been moved.   │
│                                     │
│   [Go to Dashboard] [Go Back]       │
└─────────────────────────────────────┘
```

---

## Loading States

### Skeleton Screens

Preferred over spinners for better perceived performance.

```
┌─────────────────────────────────────┐
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                │
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    │
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                │
│                                     │
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                │
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    │
└─────────────────────────────────────┘
```

### Progress Indicators

1. **Spinner**: Unknown duration, continuous
2. **Progress Bar**: Known duration, % complete
3. **Skeleton**: Content loading

### Loading Text

- "Loading..." (generic)
- "Loading tickets..." (specific)
- "Saving..." (action in progress)
- "Syncing..." (background operation)

---

## Empty States

### Zero State (No Data Yet)

```
┌─────────────────────────────────────┐
│                                     │
│         [📋 Icon]                   │
│                                     │
│      No Tickets Yet                 │
│                                     │
│  Create your first ticket to        │
│  get started with your project.     │
│                                     │
│      [+ Create Ticket]              │
│                                     │
└─────────────────────────────────────┘
```

### No Results (After Search/Filter)

```
┌─────────────────────────────────────┐
│                                     │
│         [🔍 Icon]                   │
│                                     │
│   No Results Found                  │
│                                     │
│  Try adjusting your search or       │
│  filters to find what you need.     │
│                                     │
│      [Clear Filters]                │
│                                     │
└─────────────────────────────────────┘
```

### Error State (Failed to Load)

```
┌─────────────────────────────────────┐
│                                     │
│         [⚠️ Icon]                    │
│                                     │
│   Failed to Load Data               │
│                                     │
│  Something went wrong. Please       │
│  try again or contact support.      │
│                                     │
│      [Try Again] [Contact Support]  │
│                                     │
└─────────────────────────────────────┘
```

---

## JIRA/Confluence Alignment

### JIRA-Inspired Features

1. **Issue Keys**: `PROJ-123` format (monospace, clickable)
2. **Quick Create**: `+` button (fixed bottom-right or header)
3. **Board Views**: Kanban, Scrum boards with swimlanes
4. **Filters**: Save and share custom filters
5. **Dashboards**: Configurable widgets
6. **Activity Stream**: Recent activity feed
7. **Watchers**: Follow tickets/documents
8. **Mentions**: @username in comments
9. **Rich Editor**: Text formatting, code blocks, tables

### Confluence-Inspired Features (Documents V2)

1. **Spaces**: Organize documents by space
2. **Page Tree**: Hierarchical document structure
3. **Version History**: See all changes, compare, revert
4. **Templates**: Pre-built document templates
5. **Macros**: Expandable content blocks
6. **Labels**: Tag documents for organization
7. **Attachments**: Add files to documents
8. **Comments**: Threaded discussions
9. **Permissions**: Control who can view/edit
10. **Export**: PDF, Word, HTML formats

### Navigation Similarities

**JIRA**:
- Sidebar: Projects, Filters, Dashboards
- Top bar: Create, Search, Notifications, Profile
- Breadcrumbs: Project > Board > Issue

**HelixTrack** (Match this):
- Sidebar: Projects, Teams, Filters, Boards, Reports
- Top bar: Create, Search, Notifications, Settings, Profile
- Breadcrumbs: Home > Projects > [Project] > Tickets > [Ticket]

### Visual Similarities

**Colors**:
- JIRA uses blue primary (#0052CC)
- HelixTrack uses green primary (#BCE63B) - Different but recognizable

**Layout**:
- Three-column layout (list, detail, sidebar)
- Cards for tickets/issues
- Modals for quick actions
- Inline editing where possible

**Components**:
- Issue type icons (Bug, Story, Task, Epic)
- Priority icons (Critical, High, Medium, Low)
- Status badges (Open, In Progress, Done)
- Assignee avatars
- Story point badges

---

## Implementation Checklist

### For Each Platform

- [ ] Extract brand colors from website
- [ ] Define light theme color palette
- [ ] Define dark theme color palette
- [ ] Implement theme detection (system preference)
- [ ] Implement theme storage (user preference)
- [ ] Implement theme switching (manual)
- [ ] Create color constants/variables
- [ ] Apply colors to all components
- [ ] Implement typography scale
- [ ] Apply font families and sizes
- [ ] Create component library
- [ ] Implement button variants
- [ ] Implement input fields
- [ ] Implement cards
- [ ] Implement lists
- [ ] Implement tables
- [ ] Implement modals
- [ ] Implement navigation components
- [ ] Implement layout system
- [ ] Implement grid system
- [ ] Test all components in light theme
- [ ] Test all components in dark theme
- [ ] Verify contrast ratios (WCAG AA)
- [ ] Test keyboard navigation
- [ ] Test screen reader support
- [ ] Test responsive breakpoints
- [ ] Test animations and transitions
- [ ] Document all components
- [ ] Create UI/UX diagrams
- [ ] Update tests for theme support
- [ ] Verify all screens follow specification

---

## Next Steps

1. **Implement Themes** for each platform (Android, Web, Desktop, iOS)
2. **Create .drawio Diagrams** showing complete UI/UX flows
3. **Update Tests** to cover theme switching and component variations
4. **Run Comprehensive Tests** to verify 100% implementation
5. **Document Results** with screenshots and test reports

---

**Document Version**: 2.0.0
**Last Updated**: 2025-10-18
**Maintained By**: HelixTrack UI/UX Team

---
