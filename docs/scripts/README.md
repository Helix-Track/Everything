# Script documentation companions

Per-script companion docs (Constitution §11.4.18). One entry per documented script.

- [constitution_inheritance_gate.md](constitution_inheritance_gate.md) — pre-build/pre-merge gate verifying the Constitution submodule is genuinely inherited.
- [test_constitution_inheritance.md](test_constitution_inheritance.md) — comprehensive host-side test of the full inheritance contract (gate + resolution + nested pointers).
- [pre_build_verification.md](pre_build_verification.md) — fast, non-mutating pre-build/pre-commit verification entry point.
- [meta_test_false_positive_proof.md](meta_test_false_positive_proof.md) — paired anti-bluff mutation proof that the inheritance gate catches regressions.
- [export_markdown.md](export_markdown.md) — Markdown regeneration pipeline exporting HTML + PDF siblings via pandoc.
- [guard-forbidden-commands.md](guard-forbidden-commands.md) — PreToolUse hook blocking forbidden bypass flags (force-push, --no-verify, --no-gpg-sign).
