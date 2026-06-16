# constitution_inheritance_gate.sh

**Source:** `tests/constitution_inheritance_gate.sh`

## Purpose
Pre-build / pre-merge gate that verifies the Helix Constitution submodule is genuinely
inherited (not merely referenced). A failure here MUST block the build.

## Usage
```bash
bash tests/constitution_inheritance_gate.sh
```
Runs from any CWD; resolves the repo root via `git rev-parse --show-toplevel`, falling
back to the script's parent directory.

## Inputs
No arguments. Reads tracked files under the repo root: `constitution/Constitution.md`,
`constitution/CLAUDE.md`, `constitution/AGENTS.md`, and the parent `CLAUDE.md` / `AGENTS.md`.

## Exit codes / outputs
Prints `PASS` / `FAIL` lines per invariant plus a final `GATE RESULT` line.
- `0` — all invariants hold.
- `1` — one or more invariants violated.

## Invariants checked
1. `constitution/` directory exists.
2. `constitution/Constitution.md` exists and contains the §11.4 forensic-anchor heading.
3. `constitution/CLAUDE.md` exists and contains `MANDATORY ANTI-BLUFF COVENANT`.
4. `constitution/AGENTS.md` exists and contains `Anti-bluff covenant`.
5. Parent `CLAUDE.md` references `constitution/CLAUDE.md` and parent `AGENTS.md`
   references `constitution/AGENTS.md` (inheritance pointers).

## Related Constitution clauses
- §11.4 — End-user quality guarantee (forensic anchor, the asserted heading).
- §1.1 — paired anti-bluff mutation requirement (see
  `scripts/testing/meta_test_false_positive_proof.sh`).
