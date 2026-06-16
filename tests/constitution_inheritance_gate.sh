#!/usr/bin/env bash
# constitution_inheritance_gate.sh — Pre-build / pre-merge gate that
# verifies the Helix Constitution submodule is really inherited, not
# merely referenced. A failure here MUST block the build.
#
# Invariants (all REAL anchors, verified present at wire-up time):
#   1. constitution/ directory exists.
#   2. constitution/Constitution.md exists AND contains the §11.4
#      forensic-anchor heading line.
#   3. constitution/CLAUDE.md exists AND contains the
#      "MANDATORY ANTI-BLUFF COVENANT" anchor.
#   4. constitution/AGENTS.md exists AND contains the
#      "Anti-bluff covenant" anchor.
#   5. The parent CLAUDE.md AND AGENTS.md both reference the
#      constitution submodule (inheritance pointer present).
#
# Paired anti-bluff mutation: scripts/testing/meta_test_false_positive_proof.sh
# (Constitution §1.1 — every gate MUST have a paired mutation proving it
#  catches the missing-inheritance regression).
#
# Exit code: 0 = all invariants hold; non-zero = gate FAILED.

set -uo pipefail

# Resolve repo root deterministically (works from any CWD / as a hook).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git -C "${SCRIPT_DIR}" rev-parse --show-toplevel 2>/dev/null)"
[[ -z "${REPO_ROOT}" ]] && REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

# Exact anchor strings (captured from the pinned constitution revision).
ANCHOR_CONSTITUTION='### §11.4 End-user quality guarantee — forensic anchor'
ANCHOR_CLAUDE='MANDATORY ANTI-BLUFF COVENANT'
ANCHOR_AGENTS='Anti-bluff covenant'

FAILS=0
pass() { printf '  PASS  %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; FAILS=$((FAILS + 1)); }

require_file_with_anchor() {
    # $1=path  $2=anchor (fixed string)  $3=label
    local path="$1" anchor="$2" label="$3"
    if [[ ! -f "${path}" ]]; then
        fail "${label}: file missing (${path})"
        return
    fi
    if grep -qF -- "${anchor}" "${path}"; then
        pass "${label}: anchor present"
    else
        fail "${label}: anchor MISSING in ${path} -> '${anchor}'"
    fi
}

echo "== Constitution inheritance gate =="
echo "   repo root: ${REPO_ROOT}"

# Invariant 1
if [[ -d constitution ]]; then
    pass "Invariant 1: constitution/ directory exists"
else
    fail "Invariant 1: constitution/ directory missing"
fi

# Invariant 2/3/4
require_file_with_anchor constitution/Constitution.md "${ANCHOR_CONSTITUTION}" "Invariant 2 (Constitution.md)"
require_file_with_anchor constitution/CLAUDE.md        "${ANCHOR_CLAUDE}"       "Invariant 3 (CLAUDE.md)"
require_file_with_anchor constitution/AGENTS.md        "${ANCHOR_AGENTS}"       "Invariant 4 (AGENTS.md)"

# Invariant 5: parent files reference the submodule
if [[ -f CLAUDE.md ]] && grep -qF -- 'constitution/CLAUDE.md' CLAUDE.md; then
    pass "Invariant 5a: parent CLAUDE.md references constitution submodule"
else
    fail "Invariant 5a: parent CLAUDE.md does NOT reference constitution submodule"
fi
if [[ -f AGENTS.md ]] && grep -qiF -- 'constitution/AGENTS.md' AGENTS.md; then
    pass "Invariant 5b: parent AGENTS.md references constitution submodule"
else
    fail "Invariant 5b: parent AGENTS.md does NOT reference constitution submodule"
fi

echo
if [[ "${FAILS}" -eq 0 ]]; then
    echo "GATE RESULT: PASS (all invariants hold)"
    exit 0
else
    echo "GATE RESULT: FAIL (${FAILS} invariant(s) violated)"
    exit 1
fi
