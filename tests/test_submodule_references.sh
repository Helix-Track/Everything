#!/usr/bin/env bash
# test_submodule_references.sh — Submodule reference-integrity gate.
# Proves every declared submodule resolves AND no parent-tracked file
# still references a RETIRED (renamed-away) submodule path. This is the
# physical-proof safety net for the CONST-052 snake_case rename migration:
# a broken/dangling submodule path reference becomes mechanically
# impossible to miss (operator mandate 2026-06-17: references MUST be
# unbroken, covered with validation tests, no bluff).
#
# Exit 0 only when: (A) every .gitmodules path exists + is a live gitlink;
# (B) ZERO parent-tracked files reference any RETIRED path as a filesystem
# path (`<retired>/` or `cd <retired>`).

set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git -C "${SCRIPT_DIR}" rev-parse --show-toplevel 2>/dev/null)"
[[ -z "${REPO_ROOT}" ]] && REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

# RETIRED = old PascalCase/hyphen submodule paths that have been renamed to
# snake_case. After each rename, append the OLD path here; the gate then
# proves the reference sweep for that rename was complete.
RETIRED_PATHS=(
  "Aurora-OS-Client"
  "Harmony-OS-Client"
  "Screensaver"
  "Web-Client"
  "Desktop-Client"
  "Android-Client"
  "iOS-Client"
  "Core"
)

FAILS=0
ok()  { printf '  PASS  %s\n' "$1"; }
bad() { printf '  FAIL  %s\n' "$1"; FAILS=$((FAILS + 1)); }

echo "== Submodule reference-integrity gate =="

# --- A. Every declared submodule path exists + is a live gitlink ------
echo "[A] declared submodule paths resolve:"
while read -r path; do
  [[ -z "${path}" ]] && continue
  if [[ -e "${path}/.git" ]] || git -C "${path}" rev-parse --git-dir >/dev/null 2>&1; then
    ok "${path}"
  else
    bad "${path}: missing or not a live submodule"
  fi
done < <(git config -f .gitmodules --get-regexp '^submodule\..*\.path$' 2>/dev/null | awk '{print $2}')

# git submodule status must report no missing (-) / merge-conflict (U) rows
echo "[A2] git submodule status clean (no missing):"
if git submodule status 2>/dev/null | grep -qE '^[-U]'; then
  bad "git submodule status reports missing/conflicted submodules"
  git submodule status | grep -E '^[-U]' | sed 's/^/      /'
else
  ok "no missing/conflicted submodules"
fi

# --- B. No tracked file references a RETIRED path -----------------------
echo "[B] no dangling references to retired paths:"
if [[ "${#RETIRED_PATHS[@]}" -eq 0 ]]; then
  echo "  (no retired paths yet)"
fi
for old in "${RETIRED_PATHS[@]}"; do
  [[ -z "${old}" ]] && continue
  # Path-context references only: "<old>/" or "cd <old>" (avoid prose / repo-URL false hits).
  hits="$(git grep -lE "(^|[^A-Za-z0-9_.-])${old}/|cd ${old}([^A-Za-z0-9_-]|$)" 2>/dev/null \
           | grep -vE '^(constitution|containers|docs_chain|challenges)/' || true)"
  if [[ -n "${hits}" ]]; then
    bad "retired '${old}/' still referenced in:"
    echo "${hits}" | sed 's/^/        /'
  else
    ok "no '${old}/' path references remain"
  fi
done

echo
if [[ "${FAILS}" -eq 0 ]]; then
  echo "RESULT: PASS — submodule references intact, no dangling retired paths."
  exit 0
else
  echo "RESULT: FAIL — ${FAILS} integrity violation(s). Fix references at root cause (§11.4.4)."
  exit 1
fi
