#!/usr/bin/env bash
# test_constitution_inheritance.sh — Comprehensive host-side test that
# asserts the full constitution-inheritance contract:
#   * all gate invariants (delegates to constitution_inheritance_gate.sh)
#   * every owned nested submodule carries an inheritance pointer
#   * find_constitution.sh resolves the constitution from nested depth
#
# Wire into the project's full-test orchestrator as a pre-flight check.
# Returns 0 only when EVERY assertion passes.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git -C "${SCRIPT_DIR}" rev-parse --show-toplevel 2>/dev/null)"
[[ -z "${REPO_ROOT}" ]] && REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

FAILS=0
ok()  { printf '  PASS  %s\n' "$1"; }
bad() { printf '  FAIL  %s\n' "$1"; FAILS=$((FAILS + 1)); }

echo "== Comprehensive constitution-inheritance test =="
echo "   repo root: ${REPO_ROOT}"
echo

# --- 1. Core gate invariants -----------------------------------------
echo "[1] Core gate invariants:"
if bash tests/constitution_inheritance_gate.sh; then
    ok "gate reports PASS"
else
    bad "gate reports FAIL"
fi
echo

# --- 2. find_constitution.sh resolves from nested depth --------------
echo "[2] find_constitution.sh resolution:"
if [[ -x constitution/find_constitution.sh ]]; then
    # Resolve from a deep child dir (use a submodule subdir if present).
    probe_dir="${REPO_ROOT}"
    for cand in core web_client; do
        [[ -d "${cand}" ]] && probe_dir="${REPO_ROOT}/${cand}" && break
    done
    resolved="$(cd "${probe_dir}" && bash "${REPO_ROOT}/constitution/find_constitution.sh" 2>/dev/null || true)"
    if [[ -n "${resolved}" && -f "${resolved}/Constitution.md" ]]; then
        ok "resolved from ${probe_dir#${REPO_ROOT}/} -> ${resolved#${REPO_ROOT}/}"
    else
        bad "find_constitution.sh failed to resolve from ${probe_dir}"
    fi
else
    bad "constitution/find_constitution.sh missing or not executable"
fi
echo

# --- 3. Every owned submodule carries an inheritance pointer ---------
echo "[3] Nested-submodule inheritance pointers:"
# Enumerate owned submodules from .gitmodules (authoritative declared
# list), excluding the constitution submodule itself. We deliberately do
# NOT use `git submodule status --recursive`: it aborts early if any
# nested gitlink lacks a .gitmodules mapping, silently under-reporting
# the owned set (§11.4.118 known-set completeness).
mapfile -t SUBS < <(git config -f .gitmodules --get-regexp '^submodule\..*\.path$' 2>/dev/null | awk '{print $2}' | grep -v '^constitution$' || true)
if [[ "${#SUBS[@]}" -eq 0 ]]; then
    echo "  (no nested submodules enumerated)"
fi
for sub in "${SUBS[@]}"; do
    [[ -z "${sub}" ]] && continue
    found_any=0
    for f in "${sub}/CLAUDE.md" "${sub}/AGENTS.md"; do
        if [[ -f "${f}" ]] && grep -qiF 'Helix Constitution' "${f}"; then
            found_any=1
        fi
    done
    if [[ "${found_any}" -eq 1 ]]; then
        ok "${sub}: inheritance pointer present"
    else
        bad "${sub}: inheritance pointer MISSING (no 'Helix Constitution' in CLAUDE.md/AGENTS.md)"
    fi
done
echo

# --- Verdict ----------------------------------------------------------
if [[ "${FAILS}" -eq 0 ]]; then
    echo "RESULT: PASS — constitution inheritance is real and recursive."
    exit 0
else
    echo "RESULT: FAIL — ${FAILS} assertion(s) violated. Fix at root cause (§11.4.4)."
    exit 1
fi
