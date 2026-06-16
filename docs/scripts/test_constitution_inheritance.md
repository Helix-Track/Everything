# test_constitution_inheritance.sh

**Source:** `tests/test_constitution_inheritance.sh`

## Purpose
Comprehensive host-side test asserting the full constitution-inheritance contract:
gate invariants, nested-submodule inheritance pointers, and constitution resolution
from nested depth. Intended as a pre-flight check in the full-test orchestrator.

## Usage
```bash
bash tests/test_constitution_inheritance.sh
```
Resolves repo root via `git rev-parse --show-toplevel` (fallback: script parent), then `cd`s there.

## Inputs
No arguments. Reads `.gitmodules`, invokes `tests/constitution_inheritance_gate.sh` and
`constitution/find_constitution.sh`, and scans each owned submodule's `CLAUDE.md`/`AGENTS.md`.

## Exit codes / outputs
Prints numbered sections with `PASS` / `FAIL` lines and a final `RESULT` line.
- `0` — every assertion passes.
- `1` — one or more assertions violated.

## Invariants checked
1. Delegates to the inheritance gate and asserts it reports PASS.
2. `constitution/find_constitution.sh` is executable and resolves a directory containing
   `Constitution.md` when invoked from a deep child dir (`Core` or `Web-Client`).
3. Each owned submodule from `.gitmodules` (excluding `constitution`) carries an
   inheritance pointer — the string `Helix Constitution` in its `CLAUDE.md` or `AGENTS.md`.
   Submodules are read directly from `.gitmodules` (not `git submodule status --recursive`,
   which under-reports — §11.4.118 known-set completeness).

## Related Constitution clauses
- §11.4.118 — known-set completeness (authoritative submodule enumeration).
- §11.4.4 — fix at root cause (failure-verdict guidance).
