#!/usr/bin/env bash
#
# export_markdown.sh — Markdown regeneration / multi-format export pipeline
#
# Constitution §11.4.65 — Regeneration mechanism: governance and documentation
#   artifacts MUST be regenerable from their Markdown source. This script is the
#   canonical regeneration entry point.
# Related: §11.4.60 (single source of truth), §11.4.12 (reproducibility),
#          §11.4.77 (multi-format export: HTML + PDF siblings).
#
# For each input .md file, this script regenerates two sibling artifacts:
#   <file>.html  — standalone HTML via pandoc
#   <file>.pdf   — PDF via pandoc + weasyprint engine
#
# Usage:
#   ./scripts/export_markdown.sh [file1.md file2.md ...]
#
# With no arguments it defaults to the governance set:
#   CONSTITUTION_INHERITANCE_SETUP.md
#   CONSTITUTION_COMPLIANCE_AUDIT.md
#   docs/CONTINUATION.md
#
# Exit status: 0 if every export succeeded, non-zero if any export failed.
#
set -u

# --- Resolve repo root (directory containing this script's parent) ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# --- TMPDIR: system /tmp may be full; pin to the repo volume if unset (§11.4.12) ---
if [ -z "${TMPDIR:-}" ]; then
  if [ -d "/Volumes/T7/tmp" ]; then
    export TMPDIR="/Volumes/T7/tmp"
  else
    export TMPDIR="${REPO_ROOT}/.tmp"
    mkdir -p "${TMPDIR}"
  fi
fi
echo "Using TMPDIR=${TMPDIR}"

# --- Default governance set when no args supplied ---
if [ "$#" -gt 0 ]; then
  FILES=("$@")
else
  FILES=(
    "CONSTITUTION_INHERITANCE_SETUP.md"
    "CONSTITUTION_COMPLIANCE_AUDIT.md"
    "docs/CONTINUATION.md"
  )
fi

# --- Tool checks ---
if ! command -v pandoc >/dev/null 2>&1; then
  echo "FATAL: pandoc not found on PATH" >&2
  exit 2
fi

FAIL_COUNT=0

export_one() {
  # $1 = path to .md file (relative to repo root or absolute)
  local md="$1"
  local abs="${md}"
  case "${abs}" in
    /*) : ;;                          # already absolute
    *)  abs="${REPO_ROOT}/${md}" ;;   # resolve relative to repo root
  esac

  if [ ! -f "${abs}" ]; then
    echo "FAIL [missing] ${md} :: source file does not exist"
    FAIL_COUNT=$((FAIL_COUNT + 1))
    return
  fi

  local base
  base="$(basename "${abs}" .md)"
  local html="${abs%.md}.html"
  local pdf="${abs%.md}.pdf"

  local html_err="${TMPDIR%/}/htexport_html_err_$$"
  local pdf_err="${TMPDIR%/}/htexport_pdf_err_$$"

  # --- HTML export ---
  if pandoc "${abs}" -o "${html}" --standalone --metadata title="${base}" 2>"${html_err}"; then
    echo "PASS [html] ${md} -> ${html#${REPO_ROOT}/}"
  else
    echo "FAIL [html] ${md} :: $(tr '\n' ' ' < "${html_err}" 2>/dev/null)"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
  rm -f "${html_err}" 2>/dev/null || true

  # --- PDF export (weasyprint engine) ---
  if pandoc "${abs}" -o "${pdf}" --pdf-engine=weasyprint 2>"${pdf_err}"; then
    echo "PASS [pdf ] ${md} -> ${pdf#${REPO_ROOT}/}"
  else
    echo "FAIL [pdf ] ${md} :: $(tr '\n' ' ' < "${pdf_err}" 2>/dev/null)"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
  rm -f "${pdf_err}" 2>/dev/null || true
}

echo "Regenerating ${#FILES[@]} file(s) -> HTML + PDF siblings"
echo "----------------------------------------------------------------"
for f in "${FILES[@]}"; do
  export_one "${f}"
done
echo "----------------------------------------------------------------"

if [ "${FAIL_COUNT}" -gt 0 ]; then
  echo "RESULT: FAIL (${FAIL_COUNT} export(s) failed)"
  exit 1
fi
echo "RESULT: PASS (all exports succeeded)"
exit 0
