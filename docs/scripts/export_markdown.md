# export_markdown.sh

**Source:** `scripts/export_markdown.sh`

## Purpose
Markdown regeneration / multi-format export pipeline — the canonical regeneration entry
point. For each input `.md` file it regenerates two sibling artifacts: `<file>.html`
(standalone HTML via pandoc) and `<file>.pdf` (PDF via pandoc + weasyprint engine).

## Usage
```bash
./scripts/export_markdown.sh [file1.md file2.md ...]
```
With no arguments it defaults to the governance set:
`CONSTITUTION_INHERITANCE_SETUP.md`, `CONSTITUTION_COMPLIANCE_AUDIT.md`, `docs/CONTINUATION.md`.

## Inputs
Zero or more `.md` paths (absolute, or relative to the repo root). `TMPDIR` env var is
honored; if unset it pins to `/Volumes/T7/tmp` when present, else `<repo>/.tmp` (created).

## Exit codes / outputs
Prints `PASS`/`FAIL` lines per export and a final `RESULT` line.
- `0` — every export succeeded.
- `1` — one or more exports failed.
- `2` — FATAL: `pandoc` not found on PATH.

## Invariants checked
- `pandoc` must exist on PATH (else exit 2).
- Each source `.md` must exist (missing source counts as a failure).
- Both the HTML and PDF sibling must be produced successfully for a clean pass.

## Related Constitution clauses
- §11.4.65 — regeneration mechanism (artifacts regenerable from Markdown source).
- §11.4.60 — single source of truth.
- §11.4.12 — reproducibility (also the TMPDIR pinning rationale).
- §11.4.77 — multi-format export (HTML + PDF siblings).
