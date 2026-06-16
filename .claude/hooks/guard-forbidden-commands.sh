#!/usr/bin/env bash
# guard-forbidden-commands.sh — PreToolUse guard (Constitution §11.4.109).
# Blocks Constitution-forbidden bypass flags on Bash tool calls so they can
# never be issued by forgetfulness. Enforces §11.4.113 (no force-push),
# §1/§11.4 (no --no-verify gate-skip), and signed-commit integrity.
#
# Protocol: Claude Code feeds the tool call as JSON on stdin. Exit 2 = DENY
# (stderr shown to the model); exit 0 = allow.
set -uo pipefail

payload="$(cat)"
# Extract the command string from the tool_input (fallback: raw payload).
cmd="$(printf '%s' "$payload" | python3 -c '
import sys, json
try:
    d = json.load(sys.stdin)
    print(d.get("tool_input", {}).get("command", ""))
except Exception:
    print("")
' 2>/dev/null)"
[ -z "$cmd" ] && cmd="$payload"

deny() {
    echo "BLOCKED by Constitution guard (§11.4.109): $1" >&2
    echo "If this is genuinely required, the operator must authorize it in-session." >&2
    exit 2
}

# Always-forbidden bypass flags (any tool, any subcommand).
printf '%s' "$cmd" | grep -Eq -- '--no-verify'      && deny "'--no-verify' skips the commit/inheritance gate"
printf '%s' "$cmd" | grep -Eq -- '--no-gpg-sign'    && deny "'--no-gpg-sign' bypasses signing"
printf '%s' "$cmd" | grep -Eq -- '--force-with-lease' && deny "force-push (--force-with-lease) violates §11.4.113"

# git push --force / -f
if printf '%s' "$cmd" | grep -Eq 'git[[:space:]].*push'; then
    if printf '%s' "$cmd" | grep -Eq -- '--force' || printf '%s' "$cmd" | grep -Eq -- '(^|[[:space:]])-f([[:space:]]|$)'; then
        deny "force-push (git push --force/-f) violates §11.4.113"
    fi
fi

exit 0
