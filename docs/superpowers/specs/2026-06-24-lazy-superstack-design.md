# Lazy Superstack — 設計規格（Design Spec）

- 日期：2026-06-24
- 作者：kevin801221
- 狀態：待最終 review（瘦身核心版）
- 取代：原 `lazy-cloud-devops` plugin（改名並擴大為能力捆綁包）

---

## 1. 願景與定位

`lazy-superstack` 是一個 **AI coding agent 能力捆綁包（capability bundle / meta-plugin）**。
使用者安裝這一個 plugin，他的 Claude Code（未來含 Codex）就同時長出八大能力。

**一句話定位**：裝一個 plugin，讓你的 AI coding agent 從「會寫程式」升級成
「有 PM 思維、會設計思考、懂極簡、能全端、會用 AI、能上雲、顧資安」的資深團隊。

品牌：保留 lazy / 馬尾哥（Ponytail）的極簡精神貫穿全包——**plugin 本身也要極簡，
不貪多。每領域精選旗艦，能用自有精選 skill + MCP wiring 解決的就不 vendor 一堆檔案。**

---

## 2. 設計決策（已與使用者確認）

| 決策 | 結論 |
|---|---|
| 選材策略 | 八領域全涵蓋，但**精選旗艦**；瘦身核心版：vendored skill 只留 2 個 |
| Plugin 名稱 | `lazy-superstack`（repo 一併改名） |
| 跨 agent | 先 Claude Code 做完整；skill 全用純 markdown 確保 Codex 可讀；Codex 封裝下一迭代 |
| 設計思考來源 | **自寫**（現成候選 rastian 無授權、melodic 該 skill 不存在；方法論為公共知識） |
| 授權合規 | 每個 vendored skill 附原版 LICENSE + 全包 `THIRD_PARTY_NOTICES.md`；專有服務只引用 |
| 命名空間 | vendored skill 掛 `lazy-superstack:` 之下，與既有同名 plugin 區隔 |

---

## 3. 選材清單（最終瘦身核心版）

處置類型：📥 Vendor（複製檔+附 LICENSE）｜🔌 Wire（plugin.json 設定指向官方 MCP）｜🖊️ 自有（原創撰寫）

> ⚠️ 星數待核實：調研 agent 回報的 ★ 數部分明顯偏高（疑似幻覺），實作前以 GitHub API 核對真實 repo。

| 領域 | 項目 | 處置 | 授權 | 來源 |
|---|---|---|---|---|
| 馬尾哥極簡 | `ponytail-guard`（含前端/DB/容器/雲端延伸規則） | 🖊️ 自有 | MIT | 本 repo（已寫好） |
| 設計思考 | `design-thinking`（d.school 五階段 + Empathy Map/POV/HMW 模板 + 引導腳本） | 🖊️ 自有 | MIT | 本 repo（新寫，致謝 IDEO/d.school） |
| PM | superpowers `brainstorming` + `writing-plans` | 📥 | MIT | obra/superpowers |
| 資安 | `claude-code-owasp`（OWASP Top 10 + ASVS + LLM/Agentic） | 📥 | MIT | agamm/claude-code-owasp |
| DB | mongodb-mcp-server（官方） | 🔌 | Apache-2.0 | mongodb-js/mongodb-mcp-server |
| DB | Postgres MCP Pro | 🔌 | MIT | crystaldba/postgres-mcp |
| 雲端 | Docker MCP | 🔌 | Apache/MIT | ckreiling/mcp-server-docker |
| 雲端 | AWS API MCP | 🔌 | Apache-2.0 | awslabs/mcp |
| 雲端 | Terraform MCP | 🔌 | MIT | hashicorp/terraform-mcp-server |
| 全端/AI | Context7（即時文件） | 🔌 | MIT | upstash/context7 |
| 全端 | shadcn 官方 MCP | 🔌 | MIT | ui.shadcn.com registry |

**vendored skill = 2（superpowers-pm、owasp）｜自有 skill = 2（ponytail-guard、design-thinking）｜wire MCP = 7。**

八領域涵蓋對照：
- **PM** → superpowers brainstorming+writing-plans（vendor）；GitHub MCP 列為可選按需
- **設計思考** → 自寫 design-thinking
- **馬尾哥** → ponytail-guard（自有）
- **DB** → MongoDB + Postgres MCP Pro（wire）
- **全端** → Context7 + shadcn（wire）+ ponytail-guard 前端規則
- **AI** → Context7（wire）
- **雲端** → Docker/AWS/Terraform MCP（wire）+ 既有 deploy 腳本
- **資安** → claude-code-owasp（vendor）+ ponytail-guard 最小權限規則

### 砍掉（避免肥大／重複／撞名）
ui-ux-pro-max、designer-skills（被自寫 design-thinking 取代）、langchain-skills、
Vercel react-best-practices、superpowers TDD/systematic-debugging（本環境已有 superpowers，重複）、
Figma MCP、Semgrep MCP、Jira/Linear（後三者列為 README「可選擴充」連結，不打包）。

> 🚫 **必修**：既有 `lazy-cloud-devops` plugin.json wire 的官方 `@modelcontextprotocol/server-postgres`
> 已 archived（2025-07）且有 SQL injection 漏洞 → 換成 MongoDB + Postgres MCP Pro。

---

## 4. 目錄結構

```
lazy-superstack/
├── .claude-plugin/
│   └── plugin.json              # 改名；skills/commands/hooks/mcpServers 全配置
├── skills/
│   ├── ponytail-guard/          # 🖊️ 自有（現有檔遷入）
│   │   └── SKILL.md
│   ├── design-thinking/         # 🖊️ 自有（新寫）
│   │   ├── SKILL.md
│   │   └── reference/templates.md
│   ├── vendored/                # 只有 2 個外部來源
│   │   ├── superpowers-pm/      # brainstorming + writing-plans + LICENSE + NOTICE
│   │   └── security-owasp/      # claude-code-owasp + LICENSE + NOTICE
│   └── README.md                # skill 來源與命名空間對照表
├── commands/
│   ├── lazy-ship.md             # 既有保留
│   └── superstack-doctor.md     # 新增：掃描哪些按需 MCP 已具備憑證可啟用
├── hooks/
│   ├── hooks.json               # 既有保留
│   └── inject-ponytail.sh       # 既有保留
├── scripts/
│   ├── deploy-gcp.sh            # 既有保留
│   ├── deploy-aws.sh            # 既有保留
│   └── sync-vendored.sh         # 新增：同步 2 個 vendored 來源
├── docs/superpowers/specs/      # 本 spec
├── THIRD_PARTY_NOTICES.md       # 新增：vendored 來源 + 授權彙整
├── LICENSE                      # 本專案 MIT（既有）
├── .gitignore
└── README.md                    # 改寫為能力捆綁包文案
```

> 實作首步驗證：Claude Code 是否遞迴掃描 `skills/vendored/<來源>/SKILL.md`。
> 若不掃描，改為扁平命名（如 `skills/ss-pm-brainstorming/SKILL.md`）。

---

## 5. MCP 啟用策略（兩級）

全部 MCP 預設開啟會在缺憑證時報錯、拖慢啟動。分兩級：

**A. 零憑證即用（預設啟用）**：Context7、shadcn、Docker（本機 docker 即可）

**B. 需憑證（plugin.json 留範本，預設不啟用，README 教學）**：
MongoDB（連線字串）、Postgres MCP Pro（`DATABASE_URI`）、AWS（AWS 憑證）、Terraform、GitHub（PAT）

`superstack-doctor` 指令：掃描環境變數，列出哪些 B 級 MCP 已具備憑證、可一鍵啟用。

---

## 6. 授權合規方案

候選皆 MIT / Apache-2.0（可重分發），條件是保留原始版權與授權聲明。

1. 每個 vendored skill 目錄放該來源**原版 LICENSE**。
2. 根目錄 `THIRD_PARTY_NOTICES.md` 彙整：來源、作者、URL、授權、版本、收錄日期。
3. README「致謝與靈感來源」區塊（已存在，擴充）。
4. 專有服務（Linear、Atlassian remote、Snyk、Figma 官方、Vercel remote）只引用不打包。
5. 措辭嚴格區分 vendored（複製）／inspired（致謝）／wired（設定指向）／自寫（原創致謝方法論來源）。

---

## 7. 跨 agent 策略

- 本迭代：完整 Claude Code plugin。
- 相容性：所有 skill 純 markdown（`SKILL.md`），Codex / 其他 agent 可直接讀。
- 下一迭代：Codex 專用封裝 + `AGENTS.md` 對照。

---

## 8. 既有 repo 演進

`lazy-cloud-devops`（已 push）→ `lazy-superstack`：
- 保留：`ponytail-guard`、`lazy-ship`、`inject-ponytail.sh`、`deploy-*.sh`、LICENSE、致謝區塊。
- 改名：plugin.json `name` → `lazy-superstack`；repo 改名。
- 必改：移除 archived `server-postgres`，換 MongoDB + Postgres MCP Pro。
- 重構：skill 改 `skills/<name>/SKILL.md`，新增 `vendored/`、`design-thinking/`。
- 改寫：README 擴為八領域能力捆綁包。

---

## 9. 非目標（YAGNI）

- 不自建任何 MCP server（只 wire 既有官方/社群）。
- 不 fork 維護外部 skill 邏輯（只 vendor 快照 + sync 腳本）。
- 不收 hosted/專有服務程式碼。
- 本迭代不做 Codex 專用封裝（僅確保 markdown 相容）。
- 每領域不貪多——vendored 只留 2 個真正無可替代的。

---

## 10. 風險與緩解

| 風險 | 緩解 |
|---|---|
| 星數/人氣失真 | 實作前 GitHub API 逐一核實 |
| vendored 上游更新 | `sync-vendored.sh` + `THIRD_PARTY_NOTICES` 記版本 |
| 巢狀 skill 目錄可能不被掃描 | 實作首步驗證；不行就扁平化命名 |
| 同名 skill 與既有 plugin 衝突 | 命名空間 + skills/README 對照 |
| MCP 缺憑證報錯 | 兩級啟用 + superstack-doctor |
| 授權違規 | 每來源附 LICENSE + NOTICES + 專有只引用 |
| 自寫 design-thinking 品質 | 對齊 d.school 公開教材；含可操作模板與引導腳本 |

---

## 11. 實作階段大綱（交付 writing-plans）

1. **重構骨架**：repo/plugin 改名、skill 目錄結構化、**驗證巢狀掃描**。
2. **修正 DB MCP**：移除 archived server-postgres，wire MongoDB + Postgres MCP Pro。
3. **自寫 skills**：擴充 ponytail-guard（已存在）、新寫 design-thinking（+ 模板）。
4. **Vendor 2 個 skills**：superpowers-pm（brainstorming+writing-plans）、security-owasp（含 LICENSE）。
5. **Wire 全部 MCP**：兩級啟用配置 + 範本。
6. **新增指令/腳本**：superstack-doctor、sync-vendored.sh。
7. **合規**：THIRD_PARTY_NOTICES.md + 各目錄 LICENSE。
8. **README 改寫** + 致謝區塊擴充。
9. **驗證**：plugin 載入、skill 可見、MCP wiring 語法、授權齊備。
```
