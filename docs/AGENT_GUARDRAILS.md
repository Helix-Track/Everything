# Agent Guardrails (Constitution §11.4.109)

Anti-forgetting enforcement floor for AI-agent work in this repo.

## 1. PreToolUse guard hook

`.claude/hooks/guard-forbidden-commands.sh`, wired via `.claude/settings.json`,
inspects every Bash tool call and **denies** Constitution-forbidden bypasses
before they run:

- `--no-verify` — skipping the commit / inheritance gate (§1, §11.4)
- `--no-gpg-sign` — bypassing signing
- `git push --force` / `-f` / `--force-with-lease` — §11.4.113 absolute no-force-push

Denied calls exit 2 with a directed reason; only an explicit in-session operator
authorization may lift a specific block.

## 2. Subagent constitutional preamble

Every dispatched subagent is given, in its prompt: read-only vs write scope,
"no git mutation/push", anti-bluff (§11.4 — captured evidence only), and
"report findings, do not fabricate". See this session's dispatch records.

## 3. Orchestrator pre-action checklist

Before any irreversible/outward action the orchestrator verifies: (a) `.git`
hardlink backup exists (§9.3); (b) no `--force`/`--no-verify` (§11.4.113); (c)
operator authorization captured for pushes (§2); (d) every new gate has a paired
mutation (§1.1); (e) defects halt the cycle and are root-caused before retest
(§11.4.4).

## Verify the guard

```
printf '{"tool_input":{"command":"git push --force origin main"}}' \
  | bash .claude/hooks/guard-forbidden-commands.sh ; echo "rc=$? (expect 2)"
printf '{"tool_input":{"command":"git status"}}' \
  | bash .claude/hooks/guard-forbidden-commands.sh ; echo "rc=$? (expect 0)"
```
