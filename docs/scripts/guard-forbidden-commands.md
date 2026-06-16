# guard-forbidden-commands.sh

**Source:** `.claude/hooks/guard-forbidden-commands.sh`

## Purpose
PreToolUse guard hook that blocks Constitution-forbidden bypass flags on Bash tool calls so
they can never be issued by forgetfulness. Enforces no-force-push, no gate-skip, and
signed-commit integrity.

## Usage
Invoked automatically by Claude Code as a PreToolUse hook (not run by hand). Claude Code
feeds the tool call as JSON on stdin:
```bash
echo "$TOOL_CALL_JSON" | .claude/hooks/guard-forbidden-commands.sh
```

## Inputs
Tool-call JSON on stdin. The command string is extracted from `tool_input.command` via an
inline `python3` snippet; if extraction yields nothing, the raw stdin payload is matched instead.

## Exit codes / outputs
Per the hook protocol:
- `0` — allow (command not forbidden).
- `2` — DENY; a `BLOCKED by Constitution guard` message is printed to stderr (shown to the model).

## Invariants checked
Denies the command if any of these match:
- `--no-verify` — skips the commit/inheritance gate.
- `--no-gpg-sign` — bypasses signing.
- `--force-with-lease` — force-push.
- A `git ... push` combined with `--force` or a standalone `-f` flag — force-push.

## Related Constitution clauses
- §11.4.109 — guard against forbidden bypass flags (the hook's mandate).
- §11.4.113 — no force-push.
- §1 / §11.4 — no `--no-verify` gate-skip and signed-commit integrity.
