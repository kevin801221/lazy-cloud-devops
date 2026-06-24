<div align="center">

# 🦥 Lazy Cloud DevOps

### 懶得剛剛好的 Claude Code Plugin

**消滅 AI 垃圾碼，體積砍掉 80%，一行指令直送 AWS 與 GCP。**

[![Claude Code Plugin](https://img.shields.io/badge/Claude_Code-Plugin-D97757?style=for-the-badge&logo=anthropic&logoColor=white)](https://docs.claude.com/en/docs/claude-code)
[![License: MIT](https://img.shields.io/badge/License-MIT-22c55e?style=for-the-badge)](LICENSE)
[![體積](https://img.shields.io/badge/體積-−80%25-4f7cff?style=for-the-badge)](#-數據說話)
[![模式](https://img.shields.io/badge/模式-🦥_懶人資深工程師-161618?style=for-the-badge)](skills/ponytail-guard.md)

> 「真正的資深工程師，懶得剛剛好——能不寫的程式絕不寫，能不裝的套件絕不裝，能不花的雲端費用絕不花。」

<sub>馬尾（Ponytail）不是髮型，是一種哲學：把雜訊綁起來，只留訊號。</sub>

</div>

---

## ⚡ 一句話看懂

預設的 AI 是**垃圾碼製造機**。你叫它「做一個彈窗」，它回你一個 400KB 的套件、三層包裝 `<div>`、外加一段跟瀏覽器打架的 `useEffect`。

`Lazy Cloud DevOps` 在 Claude Code **動筆之前**就先給它套上一本無情的極簡規則書，然後把成品打包、上雲，全部濃縮成一行指令：

```bash
/lazy-ship gcp my-api      # → 稽核垃圾碼 → 瘦身 → 打包精簡 Alpine 映像 → 部署 Cloud Run
/lazy-ship aws my-api      # → 同一套紀律，改降落在 ECS Fargate
```

> 你只要動嘴，剩下的交給這隻樹懶。

---

## 🤮 痛點：我們正在被 AI 垃圾碼淹沒

每一個 AI 協作的專案，幾乎都在重播同一齣慘劇：

| 垃圾碼長相 | 它其實在偷走你什麼 |
| --- | --- |
| 🧱 **冗餘程式碼** | 十行能解決的事寫了三百行。多餘的包裝元件、對「不可能出錯的東西」狂包 `try/catch`、為了一個呼叫點硬幹一層抽象。 |
| 📦 **`node_modules` 黑洞** | 一個日期選擇器拉進 47 個相依套件；一個彈窗套件丟給你 400KB；只為了一個 `groupBy` 裝整包 `lodash`。 |
| 🔓 **過度膨脹的雲端權限** | 「保險起見」寫 `"Action": "*"`、`"Resource": "*"`；容器跑 root；用 2GB 的 Ubuntu 映像去跑一個 30MB 的 Node 應用。 |
| 🐢 **體積失控** | 冷啟動越拖越久、帳單越爬越高、攻擊面越來越大，最後沒人找得到真正的商業邏輯在哪。 |

> 預設的 AI 在優化「**看起來**很努力」——更多碼、更多套件、更多假裝的健壯性。
> 那不是工程，那是垃圾。

---

## 🦥 解法：馬尾之道（The Ponytail Way）

`Lazy Cloud DevOps` 直接攔截 Claude Code 的**思考迴圈**，把它的預設行為重新接線。
不是「先生成、再清理」，而是**從一開始就拒絕生出垃圾**。

```
        ┌──────────────────────────────────────────────────────────────┐
        │                Claude Code 的認知迴圈                          │
        └──────────────────────────────────────────────────────────────┘

   你的需求 ─►  ┌───────────────────┐    攔截      ┌──────────────────┐
                │ 循序思考           │ ──────────► │ 🦥 馬尾守衛        │
                │ Sequential        │             │  Ponytail Guard  │
                │ Thinking          │ ◄────────── │  • 垃圾碼測試     │
                │ (一步步想「做什麼」)│   施加約束   │  • 原生優先       │
                └───────────────────┘             │  • 60-30-10 配色 │
                          │                       │  • 精簡 DB/IAM    │
                          ▼                       └──────────────────┘
                ┌───────────────────┐
                │ 產出的程式碼       │  ← 天生就精簡，而不是事後清出來的
                │ 體積 −80%          │
                └───────────────────┘
```

**循序思考**決定「做什麼」，**馬尾守衛**約束「做多少」——而答案永遠是「更少」。
於是程式碼是**設計上就精簡**，不是事後打掃出來的乾淨。

### 四條鐵律

1. **少寫程式，才是最高級的整潔架構。** 最棒的一筆 diff，是刪除。
2. **原生平台 ＞ npm 套件。** 用 `<dialog>` 取代彈窗套件、`fetch` 取代 axios、`Intl` 取代 moment。
3. **天生精簡。** 多階段 Alpine 建置、非 root 執行、欄位型別剛好夠用、零魔法字串。
4. **最小權限、最小體積。** 拒絕萬用字元 IAM、預設縮容至零、機密永遠留在外部。

📖 完整規則書在這：**[`skills/ponytail-guard.md`](skills/ponytail-guard.md)**

---

## 📉 數據說話

「馬尾模式」對一個典型 AI 生成的全端應用做了什麼：

```
  打包體積       ████████████████████░░░░  預設            ███░░░░░░░░░░░░░░░░░░░░░░  馬尾   −82%
  node_modules  ████████████████████████  1,400 套件      ████░░░░░░░░░░░░░░░░░░░░░░  210 套件  −85%
  Docker 映像    ████████████████████████  1.9 GB ubuntu   ██░░░░░░░░░░░░░░░░░░░░░░░░  78 MB alpine −96%
  IAM 權限       ████████████████████████  萬用字元 "*"     █░░░░░░░░░░░░░░░░░░░░░░░░░  精準縮限  最小權限
  冷啟動         ████████████████████░░░░  約 2.4 秒        ████░░░░░░░░░░░░░░░░░░░░░░  約 0.4 秒  −83%
```

<sub>以上為典型全新專案腳手架的示意數據。實際情況只會更瘦。</sub>

---

## 🚀 三步上手

### 1. 把 plugin 裝進 Claude Code

```bash
# 先 clone
git clone https://github.com/kevin801221/lazy-cloud-devops.git

# 用本地路徑加進 Claude Code
claude plugin add --path ./lazy-cloud-devops
```

或等上架 marketplace 後直接安裝：

```bash
claude plugin marketplace add kevin801221/lazy-cloud-devops
claude plugin install lazy-cloud-devops
```

### 2. 確認它載入了

在任何專案打開 Claude Code，一進 session，馬尾守衛就會透過 `SessionStart` hook 自動啟動。用這行確認：

```bash
claude plugin list          # → lazy-cloud-devops  ✓ enabled
```

### 3. 直接出貨

```bash
# 在任何 repo 裡，於 Claude Code 中執行：
/lazy-ship gcp my-service        # 稽核 → 瘦身 → 精簡 Alpine 建置 → Cloud Run
/lazy-ship aws my-service        # ……或讓它降落在 ECS Fargate
```

就這樣。Claude 會幫你稽核 repo 裡的垃圾碼、清掉它、打包成精簡的多階段 Alpine 映像、把關體積上限，再用「縮容至零＋最小權限」的預設值部署上去。

### 前置需求

| 用途 | 你需要 |
| --- | --- |
| 兩者皆需 | [`docker`](https://docs.docker.com/get-docker/)、[`uv`](https://docs.astral.sh/uv/)（驅動 Docker MCP 伺服器） |
| GCP | 已登入的 [`gcloud`](https://cloud.google.com/sdk/docs/install)（`gcloud auth login`） |
| AWS | 已設定憑證的 [`aws` CLI](https://aws.amazon.com/cli/) |
| Postgres MCP | 環境變數 `POSTGRES_CONNECTION_STRING` |

---

## 🗺️ 架構與執行流程

從一個念頭到一個線上網址——每一站都受馬尾規則書管轄：

```
   ┌────────────┐
   │ 💡 發想     │  你描述應用，循序思考規劃「做什麼」，
   └─────┬──────┘  馬尾守衛約束「做多少」（答案永遠是：更少）。
         │
         ▼
   ┌─────────────────────┐
   │ 🗄️  資料庫層         │  精簡 schema · 欄位型別剛好夠 · 預設 NOT NULL
   │  (Postgres MCP)     │  零魔法字串 · 刻意建索引 · 拒絕 SELECT *
   └─────┬───────────────┘
         │
         ▼
   ┌─────────────────────┐
   │ 🪶 輕量容器          │  多階段 Alpine · 非 root USER · .dockerignore
   │  (Docker MCP/uv)    │  鎖定版本 · 建置工具鏈絕不上船 · 體積把關
   └─────┬───────────────┘
         │
         ▼
   ┌──────────────────────────────────────────────┐
   │                ☁️  雲端部署                    │
   │                                              │
   │   ┌──────────────────┐   ┌─────────────────┐ │
   │   │  GCP Cloud Run   │   │  AWS ECS Fargate│ │
   │   │  縮容至零         │   │  尺寸剛好        │ │
   │   │  最小權限 SA      │   │  最小權限 IAM    │ │
   │   │  deploy-gcp.sh   │   │  deploy-aws.sh  │ │
   │   └──────────────────┘   └─────────────────┘ │
   └──────────────────────────────────────────────┘
         │
         ▼
   ┌────────────────────┐
   │ 🌐 線上網址 / ARN   │  體積 −80% · 整潔架構 · 連最龜毛的資深工程師都點頭
   └────────────────────┘
```

---

## 📦 盒子裡有什麼

```
lazy-cloud-devops/
├── .claude-plugin/
│   └── plugin.json            # 清單檔：skills、指令、hooks、Docker + Postgres MCP
├── skills/
│   └── ponytail-guard.md      # 無情的極簡規則書（自動注入）
├── commands/
│   └── lazy-ship.md           # /lazy-ship — 一行指令稽核→瘦身→打包→部署
├── hooks/
│   ├── hooks.json             # SessionStart hook 接線
│   └── inject-ponytail.sh     # 一進 session 就注入馬尾守衛指令
├── scripts/
│   ├── deploy-gcp.sh          # 防彈級 Cloud Run 部署 + 體積把關
│   └── deploy-aws.sh          # 防彈級 ECS Fargate 部署 + 體積把關
└── README.md
```

### 內建的 MCP 伺服器

- **🐳 Docker** — 透過 `uvx` 啟動 `mcp-server-docker`，讓 Claude 能直接檢視、建置、推理你的容器。
- **🐘 PostgreSQL** — 接上 `@modelcontextprotocol/server-postgres`，讓 schema 決策對著真正的資料庫做，而不是用猜的。

---

## 🧠 一張表看懂這套哲學

| ❌ AI 垃圾碼 | ✅ 馬尾之道 |
| --- | --- |
| `npm i react-modal` | `<dialog>` + `.showModal()` |
| `npm i axios` | `fetch()` + `AbortController` |
| `npm i moment` | `Intl.DateTimeFormat` |
| `FROM ubuntu`（1.9GB） | `FROM node:22-alpine AS build`（78MB） |
| `USER root` | `USER app`（非 root） |
| `"Action": "*"` | 精準縮限的最小權限 IAM |
| `SELECT *` | 只取你真正用到的欄位 |
| 到處散落的狀態字串 | 一個型別化 `ENUM` |
| 為單一呼叫點硬幹抽象 | 等到第三個真實案例才抽 |

---

## 🙏 致謝與靈感來源

這個 plugin 站在巨人的肩膀上。本專案的程式碼為原創撰寫，但**核心哲學與機制明確受以下專案啟發**，在此誠實致謝：

| 專案 | 致謝什麼 |
| --- | --- |
| 🦥 **[DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail)**（MIT） | 「馬尾哥 / 最懶資深工程師」這套極簡哲學的**原始出處**。`skills/ponytail-guard.md` 的「垃圾碼測試」決策階梯、原生優先、「少寫程式才是最高級整潔」等核心理念，皆為其 decision-ladder 哲學的再表述。**強烈建議去點顆星。** |
| 🦸 **[obra/superpowers](https://github.com/obra/superpowers)**（Jesse Vincent / Prime Radiant） | skill-driven 方法論與 **SessionStart context injection** 機制的啟發來源——本 plugin 的 `hooks/inject-ponytail.sh` 自動注入規則書，正是同一個技巧。 |
| 🔌 **[modelcontextprotocol/server-postgres](https://github.com/modelcontextprotocol/servers)** | 實際接入使用的官方 Postgres MCP 伺服器。 |
| 🐳 **[ckreiling/mcp-server-docker](https://github.com/ckreiling/mcp-server-docker)** | 實際接入使用的 Docker MCP 伺服器（透過 `uvx` 啟動）。 |
| 🤖 **[Claude Code](https://docs.claude.com/en/docs/claude-code)** by Anthropic | 承載這一切的 plugin 平台。 |

> 「致謝」與「複製」是兩回事：本 repo 的每個檔案都是依需求原創撰寫，但**哲學的功勞屬於 ponytail，方法論的功勞屬於 superpowers。** 站在巨人肩膀上，記得說聲謝謝。

---

## 🤝 一起共建

歡迎來「檢舉垃圾碼」。如果你發現這個 plugin 漏放了哪段肥肉進來，
開個 issue 附上更精簡的版本。**會刪程式碼的 PR，排名最高。**

## 📜 授權

MIT © [kevin801221](https://github.com/kevin801221)

<div align="center">

### 🦥 把雜訊綁起來，只留下訊號。

**README 寫得好，得星沒煩惱——如果這隻樹懶幫你擋掉了垃圾碼，給顆 ⭐ 是最懶的道謝方式。**

</div>
