#!/usr/bin/env bash
# pre_build_verification.sh — Pre-build / pre-commit verification entry.
# Wired into the git pre-commit hook and intended to be called by the
# project's build/test orchestrators before producing any artifact.
#
# Runs the FAST, NON-MUTATING checks:
#   * constitution inheritance gate (Invariants 1-5)
#   * comprehensive inheritance test (gate + find_constitution + all
#     owned submodule pointers)
#
# The anti-bluff mutation proof (scripts/testing/meta_test_false_positive_proof.sh)
# mutates Constitution.md and is therefore run by the FULL test / CI
# sweep, NOT here (never mutate tracked files inside a commit hook).
#
# Exit 0 only when every check passes; non-zero blocks the build/commit.

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git -C "${SCRIPT_DIR}" rev-parse --show-toplevel 2>/dev/null)"
[[ -z "${REPO_ROOT}" ]] && REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

rc=0
echo "==> pre-build: constitution inheritance gate"
bash tests/constitution_inheritance_gate.sh || rc=1
echo
echo "==> pre-build: comprehensive inheritance test"
bash tests/test_constitution_inheritance.sh || rc=1
echo
if [[ "${rc}" -eq 0 ]]; then
    echo "PRE-BUILD VERIFICATION: PASS"
else
    echo "PRE-BUILD VERIFICATION: FAIL — commit/build blocked (fix at root cause, §11.4.4)"
fi
exit "${rc}"
