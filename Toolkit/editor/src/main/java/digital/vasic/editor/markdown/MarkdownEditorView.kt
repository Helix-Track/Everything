package digital.vasic.editor.markdown

import android.content.Context
import android.graphics.Typeface
import android.text.Editable
import android.text.SpannableStringBuilder
import android.text.Spanned
import android.text.TextWatcher
import android.text.style.*
import android.util.AttributeSet
import androidx.core.content.ContextCompat
import java.util.regex.Pattern

/**
 * Enhanced EditText with real-time markdown syntax highlighting
 * Part of Toolit - HelixTrack's reusable component library
 *
 * Based on Markor's HighlightingEditor, adapted for Toolit
 *
 * @author Milos Vasic (digital.vasic)
 * @since 2025-10-18
 */
class MarkdownEditorView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = android.R.attr.editTextStyle
) : androidx.appcompat.widget.AppCompatEditText(context, attrs, defStyleAttr) {

    private var isHighlightingEnabled = true
    private var highlightingDelay = 150L
    private val highlightingRunnable = Runnable { applyHighlighting() }

    // Markdown patterns for syntax highlighting
    private val patterns = mapOf(
        // Headers (# to ######)
        Pattern.compile("^(#{1,6})\\s+(.+)$", Pattern.MULTILINE) to MarkdownStyle.HEADER,
        // Bold (**text** or __text__)
        Pattern.compile("\\*\\*(.+?)\\*\\*|__(.+?)__") to MarkdownStyle.BOLD,
        // Italic (*text* or _text_)
        Pattern.compile("\\*(.+?)\\*|_(.+?)_") to MarkdownStyle.ITALIC,
        // Strikethrough (~~text~~)
        Pattern.compile("~~(.+?)~~") to MarkdownStyle.STRIKETHROUGH,
        // Inline code (`code`)
        Pattern.compile("`(.+?)`") to MarkdownStyle.CODE_INLINE,
        // Code block (```code``` or ~~~code~~~)
        Pattern.compile("```[\\s\\S]*?```|~~~[\\s\\S]*?~~~") to MarkdownStyle.CODE_BLOCK,
        // Links ([text](url))
        Pattern.compile("\\[(.+?)\\]\\((.+?)\\)") to MarkdownStyle.LINK,
        // Unordered list (-, *, +)
        Pattern.compile("^\\s*[-*+]\\s+", Pattern.MULTILINE) to MarkdownStyle.LIST,
        // Ordered list (1., 2., etc.)
        Pattern.compile("^\\s*\\d+\\.\\s+", Pattern.MULTILINE) to MarkdownStyle.LIST,
        // Quote (> text)
        Pattern.compile("^>\\s+.+$", Pattern.MULTILINE) to MarkdownStyle.QUOTE,
        // Horizontal rule (---, ***, ___)
        Pattern.compile("^(---|\\*\\*\\*|___)$", Pattern.MULTILINE) to MarkdownStyle.HORIZONTAL_RULE,
        // Task list (- [ ] or - [x])
        Pattern.compile("^\\s*[-*+]\\s+\\[[ xX]\\]\\s+", Pattern.MULTILINE) to MarkdownStyle.TASK_LIST
    )

    // Color scheme (will be overridden by colors.xml)
    private val colorHeader by lazy { getColorCompat(R.color.markdown_header) }
    private val colorCode by lazy { getColorCompat(R.color.markdown_code) }
    private val colorCodeBg by lazy { getColorCompat(R.color.markdown_code_bg) }
    private val colorLink by lazy { getColorCompat(R.color.markdown_link) }
    private val colorList by lazy { getColorCompat(R.color.markdown_list) }
    private val colorQuote by lazy { getColorCompat(R.color.markdown_quote) }
    private val colorRule by lazy { getColorCompat(R.color.markdown_rule) }

    init {
        typeface = Typeface.MONOSPACE
        addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable?) {
                if (isHighlightingEnabled) {
                    removeCallbacks(highlightingRunnable)
                    postDelayed(highlightingRunnable, highlightingDelay)
                }
            }
        })
    }

    /**
     * Apply syntax highlighting to the current text
     */
    private fun applyHighlighting() {
        val text = text ?: return
        val spannable = SpannableStringBuilder(text)

        // Clear existing spans
        val existingSpans = spannable.getSpans(0, spannable.length, CharacterStyle::class.java)
        existingSpans.forEach { spannable.removeSpan(it) }

        // Apply new spans based on markdown patterns
        patterns.forEach { (pattern, style) ->
            val matcher = pattern.matcher(spannable)
            while (matcher.find()) {
                applyStyle(spannable, matcher, style)
            }
        }

        // Apply the highlighted text without triggering text changed listener
        isHighlightingEnabled = false
        setText(spannable)
        setSelection(selectionStart.coerceAtMost(spannable.length))
        isHighlightingEnabled = true
    }

    /**
     * Apply a specific markdown style to a matched region
     */
    private fun applyStyle(spannable: SpannableStringBuilder, matcher: java.util.regex.Matcher, style: MarkdownStyle) {
        when (style) {
            MarkdownStyle.HEADER -> {
                val level = matcher.group(1)?.length ?: 1
                val size = when (level) {
                    1 -> 2.0f
                    2 -> 1.8f
                    3 -> 1.6f
                    4 -> 1.4f
                    5 -> 1.2f
                    else -> 1.1f
                }
                spannable.setSpan(
                    RelativeSizeSpan(size),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
                spannable.setSpan(
                    StyleSpan(Typeface.BOLD),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
                spannable.setSpan(
                    ForegroundColorSpan(colorHeader),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
            }
            MarkdownStyle.BOLD -> {
                spannable.setSpan(
                    StyleSpan(Typeface.BOLD),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
            }
            MarkdownStyle.ITALIC -> {
                spannable.setSpan(
                    StyleSpan(Typeface.ITALIC),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
            }
            MarkdownStyle.STRIKETHROUGH -> {
                spannable.setSpan(
                    StrikethroughSpan(),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
            }
            MarkdownStyle.CODE_INLINE -> {
                spannable.setSpan(
                    TypefaceSpan("monospace"),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
                spannable.setSpan(
                    BackgroundColorSpan(colorCodeBg),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
                spannable.setSpan(
                    ForegroundColorSpan(colorCode),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
            }
            MarkdownStyle.CODE_BLOCK -> {
                spannable.setSpan(
                    TypefaceSpan("monospace"),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
                spannable.setSpan(
                    BackgroundColorSpan(colorCodeBg),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
                spannable.setSpan(
                    ForegroundColorSpan(colorCode),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
            }
            MarkdownStyle.LINK -> {
                spannable.setSpan(
                    ForegroundColorSpan(colorLink),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
                spannable.setSpan(
                    UnderlineSpan(),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
            }
            MarkdownStyle.LIST -> {
                spannable.setSpan(
                    ForegroundColorSpan(colorList),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
            }
            MarkdownStyle.QUOTE -> {
                spannable.setSpan(
                    QuoteSpan(colorQuote),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
                spannable.setSpan(
                    StyleSpan(Typeface.ITALIC),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
            }
            MarkdownStyle.HORIZONTAL_RULE -> {
                spannable.setSpan(
                    ForegroundColorSpan(colorRule),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
            }
            MarkdownStyle.TASK_LIST -> {
                spannable.setSpan(
                    ForegroundColorSpan(colorList),
                    matcher.start(),
                    matcher.end(),
                    Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
                )
            }
        }
    }

    /**
     * Get color from resources with fallback
     */
    private fun getColorCompat(colorResId: Int): Int {
        return try {
            ContextCompat.getColor(context, colorResId)
        } catch (e: Exception) {
            // Fallback to default colors if resources not found
            when (colorResId) {
                R.color.markdown_header -> 0xFF0066CC.toInt()
                R.color.markdown_code -> 0xFFD73A49.toInt()
                R.color.markdown_code_bg -> 0xFFF6F8FA.toInt()
                R.color.markdown_link -> 0xFF0366D6.toInt()
                R.color.markdown_list -> 0xFF6A737D.toInt()
                R.color.markdown_quote -> 0xFF6A737D.toInt()
                R.color.markdown_rule -> 0xFFE1E4E8.toInt()
                else -> 0xFF000000.toInt()
            }
        }
    }

    /**
     * Enable or disable syntax highlighting
     */
    fun setHighlightingEnabled(enabled: Boolean) {
        isHighlightingEnabled = enabled
        if (enabled) {
            applyHighlighting()
        }
    }

    /**
     * Set highlighting delay in milliseconds
     */
    fun setHighlightingDelay(delayMs: Long) {
        highlightingDelay = delayMs
    }

    /**
     * Markdown style types
     */
    enum class MarkdownStyle {
        HEADER, BOLD, ITALIC, STRIKETHROUGH,
        CODE_INLINE, CODE_BLOCK, LINK, LIST,
        QUOTE, HORIZONTAL_RULE, TASK_LIST
    }
}
