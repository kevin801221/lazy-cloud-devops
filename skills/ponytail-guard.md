---
name: ponytail-guard
description: Use when writing, reviewing, scaffolding, containerizing, or deploying any full-stack code — the ruthless minimalist rulebook that eradicates AI Slop and enforces native-first frontend, lean databases, and minimal cloud footprint (Ponytail / Lazy Senior Engineer Mode).
---

# 🦥 Ponytail Guard — The Lazy Senior Engineer's Rulebook

> "A senior engineer is lazy in the right way: they refuse to write, run, or
> pay for anything they don't have to. The ponytail isn't a hairstyle — it's
> a philosophy. Tie back the noise. Ship the signal."

This skill is a **rigid** rulebook. Follow it exactly. It exists to kill
**AI Slop** — the reflexive over-generation of redundant code, bloated
dependency trees, speculative abstractions, and over-permissioned cloud
infrastructure that default LLM behavior produces.

The prime directive, from which everything else derives:

> **Writing less code is the ultimate form of clean architecture.**
> The best diff is a deletion. The best dependency is the one you didn't add.
> The best abstraction is the one the problem actually required.

---

## 0. The Slop Test (apply before generating ANYTHING)

Before you write a line, ask in order. Stop at the first "no":

1. **Does this need to exist at all?** Can deletion, a config flag, or an
   existing function solve it? If yes — don't write new code.
2. **Can a native platform primitive do it?** (See §1.) If yes — use the
   primitive, add nothing.
3. **Is this the smallest correct version?** If you're adding flexibility
   "for later", you're adding slop now. Build for today.
4. **Will every line, dep, and permission survive code review by a skeptic?**
   If you can't defend a line out loud, delete it.

If a generated artifact fails the Slop Test, **regenerate the smaller version.**

---

## 1. Frontend — Native-First, Always

**Mandate: reach for the platform before reaching for npm.** The browser
shipped a feature; use it. Every UI dependency is bundle weight, a supply-chain
liability, and a thing that breaks on upgrade.

### Native over libraries — required substitutions

| ❌ Slop (don't install) | ✅ Ponytail (use the platform) |
|---|---|
| A modal library (react-modal, etc.) | `<dialog>` + `.showModal()` |
| An accordion / collapse library | `<details>` / `<summary>` |
| axios / request wrappers | `fetch()` + `AbortController` |
| moment / dayjs for basic formatting | `Intl.DateTimeFormat`, `Intl.NumberFormat` |
| A tooltip library | `popover` attribute / `title` |
| A carousel library | CSS scroll-snap |
| lodash for one helper | the one-line vanilla equivalent |
| A form-state library for 3 fields | `FormData` + native validation |
| A date-picker mega-package | `<input type="date">` |
| jQuery for DOM access | `querySelector` / `classList` / `dataset` |

**Rule:** You may only add a frontend UI dependency after explicitly stating,
in a comment or message, which native API you evaluated and the concrete reason
it cannot do the job. "It's more convenient" is not a reason.

### Component discipline

- Components do one thing. If a component needs a comment to explain *what* it
  is (not *why*), it's doing too much — split or delete.
- No prop-drilling more than one level — colocate state or lift it deliberately.
- Derive state; never duplicate it. A second source of truth is a future bug.
- No premature memoization. Measure, then optimize. `useMemo` on a cheap
  computation is slop.

---

## 2. Design System — Functional Minimalism

Design is not decoration. The aesthetic is **Apple-grade functional
minimalism**: every visual element earns its place by improving comprehension
or usability. If it only "looks designed", it's slop.

### 2.1 The 60-30-10 Colour Rule (strict)

A screen uses exactly three roles, in proportion:

- **60% — Dominant / neutral.** Background and large surfaces. Usually a near-
  white or near-black plus one neutral. This is the canvas; it should be quiet.
- **30% — Secondary.** Cards, panels, secondary surfaces, structural contrast.
- **10% — Accent.** Exactly one accent hue for primary actions, focus, and
  emphasis. One. Not three "primary" colours.

Define these as **semantic tokens**, never raw hex in components:

```css
:root {
  /* 60 — dominant */
  --surface:        #0b0b0c;
  --surface-muted:  #161618;
  /* 30 — secondary */
  --panel:          #1f1f23;
  --border:         #2a2a30;
  --text:           #f4f4f5;
  --text-muted:     #a1a1aa;
  /* 10 — accent (the ONLY accent) */
  --accent:         #4f7cff;
  --accent-contrast:#ffffff;
}
```

**Rule:** No raw colour literals in component code. No second accent. If a new
colour is "needed", you almost certainly need a state token, not a new hue.

### 2.2 Systemic Typography

One type scale, used everywhere. No arbitrary font sizes.

- **System font stack** by default — zero web-font payload, native rendering:
  ```css
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
               Helvetica, Arial, sans-serif;
  ```
- A **modular scale** (1.25 ratio is a safe default). Expose as tokens:
  `--text-xs / sm / base / lg / xl / 2xl`. Components pick a token, never a `px`.
- **Hierarchy via weight and size, not colour.** Two weights (regular + semibold)
  cover almost everything.
- Line-height ~1.5 for body, ~1.2 for headings. Measure (line length) 60–75ch.
- If you must load a web font: **one family, two weights, `font-display: swap`,
  self-hosted, subset.** A 400KB font download for a marketing word is slop.

### 2.3 Zero-Slop Animation

Motion clarifies state change. It is never ornament.

- Animate **only** `transform` and `opacity` (compositor-friendly, 60fps).
  Never animate `width`, `height`, `top`, `left`, or `box-shadow` in hot paths.
- Duration **150–250ms** for UI transitions. Anything slower than 300ms feels
  broken; anything that loops "to look alive" is slop — delete it.
- Always honour the user:
  ```css
  @media (prefers-reduced-motion: reduce) {
    *, *::before, *::after { animation: none !important; transition: none !important; }
  }
  ```
- No animation libraries for a fade or a slide. CSS transitions/keyframes do it
  with zero bytes.

### 2.4 Spacing & layout

- One spacing scale (e.g. 4px base: 4/8/12/16/24/32/48). No arbitrary margins.
- Layout with **CSS Grid and Flexbox** — not a grid framework, not nested
  wrapper `<div>` soup. If an element exists only to position another, the
  layout is wrong.
- Mobile-first. Fewer breakpoints, defined by content, not devices.

---

## 3. Database — Lean Schema, Zero Magic

The database is the most expensive thing to get wrong. Minimalism here is
discipline, not laziness.

### 3.1 Column-level optimization

- **Right-size every type.** `SMALLINT` over `INTEGER` when the range allows.
  `VARCHAR(n)` with a justified `n`, not `TEXT` everywhere. `TIMESTAMPTZ`, never
  naive timestamps. Money is `NUMERIC`, never `FLOAT`.
- **`NOT NULL` is the default.** Nullable columns are a deliberate, justified
  choice — every `NULL` is a branch in every query that reads the column.
- **Constrain at the schema, not in app code.** `CHECK`, `UNIQUE`, `FOREIGN KEY`
  with explicit `ON DELETE`. The database is the last line of integrity.
- **Index intentionally.** Index what you query and join on — and nothing else.
  An unused index is write-amplification slop. Composite index column order
  follows query predicates.

### 3.2 Zero magic strings / magic numbers

- No status string literals scattered across the codebase. Use a native
  `ENUM` (or a lookup table) and a single typed constant module.
- No raw numeric flags. Name them once, reference the name.
- Connection strings, table names, and limits come from config/env — never
  hardcoded inline. (See §5 secrets.)

### 3.3 Query discipline

- `SELECT` only the columns you use. `SELECT *` over the wire is slop.
- Parameterized queries always — no string-concatenated SQL, ever (correctness
  *and* security).
- One round-trip where one suffices. N+1 is the most common AI-Slop data bug —
  batch, join, or `IN (...)` instead.
- Migrations are forward-only, reviewed, and reversible. No "edit the schema by
  hand on prod".

---

## 4. Containers — Multi-Stage Alpine, Non-Root

A container image is a liability the size of its bytes. Ship the smallest thing
that runs.

### 4.1 The canonical lean Dockerfile (Node example)

```dockerfile
# ---- build stage: has the toolchain, never ships ----
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build && npm prune --omit=dev

# ---- runtime stage: minimal, non-root, no toolchain ----
FROM node:22-alpine AS runtime
ENV NODE_ENV=production
WORKDIR /app
# create and drop to an unprivileged user
RUN addgroup -S app && adduser -S app -G app
COPY --from=build --chown=app:app /app/node_modules ./node_modules
COPY --from=build --chown=app:app /app/dist ./dist
COPY --from=build --chown=app:app /app/package.json ./package.json
USER app
EXPOSE 8080
CMD ["node", "dist/server.js"]
```

### 4.2 Container rules

- **Multi-stage, always.** Build deps and source never reach the runtime image.
- **Alpine (or `-slim` / distroless)** base. No full `ubuntu` for a Node/Python app.
- **Non-root `USER`.** Running as root is a security default-fail.
- **A real `.dockerignore`** — exclude `.git`, `node_modules`, tests, `.env`,
  CI files, docs. What's not copied can't bloat the layer or leak.
- **Pin versions.** No `:latest` base tags in anything you deploy.
- **One process per container.** No process managers wrapping a single app.
- **`HEALTHCHECK`** defined so the orchestrator knows truth.

Python equivalent: `python:3.13-alpine` build stage with `uv` for dependency
resolution (`uv pip install --system`), runtime stage copies only the installed
site-packages and app. Same non-root, same multi-stage discipline.

---

## 5. Cloud — Least-Privilege, Smallest Footprint

The cloud bill and the blast radius are both proportional to slop.

- **Least-privilege IAM, always.** No wildcard `*` actions, no `*` resources.
  A service gets exactly the permissions it provably uses — nothing "to be safe".
- **Right-size compute.** Cloud Run / Fargate sized to measured need; scale-to-
  zero where the workload allows. Don't provision a fleet for a webhook.
- **No secrets in images or env literals.** Use Secret Manager (GCP) / Secrets
  Manager / SSM (AWS). The connection string is injected at runtime, never baked.
- **Statelessness by default.** State lives in managed stores, not container
  disks, so scaling is free and deploys are disposable.
- **One region until proven otherwise.** Multi-region is real cost and real
  complexity — add it when traffic, not imagination, demands it.
- **Tag and budget.** Every resource tagged with owner + service; a billing
  alert exists before the first deploy.

---

## 6. Code-Level Anti-Slop Heuristics

- **No dead code.** Unreferenced functions, commented-out blocks, and `TODO`
  graveyards get deleted, not shipped.
- **No speculative abstraction.** Two call sites is not a pattern. Inline until
  the third real case forces a clean extraction (rule of three).
- **No defensive over-engineering.** Don't wrap, retry, and try/catch around
  things that can't fail. Handle real error paths; ignore imaginary ones.
- **Functions are short and named for intent.** If you need a comment to say
  *what* a block does, extract and name it. Comments explain *why*, not *what*.
- **One source of truth per fact.** Duplicated constants, parallel arrays, and
  copy-pasted config are slop that drifts.
- **Delete on sight.** When you touch a file, leave it smaller if you honestly
  can. The boy-scout rule, inverted: remove litter, don't just avoid adding it.

---

## 7. The Ponytail Checklist (run before declaring done)

- [ ] Could any code here be **deleted** without losing behavior?
- [ ] Is every **dependency** justified against a native alternative?
- [ ] Are there **zero magic strings / numbers**? All named or in config?
- [ ] Frontend: **60-30-10** colour, one type scale, motion ≤250ms & reduced-motion safe?
- [ ] DB: types right-sized, `NOT NULL` by default, indexes intentional, no `SELECT *`?
- [ ] Container: multi-stage, Alpine/slim, non-root, `.dockerignore`, pinned base?
- [ ] Cloud: least-privilege IAM (no `*`), secrets external, right-sized, tagged?
- [ ] Would a skeptical senior engineer sign off on **every line** out loud?

If any box is unchecked, you are not done. Ship the smaller version.
