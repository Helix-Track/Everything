# pre_build_verification.sh

**Source:** `tests/pre_build_verification.sh`

## Purpose
Pre-build / pre-commit verification entry point. Wired into the git pre-commit hook and
intended to be called by build/test orchestrators before producing any artifact. Runs the
FAST, NON-MUTATING inheritance checks only.

## Usage
```bash
bash tests/pre_build_verification.sh
```
Resolves repo root via `git rev-parse --show-toplevel` (fallback: script parent), then `cd`s there.

## Inputs
No arguments. Invokes two sibling scripts in sequence.

## Exit codes / outputs
Prints `==>` section headers and a final `PRE-BUILD VERIFICATION: PASS/FAIL` line.
- `0` — every check passed.
- `1` (non-zero) — a check failed; commit/build is blocked.

## Invariants checked
1. `tests/constitution_inheritance_gate.sh` passes (Invariants 1–5).
2. `tests/test_constitution_inheritance.sh` passes (gate + `find_constitution` +
   all owned submodule pointers).

The anti-bluff mutation proof (`scripts/testing/meta_test_false_positive_proof.sh`)
mutates `Constitution.md` and is therefore deliberately NOT run here — never mutate
tracked files inside a commit hook. It belongs to the full test / CI sweep.

## Related Constitution clauses
- §11.4.4 — fix at root cause (failure-verdict guidance).
