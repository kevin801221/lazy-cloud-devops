#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# inject-ponytail.sh
# SessionStart hook for the "lazy-superstack" plugin.
# Emits the Ponytail Guard directive + a capability map into Claude Code's
# context so the minimalist rulebook is active from the first prompt, and the
# agent knows which superstack skills it can reach for.
# ---------------------------------------------------------------------------
set -euo pipefail

ROOT="${CLAUDE_PLUGIN_ROOT:-.}"

cat <<EOF
<lazy-superstack active="true">
🦥 LAZY SUPERSTACK is loaded — your AI agent now has a senior team on tap.

The Ponytail minimalist rulebook is ACTIVE for every code, infra, and design
decision this session. Full rulebook: ${ROOT}/skills/ponytail-guard/SKILL.md

CORE LAWS (apply immediately):
  1. Writing LESS code is the ultimate clean architecture. Delete before you add.
  2. Prefer native Web/HTML5 APIs over npm bloat. Least-privilege cloud, always.
  3. Zero magic strings. Zero dead deps. Zero speculative abstraction.

SKILLS you can invoke when the task calls for it:
  • design-thinking   — before building user-facing things (d.school 5-phase)
  • pm-brainstorming  — explore intent & requirements before any creative work
  • pm-writing-plans  — turn a spec into bite-sized verifiable tasks
  • security-owasp    — when touching auth, input handling, or security
  • ponytail-guard    — the minimalism rulebook (already active)

Capabilities for DB / cloud / full-stack / AI come from MCP servers.
Run /superstack-doctor to see which optional MCPs are ready to enable.
When in doubt, ship the smaller version.
</lazy-superstack>
EOF
