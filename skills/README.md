# Skills — lazy-superstack

本 plugin 的所有 skill 都是**扁平結構**（每個 skill 是 `skills/<name>/SKILL.md`），
以確保 Claude Code 能正確自動發現。命名前綴標示能力領域與來源。

| Skill（觸發名） | 領域 | 處置 | 來源 / 授權 |
|---|---|---|---|
| `ponytail-guard` | 馬尾哥極簡 | 🖊️ 自有 | 本 repo（MIT）· 致謝 [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) |
| `design-thinking` | 設計思考 | 🖊️ 自有 | 本 repo（MIT）· 致謝 Stanford d.school / IDEO |
| `pm-brainstorming` | PM / 需求探索 | 📥 Vendored | [obra/superpowers](https://github.com/obra/superpowers)（MIT, © 2025 Jesse Vincent） |
| `pm-writing-plans` | PM / 計畫拆解 | 📥 Vendored | [obra/superpowers](https://github.com/obra/superpowers)（MIT, © 2025 Jesse Vincent） |
| `security-owasp` | 資安 | 📥 Vendored | [agamm/claude-code-owasp](https://github.com/agamm/claude-code-owasp)（MIT, © 2026 agamm） |

## 命名空間說明

`pm-` 前綴的兩個 skill 來自 obra/superpowers。若你**同時**安裝了 superpowers 本體，
兩邊會有功能相近但不同名的 skill（`pm-brainstorming` vs `superpowers:brainstorming`）——
這是刻意的，避免撞名；擇一使用即可。

完整授權與修改說明見根目錄 [`THIRD_PARTY_NOTICES.md`](../THIRD_PARTY_NOTICES.md)。

## 其餘能力來自 MCP

全端 / AI / DB / 雲端等能力不是靠 vendored skill，而是靠輕量 MCP wiring 提供
（見根目錄 `plugin.json` 與 `mcp-optional.example.json`）。執行 `/superstack-doctor`
可體檢哪些 MCP 已就緒。
