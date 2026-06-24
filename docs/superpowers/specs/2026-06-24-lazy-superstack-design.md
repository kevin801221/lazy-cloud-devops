# Lazy Superstack — 設計規格（Design Spec）

- 日期：2026-06-24
- 作者：kevin801221
- 狀態：待 review
- 取代：原 `lazy-cloud-devops` plugin（改名並擴大為能力捆綁包）

---

## 1. 願景與定位

`lazy-superstack` 是一個 **AI coding agent 能力捆綁包（capability bundle / meta-plugin）**。
使用者只要安裝這一個 plugin，他的 Claude Code（未來含 Codex）就同時長出八大能力，
裡面裝載的是「網路上目前最受認同、最強」的開源 skills 與 MCP servers。

**一句話定位**：裝一個 plugin，讓你的 AI coding agent 從「會寫程式」升級成
「有 PM 思維、會設計思考、懂極簡、能全端、會用 AI、能上雲、顧資安」的資深團隊。

定位轉變：從 `lazy-cloud-devops`（只做雲端部署）→ `lazy-superstack`（八領域能力捆綁），
保留 lazy / 馬尾哥（Ponytail）的極簡品牌精神貫穿全包。

---

## 2. 設計決策（已與使用者確認）

| 決策 | 結論 |
|---|---|
| 選材策略 | 廣度優先、八領域全涵蓋；但每領域**精選旗艦**（1–3 個最強），非全塞 |
| Plugin 名稱 | `lazy-superstack`（repo 一併改名） |
| 跨 agent | **先 Claude Code 做完整**；skill 全用純 markdown 確保 Codex 可讀；Codex 專用封裝下一迭代 |
| 授權合規 | 每個 vendored skill 各附原版 LICENSE + 全包 `THIRD_PARTY_NOTICES.md`；hosted/專有服務只引用不打包 |
| 命名空間 | vendored skill 掛 `lazy-superstack:` 之下，與既有同名 plugin 區隔 |

---

## 3. 選材清單（八領域 × 精選旗艦）

處置類型：
- 📥 **Vendor** = 複製 markdown 檔進 repo，必須保留原 LICENSE
- 🔌 **Wire** = 在 `plugin.json` 的 `mcpServers` 設定指向官方 MCP，不複製程式碼
- 🔗 **引用** = hosted/專有，僅在 README 提供連結與設定教學，不打包

> ⚠️ 星數待核實：調研 agent 回報的 ★ 數部分明顯偏高（疑似幻覺），實作前逐一核對真實 repo。

### ⭐ 核心領域

| 領域 | 項目 | 處置 | 授權 | 來源 | 備註 |
|---|---|---|---|---|---|
| PM | superpowers `brainstorming` + `writing-plans` | 📥 | MIT | obra/superpowers | 與既有 superpowers 同名 → 命名空間區隔 |
| PM | GitHub MCP（issue/PR/project board） | 🔌 | MIT | github/github-mcp-server | 需 PAT → 按需啟用 |
| PM（可選） | Jira：sooperset/mcp-atlassian | 🔌 | MIT | sooperset/mcp-atlassian | 可自架；Linux 端二選一 |
| PM（可選） | Linear 官方 remote | 🔗 | 專有 | mcp.linear.app | hosted，只引用 |
| 設計思考 | ui-ux-pro-max | 📥 | MIT | nextlevelbuilder/ui-ux-pro-max-skill | 既有同名 → 命名空間區隔 |
| 設計思考 | designer-skills（雙鑽石/JTBD/journey 子集） | 📥 | MIT | Owl-Listener/designer-skills | 只挑 design-research/ux-strategy 子集 |
| 設計思考 | Figma-Context-MCP | 🔌 | MIT | GLips/Figma-Context-MCP | 開源版；官方 Figma MCP 列為可選引用 |
| 馬尾哥極簡 | ponytail 原版 | 📥 | MIT | DietrichGebert/ponytail | 已驗證真實、活躍 |
| 馬尾哥極簡 | ponytail-guard（本專案延伸版） | 自有 | MIT | 本 repo | 保留：補前端/DB/容器/雲端規則 |
| DB | mongodb-mcp-server（官方） | 🔌 | Apache-2.0 | mongodb-js/mongodb-mcp-server | npx；需連線字串 → 按需 |
| DB | Postgres MCP Pro | 🔌 | MIT | crystaldba/postgres-mcp | uvx；index tuning |
| DB（替代） | Bytebase DBHub（多 DB 通吃） | 🔌 | MIT | bytebase/dbhub | 想一個 server 通吃時用 |

> 🚫 **避開**：`@modelcontextprotocol/server-postgres` 已 archived（2025-07）且有 SQL injection 漏洞。
> 既有 `lazy-cloud-devops` plugin.json 目前 wire 的就是這個 → **必須換掉**。

### 延伸領域

| 領域 | 項目 | 處置 | 授權 | 來源 | 備註 |
|---|---|---|---|---|---|
| 全端 | superpowers `test-driven-development` + `systematic-debugging` | 📥 | MIT | obra/superpowers | 命名空間區隔 |
| 全端 | Vercel react-best-practices | 📥 | MIT | vercel-labs/agent-skills | 官方 |
| 全端 | shadcn 官方 MCP | 🔌 | MIT | ui.shadcn.com registry | 零憑證可預設開 |
| 全端 / AI | Context7（即時文件） | 🔌 | MIT | upstash/context7 | 零憑證可預設開 |
| AI 應用 | langchain-skills | 📥 | MIT | langchain-ai/langchain-skills | RAG/agent/LangGraph |
| 雲端部署 | awslabs/mcp（AWS API） | 🔌 | Apache-2.0 | awslabs/mcp | uvx；需 AWS 憑證 → 按需 |
| 雲端部署 | hashicorp/terraform-mcp-server | 🔌 | MIT | hashicorp/terraform-mcp-server | docker；IaC |
| 雲端部署 | Docker MCP（ckreiling 或官方 gateway） | 🔌 | Apache/MIT | ckreiling/mcp-server-docker | 沿用既有 wiring |
| 雲端部署 | GCP/AWS 部署腳本 | 自有 | MIT | 本 repo | 保留既有 deploy-gcp/aws.sh |
| 資安 | claude-code-owasp | 📥 | MIT | agamm/claude-code-owasp | OWASP Top 10 + ASVS |
| 資安 | security-review prompt | 📥 | MIT | anthropics/claude-code-security-review | 與內建 /security-review 同名 → 改名 |
| 資安 | Semgrep MCP（官方 binary） | 🔌 | MIT | semgrep/mcp | 確定性 SAST |

---

## 4. 目錄結構

```
lazy-superstack/
├── .claude-plugin/
│   └── plugin.json              # 改名；skills/commands/hooks/mcpServers 全配置
├── skills/
│   ├── ponytail-guard/          # 自有：延伸極簡規則書（現有檔遷入）
│   │   └── SKILL.md
│   ├── vendored/                # 所有外部 vendored skills，按來源分目錄
│   │   ├── ponytail/            # DietrichGebert/ponytail + 其 LICENSE
│   │   ├── superpowers-pm/      # brainstorming + writing-plans + 其 LICENSE
│   │   ├── superpowers-dev/     # TDD + systematic-debugging + 其 LICENSE
│   │   ├── ui-ux-pro-max/       # + 其 LICENSE
│   │   ├── designer-skills/     # 子集 + 其 LICENSE
│   │   ├── langchain/           # + 其 LICENSE
│   │   ├── react-best-practices/# + 其 LICENSE
│   │   └── security/            # owasp + security-review + 其 LICENSE
│   └── README.md                # 各 skill 來源與命名空間對照表
├── commands/
│   ├── lazy-ship.md             # 既有：一鍵部署（保留）
│   └── superstack-doctor.md     # 新增：檢查哪些 MCP 已具備憑證可啟用
├── hooks/
│   ├── hooks.json
│   └── inject-ponytail.sh       # 既有：SessionStart 注入極簡指令（保留）
├── scripts/
│   ├── deploy-gcp.sh            # 既有保留
│   ├── deploy-aws.sh            # 既有保留
│   └── sync-vendored.sh         # 新增：從上游同步 vendored skills 的腳本
├── docs/
│   └── superpowers/specs/        # 本 spec
├── THIRD_PARTY_NOTICES.md       # 新增：所有 vendored 來源 + 授權彙整
├── LICENSE                      # 本專案 MIT（既有）
├── .gitignore
└── README.md                    # 全面改寫為能力捆綁包文案
```

> 註：Claude Code 的 skill 發現支援 `skills/<name>/SKILL.md`。vendored 子目錄維持各 skill 自己的
> `SKILL.md`，並在 `skills/README.md` 維護來源對照。實作時需驗證巢狀目錄是否被正確掃描，
> 若不被掃描則改為扁平化命名（如 `skills/ss-pm-brainstorming/SKILL.md`）。

---

## 5. MCP 啟用策略（兩級）

全部 MCP 預設開啟會在缺憑證時報錯、拖慢啟動。因此分兩級：

**A. 零憑證即用（預設啟用）**
- Context7（即時文件）
- shadcn MCP
- Docker MCP（本機 docker 即可）

**B. 需憑證（plugin.json 留設定範本，預設不啟用，README 教學開啟）**
- GitHub MCP（需 `GITHUB_TOKEN`）
- MongoDB MCP（需連線字串）
- Postgres MCP Pro（需 `DATABASE_URI`）
- AWS MCP（需 AWS 憑證）
- Terraform / Semgrep / Figma 等

`superstack-doctor` 指令：掃描環境變數，列出哪些 B 級 MCP 已具備憑證、可一鍵啟用。

---

## 6. 授權合規方案

所有候選皆 MIT / Apache-2.0（可重分發），但條件是**保留原始版權與授權聲明**。

1. 每個 vendored skill 目錄內放該來源的**原版 LICENSE 檔**。
2. 根目錄 `THIRD_PARTY_NOTICES.md` 彙整：來源名、作者、repo URL、授權、commit/版本、收錄日期。
3. README 設「致謝與靈感來源」區塊（已存在，擴充）。
4. hosted/專有服務（Linear、Atlassian remote、Snyk、Figma 官方、Vercel remote）**只引用設定不打包**。
5. 措辭嚴格區分「vendored（複製檔案）」與「inspired/wired（致謝或設定指向）」，不謊稱原創。

---

## 7. 跨 agent 策略

- **本迭代**：完整 Claude Code plugin（`plugin.json` + skills + MCP + hooks + commands）。
- **相容性**：所有 skill 用純 markdown（`SKILL.md`），確保 Codex / 其他 agent 可直接讀取內容。
- **下一迭代**：補 Codex 專用封裝（其 skill/plugin 格式）與 `AGENTS.md` 對照。

---

## 8. 既有 repo 演進

現有 `lazy-cloud-devops`（已 push）演進為 `lazy-superstack`：
- 保留：`ponytail-guard`、`lazy-ship` 指令、`inject-ponytail.sh`、`deploy-*.sh`、LICENSE。
- 改名：plugin.json `name` → `lazy-superstack`；repo 改名。
- 必改：plugin.json 移除已 archived 的 `server-postgres`，換成 MongoDB + Postgres MCP Pro。
- 重構：skill 目錄改為 `skills/<name>/SKILL.md` 結構，新增 `vendored/`。
- 改寫：README 從「雲端部署」擴為「八領域能力捆綁包」。

---

## 9. 非目標（YAGNI）

- 不自建任何 MCP server（只 wire 官方/社群既有的）。
- 不 fork 維護外部 skill 的邏輯（只 vendor 快照 + sync 腳本）。
- 不收 hosted/專有服務的程式碼。
- 本迭代不做 Codex 專用封裝（僅確保 markdown 相容）。
- 每領域不貪多（精選旗艦，避免肥大與撞名）。

---

## 10. 風險與待辦

| 風險 | 緩解 |
|---|---|
| 星數/人氣數據可能失真 | 實作前用 GitHub API 逐一核實，不採用的標註理由 |
| vendored skill 上游更新 | `sync-vendored.sh` + `THIRD_PARTY_NOTICES` 記錄版本 |
| 巢狀 skill 目錄可能不被掃描 | 實作首步先驗證；不行就扁平化命名 |
| 同名 skill 與既有 plugin 衝突 | 命名空間 + skills/README 對照表 |
| MCP 缺憑證報錯 | 兩級啟用 + superstack-doctor |
| 授權違規 | 每來源附 LICENSE + THIRD_PARTY_NOTICES + 只引用專有服務 |

---

## 11. 實作階段大綱（交付 writing-plans）

1. **重構骨架**：repo/plugin 改名、skill 目錄結構化、驗證巢狀掃描。
2. **修正 DB MCP**：移除 archived server-postgres，wire MongoDB + Postgres MCP Pro。
3. **Vendor 核心領域 skills**：ponytail、superpowers-pm、ui-ux-pro-max、designer-skills（含 LICENSE）。
4. **Vendor 延伸領域 skills**：superpowers-dev、react-best-practices、langchain、security。
5. **Wire 全部 MCP**：兩級啟用配置 + 範本。
6. **新增指令**：superstack-doctor、sync-vendored.sh。
7. **合規**：THIRD_PARTY_NOTICES.md + 各目錄 LICENSE。
8. **README 改寫** + 致謝區塊擴充。
9. **驗證**：plugin 載入、skill 可見、MCP wiring 語法、授權齊備。
```
