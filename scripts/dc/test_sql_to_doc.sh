#!/bin/sh
# =============================================================================
# test_sql_to_doc.sh — 100%-branch test harness for scripts/dc/sql_to_doc.sh
# =============================================================================
#
# Purpose:
#   Anti-bluff (§11.4 / §11.4.27) test suite for the Docs Chain `sql-to-doc`
#   exec transform. Exercises EVERY branch of sql_to_doc.sh with REAL fixture
#   DDL and asserts deterministic (§11.4.50 byte-stable) output by running the
#   transform TWICE and diffing. Includes positive, negative, and edge cases.
#
# Usage:
#   sh scripts/dc/test_sql_to_doc.sh
#   Exit 0 = all assertions passed (real captured PASS). Non-zero = failure.
#
# Side-effects:
#   Operates entirely within a self-cleaning temp dir (trap on EXIT). No live
#   tree writes, no network, no host operations.
#
# Cross-references:
#   - Unit under test: scripts/dc/sql_to_doc.sh
#   - Contract: docs_chain/docs/CONFIG_SCHEMA.md §5.2
#   - Companion doc: docs/scripts/sql_to_doc.md
# =============================================================================

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SUT="${SCRIPT_DIR}/sql_to_doc.sh"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT INT TERM

PASS=0
FAIL=0

ok() { PASS=$((PASS + 1)); printf 'PASS: %s\n' "$1"; }
no() { FAIL=$((FAIL + 1)); printf 'FAIL: %s\n' "$1"; }

assert_eq() {
    # $1 desc, $2 expected, $3 actual
    if [ "$2" = "$3" ]; then ok "$1"; else
        no "$1"
        printf '  expected: [%s]\n' "$2"
        printf '  actual:   [%s]\n' "$3"
    fi
}

assert_contains() {
    # $1 desc, $2 file, $3 needle
    # NOTE: `-- ` terminates option parsing so needles beginning with `-`
    # (e.g. "- `alpha`") are treated as data, not flags (§11.4.1 FAIL-bluff guard).
    if grep -qF -e "$3" -- "$2"; then ok "$1"; else
        no "$1"; printf '  needle not found: [%s] in %s\n' "$3" "$2"
    fi
}

assert_not_contains() {
    if grep -qF -e "$3" -- "$2"; then no "$1"; printf '  unexpected needle: [%s]\n' "$3"; else ok "$1"; fi
}

# ---------------------------------------------------------------------------
# Fixtures: deterministic, hand-written DDL covering every parse form.
# ---------------------------------------------------------------------------
mk_fixtures() {
    # f_basic: plain "CREATE TABLE name"
    cat > "$WORK/f_basic" <<'EOF'
/* header */
CREATE TABLE alpha (
  id TEXT PRIMARY KEY
);
CREATE TABLE beta (id TEXT);
EOF

    # f_ifnotexists: "CREATE TABLE IF NOT EXISTS name" + lowercase keyword form
    cat > "$WORK/f_ine" <<'EOF'
CREATE TABLE IF NOT EXISTS gamma (id TEXT);
create table delta (id TEXT);
CREATE TABLE alpha (id TEXT);  -- duplicate of f_basic alpha (dedup test)
EOF

    # f_empty: a DDL file with NO create table (only comments / other SQL)
    cat > "$WORK/f_empty" <<'EOF'
/* just a comment */
INSERT INTO alpha VALUES ('x');
CREATE INDEX idx ON alpha(id);
EOF

    # f_malformed: binary-ish / no valid table names; ensures no crash
    printf '\001\002 CREATE TABL not_a_table \003\n' > "$WORK/f_malformed"
}
mk_fixtures

# ---------------------------------------------------------------------------
# CASE 1 — Multi-input happy path: 3 inputs, deterministic output.
# Covers: arg parse (no env), per-block loop, extract_tables match branch,
#         global inventory branch (>0), block-with-tables branch.
# ---------------------------------------------------------------------------
out1="$WORK/c1_a.md"
sh "$SUT" "$WORK/f_basic" "$WORK/f_ine" "$WORK/f_empty" "$out1"
rc=$?
assert_eq "C1 exit 0" "0" "$rc"
assert_contains "C1 has header" "$out1" "# System SQL Reference"
assert_contains "C1 global inventory present" "$out1" "## Table Inventory (all DDL blocks)"
# distinct tables: alpha,beta (f_basic) + gamma,delta (f_ine; alpha dup) = 4
assert_contains "C1 global count = 4" "$out1" "Total distinct tables across all DDL sources: **4**"
assert_contains "C1 lists alpha" "$out1" "- \`alpha\`"
assert_contains "C1 lists gamma (IF NOT EXISTS form)" "$out1" "- \`gamma\`"
assert_contains "C1 lists delta (lowercase form)" "$out1" "- \`delta\`"
assert_contains "C1 Block 01 present" "$out1" "## Block 01"
assert_contains "C1 Block 03 present" "$out1" "## Block 03"
# f_empty (block 03) -> the empty-block branch
assert_contains "C1 empty block branch" "$out1" "_No \`CREATE TABLE\` statements in this block._"

# ---------------------------------------------------------------------------
# CASE 2 — BYTE-STABILITY (§11.4.50): run twice, identical output.
# ---------------------------------------------------------------------------
out2="$WORK/c2_b.md"
sh "$SUT" "$WORK/f_basic" "$WORK/f_ine" "$WORK/f_empty" "$out2"
if diff -u "$out1" "$out2" >/dev/null 2>&1; then
    ok "C2 byte-stable across two runs (§11.4.50)"
else
    no "C2 NOT byte-stable"
    diff -u "$out1" "$out2" | head -20
fi
# Also assert no host/temp-name leakage into output (byte-stability hazard).
assert_not_contains "C2 no temp-input-name leak" "$out1" ".docs_chain_exec_in_"
assert_not_contains "C2 no acc-temp-name leak" "$out1" ".sql_to_doc_acc"

# ---------------------------------------------------------------------------
# CASE 3 — Single input only (n_in=1 path).
# ---------------------------------------------------------------------------
out3="$WORK/c3.md"
sh "$SUT" "$WORK/f_basic" "$out3"
assert_eq "C3 single-input exit 0" "0" "$?"
assert_contains "C3 global count = 2" "$out3" "Total distinct tables across all DDL sources: **2**"
assert_contains "C3 only Block 01" "$out3" "## Block 01"
assert_not_contains "C3 no Block 02" "$out3" "## Block 02"

# ---------------------------------------------------------------------------
# CASE 4 — All-empty input set -> global "none found" branch.
# Covers: global_count == 0 branch AND per-block empty branch.
# ---------------------------------------------------------------------------
out4="$WORK/c4.md"
sh "$SUT" "$WORK/f_empty" "$WORK/f_malformed" "$out4"
assert_eq "C4 exit 0 on no-tables" "0" "$?"
assert_contains "C4 zero global count" "$out4" "Total distinct tables across all DDL sources: **0**"
assert_contains "C4 global none-found branch" "$out4" "_No \`CREATE TABLE\` statements found in any DDL source._"

# ---------------------------------------------------------------------------
# CASE 5 — Malformed/binary input does not crash, exits 0.
# ---------------------------------------------------------------------------
out5="$WORK/c5.md"
sh "$SUT" "$WORK/f_malformed" "$out5"
assert_eq "C5 malformed input exit 0 (no crash)" "0" "$?"

# ---------------------------------------------------------------------------
# CASE 6 — Argument-error branches (defensive, §11.4.1 FAIL-bluff guard).
# ---------------------------------------------------------------------------
sh "$SUT" "$WORK/onlyone" 2>/dev/null
assert_eq "C6 too-few-args exit 64" "64" "$?"

sh "$SUT" 2>/dev/null
assert_eq "C6 zero-args exit 64" "64" "$?"

# ---------------------------------------------------------------------------
# CASE 7 — SQL_TO_DOC_NUM_INPUTS env-pin branch (input count + trailing args).
# Inputs=1, then output, then a trailing context-arg that must be ignored.
# ---------------------------------------------------------------------------
out7="$WORK/c7.md"
SQL_TO_DOC_NUM_INPUTS=1 sh "$SUT" "$WORK/f_basic" "$out7" "EXTRA_ARG_IGNORED"
assert_eq "C7 env-pin exit 0" "0" "$?"
assert_contains "C7 env-pin count = 2" "$out7" "Total distinct tables across all DDL sources: **2**"
assert_not_contains "C7 trailing arg not treated as input" "$out7" "## Block 02"

# ---------------------------------------------------------------------------
# CASE 8 — REAL Core DDL end-to-end (if the submodule tree is present).
# Drives the transform with two genuine DDL files from core/Database/DDL and
# asserts a real, known table name appears. SKIP-with-reason (§11.4.3) when the
# submodule working tree is absent — never a faked PASS.
# ---------------------------------------------------------------------------
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
DDL_V5="${REPO_ROOT}/core/Database/DDL/Definition.V5.sql"
DDL_DOCS="${REPO_ROOT}/core/Database/DDL/Extensions/Documents/Definition.V1.sql"
if [ -f "$DDL_V5" ] && [ -f "$DDL_DOCS" ]; then
    # Stage copies (simulate Docs Chain staging into temp content files).
    cp "$DDL_V5" "$WORK/real_in1"
    cp "$DDL_DOCS" "$WORK/real_in2"
    out8="$WORK/c8.md"
    sh "$SUT" "$WORK/real_in1" "$WORK/real_in2" "$out8"
    assert_eq "C8 real Core DDL exit 0" "0" "$?"
    assert_contains "C8 real table 'document' present" "$out8" "- \`document\`"
    # byte-stable on real input too
    out8b="$WORK/c8b.md"
    sh "$SUT" "$WORK/real_in1" "$WORK/real_in2" "$out8b"
    if diff -u "$out8" "$out8b" >/dev/null 2>&1; then
        ok "C8 real DDL byte-stable"
    else
        no "C8 real DDL NOT byte-stable"
    fi
else
    printf 'SKIP: C8 real Core DDL — core submodule working tree absent (reason: topology, §11.4.3)\n'
fi

# ---------------------------------------------------------------------------
printf '\n----------------------------------------\n'
printf 'sql_to_doc test summary: PASS=%d FAIL=%d\n' "$PASS" "$FAIL"
if [ "$FAIL" -ne 0 ]; then
    exit 1
fi
exit 0
