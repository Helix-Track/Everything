package digital.vasic.editor.markdown

import java.util.regex.Pattern
import com.vladsch.flexmark.ext.abbreviation.AbbreviationExtension
import com.vladsch.flexmark.ext.anchorlink.AnchorLinkExtension
import com.vladsch.flexmark.ext.autolink.AutolinkExtension
import com.vladsch.flexmark.ext.definition.DefinitionExtension
import com.vladsch.flexmark.ext.emoji.EmojiExtension
import com.vladsch.flexmark.ext.footnotes.FootnoteExtension
import com.vladsch.flexmark.ext.gfm.strikethrough.StrikethroughExtension
import com.vladsch.flexmark.ext.gfm.tasklist.TaskListExtension
import com.vladsch.flexmark.ext.ins.InsExtension
import com.vladsch.flexmark.ext.superscript.SuperscriptExtension
import com.vladsch.flexmark.ext.tables.TablesExtension
import com.vladsch.flexmark.ext.toc.TocExtension
import com.vladsch.flexmark.ext.wikilink.WikiLinkExtension
import com.vladsch.flexmark.ext.yaml.front.matter.YamlFrontMatterExtension
import com.vladsch.flexmark.html.HtmlRenderer
import com.vladsch.flexmark.parser.Parser
import com.vladsch.flexmark.util.data.MutableDataSet

/**
 * Markdown to HTML renderer using Flexmark
 * Part of Toolit - HelixTrack's reusable component library
 *
 * Provides GitHub-flavored markdown support with full extension compatibility
 *
 * Features:
 * - Tables, strikethrough, task lists
 * - Auto-linking, anchor links, table of contents
 * - Wiki links, YAML front matter
 * - Footnotes, definitions, abbreviations
 * - Superscript, emoji, insert tags
 *
 * @author Milos Vasic (digital.vasic)
 * @since 2025-10-18
 */
object MarkdownRenderer {

    private val options = MutableDataSet().apply {
        // Enable all extensions for full markdown support
        set(
            Parser.EXTENSIONS,
            listOf(
                TablesExtension.create(),
                StrikethroughExtension.create(),
                TaskListExtension.create(),
                AutolinkExtension.create(),
                AnchorLinkExtension.create(),
                TocExtension.create(),
                WikiLinkExtension.create(),
                YamlFrontMatterExtension.create(),
                FootnoteExtension.create(),
                DefinitionExtension.create(),
                AbbreviationExtension.create(),
                SuperscriptExtension.create(),
                EmojiExtension.create(),
                InsExtension.create()
            )
        )

        // Configure table rendering
        set(TablesExtension.COLUMN_SPANS, false)
        set(TablesExtension.APPEND_MISSING_COLUMNS, true)
        set(TablesExtension.DISCARD_EXTRA_COLUMNS, true)
        set(TablesExtension.HEADER_SEPARATOR_COLUMN_MATCH, true)

        // Configure task lists
        set(TaskListExtension.ITEM_DONE_MARKER, "<span class=\"task-done\">✓</span>")
        set(TaskListExtension.ITEM_NOT_DONE_MARKER, "<span class=\"task-todo\">◻</span>")

        // Configure HTML rendering
        set(HtmlRenderer.SOFT_BREAK, "<br />\n")
        set(HtmlRenderer.HARD_BREAK, "<br />\n")
        set(HtmlRenderer.GENERATE_HEADER_ID, true)
        set(HtmlRenderer.RENDER_HEADER_ID, true)
    }

    private val parser: Parser = Parser.builder(options).build()
    private val renderer: HtmlRenderer = HtmlRenderer.builder(options).build()

    /**
     * Convert markdown text to HTML
     *
     * @param markdown The markdown source text
     * @param wrapInTemplate Whether to wrap in full HTML template (default: true)
     * @return HTML representation with optional full styling
     */
    fun markdownToHtml(markdown: String, wrapInTemplate: Boolean = true): String {
        if (markdown.isBlank()) return ""

        val document = parser.parse(markdown)
        val html = renderer.render(document)

        return if (wrapInTemplate) {
            wrapWithHtmlTemplate(html)
        } else {
            html
        }
    }

    /**
     * Convert markdown to plain text (strips all formatting)
     *
     * @param markdown The markdown source text
     * @return Plain text without markdown syntax
     */
    fun markdownToPlainText(markdown: String): String {
        val html = markdownToHtml(markdown, wrapInTemplate = false)
        return html
            .replace(Regex("<[^>]*>"), "") // Remove HTML tags
            .replace(Regex("\\s+"), " ") // Normalize whitespace
            .trim()
    }

    /**
     * Extract document title from markdown (first H1 heading)
     *
     * @param markdown The markdown source text
     * @return The title, or null if no H1 found
     */
    fun extractTitle(markdown: String): String? {
        val h1Pattern = Pattern.compile("^#\\s+(.+)$", Pattern.MULTILINE)
        val matcher = h1Pattern.matcher(markdown)
        return if (matcher.find()) {
            matcher.group(1)
        } else {
            null
        }
    }

    /**
     * Count words in markdown document
     *
     * @param markdown The markdown source text
     * @return Word count
     */
    fun countWords(markdown: String): Int {
        val plainText = markdownToPlainText(markdown)
        return plainText.split(Regex("\\s+")).count { it.isNotBlank() }
    }

    /**
     * Wrap HTML content with full HTML template including CSS styles
     *
     * Includes:
     * - Responsive viewport settings
     * - GitHub-style markdown CSS
     * - Dark mode support via media query
     * - Mobile-friendly typography
     */
    private fun wrapWithHtmlTemplate(content: String): String {
        return """
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            padding: 16px;
            margin: 0;
            background: #ffffff;
        }

        h1, h2, h3, h4, h5, h6 {
            margin-top: 24px;
            margin-bottom: 16px;
            font-weight: 600;
            line-height: 1.25;
            color: #1a1a1a;
        }

        h1 { font-size: 2em; border-bottom: 1px solid #eaecef; padding-bottom: 0.3em; }
        h2 { font-size: 1.5em; border-bottom: 1px solid #eaecef; padding-bottom: 0.3em; }
        h3 { font-size: 1.25em; }
        h4 { font-size: 1em; }
        h5 { font-size: 0.875em; }
        h6 { font-size: 0.85em; color: #6a737d; }

        p { margin-top: 0; margin-bottom: 16px; }

        a {
            color: #0366d6;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        code {
            background-color: rgba(27, 31, 35, 0.05);
            border-radius: 3px;
            font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, monospace;
            font-size: 85%;
            padding: 0.2em 0.4em;
        }

        pre {
            background-color: #f6f8fa;
            border-radius: 6px;
            font-family: 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', Consolas, monospace;
            font-size: 85%;
            line-height: 1.45;
            overflow: auto;
            padding: 16px;
        }

        pre code {
            background-color: transparent;
            border: 0;
            display: inline;
            line-height: inherit;
            margin: 0;
            max-width: auto;
            overflow: visible;
            padding: 0;
            word-wrap: normal;
        }

        blockquote {
            border-left: 4px solid #dfe2e5;
            color: #6a737d;
            margin: 0 0 16px 0;
            padding: 0 1em;
        }

        ul, ol {
            margin-top: 0;
            margin-bottom: 16px;
            padding-left: 2em;
        }

        li { margin-top: 0.25em; }

        table {
            border-collapse: collapse;
            border-spacing: 0;
            margin-bottom: 16px;
            width: 100%;
        }

        table th {
            background-color: #f6f8fa;
            border: 1px solid #d0d7de;
            font-weight: 600;
            padding: 6px 13px;
        }

        table td {
            border: 1px solid #d0d7de;
            padding: 6px 13px;
        }

        table tr {
            background-color: #ffffff;
            border-top: 1px solid #d0d7de;
        }

        table tr:nth-child(2n) {
            background-color: #f6f8fa;
        }

        hr {
            background-color: #e1e4e8;
            border: 0;
            height: 0.25em;
            margin: 24px 0;
            padding: 0;
        }

        img {
            max-width: 100%;
            height: auto;
            box-sizing: content-box;
        }

        .task-done {
            color: #28a745;
            font-weight: bold;
        }

        .task-todo {
            color: #6a737d;
        }

        .footnotes {
            border-top: 1px solid #e1e4e8;
            margin-top: 32px;
            padding-top: 16px;
            font-size: 0.9em;
            color: #6a737d;
        }

        /* Dark mode support */
        @media (prefers-color-scheme: dark) {
            body {
                background: #0d1117;
                color: #c9d1d9;
            }

            h1, h2, h3, h4, h5, h6 {
                color: #c9d1d9;
            }

            h1, h2 {
                border-bottom-color: #21262d;
            }

            a {
                color: #58a6ff;
            }

            code {
                background-color: rgba(110, 118, 129, 0.4);
            }

            pre {
                background-color: #161b22;
            }

            blockquote {
                border-left-color: #3b434b;
                color: #8b949e;
            }

            table th {
                background-color: #161b22;
                border-color: #30363d;
            }

            table td {
                border-color: #30363d;
            }

            table tr {
                background-color: #0d1117;
                border-top-color: #21262d;
            }

            table tr:nth-child(2n) {
                background-color: #161b22;
            }

            hr {
                background-color: #21262d;
            }
        }
    </style>
</head>
<body>
$content
</body>
</html>
        """.trimIndent()
    }
}
