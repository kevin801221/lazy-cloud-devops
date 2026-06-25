# Third-Party Notices — lazy-superstack

`lazy-superstack` 捆綁了第三方開源內容。本檔彙整所有來源、作者、授權與收錄方式，
以符合各授權條款（保留版權與授權聲明）。收錄日期：2026-06-24。

> 處置定義：**Vendored** = 檔案被複製進本 repo（附原版 LICENSE）；
> **Wired** = 僅在 `plugin.json` / `mcp-optional.example.json` 設定指向其官方套件，**未**複製程式碼；
> **Inspired** = 概念/方法論致謝，未複製內容。

---

## A. Vendored Skills（複製進 repo，附 LICENSE）

### 1. superpowers — `brainstorming` + `writing-plans`
- 收錄為：`skills/pm-brainstorming/`、`skills/pm-writing-plans/`
- 來源：https://github.com/obra/superpowers
- 作者：Jesse Vincent (obra) / Prime Radiant
- 授權：MIT — © 2025 Jesse Vincent（見各 skill 目錄 `LICENSE`）
- 修改：僅將 frontmatter `name` 改為加前綴版本以避免命名衝突，並於檔頂加入 Vendored 註記；
  方法論內容未改動。

### 2. claude-code-owasp
- 收錄為：`skills/security-owasp/`
- 來源：https://github.com/agamm/claude-code-owasp
- 作者：agamm
- 授權：MIT — © 2026 agamm（見 `skills/security-owasp/LICENSE`）
- 修改：僅將 frontmatter `name` 改為 `security-owasp` 並於檔頂加入 Vendored 註記；內容未改動。

---

## B. Wired MCP Servers（設定指向，未複製程式碼）

預設啟用（`plugin.json`）：
| Server | 來源 | 作者 | 授權 |
|---|---|---|---|
| Context7 | https://github.com/upstash/context7 | Upstash | MIT |
| Docker MCP | https://github.com/ckreiling/mcp-server-docker | ckreiling | Apache-2.0 |

可選啟用（`mcp-optional.example.json`）：
| Server | 來源 | 作者 | 授權 |
|---|---|---|---|
| MongoDB MCP | https://github.com/mongodb-js/mongodb-mcp-server | MongoDB（官方） | Apache-2.0 |
| Postgres MCP Pro | https://github.com/crystaldba/postgres-mcp | Crystal DBA | MIT |
| AWS API MCP | https://github.com/awslabs/mcp | AWS Labs（官方） | Apache-2.0 |
| Terraform MCP | https://github.com/hashicorp/terraform-mcp-server | HashiCorp（官方） | MIT |
| GitHub MCP | https://github.com/github/github-mcp-server | GitHub（官方） | MIT |
| shadcn MCP | https://ui.shadcn.com | shadcn / Vercel | MIT |

---

## C. Inspired / 方法論致謝（未複製內容）

| 項目 | 來源 | 說明 |
|---|---|---|
| 馬尾哥極簡哲學 | https://github.com/DietrichGebert/ponytail （MIT） | `skills/ponytail-guard` 為其決策階梯哲學的原創再表述 |
| 設計思考方法論 | Stanford d.school · IDEO（公開教材） | `skills/design-thinking` 為原創撰寫，致謝其五階段框架 |

---

## D. 本專案授權

lazy-superstack 自身（自有 skills、指令、腳本、設定）以 MIT 授權發布，見根目錄 `LICENSE`。
