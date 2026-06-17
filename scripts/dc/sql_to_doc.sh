#!/bin/sh
# =============================================================================
# sql_to_doc.sh — Docs Chain exec transform: SQL DDL -> System SQL-reference doc
# =============================================================================
#
# Purpose:
#   Project-owned Docs Chain (§11.4.106) `exec:` transform that derives the
#   System SQL-reference Markdown document from the Core SQL DDL definition
#   files. It is the `sql-to-doc` transform referenced by the
#   `.docs_chain/contexts/sql_definitions.yaml` context.
#
#   Authority direction (SAFE DEFAULT, operator-recommended, lowest blast
#   radius): the .sql DDL files are the SOLE AUTHORITY; the System SQL-reference
#   doc is DERIVED from them (one-way sql -> doc). The reverse projection
#   (doc -> sql) is intentionally NOT implemented here — it requires a
#   §11.4.133 target-System safety review (a doc edit must never silently
#   rewrite authoritative schema). See docs/scripts/sql_to_doc.md.
#
# Usage (Docs Chain exec contract — docs_chain/docs/CONFIG_SCHEMA.md §5.2,
#        verified against docs_chain/internal/runner/runner.go:300-354):
#   sql_to_doc.sh <in_path_1> [<in_path_2> ... <in_path_N>] <out_path> [args...]
#
#   Docs Chain stages each input node's CONTENT into a temp file and passes the
#   temp paths in DETERMINISTIC sorted-by-source-node-id order, then appends ONE
#   staged output temp path, then any `args:` from the context. This script:
#     * reads ONLY from the supplied input temp paths (never the live tree);
#     * writes its result ONLY to the supplied output temp path (Docs Chain owns
#       the atomic rename to the live artefact, §8);
#     * exits 0 on success, non-zero on failure (triggers rollback, exit 3);
#     * produces BYTE-STABLE output for identical input (§11.4.50) — no
#       timestamps, no temp-file names, no host-specific data appear in output.
#
# Inputs:
#   $1..$(N)  — staged SQL DDL content temp files (the last positional before
#               any trailing args is the OUTPUT path).
#   $N+1      — staged OUTPUT temp path (Markdown written here).
#   remainder — optional args (currently none consumed).
#
# Outputs:
#   A deterministic Markdown System SQL-reference document written to the output
#   path: a header, a global alphabetical table inventory (deduplicated) with a
#   table count, and a per-input-block table listing in Docs-Chain pass order.
#
# Side-effects:
#   None beyond writing the single output path. No network, no live-tree writes,
#   no host power/session operations (§12). POSIX-sh only (§11.4.67 — parses
#   clean under `sh -n`).
#
# Dependencies:
#   POSIX sh, grep, sed, sort, awk (all base userland). No bashisms.
#
# Cross-references:
#   - Contract: docs_chain/docs/CONFIG_SCHEMA.md §5.2
#   - Context:  .docs_chain/contexts/sql_definitions.yaml (transform sql-to-doc)
#   - Companion doc: docs/scripts/sql_to_doc.md (§11.4.18)
#   - Tests: scripts/dc/test_sql_to_doc.sh (100% branch coverage, §11.4.27)
# =============================================================================

set -eu

# --- Argument parsing: last positional is the output path; everything before
# --- it (that this script consumes) is an input DDL content path. Trailing
# --- args after the output path (the context `args:`) are ignored by design. ---

if [ "$#" -lt 2 ]; then
    printf 'sql_to_doc.sh: ERROR: need >=2 args (>=1 input + 1 output), got %d\n' "$#" >&2
    printf 'usage: sql_to_doc.sh <in_1> [<in_2> ...] <out>\n' >&2
    exit 64
fi

# Collect positionals into in_1..in_(N), out. Docs Chain passes exactly:
#   <in_1> ... <in_N> <out> [context-args...]
# We treat ALL positionals except the LAST as inputs. (This transform declares
# no `args:` in the context, so the last positional is the output path.)
# To stay robust if a future context adds args, we honor an explicit sentinel:
# if the env var SQL_TO_DOC_NUM_INPUTS is set, it pins the input count.

total="$#"
if [ -n "${SQL_TO_DOC_NUM_INPUTS:-}" ]; then
    n_in="${SQL_TO_DOC_NUM_INPUTS}"
    # output path is the (n_in+1)-th positional
    out_idx=$((n_in + 1))
else
    n_in=$((total - 1))
    out_idx="$total"
fi

if [ "$n_in" -lt 1 ]; then
    printf 'sql_to_doc.sh: ERROR: computed input count < 1 (n_in=%s)\n' "$n_in" >&2
    exit 64
fi

# Extract the output path by index (POSIX-portable positional addressing).
i=0
out_path=""
for a in "$@"; do
    i=$((i + 1))
    if [ "$i" -eq "$out_idx" ]; then
        out_path="$a"
        break
    fi
done

if [ -z "$out_path" ]; then
    printf 'sql_to_doc.sh: ERROR: could not resolve output path (out_idx=%s)\n' "$out_idx" >&2
    exit 64
fi

# --- Helper: extract CREATE TABLE names from a single DDL file's content.
# Handles `CREATE TABLE name`, `CREATE TABLE IF NOT EXISTS name`, optional
# back-tick / double-quote / bracket quoting, case-insensitively. Emits one
# bare table name per line. Deterministic (no timestamps, no host data). ---
extract_tables() {
    # $1 = path to a DDL content file
    # grep -oE yields the matched fragment "CREATE TABLE [IF NOT EXISTS] [q]name";
    # the matched table name is always the LAST whitespace-delimited field, so we
    # take $NF and strip a single leading quote char. awk (POSIX) is used instead
    # of `sed -E` so no ERE/POSIX.1-2008 sed flag is required (§11.4.67).
    grep -ioE 'CREATE[[:space:]]+TABLE([[:space:]]+IF[[:space:]]+NOT[[:space:]]+EXISTS)?[[:space:]]+[`"\[]?[A-Za-z_][A-Za-z0-9_]*' "$1" 2>/dev/null \
        | awk '{ n=$NF; sub(/^[`"[]/, "", n); print n }' \
        || true
}

# --- Build the document into a temp accumulator, then move to out_path so a
# partial write is never observed at out_path. We write to a sibling temp in the
# same dir as out_path (Docs Chain's staging dir) to keep the same filesystem. ---
out_dir="$(dirname "$out_path")"
acc="$(mktemp "${out_dir}/.sql_to_doc_acc.XXXXXX")" || {
    printf 'sql_to_doc.sh: ERROR: mktemp failed in %s\n' "$out_dir" >&2
    exit 70
}
# Cleanup the accumulator on any exit path (§11.4.14).
trap 'rm -f "$acc"' EXIT INT TERM

# Global (all-inputs) deduplicated, sorted table list accumulator.
all_tables="$(mktemp "${out_dir}/.sql_to_doc_all.XXXXXX")" || {
    printf 'sql_to_doc.sh: ERROR: mktemp failed in %s\n' "$out_dir" >&2
    exit 70
}
trap 'rm -f "$acc" "$all_tables"' EXIT INT TERM

# --- Per-input block section (in Docs Chain pass order = sorted node-id order).
# We number the blocks deterministically (Block 01, 02, ...) since the original
# file path is NOT recoverable from a staged temp file by contract; the block
# index is the stable, byte-reproducible identifier. ---
{
    printf '# System SQL Reference\n\n'
    printf 'Derived from the Core SQL DDL definitions by the Docs Chain '
    printf '`sql-to-doc` transform (§11.4.106). The `.sql` DDL files are the '
    printf 'sole authority; this document is generated from them and MUST NOT '
    printf 'be hand-edited (doc -> sql is intentionally unimplemented pending a '
    printf '§11.4.133 review). Regenerate via `docs_chain sync` on the '
    printf '`sql_definitions` context.\n\n'
    printf '<!-- GENERATED FILE — do not edit by hand. Source of truth: '
    printf 'core/Database/DDL/*.sql -->\n\n'
} > "$acc"

idx=0
i=0
for a in "$@"; do
    i=$((i + 1))
    # Only the first n_in positionals are inputs.
    if [ "$i" -gt "$n_in" ]; then
        break
    fi
    idx=$((idx + 1))
    # Zero-padded deterministic block label.
    label="$(printf 'Block %02d' "$idx")"
    block_tables="$(extract_tables "$a")"
    # Append to global list.
    if [ -n "$block_tables" ]; then
        printf '%s\n' "$block_tables" >> "$all_tables"
    fi
    count="$(printf '%s\n' "$block_tables" | grep -c '[A-Za-z]' || true)"
    {
        printf '## %s\n\n' "$label"
        printf 'Tables defined in this DDL block: **%s**\n\n' "$count"
        if [ "$count" -gt 0 ]; then
            # Sort the per-block list for deterministic ordering, dedup.
            printf '%s\n' "$block_tables" | sort -u | while IFS= read -r t; do
                [ -n "$t" ] && printf -- '- `%s`\n' "$t"
            done
            printf '\n'
        else
            printf '_No `CREATE TABLE` statements in this block._\n\n'
        fi
    } >> "$acc"
done

# --- Global inventory section (header placed before blocks would require a
# second pass; instead we append it and the doc reads blocks then global — but
# operators expect the global list first. Re-assemble: header + global + blocks.
# To keep a single deterministic pass we built blocks into $acc AFTER the doc
# header; now we splice the global inventory right after the header marker. ---

# Compute the global sorted, deduplicated table inventory + count.
global_sorted="$(sort -u "$all_tables" 2>/dev/null | grep '[A-Za-z]' || true)"
global_count="$(printf '%s\n' "$global_sorted" | grep -c '[A-Za-z]' || true)"

# Final assembly: header (already in $acc up to the GENERATED marker line),
# then global inventory, then the per-block sections. We rebuild deterministically.
final="$(mktemp "${out_dir}/.sql_to_doc_final.XXXXXX")" || {
    printf 'sql_to_doc.sh: ERROR: mktemp failed in %s\n' "$out_dir" >&2
    exit 70
}
# Include the awk side-files (.hdr/.blk) in the trap so they are never orphaned
# in the staging dir if any later step fails under `set -e` (review finding).
trap 'rm -f "$acc" "$all_tables" "$final" "${final}.hdr" "${final}.blk"' EXIT INT TERM

# Header portion = everything in $acc BEFORE the first "## Block" line.
# Blocks portion = from the first "## Block" line to EOF.
awk '
    /^## Block / && !seen { seen=1 }
    { if (!seen) print > HDR; else print > BLK }
' HDR="${final}.hdr" BLK="${final}.blk" "$acc"

# If there were zero inputs producing blocks, BLK may not exist.
[ -f "${final}.hdr" ] || cp "$acc" "${final}.hdr"
[ -f "${final}.blk" ] || : > "${final}.blk"

{
    cat "${final}.hdr"
    printf '## Table Inventory (all DDL blocks)\n\n'
    printf 'Total distinct tables across all DDL sources: **%s**\n\n' "$global_count"
    if [ "$global_count" -gt 0 ]; then
        printf '%s\n' "$global_sorted" | while IFS= read -r t; do
            [ -n "$t" ] && printf -- '- `%s`\n' "$t"
        done
        printf '\n'
    else
        printf '_No `CREATE TABLE` statements found in any DDL source._\n\n'
    fi
    cat "${final}.blk"
} > "$final"

rm -f "${final}.hdr" "${final}.blk"

# Atomic-ish move into the Docs-Chain-supplied output path. Docs Chain itself
# owns the final atomic rename to the live artefact; here we only need the
# output temp path populated.
mv "$final" "$out_path"
# $final no longer exists; drop it from the trap set by resetting trap.
trap 'rm -f "$acc" "$all_tables"' EXIT INT TERM

exit 0
