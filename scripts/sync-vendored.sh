#!/usr/bin/env bash
# ===========================================================================
# sync-vendored.sh — 從上游重新同步 lazy-superstack 的 vendored skills
# ---------------------------------------------------------------------------
# lazy-superstack 只 vendor 兩個外部來源（superpowers PM、claude-code-owasp）。
# 這個腳本把它們從上游重新抓取、覆蓋到 skills/ 下，並提醒你重新套用命名空間
# 前綴與合規註記（frontmatter 的 name 與頂部 Vendored 區塊）。
#
# 用法：./scripts/sync-vendored.sh
#
# 注意：本腳本「只更新內容」，不會自動重打前綴。同步後請檢查三個 SKILL.md 的
# frontmatter，確保 name 仍為 pm-brainstorming / pm-writing-plans / security-owasp，
# 且頂部 Vendored 合規區塊還在（git diff 一看便知）。
# ===========================================================================
set -Eeuo pipefail

log()  { printf '\033[1;34m🔄 [sync]\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m✓\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m✗ %s\033[0m\n' "$*" >&2; exit 1; }

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

command -v git >/dev/null || die "git not installed"

# --- 1) claude-code-owasp (agamm, MIT) -------------------------------------
log "fetching agamm/claude-code-owasp ..."
git clone --depth 1 https://github.com/agamm/claude-code-owasp.git "$TMP/owasp" >/dev/null 2>&1
SRC="$TMP/owasp/.claude/skills/owasp-security"
[[ -f "$SRC/SKILL.md" ]] || die "owasp SKILL.md not found upstream — layout changed?"
cp "$SRC/SKILL.md"          "$ROOT/skills/security-owasp/SKILL.md"
cp -r "$SRC/reference"      "$ROOT/skills/security-owasp/reference"
cp "$TMP/owasp/LICENSE"     "$ROOT/skills/security-owasp/LICENSE"
ok "owasp synced"

# --- 2) superpowers PM skills (obra, MIT) ----------------------------------
# superpowers 透過 Claude Code plugin marketplace 安裝；優先從本機 cache 取，
# 找不到才從 GitHub 拉。
log "locating superpowers (brainstorming + writing-plans) ..."
SP_CACHE="$(find "$HOME/.claude/plugins/cache" -type d -path '*superpowers*/skills/brainstorming' 2>/dev/null | head -1 | sed 's#/skills/brainstorming##')"
if [[ -n "$SP_CACHE" && -d "$SP_CACHE" ]]; then
  log "using local cache: $SP_CACHE"
  SP="$SP_CACHE"
else
  log "cache miss — cloning obra/superpowers ..."
  git clone --depth 1 https://github.com/obra/superpowers.git "$TMP/sp" >/dev/null 2>&1
  SP="$TMP/sp"
fi
for skill in brainstorming writing-plans; do
  dst="$ROOT/skills/pm-${skill}"
  [[ -f "$SP/skills/$skill/SKILL.md" ]] || die "superpowers $skill SKILL.md not found — layout changed?"
  cp "$SP/skills/$skill/SKILL.md" "$dst/SKILL.md"
  cp "$SP/LICENSE" "$dst/LICENSE"
done
ok "superpowers PM skills synced"

# --- 3) 提醒 ---------------------------------------------------------------
printf '\n'
ok "同步完成。請務必檢查（git diff）："
echo "   • 三個 SKILL.md 的 frontmatter name 仍為 pm-brainstorming / pm-writing-plans / security-owasp"
echo "   • 每個檔頂部的「📥 Vendored skill」合規區塊還在"
echo "   • 更新 THIRD_PARTY_NOTICES.md 的版本/日期"
printf '\n上游覆蓋會清掉前綴與註記，這是預期行為——用 git diff 重新套回即可。\n'
