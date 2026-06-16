# Changelog

All notable changes to this repository are recorded here.

## 2026-06-16 — Helix Constitution inheritance

Parent (Helix-Track/Everything) final HEAD: `b76fc39`

### Constitution submodule
- Added the Helix Constitution as a git submodule at `constitution/`, pinned to `1d408cb`. No `v1.0.0` tag exists upstream; pinned to current `main` HEAD.
- Configured 6 upstream remotes locally within the submodule (push-free; local-only configuration).

### Rules audit (no promotions)
- Audited project rules for promotion to the constitution. Promoted **nothing** — no theme earned universal status; all candidate themes were already covered by the existing constitution.
- No credentials or project-specific data were ported into the constitution.

### Inheritance pointers
- Added constitution inheritance pointers to the parent `CLAUDE.md` and `AGENTS.md`, and to all 8 submodules.
- Submodule inheritance-pointer commits:
  - Core `6aae01f`
  - Web-Client `45e8530`
  - Desktop-Client `a2b3e29`
  - Android-Client `850b96e`
  - iOS-Client `0719e57`
  - Harmony-OS-Client `d1d45d0`
  - Aurora-OS-Client `2c786fd`
  - Screensaver `093fd8e`

### Constitution-inheritance gate and tests
- Added the constitution-inheritance gate: `tests/constitution_inheritance_gate.sh`.
- Added paired anti-bluff mutation: `scripts/testing/meta_test_false_positive_proof.sh` — proves the gate catches the missing-inheritance regression, with byte-identical md5 restore.
- Added comprehensive test: `tests/test_constitution_inheritance.sh`.
- Wired the gate into pre-build verification: `tests/pre_build_verification.sh` and `.git/hooks/pre-commit`.

### §11.4 closures
- GEMINI.md + QWEN.md carriers across the parent and all 8 submodules.
  - Submodule GEMINI/QWEN carrier commits:
    - Core `df6f13d`
    - Web-Client `16568b8`
    - Desktop-Client `1db5dab`
    - Android-Client `1103f41`
    - iOS-Client `af6909f`
    - Harmony-OS-Client `a1c4303`
    - Aurora-OS-Client `2dc62be`
    - Screensaver `e77d131`
- PreToolUse guard hook: `.claude/hooks/guard-forbidden-commands.sh` + `.claude/settings.json` + `docs/AGENT_GUARDRAILS.md`.
- Markdown HTML/PDF export pipeline: `scripts/export_markdown.sh`.
- CodeGraph index: initialized via `codegraph init`; `.codegraph/` is gitignored.

### Compliance audit
- Full compliance audit recorded in `CONSTITUTION_COMPLIANCE_AUDIT.md`.
