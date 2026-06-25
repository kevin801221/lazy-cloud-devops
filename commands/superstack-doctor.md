---
description: 體檢 lazy-superstack — 掃描環境，列出哪些可選（B 級）MCP 已具備憑證可啟用，並給出一鍵設定指引。
allowed-tools: Bash, Read
---

# 🩺 /superstack-doctor — lazy-superstack 能力體檢

你的任務是幫使用者搞清楚：**這台機器上，lazy-superstack 的哪些能力已經就緒、哪些還差設定。**
務必簡潔、用清單呈現，不要長篇大論。

## 步驟

1. **檢查預設（A 級）MCP 的前置工具**，用 Bash 逐項偵測（存在即綠燈）：
   - `node` / `npx`（Context7 需要）
   - `uvx`（Docker MCP 需要）
   - `docker` daemon 是否在跑（`docker info`）

2. **掃描可選（B 級）MCP 的憑證**，檢查這些環境變數 / 設定是否存在（**只看有無、絕不印出值**）：
   - MongoDB → `MDB_MCP_CONNECTION_STRING`
   - Postgres MCP Pro → `DATABASE_URI`
   - AWS → `~/.aws/credentials` 或 `AWS_ACCESS_KEY_ID`
   - GitHub → `GITHUB_PERSONAL_ACCESS_TOKEN`
   - Terraform → 本機 `docker`
   - shadcn → 當前目錄是否有 `components.json`

3. **檢查 vendored skills 是否就緒**：`skills/` 下是否有
   `ponytail-guard`、`design-thinking`、`pm-brainstorming`、`pm-writing-plans`、`security-owasp`。

## 輸出格式

用三段清單回報，每項加 ✅ / ⚠️ / ❌：

```
🦥 lazy-superstack 體檢報告

預設能力（A 級，零設定）
  ✅ Context7（即時文件）
  ✅ Docker MCP
  ...

可選能力（B 級，需憑證）— 偵測到可啟用：
  ✅ Postgres MCP Pro（已偵測到 DATABASE_URI）→ 複製 mcp-optional.example.json 的 postgres 區塊即可
  ⚠️ MongoDB（未偵測到連線字串）→ 設定 MDB_MCP_CONNECTION_STRING 後可啟用
  ...

Skills
  ✅ ponytail-guard / design-thinking / pm-brainstorming / pm-writing-plans / security-owasp
```

最後給一句總結：「已就緒 N 項；想再開 M 項，看 `mcp-optional.example.json`。」

## 鐵律
- **絕不印出任何憑證的值**，只回報「有 / 無」。
- 不要嘗試替使用者寫入設定檔；只給指引，讓他自己決定要不要開。
