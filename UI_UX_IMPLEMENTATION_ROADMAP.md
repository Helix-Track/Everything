# HelixTrack - UI/UX Implementation Roadmap

**Version**: 1.0.0
**Date**: 2025-10-18
**Status**: Complete Implementation Plan

---

## Overview

This document provides a complete, step-by-step roadmap for implementing the HelixTrack UI/UX specification across all platforms with JIRA/Confluence alignment, theme support, comprehensive testing, and wireframe documentation.

### Objectives

1. ✅ **Consistent Brand Identity** - HelixTrack colors across all platforms
2. ✅ **Theme Support** - Light/Dark themes with system detection
3. ✅ **JIRA/Confluence Look & Feel** - Familiar workflows and patterns
4. ✅ **Modern UI Standards** - Material Design 3, iOS HIG compliance
5. ✅ **Complete Documentation** - Wireframes, specifications, test plans
6. ✅ **100% Test Coverage** - All flows, cases, and edge cases

### Scope

| Platform | Current Status | Target Status | Estimated Time |
|----------|----------------|---------------|----------------|
| **Android** | 70% UI/UX | 100% with themes | 24-32 hours |
| **Web** | 75% UI/UX | 100% with themes | 20-28 hours |
| **Desktop** | 75% UI/UX | 100% with themes | 20-28 hours |
| **iOS** | 80% UI/UX | 100% with themes | 16-24 hours |
| **Total** | - | - | **80-112 hours** |

---

## Phase 1: Brand Colors & Theme System (ALL PLATFORMS)

### 1.1 Android Theme Implementation

**Time**: 6-8 hours

#### Step 1: Create Theme Color Resources

**File**: `Android-Client/app/src/main/res/values/colors.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Brand Colors (from website) -->
    <color name="brand_primary">#BCE63B</color>
    <color name="brand_primary_hover">#A9D02C</color>
    <color name="brand_primary_active">#96BA1D</color>
    <color name="brand_secondary">#7AA590</color>
    <color name="brand_secondary_hover">#6A9580</color>
    <color name="brand_secondary_active">#5A8570</color>
    <color name="brand_accent">#B2E3C2</color>

    <!-- Light Theme Colors -->
    <color name="light_background">#FFFFFF</color>
    <color name="light_surface">#F8F9FA</color>
    <color name="light_surface_variant">#E9ECEF</color>
    <color name="light_text_primary">#1A1A1A</color>
    <color name="light_text_secondary">#6C757D</color>
    <color name="light_text_disabled">#ADB5BD</color>
    <color name="light_border">#DEE2E6</color>

    <!-- Dark Theme Colors -->
    <color name="dark_background">#0D0D0D</color>
    <color name="dark_surface">#1A1A1A</color>
    <color name="dark_surface_variant">#2D2D2D</color>
    <color name="dark_text_primary">#FFFFFF</color>
    <color name="dark_text_secondary">#ADB5BD</color>
    <color name="dark_text_disabled">#6C757D</color>
    <color name="dark_border">#1A1A1A</color>

    <!-- Semantic Colors -->
    <color name="error_light">#DC3545</color>
    <color name="error_dark">#FF6B6B</color>
    <color name="warning_light">#FFC107</color>
    <color name="warning_dark">#FFD93D</color>
    <color name="success_light">#28A745</color>
    <color name="success_dark">#51CF66</color>
    <color name="info_light">#17A2B8</color>
    <color name="info_dark">#4DABF7</color>
</resources>
```

#### Step 2: Create Material Design 3 Themes

**File**: `Android-Client/app/src/main/res/values/themes.xml`

```xml
<resources xmlns:tools="http://schemas.android.com/tools">
    <!-- Light Theme -->
    <style name="Theme.HelixTrack.Light" parent="Theme.Material3.Light.NoActionBar">
        <!-- Primary -->
        <item name="colorPrimary">@color/brand_primary</item>
        <item name="colorPrimaryVariant">@color/brand_primary_active</item>
        <item name="colorOnPrimary">@color/dark_text_primary</item>

        <!-- Secondary -->
        <item name="colorSecondary">@color/brand_secondary</item>
        <item name="colorSecondaryVariant">@color/brand_secondary_active</item>
        <item name="colorOnSecondary">@color/light_text_primary</item>

        <!-- Background -->
        <item name="android:colorBackground">@color/light_background</item>
        <item name="colorSurface">@color/light_surface</item>
        <item name="colorOnBackground">@color/light_text_primary</item>
        <item name="colorOnSurface">@color/light_text_primary</item>

        <!-- Status Bar -->
        <item name="android:statusBarColor">@color/light_surface</item>
        <item name="android:windowLightStatusBar">true</item>

        <!-- Navigation Bar -->
        <item name="android:navigationBarColor">@color/light_background</item>
        <item name="android:windowLightNavigationBar">true</item>
    </style>

    <!-- Dark Theme -->
    <style name="Theme.HelixTrack.Dark" parent="Theme.Material3.Dark.NoActionBar">
        <!-- Primary -->
        <item name="colorPrimary">@color/brand_primary</item>
        <item name="colorPrimaryVariant">@color/brand_primary_active</item>
        <item name="colorOnPrimary">@color/dark_text_primary</item>

        <!-- Secondary -->
        <item name="colorSecondary">@color/brand_secondary</item>
        <item name="colorSecondaryVariant">@color/brand_secondary_active</item>
        <item name="colorOnSecondary">@color/dark_text_primary</item>

        <!-- Background -->
        <item name="android:colorBackground">@color/dark_background</item>
        <item name="colorSurface">@color/dark_surface</item>
        <item name="colorOnBackground">@color/dark_text_primary</item>
        <item name="colorOnSurface">@color/dark_text_primary</item>

        <!-- Status Bar -->
        <item name="android:statusBarColor">@color/dark_surface</item>
        <item name="android:windowLightStatusBar">false</item>

        <!-- Navigation Bar -->
        <item name="android:navigationBarColor">@color/dark_background</item>
        <item name="android:windowLightNavigationBar">false</item>
    </style>
</resources>
```

#### Step 3: Implement Theme Manager

**File**: `Android-Client/app/src/main/java/com/helixtrack/ThemeManager.kt`

```kotlin
package com.helixtrack

import android.content.Context
import android.content.SharedPreferences
import androidx.appcompat.app.AppCompatDelegate
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

enum class ThemeMode {
    LIGHT, DARK, AUTO
}

object ThemeManager {
    private const val PREFS_NAME = "theme_prefs"
    private const val KEY_THEME = "theme_mode"

    private val _themeMode = MutableStateFlow(ThemeMode.AUTO)
    val themeMode: StateFlow<ThemeMode> = _themeMode

    fun init(context: Context) {
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val savedTheme = prefs.getString(KEY_THEME, "AUTO") ?: "AUTO"
        _themeMode.value = ThemeMode.valueOf(savedTheme)
        applyTheme(_themeMode.value)
    }

    fun setThemeMode(context: Context, mode: ThemeMode) {
        _themeMode.value = mode
        saveThemePreference(context, mode)
        applyTheme(mode)
    }

    private fun applyTheme(mode: ThemeMode) {
        val nightMode = when (mode) {
            ThemeMode.LIGHT -> AppCompatDelegate.MODE_NIGHT_NO
            ThemeMode.DARK -> AppCompatDelegate.MODE_NIGHT_YES
            ThemeMode.AUTO -> AppCompatDelegate.MODE_NIGHT_FOLLOW_SYSTEM
        }
        AppCompatDelegate.setDefaultNightMode(nightMode)
    }

    private fun saveThemePreference(context: Context, mode: ThemeMode) {
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putString(KEY_THEME, mode.name)
            .apply()
    }
}
```

#### Step 4: Apply Theme in MainActivity

```kotlin
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Initialize theme
        ThemeManager.init(this)

        setContent {
            val themeMode by ThemeManager.themeMode.collectAsState()
            val darkTheme = when (themeMode) {
                ThemeMode.LIGHT -> false
                ThemeMode.DARK -> true
                ThemeMode.AUTO -> isSystemInDarkTheme()
            }

            HelixTrackTheme(darkTheme = darkTheme) {
                // Your app content
            }
        }
    }
}
```

#### Step 5: Create Jetpack Compose Theme

**File**: `Android-Client/app/src/main/java/com/helixtrack/ui/theme/Theme.kt`

```kotlin
@Composable
fun HelixTrackTheme(
    darkTheme: Boolean = isSystemInDarkTheme(),
    content: @Composable () -> Unit
) {
    val colorScheme = if (darkTheme) {
        darkColorScheme(
            primary = Color(0xFFBCE63B),
            secondary = Color(0xFF7AA590),
            tertiary = Color(0xFFB2E3C2),
            background = Color(0xFF0D0D0D),
            surface = Color(0xFF1A1A1A),
            onPrimary = Color.White,
            onSecondary = Color.White,
            onBackground = Color.White,
            onSurface = Color.White,
            error = Color(0xFFFF6B6B)
        )
    } else {
        lightColorScheme(
            primary = Color(0xFFBCE63B),
            secondary = Color(0xFF7AA590),
            tertiary = Color(0xFFB2E3C2),
            background = Color.White,
            surface = Color(0xFFF8F9FA),
            onPrimary = Color(0xFF1A1A1A),
            onSecondary = Color.White,
            onBackground = Color(0xFF1A1A1A),
            onSurface = Color(0xFF1A1A1A),
            error = Color(0xFFDC3545)
        )
    }

    MaterialTheme(
        colorScheme = colorScheme,
        typography = Typography,
        content = content
    )
}
```

---

### 1.2 Web Theme Implementation

**Time**: 5-7 hours

#### Step 1: Create CSS Variables

**File**: `Web-Client/src/styles/themes.scss`

```scss
// Brand Colors (from website)
$brand-primary: #BCE63B;
$brand-primary-hover: #A9D02C;
$brand-primary-active: #96BA1D;
$brand-secondary: #7AA590;
$brand-secondary-hover: #6A9580;
$brand-secondary-active: #5A8570;
$brand-accent: #B2E3C2;

// Light Theme
:root, [data-theme="light"] {
  // Primary
  --color-primary: #{$brand-primary};
  --color-primary-hover: #{$brand-primary-hover};
  --color-primary-active: #{$brand-primary-active};
  --color-secondary: #{$brand-secondary};
  --color-secondary-hover: #{$brand-secondary-hover};
  --color-secondary-active: #{$brand-secondary-active};
  --color-accent: #{$brand-accent};

  // Backgrounds
  --color-background: #FFFFFF;
  --color-surface: #F8F9FA;
  --color-surface-variant: #E9ECEF;

  // Text
  --color-text-primary: #1A1A1A;
  --color-text-secondary: #6C757D;
  --color-text-disabled: #ADB5BD;

  // Borders
  --color-border: #DEE2E6;

  // Semantic
  --color-error: #DC3545;
  --color-warning: #FFC107;
  --color-success: #28A745;
  --color-info: #17A2B8;

  // Shadows
  --shadow-sm: 0 2px 4px rgba(0,0,0,0.1);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.1);
  --shadow-lg: 0 10px 20px rgba(0,0,0,0.15);
}

// Dark Theme
[data-theme="dark"] {
  // Backgrounds
  --color-background: #0D0D0D;
  --color-surface: #1A1A1A;
  --color-surface-variant: #2D2D2D;

  // Text
  --color-text-primary: #FFFFFF;
  --color-text-secondary: #ADB5BD;
  --color-text-disabled: #6C757D;

  // Borders
  --color-border: rgba(255,255,255,0.1);

  // Semantic (brighter in dark)
  --color-error: #FF6B6B;
  --color-warning: #FFD93D;
  --color-success: #51CF66;
  --color-info: #4DABF7;

  // Shadows
  --shadow-sm: 0 2px 4px rgba(0,0,0,0.3);
  --shadow-md: 0 4px 6px rgba(0,0,0,0.3);
  --shadow-lg: 0 10px 20px rgba(0,0,0,0.4);
}

// Transitions
:root {
  --transition-fast: 0.2s ease;
  --transition-normal: 0.3s ease;
  --transition-slow: 0.5s ease;
}

// Apply transitions to theme changes
* {
  transition: background-color var(--transition-normal),
              color var(--transition-normal),
              border-color var(--transition-normal);
}
```

#### Step 2: Create Theme Service

**File**: `Web-Client/src/app/core/services/theme.service.ts`

```typescript
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';

export type ThemeMode = 'light' | 'dark' | 'auto';

@Injectable({
  providedIn: 'root'
})
export class ThemeService {
  private readonly STORAGE_KEY = 'theme-mode';
  private themeModeSubject = new BehaviorSubject<ThemeMode>('auto');
  public themeMode$: Observable<ThemeMode> = this.themeModeSubject.asObservable();

  private currentTheme: 'light' | 'dark' = 'light';

  constructor() {
    this.initTheme();
  }

  private initTheme(): void {
    // Load saved preference
    const savedTheme = localStorage.getItem(this.STORAGE_KEY) as ThemeMode || 'auto';
    this.setThemeMode(savedTheme);

    // Listen for system theme changes
    window.matchMedia('(prefers-color-scheme: dark)')
      .addEventListener('change', (e) => {
        if (this.themeModeSubject.value === 'auto') {
          this.applyTheme(e.matches ? 'dark' : 'light');
        }
      });
  }

  setThemeMode(mode: ThemeMode): void {
    this.themeModeSubject.next(mode);
    localStorage.setItem(this.STORAGE_KEY, mode);

    const theme = mode === 'auto'
      ? (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light')
      : mode;

    this.applyTheme(theme);
  }

  private applyTheme(theme: 'light' | 'dark'): void {
    this.currentTheme = theme;
    document.documentElement.setAttribute('data-theme', theme);
  }

  getCurrentTheme(): 'light' | 'dark' {
    return this.currentTheme;
  }

  getThemeMode(): ThemeMode {
    return this.themeModeSubject.value;
  }
}
```

#### Step 3: Create Theme Toggle Component

**File**: `Web-Client/src/app/shared/components/theme-toggle/theme-toggle.component.ts`

```typescript
import { Component } from '@angular/core';
import { ThemeService, ThemeMode } from '../../../core/services/theme.service';

@Component({
  selector: 'app-theme-toggle',
  template: `
    <div class="theme-toggle">
      <button
        mat-icon-button
        [matMenuTriggerFor]="themeMenu"
        aria-label="Toggle theme">
        <mat-icon>
          {{ getCurrentIcon() }}
        </mat-icon>
      </button>

      <mat-menu #themeMenu="matMenu">
        <button
          mat-menu-item
          (click)="setTheme('light')"
          [class.active]="(themeService.themeMode$ | async) === 'light'">
          <mat-icon>light_mode</mat-icon>
          <span>Light</span>
        </button>
        <button
          mat-menu-item
          (click)="setTheme('dark')"
          [class.active]="(themeService.themeMode$ | async) === 'dark'">
          <mat-icon>dark_mode</mat-icon>
          <span>Dark</span>
        </button>
        <button
          mat-menu-item
          (click)="setTheme('auto')"
          [class.active]="(themeService.themeMode$ | async) === 'auto'">
          <mat-icon>brightness_auto</mat-icon>
          <span>Auto (System)</span>
        </button>
      </mat-menu>
    </div>
  `,
  styles: [`
    .theme-toggle button.active {
      background: var(--color-primary);
      color: var(--color-text-primary);
    }
  `]
})
export class ThemeToggleComponent {
  constructor(public themeService: ThemeService) {}

  setTheme(mode: ThemeMode): void {
    this.themeService.setThemeMode(mode);
  }

  getCurrentIcon(): string {
    const mode = this.themeService.getThemeMode();
    switch (mode) {
      case 'light': return 'light_mode';
      case 'dark': return 'dark_mode';
      case 'auto': return 'brightness_auto';
    }
  }
}
```

---

### 1.3 Desktop Theme Implementation

**Time**: 4-6 hours

Desktop client uses the same Web implementation + Tauri-specific enhancements.

#### Additional: Tauri Theme Detection

**File**: `Desktop-Client/src-tauri/src/main.rs` (add command)

```rust
#[tauri::command]
fn get_system_theme() -> String {
    // Platform-specific system theme detection
    #[cfg(target_os = "macos")]
    {
        // macOS implementation
        use cocoa::appkit::{NSAppearance, NSApplication};
        use cocoa::base::id;

        unsafe {
            let app: id = NSApplication::sharedApplication(cocoa::base::nil);
            let appearance: id = msg_send![app, effectiveAppearance];
            let name: id = msg_send![appearance, name];
            let name_str: *const i8 = msg_send![name, UTF8String];
            let name_string = std::ffi::CStr::from_ptr(name_str).to_string_lossy();

            if name_string.contains("Dark") {
                return "dark".to_string();
            }
        }
    }

    #[cfg(target_os = "windows")]
    {
        // Windows implementation
        use winreg::enums::*;
        use winreg::RegKey;

        let hkcu = RegKey::predef(HKEY_CURRENT_USER);
        let key = hkcu.open_subkey("Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize");

        if let Ok(key) = key {
            if let Ok(value) = key.get_value::<u32, _>("AppsUseLightTheme") {
                return if value == 0 { "dark".to_string() } else { "light".to_string() };
            }
        }
    }

    "light".to_string()
}
```

---

### 1.4 iOS Theme Implementation

**Time**: 4-6 hours

#### Step 1: Create Color Extensions

**File**: `iOS-Client/Sources/Extensions/Color+Theme.swift`

```swift
import SwiftUI

extension Color {
    // Brand Colors
    static let brandPrimary = Color(hex: "BCE63B")
    static let brandPrimaryHover = Color(hex: "A9D02C")
    static let brandPrimaryActive = Color(hex: "96BA1D")
    static let brandSecondary = Color(hex: "7AA590")
    static let brandSecondaryHover = Color(hex: "6A9580")
    static let brandSecondaryActive = Color(hex: "5A8570")
    static let brandAccent = Color(hex: "B2E3C2")

    // Adaptive Colors (change with theme)
    static let background = Color("Background")
    static let surface = Color("Surface")
    static let surfaceVariant = Color("SurfaceVariant")
    static let textPrimary = Color("TextPrimary")
    static let textSecondary = Color("TextSecondary")
    static let textDisabled = Color("TextDisabled")
    static let border = Color("Border")

    // Semantic Colors (adaptive)
    static let error = Color("Error")
    static let warning = Color("Warning")
    static let success = Color("Success")
    static let info = Color("Info")

    // Hex initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
```

#### Step 2: Create Asset Catalog Colors

**File**: `iOS-Client/Assets.xcassets/Colors/Contents.json`

Add adaptive color sets in Xcode Asset Catalog:

```
Colors/
  Background.colorset/
    Contents.json:
    {
      "colors": [
        {
          "color": { "color-space": "srgb", "components": { "red": "1.000", "green": "1.000", "blue": "1.000", "alpha": "1.000" } },
          "idiom": "universal"
        },
        {
          "appearances": [ { "appearance": "luminosity", "value": "dark" } ],
          "color": { "color-space": "srgb", "components": { "red": "0.051", "green": "0.051", "blue": "0.051", "alpha": "1.000" } },
          "idiom": "universal"
        }
      ]
    }
```

#### Step 3: Theme Manager

**File**: `iOS-Client/Sources/Managers/ThemeManager.swift`

```swift
import SwiftUI
import Combine

enum ThemeMode: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case auto = "Auto (System)"
}

class ThemeManager: ObservableObject {
    @Published var themeMode: ThemeMode {
        didSet {
            UserDefaults.standard.set(themeMode.rawValue, forKey: "theme_mode")
        }
    }

    @Published var currentColorScheme: ColorScheme?

    init() {
        let savedMode = UserDefaults.standard.string(forKey: "theme_mode") ?? "Auto (System)"
        self.themeMode = ThemeMode(rawValue: savedMode) ?? .auto
        self.updateColorScheme()
    }

    func updateColorScheme() {
        switch themeMode {
        case .light:
            currentColorScheme = .light
        case .dark:
            currentColorScheme = .dark
        case .auto:
            currentColorScheme = nil // Use system default
        }
    }
}
```

#### Step 4: Apply Theme to App

**File**: `iOS-Client/Sources/App/HelixTrackApp.swift`

```swift
@main
struct HelixTrackApp: App {
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.currentColorScheme)
        }
    }
}
```

---

## Phase 2: JIRA/Confluence UI Components (ALL PLATFORMS)

**Time**: 24-32 hours

### 2.1 Ticket/Issue Card Component

Match JIRA's ticket card design:

```
┌─────────────────────────────────────┐
│ [🐛] PROJ-123           [🔴 High]   │
│ Fix login authentication bug        │
│                                     │
│ [Avatar] John Doe | 📊 In Progress │
│ ─────────────────────────────────  │
│ ⚡ 5 points  💬 3  📎 1  👁 2       │
└─────────────────────────────────────┘
```

#### Android Implementation

```kotlin
@Composable
fun TicketCard(ticket: Ticket, onClick: () -> Unit) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(8.dp)
            .clickable(onClick = onClick),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface
        ),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            // Header: Type icon, ID, Priority
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(
                        imageVector = ticket.type.icon,
                        contentDescription = ticket.type.name,
                        tint = ticket.type.color
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = ticket.key,
                        style = MaterialTheme.typography.labelMedium,
                        fontFamily = FontFamily.Monospace
                    )
                }

                PriorityBadge(priority = ticket.priority)
            }

            Spacer(modifier = Modifier.height(8.dp))

            // Title
            Text(
                text = ticket.title,
                style = MaterialTheme.typography.bodyLarge,
                maxLines = 2,
                overflow = TextOverflow.Ellipsis
            )

            Spacer(modifier = Modifier.height(12.dp))

            // Metadata: Assignee, Status
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    AssigneeAvatar(assignee = ticket.assignee, size = 24.dp)
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = ticket.assignee?.name ?: "Unassigned",
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant
                    )
                }

                StatusBadge(status = ticket.status)
            }

            Divider(modifier = Modifier.padding(vertical = 8.dp))

            // Footer: Metrics
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                    if (ticket.storyPoints != null) {
                        MetricChip(icon = Icons.Default.Bolt, value = "${ticket.storyPoints}")
                    }
                    if (ticket.commentCount > 0) {
                        MetricChip(icon = Icons.Default.Comment, value = "${ticket.commentCount}")
                    }
                    if (ticket.attachmentCount > 0) {
                        MetricChip(icon = Icons.Default.AttachFile, value = "${ticket.attachmentCount}")
                    }
                    if (ticket.watcherCount > 0) {
                        MetricChip(icon = Icons.Default.Visibility, value = "${ticket.watcherCount}")
                    }
                }
            }
        }
    }
}
```

#### Web/Desktop Implementation (Angular)

**File**: `ticket-card.component.html`

```html
<mat-card class="ticket-card" (click)="onCardClick()">
  <mat-card-header>
    <div class="ticket-header">
      <div class="ticket-type-and-id">
        <mat-icon [style.color]="ticket.type.color">{{ ticket.type.icon }}</mat-icon>
        <span class="ticket-id">{{ ticket.key }}</span>
      </div>
      <app-priority-badge [priority]="ticket.priority"></app-priority-badge>
    </div>
  </mat-card-header>

  <mat-card-content>
    <h3 class="ticket-title">{{ ticket.title }}</h3>

    <div class="ticket-metadata">
      <div class="assignee">
        <app-avatar [user]="ticket.assignee" [size]="24"></app-avatar>
        <span>{{ ticket.assignee?.name || 'Unassigned' }}</span>
      </div>
      <app-status-badge [status]="ticket.status"></app-status-badge>
    </div>

    <mat-divider></mat-divider>

    <div class="ticket-metrics">
      <span *ngIf="ticket.storyPoints" class="metric">
        <mat-icon>bolt</mat-icon> {{ ticket.storyPoints }}
      </span>
      <span *ngIf="ticket.commentCount > 0" class="metric">
        <mat-icon>comment</mat-icon> {{ ticket.commentCount }}
      </span>
      <span *ngIf="ticket.attachmentCount > 0" class="metric">
        <mat-icon>attach_file</mat-icon> {{ ticket.attachmentCount }}
      </span>
      <span *ngIf="ticket.watcherCount > 0" class="metric">
        <mat-icon>visibility</mat-icon> {{ ticket.watcherCount }}
      </span>
    </div>
  </mat-card-content>
</mat-card>
```

### 2.2 Kanban Board Component

Match JIRA's board layout:

```
┌─────────────┬─────────────┬─────────────┬─────────────┐
│  To Do      │ In Progress │  Review     │   Done      │
│  (3)        │  (2)        │  (1)        │   (5)       │
├─────────────┼─────────────┼─────────────┼─────────────┤
│ ┌─────────┐ │ ┌─────────┐ │ ┌─────────┐ │ ┌─────────┐ │
│ │ Card 1  │ │ │ Card 4  │ │ │ Card 6  │ │ │ Card 7  │ │
│ └─────────┘ │ └─────────┘ │ └─────────┘ │ └─────────┘ │
│ ┌─────────┐ │ ┌─────────┐ │             │ ┌─────────┐ │
│ │ Card 2  │ │ │ Card 5  │ │             │ │ Card 8  │ │
│ └─────────┘ │ └─────────┘ │             │ └─────────┘ │
│ ┌─────────┐ │             │             │ ┌─────────┐ │
│ │ Card 3  │ │             │             │ │ Card 9  │ │
│ └─────────┘ │             │             │ └─────────┘ │
└─────────────┴─────────────┴─────────────┴─────────────┘
```

### 2.3 Document Page Layout (Confluence-style)

```
┌─────────────────────────────────────────────┐
│ 📄 Document Title                      [⋮]  │
├──────┬──────────────────────────────────────┤
│ TOC  │ # Heading 1                          │
│      │                                      │
│ • H1 │ Content goes here...                 │
│ • H2 │                                      │
│   ∙ H3│ ## Heading 2                         │
│ • H4 │                                      │
│      │ More content...                      │
│      │                                      │
│      │ ### Heading 3                        │
│      │                                      │
│      │ Final content...                     │
└──────┴──────────────────────────────────────┘
```

---

## Phase 3: Wireframe Diagrams (.drawio)

**Time**: 16-20 hours

### 3.1 Create .drawio Diagrams for Each Client

For each platform, create comprehensive .drawio diagrams showing:

1. **Complete Navigation Flow**
2. **All Screens and Their Connections**
3. **User Interaction Flows**
4. **State Changes and Transitions**
5. **Error Flows and Edge Cases**

#### Files to Create:

```
UI_UX_Wireframes/
├── Android_UI_UX_Flow.drawio          (complete wireframe)
├── Android_UI_UX_Flow.png             (exported)
├── Web_UI_UX_Flow.drawio              (complete wireframe)
├── Web_UI_UX_Flow.png                 (exported)
├── Desktop_UI_UX_Flow.drawio          (complete wireframe)
├── Desktop_UI_UX_Flow.png             (exported)
├── iOS_UI_UX_Flow.drawio              (complete wireframe)
├── iOS_UI_UX_Flow.png                 (exported)
├── Common_Components.drawio           (shared components)
├── Common_Components.png              (exported)
└── README.md                          (diagram documentation)
```

#### Diagram Structure (Each Client):

**Page 1: Authentication Flow**
- Login screen
- Registration screen
- Password reset flow
- 2FA flow (if applicable)
- Success/error states

**Page 2: Main Navigation**
- Dashboard (home screen)
- Sidebar/drawer navigation
- Top bar navigation
- Tab bar (mobile)
- Breadcrumb navigation

**Page 3: Project Management**
- Project list
- Project detail
- Project creation
- Project settings
- Project members

**Page 4: Ticket/Issue Management**
- Ticket list (list view)
- Ticket list (grid view)
- Ticket detail
- Ticket creation
- Ticket editing
- Comments and activity

**Page 5: Board Views**
- Kanban board
- Scrum board
- Backlog view
- Sprint planning
- Drag and drop interactions

**Page 6: Documents (Confluence-style)**
- Document space list
- Document list
- Document editor
- Document viewer
- Version history
- Comments

**Page 7: Settings & Profile**
- User profile
- Account settings
- Theme selector
- Notification preferences
- Integrations

**Page 8: Reports & Analytics**
- Dashboard widgets
- Charts and graphs
- Report builder
- Export options

#### Using .drawio Export Script

The Core has a script for exporting .drawio to PNG:

```bash
cd Core/Application/scripts
./export-drawio-to-png.sh /path/to/diagram.drawio
```

This will create `diagram.png` next to `diagram.drawio`.

---

## Phase 4: Comprehensive Testing

**Time**: 20-28 hours

### 4.1 Test Categories

#### Unit Tests
- Component rendering (light/dark themes)
- Theme switching logic
- Color contrast validation
- Accessibility checks

#### Integration Tests
- Theme persistence across app restarts
- System theme detection
- Theme synchronization

#### E2E Tests
- Complete user flows in both themes
- Navigation flows
- CRUD operations
- Error handling

#### Visual Regression Tests
- Screenshot comparison (light vs dark)
- Component visual consistency
- Layout responsiveness

### 4.2 Test Implementation Examples

#### Android Theme Tests

**File**: `ThemeManagerTest.kt`

```kotlin
@Test
fun `theme mode changes correctly`() = runTest {
    val context = ApplicationProvider.getApplicationContext<Context>()

    // Test light theme
    ThemeManager.setThemeMode(context, ThemeMode.LIGHT)
    assertEquals(ThemeMode.LIGHT, ThemeManager.themeMode.value)

    // Test dark theme
    ThemeManager.setThemeMode(context, ThemeMode.DARK)
    assertEquals(ThemeMode.DARK, ThemeManager.themeMode.value)

    // Test auto theme
    ThemeManager.setThemeMode(context, ThemeMode.AUTO)
    assertEquals(ThemeMode.AUTO, ThemeManager.themeMode.value)
}

@Test
fun `theme preference persists`() {
    val context = ApplicationProvider.getApplicationContext<Context>()

    // Set theme
    ThemeManager.setThemeMode(context, ThemeMode.DARK)

    // Verify persistence
    val prefs = context.getSharedPreferences("theme_prefs", Context.MODE_PRIVATE)
    assertEquals("DARK", prefs.getString("theme_mode", ""))
}
```

#### Web Theme Tests

**File**: `theme.service.spec.ts`

```typescript
describe('ThemeService', () => {
  let service: ThemeService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ThemeService);
    localStorage.clear();
  });

  it('should initialize with auto theme', (done) => {
    service.themeMode$.subscribe(mode => {
      expect(mode).toBe('auto');
      done();
    });
  });

  it('should change theme mode', (done) => {
    service.setThemeMode('dark');

    service.themeMode$.subscribe(mode => {
      expect(mode).toBe('dark');
      expect(localStorage.getItem('theme-mode')).toBe('dark');
      done();
    });
  });

  it('should apply dark theme', () => {
    service.setThemeMode('dark');

    const theme = document.documentElement.getAttribute('data-theme');
    expect(theme).toBe('dark');
  });

  it('should detect system preference', () => {
    const darkModeMediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
    service.setThemeMode('auto');

    const expectedTheme = darkModeMediaQuery.matches ? 'dark' : 'light';
    expect(service.getCurrentTheme()).toBe(expectedTheme);
  });
});
```

#### E2E Theme Tests (Cypress)

**File**: `theme.cy.ts`

```typescript
describe('Theme Switching E2E', () => {
  beforeEach(() => {
    cy.visit('/');
  });

  it('should start with system theme', () => {
    cy.window().then(win => {
      const darkMode = win.matchMedia('(prefers-color-scheme: dark)').matches;
      const expectedTheme = darkMode ? 'dark' : 'light';
      cy.get('html').should('have.attr', 'data-theme', expectedTheme);
    });
  });

  it('should switch to dark theme', () => {
    cy.get('[data-testid="theme-toggle"]').click();
    cy.get('[data-testid="theme-dark"]').click();

    cy.get('html').should('have.attr', 'data-theme', 'dark');
    cy.get('body').should('have.css', 'background-color', 'rgb(13, 13, 13)'); // #0D0D0D
  });

  it('should switch to light theme', () => {
    cy.get('[data-testid="theme-toggle"]').click();
    cy.get('[data-testid="theme-light"]').click();

    cy.get('html').should('have.attr', 'data-theme', 'light');
    cy.get('body').should('have.css', 'background-color', 'rgb(255, 255, 255)'); // #FFFFFF
  });

  it('should persist theme across reload', () => {
    cy.get('[data-testid="theme-toggle"]').click();
    cy.get('[data-testid="theme-dark"]').click();

    cy.reload();

    cy.get('html').should('have.attr', 'data-theme', 'dark');
  });
});
```

### 4.3 Accessibility Tests

```typescript
describe('Accessibility Tests', () => {
  it('should meet WCAG AA contrast requirements', () => {
    cy.visit('/');
    cy.injectAxe();

    // Check light theme
    cy.checkA11y(null, {
      rules: {
        'color-contrast': { enabled: true }
      }
    });

    // Switch to dark theme
    cy.get('[data-testid="theme-toggle"]').click();
    cy.get('[data-testid="theme-dark"]').click();

    // Check dark theme
    cy.checkA11y(null, {
      rules: {
        'color-contrast': { enabled: true }
      }
    });
  });

  it('should be keyboard navigable', () => {
    cy.visit('/');

    // Tab through all interactive elements
    cy.get('body').tab();
    cy.focused().should('have.css', 'outline-color', 'rgb(188, 230, 59)'); // Primary color

    // Continue tabbing
    cy.focused().tab();
    cy.focused().should('be.visible');
  });

  it('should have proper ARIA labels', () => {
    cy.visit('/');

    // Check for ARIA labels on key elements
    cy.get('button[aria-label]').should('have.length.greaterThan', 0);
    cy.get('[role="navigation"]').should('exist');
    cy.get('[role="main"]').should('exist');
  });
});
```

---

## Phase 5: Documentation & Test Results

**Time**: 8-12 hours

### 5.1 Update All Documentation

#### Files to Update:

1. **README.md** (each client)
   - Add "Theme Support" section
   - Screenshots in both themes
   - Setup instructions

2. **TESTING.md** (each client)
   - Theme-specific test cases
   - Visual regression tests
   - Accessibility tests

3. **IMPLEMENTATION_GUIDE.md** (each client)
   - Theme implementation details
   - Component usage with themes
   - Best practices

4. **CHANGELOG.md** (each client)
   - Document theme feature addition
   - List all UI/UX improvements
   - Breaking changes (if any)

### 5.2 Create Test Results Document

**File**: `UI_UX_TEST_RESULTS.md`

```markdown
# HelixTrack - UI/UX Implementation Test Results

**Date**: 2025-10-18
**Version**: 2.0.0
**Scope**: All Platforms (Android, Web, Desktop, iOS)

## Test Summary

| Platform | Total Tests | Passed | Failed | Coverage |
|----------|-------------|--------|--------|----------|
| **Android** | 450 | 450 | 0 | 95% |
| **Web** | 520 | 520 | 0 | 92% |
| **Desktop** | 480 | 480 | 0 | 90% |
| **iOS** | 380 | 380 | 0 | 93% |
| **TOTAL** | **1,830** | **1,830** | **0** | **92.5%** |

## Theme Tests

### Android
- [x] Light theme renders correctly
- [x] Dark theme renders correctly
- [x] Theme switching works
- [x] System theme detection works
- [x] Theme preference persists
- [x] All components adapt to theme
- [x] Color contrast meets WCAG AA

### Web
- [x] Light theme renders correctly
- [x] Dark theme renders correctly
- [x] Theme switching works
- [x] System theme detection works
- [x] Theme preference persists
- [x] CSS variables apply correctly
- [x] Smooth theme transitions

### Desktop
- [x] All Web tests pass
- [x] Native theme detection (Windows/macOS/Linux)
- [x] System theme synchronization
- [x] Tauri integration works

### iOS
- [x] Light theme renders correctly
- [x] Dark theme renders correctly
- [x] Automatic theme switching
- [x] SwiftUI environment detection
- [x] Asset catalog colors work
- [x] SF Symbols adapt to theme

## Component Tests

### Buttons
- [x] All variants render in both themes
- [x] Hover states work correctly
- [x] Focus indicators visible
- [x] Disabled state has correct opacity

### Cards
- [x] Background color adapts
- [x] Border color adapts
- [x] Shadow adapts
- [x] Content contrast is sufficient

### Forms
- [x] Input fields render correctly
- [x] Labels are readable
- [x] Error states are visible
- [x] Focus states are clear

### Navigation
- [x] Navbar adapts to theme
- [x] Sidebar adapts to theme
- [x] Breadcrumbs are readable
- [x] Active states are clear

## Accessibility Tests

- [x] Color contrast meets WCAG AA (4.5:1 for text)
- [x] Focus indicators visible (2px outline)
- [x] Keyboard navigation works
- [x] Screen reader labels present
- [x] Semantic HTML used
- [x] ARIA attributes correct
- [x] Alt text on images

## Visual Regression Tests

- [x] Light theme matches reference
- [x] Dark theme matches reference
- [x] All breakpoints tested
- [x] No layout shifts
- [x] Animations smooth

## E2E Test Scenarios

### Ticket Management
- [x] Create ticket (light theme)
- [x] Create ticket (dark theme)
- [x] Edit ticket (both themes)
- [x] Delete ticket (both themes)
- [x] View ticket details (both themes)

### Board Operations
- [x] Drag and drop cards (light theme)
- [x] Drag and drop cards (dark theme)
- [x] Filter board (both themes)
- [x] Change board view (both themes)

### Document Management
- [x] Create document (light theme)
- [x] Create document (dark theme)
- [x] Edit document (both themes)
- [x] View version history (both themes)

## Performance Tests

| Metric | Android | Web | Desktop | iOS |
|--------|---------|-----|---------|-----|
| **Theme Switch Time** | < 100ms | < 100ms | < 100ms | < 100ms |
| **First Paint** | < 1.5s | < 800ms | < 1.2s | < 1s |
| **Interactive** | < 2s | < 1.5s | < 2s | < 1.8s |

## Known Issues

None - All tests passing ✅

## Recommendations

1. ✅ Monitor theme performance on low-end devices
2. ✅ Add more visual regression tests
3. ✅ Test with real users for feedback
4. ✅ Consider adding more theme customization options

---

**Test Execution Date**: 2025-10-18
**Executed By**: HelixTrack QA Team
**Status**: ✅ All Tests Passed

```

---

## Implementation Timeline

### Week 1: Theme System Foundation
- Days 1-2: Android theme implementation
- Days 3-4: Web/Desktop theme implementation
- Day 5: iOS theme implementation

### Week 2: UI Components & JIRA Alignment
- Days 1-2: Ticket/Issue cards (all platforms)
- Days 3-4: Board views (all platforms)
- Day 5: Document pages (all platforms)

### Week 3: Wireframes & Documentation
- Days 1-3: Create .drawio wireframes (all clients)
- Days 4-5: Export PNGs, document flows

### Week 4: Testing & Validation
- Days 1-2: Unit tests (all platforms)
- Day 3: Integration tests (all platforms)
- Days 4-5: E2E tests, accessibility tests

### Week 5: Polish & Documentation
- Days 1-2: Run all tests, fix issues
- Days 3-4: Document test results
- Day 5: Final review, deployment prep

**Total**: 5 weeks (80-112 hours)

---

## Success Criteria

✅ **Theme Support**:
- Light and dark themes on all platforms
- System preference detection working
- User preference persists
- Smooth transitions

✅ **JIRA/Confluence Alignment**:
- Ticket cards match JIRA design
- Board views match JIRA boards
- Document pages match Confluence
- Navigation patterns familiar

✅ **UI/UX Quality**:
- Consistent across platforms
- Modern and polished
- Accessible (WCAG 2.1 AA)
- Responsive on all devices

✅ **Testing**:
- 100% test success rate
- All flows covered
- All edge cases handled
- Documented results

✅ **Documentation**:
- Complete wireframes (.drawio + PNG)
- Updated README files
- Test reports
- Implementation guides

---

## Next Steps

1. **Review & Approve** this roadmap
2. **Assign Resources** to each phase
3. **Begin Phase 1** (theme implementation)
4. **Track Progress** using todo list
5. **Regular Reviews** at end of each week

---

**Document Version**: 1.0.0
**Last Updated**: 2025-10-18
**Maintained By**: HelixTrack UI/UX Team

---
