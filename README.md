<div align="center">

# 🦥 Lazy Superstack

### 裝一個 plugin，讓你的 AI coding agent 長出一整支資深團隊

**PM · 設計思考 · 馬尾哥極簡 · 全端 · AI · 雲端部署 · 資安 —— 一次到位。**

[![Claude Code Plugin](https://img.shields.io/badge/Claude_Code-Plugin-D97757?style=for-the-badge&logo=anthropic&logoColor=white)](https://docs.claude.com/en/docs/claude-code)
[![License: MIT](https://img.shields.io/badge/License-MIT-22c55e?style=for-the-badge)](LICENSE)
[![Skills + MCP](https://img.shields.io/badge/skills_+_MCP-curated-4f7cff?style=for-the-badge)](#-盒子裡有什麼)
[![模式](https://img.shields.io/badge/模式-🦥_懶人資深工程師-161618?style=for-the-badge)](skills/ponytail-guard/SKILL.md)

> 「真正的資深工程師，懶得剛剛好——能不寫的程式絕不寫，能不裝的套件絕不裝，能不花的雲端費用絕不花。」

</div>

---

## ⚡ 這是什麼

`Lazy Superstack` 是一個 **AI coding agent 能力捆綁包**。
你只要安裝這一個 Claude Code plugin，你的 agent 就同時擁有八大領域的能力——
裡面裝的是**精選自社群、授權清楚、可重分發**的最強 skills 與 MCP servers，
全部用「馬尾哥極簡」的精神捆好。

不是一堆肥肉。每個領域只收**真正無可替代**的旗艦——`vendored skill` 只有 2 個，
其餘能力靠輕量 MCP wiring 提供。**plugin 本身也極簡，因為塞太多本身就是 slop。**

---

## 🧠 八大能力，一次長出

| 領域 | 你的 agent 得到什麼 | 怎麼來 |
|---|---|---|
| 📋 **PM / 專案管理** | 需求探索、寫 spec、把計畫拆成可驗證的小任務 | `pm-brainstorming` + `pm-writing-plans`（vendored, MIT） |
| 🎨 **設計思考** | Stanford d.school 五階段、Empathy Map、POV、HMW、測試腳本 | `design-thinking`（自寫，致謝 d.school/IDEO） |
| 🦥 **馬尾哥極簡** | 消滅 AI 垃圾碼、原生優先、最小權限的鐵律 | `ponytail-guard`（自寫） |
| 🗄️ **資料庫** | MongoDB + SQL 直連、schema 設計、index tuning | MongoDB / Postgres MCP Pro（wired） |
| 🌐 **全端開發** | 即時正確的官方文件、shadcn 元件正確安裝 | Context7 + shadcn MCP（wired） |
| 🤖 **AI 應用** | 拉最新 API 文件進 context，根治過時 API 幻覺 | Context7（wired） |
| ☁️ **雲端部署** | Docker / AWS / Terraform 操作 + 一鍵極簡部署 | Docker/AWS/Terraform MCP + `/lazy-ship` |
| 🔒 **資安** | OWASP Top 10:2025、ASVS、LLM/Agentic 安全審查 | `security-owasp`（vendored, MIT） |

---

## 🎯 設計哲學：精選旗艦，不是塞好塞滿

別的「集大成」plugin 塞 300 個 skill，然後互相撞名、沒人維護得動。
`Lazy Superstack` 反過來：

```
  ❌ 廣度堆疊            ✅ 精選旗艦（馬尾哥的方式）
  ───────────           ──────────────────────────
  12+ vendored skills   2 個 vendored skill（真正無可替代）
  全部塞進 plugin        + 2 個自寫高品質 skill
  撞名、肥大、難維護      + 7 個輕量 MCP wiring（零複製、零撞名）
  授權含糊              每個來源附 LICENSE + THIRD_PARTY_NOTICES
```

> 能用 MCP wiring（設定指向官方 server）解決的，就不複製一堆檔案進來。
> 這本身就是「少即是多」的實踐。

---

## 🚀 三步上手

### 1. 安裝

```bash
git clone https://github.com/kevin801221/lazy-superstack.git
claude plugin add --path ./lazy-superstack
```

或從 marketplace（上架後）：

```bash
claude plugin marketplace add kevin801221/lazy-superstack
claude plugin install lazy-superstack
```

### 2. 體檢，看哪些能力已就緒

一進 session，馬尾哥守衛會自動啟動。接著跑：

```bash
/superstack-doctor
```

它會掃描你的環境，告訴你**哪些能力立即可用、哪些還差一個憑證**——
且**絕不印出任何憑證的值**，只報「有 / 無」。

### 3. 開工

```bash
# 用對應的 skill / 能力，例如：
/lazy-ship gcp my-service     # 極簡稽核 → 瘦身 → Alpine 打包 → 部署 Cloud Run / ECS
```

或直接讓 agent 在對的時機自動調用 `design-thinking`、`pm-writing-plans`、`security-owasp`。

---

## 🔌 能力分兩級啟用（重要）

很多 MCP 需要憑證（DB 連線字串、AWS 金鑰、GitHub PAT）。
**全部預設開啟會在你沒憑證時噴錯、拖慢啟動**——所以分兩級：

- **A 級（零設定，預設開）**：Context7、Docker MCP。裝完就能用。
- **B 級（需憑證，按需開）**：MongoDB、Postgres MCP Pro、AWS、Terraform、GitHub、shadcn。
  範本在 [`mcp-optional.example.json`](mcp-optional.example.json)，跑 `/superstack-doctor` 看你能開哪些。

---

## 📦 盒子裡有什麼

```
lazy-superstack/
├── .claude-plugin/plugin.json     # 清單：skills + commands + hooks + A 級 MCP
├── skills/
│   ├── ponytail-guard/            # 🖊️ 自有：極簡鐵律
│   ├── design-thinking/           # 🖊️ 自有：d.school 五階段 + 模板
│   ├── pm-brainstorming/          # 📥 vendored from obra/superpowers (MIT)
│   ├── pm-writing-plans/          # 📥 vendored from obra/superpowers (MIT)
│   ├── security-owasp/            # 📥 vendored from agamm/claude-code-owasp (MIT)
│   └── README.md                  # skill 來源與命名空間對照
├── commands/
│   ├── lazy-ship.md               # 一鍵極簡部署
│   └── superstack-doctor.md       # 能力體檢
├── hooks/                         # SessionStart 自動注入馬尾哥守衛
├── scripts/
│   ├── deploy-gcp.sh / deploy-aws.sh   # footprint-gated 部署
│   └── sync-vendored.sh           # 從上游同步 2 個 vendored 來源
├── mcp-optional.example.json      # B 級 MCP 設定範本
├── THIRD_PARTY_NOTICES.md         # 所有第三方來源 + 授權彙整
└── docs/superpowers/specs/        # 設計規格
```

---

## 🙏 致謝與來源（誠實標註）

`Lazy Superstack` 站在巨人的肩膀上。我們嚴格區分「複製（vendored）」「設定指向（wired）」
與「方法論致謝（inspired）」，**絕不謊稱原創**。完整清單見 [`THIRD_PARTY_NOTICES.md`](THIRD_PARTY_NOTICES.md)。

| 來源 | 用途 | 授權 |
|---|---|---|
| [obra/superpowers](https://github.com/obra/superpowers)（Jesse Vincent） | PM 兩個 skill（vendored） | MIT |
| [agamm/claude-code-owasp](https://github.com/agamm/claude-code-owasp) | 資安 skill（vendored） | MIT |
| [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) | 馬尾哥極簡哲學（inspired） | MIT |
| Stanford d.school · IDEO | 設計思考方法論（inspired） | 公開教材 |
| Context7 / MongoDB / Postgres MCP Pro / AWS / Terraform / Docker / shadcn | 能力 MCP（wired） | MIT / Apache-2.0 |

---

## 📜 授權

MIT © [kevin801221](https://github.com/kevin801221) · 第三方內容各依其原始授權（見 THIRD_PARTY_NOTICES）。

<div align="center">

### 🦥 把雜訊綁起來，只留下訊號。

**裝一個 plugin，少一整支待招募的團隊。**

</div>
