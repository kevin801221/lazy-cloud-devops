#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# inject-ponytail.sh
# SessionStart hook for the "lazy-cloud-devops" plugin.
# Emits the Ponytail Guard directive into Claude Code's context so the
# minimalist rulebook is active from the very first prompt of the session.
#
# A SessionStart hook's stdout is appended to the model context as
# additionalContext — so we print a compact, high-signal directive that
# points Claude at the full skill and locks in the non-negotiable rules.
# ---------------------------------------------------------------------------
set -euo pipefail

SKILL_PATH="${CLAUDE_PLUGIN_ROOT:-.}/skills/ponytail-guard.md"

cat <<EOF
<ponytail-guard active="true">
🦥 LAZY CLOUD DEVOPS — Ponytail Senior Engineer Mode is now ACTIVE.

Adopt these non-negotiable rules for every code, infra, and design decision
in this session. The full rulebook lives at:
  ${SKILL_PATH}
Load it with the Skill tool (skill: "ponytail-guard") before writing code.

CORE LAWS (apply immediately, even before loading the full skill):
  1. Writing LESS code is the ultimate clean architecture. Delete before you add.
  2. Prefer native Web/HTML5 APIs (<dialog>, <details>, fetch, Intl) over npm UI bloat.
  3. Zero magic strings. Zero dead deps. Zero speculative abstraction.
  4. Containers: multi-stage Alpine builds, non-root, minimal layers.
  5. Cloud: least-privilege IAM, no wildcard permissions, smallest viable footprint.
  6. UI: 60-30-10 colour rule, systemic type scale, zero-slop motion.

Refuse to generate "AI Slop". When in doubt, ship the smaller version.
</ponytail-guard>
EOF
