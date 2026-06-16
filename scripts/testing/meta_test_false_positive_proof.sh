#!/usr/bin/env bash
# meta_test_false_positive_proof.sh — Paired anti-bluff mutation proof
# for the constitution-inheritance gate (Constitution §1.1).
#
# A gate that always passes is a BLUFF gate. This harness PROVES the
# inheritance gate actually catches the missing-inheritance regression
# by mutating the Constitution and asserting the gate flips to FAIL.
#
# Two independent mutations are run (defense in depth):
#   CM-CONSTITUTION-INHERITANCE  — strip the §11.4 forensic anchor from
#                                  constitution/Constitution.md locally,
#                                  assert gate FAILs, restore.
#   constitution/meta_test_inheritance.sh — the constitution-shipped
#                                  generic mutation+restore loop, given
#                                  our gate command as its argument.
#
# Every mutation backs up first and restores via trap, with an md5
# integrity check after restore. Exit 0 only if BOTH mutations prove
# the gate is non-bluff.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git -C "${SCRIPT_DIR}" rev-parse --show-toplevel 2>/dev/null)"
[[ -z "${REPO_ROOT}" ]] && REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
cd "${REPO_ROOT}"

GATE_CMD="bash ${REPO_ROOT}/tests/constitution_inheritance_gate.sh"
TARGET="constitution/Constitution.md"
ANCHOR='### §11.4 End-user quality guarantee — forensic anchor'

md5_of() { md5 -q "$1" 2>/dev/null || md5sum "$1" 2>/dev/null | awk '{print $1}'; }

FAILS=0
note_pass() { printf 'META PASS  %s\n' "$1"; }
note_fail() { printf 'META FAIL  %s\n' "$1"; FAILS=$((FAILS + 1)); }

echo "== Anti-bluff meta-test: constitution-inheritance gate =="
echo

# Sanity: the un-mutated gate MUST pass, else the proof is meaningless.
echo "[0] Baseline: gate on un-mutated tree must PASS"
if ${GATE_CMD} >/dev/null 2>&1; then
    note_pass "baseline gate PASS"
else
    note_fail "baseline gate did NOT pass — fix inheritance before meta-testing"
    echo "ABORT: cannot prove a gate that is already failing."
    exit 1
fi
echo

# --- Mutation 1: CM-CONSTITUTION-INHERITANCE -------------------------
echo "[1] CM-CONSTITUTION-INHERITANCE mutation (strip §11.4 anchor)"
if [[ ! -f "${TARGET}" ]]; then
    note_fail "target ${TARGET} not found"
else
    occ="$(grep -cF -- "${ANCHOR}" "${TARGET}" || true)"
    echo "    anchor occurrences in ${TARGET}: ${occ}"
    BK="$(mktemp)"; cp -- "${TARGET}" "${BK}"
    pre_md5="$(md5_of "${TARGET}")"
    # shellcheck disable=SC2064
    trap "cp -- '${BK}' '${TARGET}'; rm -f '${BK}'" EXIT INT TERM
    # Remove ALL lines containing the anchor (guarantees the gate flips).
    grep -vF -- "${ANCHOR}" "${BK}" > "${TARGET}"
    set +e; ${GATE_CMD} >/dev/null 2>&1; rc=$?; set -e
    # Restore + verify integrity.
    cp -- "${BK}" "${TARGET}"; rm -f "${BK}"; trap - EXIT INT TERM
    post_md5="$(md5_of "${TARGET}")"
    if [[ "${rc}" -ne 0 ]]; then
        note_pass "gate correctly FAILed (rc=${rc}) on mutated Constitution"
    else
        note_fail "gate returned 0 on mutated Constitution — BLUFF GATE"
    fi
    if [[ "${pre_md5}" == "${post_md5}" ]]; then
        note_pass "Constitution.md restored byte-identical (md5 ${post_md5})"
    else
        note_fail "Constitution.md NOT restored (pre=${pre_md5} post=${post_md5})"
    fi
fi
echo

# --- Mutation 2: constitution-shipped generic harness ----------------
echo "[2] constitution/meta_test_inheritance.sh (shipped generic mutation)"
if [[ -x constitution/meta_test_inheritance.sh ]]; then
    set +e
    bash constitution/meta_test_inheritance.sh "${GATE_CMD}"
    rc2=$?
    set -e
    if [[ "${rc2}" -eq 0 ]]; then
        note_pass "shipped meta-test confirms gate is non-bluff (rc=0)"
    else
        note_fail "shipped meta-test reports gate is a bluff gate (rc=${rc2})"
    fi
else
    note_fail "constitution/meta_test_inheritance.sh missing or not executable"
fi
echo

if [[ "${FAILS}" -eq 0 ]]; then
    echo "META-TEST RESULT: PASS — the inheritance gate is proven non-bluff (§1.1)."
    exit 0
else
    echo "META-TEST RESULT: FAIL — ${FAILS} proof(s) failed."
    exit 1
fi
