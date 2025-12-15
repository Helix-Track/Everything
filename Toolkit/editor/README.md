# Toolkit Markdown Editor

**Author**: Milos Vasic (digital.vasic)
**Package**: `digital.vasic.editor.markdown`
**Version**: 1.0.0
**Date**: 2025-10-18

## Overview

Toolkit Markdown Editor is a reusable Android library module that provides a powerful, feature-rich markdown editing experience with real-time syntax highlighting and HTML rendering capabilities.

Part of the **HelixTrack** project ecosystem, this editor is built on top of the excellent **Flexmark** library and inspired by the **Markor** markdown editor.

## Features

### MarkdownEditorView
- Real-time syntax highlighting as you type
- Support for all major markdown elements:
  - Headers (H1-H6)
  - Bold, italic, strikethrough
  - Inline code and code blocks
  - Links and images
  - Ordered and unordered lists
  - Task lists (checkboxes)
  - Blockquotes
  - Horizontal rules
- Monospace font for better code editing
- Configurable highlighting delay
- Can be enabled/disabled dynamically

### MarkdownRenderer
- Convert markdown to HTML with full styling
- GitHub-flavored markdown support
- Full extension support:
  - Tables
  - Strikethrough
  - Task lists
  - Auto-linking
  - Anchor links
  - Table of contents
  - Wiki links
  - YAML front matter
  - Footnotes
  - Definitions
  - Abbreviations
  - Superscript
  - Emoji
  - Insert tags
- Dark mode support via CSS media query
- Mobile-responsive HTML output
- Utility methods:
  - `markdownToHtml()` - Full HTML conversion
  - `markdownToPlainText()` - Strip all formatting
  - `extractTitle()` - Get first H1 heading
  - `countWords()` - Word count from markdown

## Installation

### 1. Add Module to Project

In your `settings.gradle`:

```gradle
include ':Toolkit:editor'
```

### 2. Add Dependency

In your app's `build.gradle`:

```gradle
dependencies {
    implementation project(':Toolkit:editor')
}
```

The editor module already includes all Flexmark dependencies as `api` dependencies, so they'll be available to your app automatically.

## Usage

### Using MarkdownEditorView in XML

```xml
<digital.vasic.editor.markdown.MarkdownEditorView
    android:id="@+id/markdownEditor"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:padding="16dp"
    android:hint="Enter markdown here..."
    android:gravity="top|start"
    android:inputType="textMultiLine|textNoSuggestions" />
```

### Using MarkdownEditorView in Code

```kotlin
import digital.vasic.editor.markdown.MarkdownEditorView

val editor = findViewById<MarkdownEditorView>(R.id.markdownEditor)

// Get markdown content
val markdown = editor.text.toString()

// Set markdown content
editor.setText("# Hello World\n\nThis is **bold** text")

// Enable/disable highlighting
editor.setHighlightingEnabled(true)

// Set highlighting delay (default 150ms)
editor.setHighlightingDelay(200L)
```

### Using MarkdownRenderer

```kotlin
import digital.vasic.editor.markdown.MarkdownRenderer

// Convert markdown to HTML
val markdown = "# Hello\n\nThis is **markdown**"
val html = MarkdownRenderer.markdownToHtml(markdown)

// Convert to HTML without template wrapper
val htmlFragment = MarkdownRenderer.markdownToHtml(markdown, wrapInTemplate = false)

// Convert to plain text
val plainText = MarkdownRenderer.markdownToPlainText(markdown)

// Extract title
val title = MarkdownRenderer.extractTitle(markdown) // Returns "Hello"

// Count words
val wordCount = MarkdownRenderer.countWords(markdown) // Returns 3
```

### Displaying HTML in WebView

```kotlin
import android.webkit.WebView

val webView = findViewById<WebView>(R.id.webView)
val markdown = editor.text.toString()
val html = MarkdownRenderer.markdownToHtml(markdown)

webView.loadDataWithBaseURL(null, html, "text/html", "UTF-8", null)
```

## Customization

### Color Customization

Override the markdown colors in your app's `colors.xml`:

```xml
<resources>
    <color name="markdown_header">#FF6600</color>
    <color name="markdown_code">#00CC66</color>
    <color name="markdown_code_bg">#F0F0F0</color>
    <color name="markdown_link">#0066CC</color>
    <color name="markdown_list">#666666</color>
    <color name="markdown_quote">#777777</color>
    <color name="markdown_rule">#CCCCCC</color>
</resources>
```

### Highlighting Delay

Adjust the delay before syntax highlighting is applied (useful for performance with large documents):

```kotlin
editor.setHighlightingDelay(300L) // 300ms delay
```

## Supported Markdown Syntax

### Headers
```markdown
# H1
## H2
### H3
#### H4
##### H5
###### H6
```

### Text Formatting
```markdown
**bold** or __bold__
*italic* or _italic_
~~strikethrough~~
`inline code`
```

### Code Blocks
```markdown
\`\`\`kotlin
fun main() {
    println("Hello World")
}
\`\`\`
```

### Lists
```markdown
- Unordered item 1
- Unordered item 2

1. Ordered item 1
2. Ordered item 2

- [ ] Task item unchecked
- [x] Task item checked
```

### Links and Images
```markdown
[Link text](https://example.com)
![Image alt text](https://example.com/image.png)
```

### Blockquotes
```markdown
> This is a blockquote
> It can span multiple lines
```

### Horizontal Rule
```markdown
---
***
___
```

### Tables
```markdown
| Column 1 | Column 2 |
|----------|----------|
| Cell 1   | Cell 2   |
```

## Dependencies

This module uses the following libraries:

- **Flexmark** 0.64.8 - Markdown parsing and rendering
- **AndroidX AppCompat** - Backward compatibility
- **AndroidX Core KTX** - Kotlin extensions
- **Material Components** - Material Design support
- **Jetpack Compose** (optional) - For Compose integration

## Architecture

```
digital.vasic.editor.markdown/
├── MarkdownEditorView.kt    # EditText with syntax highlighting
├── MarkdownRenderer.kt      # Markdown to HTML converter
└── res/
    └── values/
        └── colors.xml        # Color definitions
```

## Performance Considerations

- **Highlighting Delay**: Default 150ms delay prevents lag while typing
- **Pattern Matching**: Optimized regex patterns for real-time highlighting
- **Span Reuse**: Existing spans are cleared and reapplied efficiently
- **HTML Caching**: Consider caching rendered HTML for large documents

## Integration with HelixTrack

This editor is designed specifically for **HelixTrack Documents V2**, providing:

1. **Document Editing**: Rich markdown editing for documents
2. **Real-time Preview**: Instant HTML rendering
3. **Version Control**: Markdown content for version diffing
4. **Export**: HTML export with consistent styling
5. **Offline Support**: Pure client-side rendering

## License

Part of the HelixTrack project.

**Copyright © 2025 Milos Vasic (digital.vasic)**

## Credits

- **Markor** - Original inspiration for markdown editing
- **Flexmark** - Powerful markdown processing library
- **HelixTrack** - The open-source JIRA + Confluence alternative

## Changelog

### Version 1.0.0 (2025-10-18)
- Initial release
- MarkdownEditorView with real-time syntax highlighting
- MarkdownRenderer with full Flexmark extension support
- GitHub-flavored markdown support
- Dark mode CSS support
- Utility methods (extractTitle, countWords, markdownToPlainText)

---

**Built with ❤️ for the HelixTrack project**
