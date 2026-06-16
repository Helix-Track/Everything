# meta_test_false_positive_proof.sh

**Source:** `scripts/testing/meta_test_false_positive_proof.sh`

## Purpose
Paired anti-bluff mutation proof for the constitution-inheritance gate. A gate that always
passes is a bluff gate; this harness proves the gate actually catches the missing-inheritance
regression by mutating the Constitution and asserting the gate flips to FAIL.

## Usage
```bash
bash scripts/testing/meta_test_false_positive_proof.sh
```
Resolves repo root via `git rev-parse --show-toplevel` (fallback: `../..` from the script), then `cd`s there.

## Inputs
No arguments. Operates on `constitution/Constitution.md` (target) and invokes
`tests/constitution_inheritance_gate.sh` plus `constitution/meta_test_inheritance.sh`.

## Exit codes / outputs
Prints `META PASS` / `META FAIL` lines per check and a final `META-TEST RESULT` line.
- `0` — BOTH mutations prove the gate is non-bluff.
- `1` — baseline gate already failing (abort) or one or more proofs failed.

## Invariants checked
0. Baseline: the un-mutated gate must PASS (else the proof is meaningless — aborts).
1. **CM-CONSTITUTION-INHERITANCE** — backs up `Constitution.md`, strips every line
   containing the §11.4 forensic anchor, asserts the gate returns non-zero, then restores
   from backup and verifies the file is byte-identical via md5.
2. Runs the constitution-shipped generic mutation harness
   `constitution/meta_test_inheritance.sh` with the gate command and asserts it returns 0.

Every mutation backs up first, restores via trap on EXIT/INT/TERM, and checks md5 integrity.

## Related Constitution clauses
- §1.1 — every gate MUST have a paired mutation proving it catches the regression.
- §11.4 — forensic anchor that is stripped to drive the mutation.
