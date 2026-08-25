# ANUI Documentation

The official documentation site for **ANUI** (Advanced Roblox UI Library), built with
[VitePress](https://vitepress.dev). Fully translated into four languages:
**English** (default), **Bahasa Indonesia** (`/id/`), **Русский** (`/ru/`) and
**简体中文** (`/zh/`) — 35 pages per locale, 140 in total.

- **Live site:** https://ANHub-Script.github.io/ANUI/
- **Repo:** https://github.com/ANHub-Script/ANUI (docs live in this `docs/` folder)
- **Discord:** https://discord.gg/bUkCZvmrpH · **YouTube:** https://www.youtube.com/@ANHubRoblox

---

## Prerequisites

- **Node.js 18 or newer** (VitePress 1.x requires Node 18+). Check with `node -v`.
- npm (ships with Node).

## Run it locally

From **this `docs/` folder**:

```bash
npm install          # first time only — installs VitePress
npm run docs:dev     # start the dev server with hot reload
```

Then open the URL it prints — **http://localhost:5173/ANUI/**
(the `/ANUI/` suffix is expected; see [Base path](#base-path--repo-name) below).

## Build & preview a production bundle

```bash
npm run docs:build     # output → .vitepress/dist
npm run docs:preview   # serve the built site locally to sanity-check
```

---

## Project structure

```
docs/
├─ .vitepress/
│  ├─ config.mts          # site config: nav, sidebar, i18n, theme, search
│  └─ theme/
│     ├─ index.ts         # extends the default theme
│     └─ custom.css       # ANUI brand colors (cyan → magenta)
├─ public/
│  └─ logo.svg            # site logo / favicon
├─ index.md               # English home (hero) page
├─ guide/                 # Getting Started + Guide (English)
├─ elements/              # Element API reference — 15 elements + overview
├─ features/              # Feature guides (config, key system, themes, …)
├─ examples/              # Copy-paste recipes
├─ api/                   # API cheatsheet
├─ id/                    # 🇮🇩 Bahasa Indonesia mirror of everything above
├─ ru/                    # 🇷🇺 Русский mirror
├─ zh/                    # 🇨🇳 简体中文 mirror
├─ package.json
└─ README.md              # you are here
```

Every English page under `guide/`, `elements/`, `features/`, `examples/`, and `api/`
has a matching translation under `id/…`, `ru/…`, and `zh/…`.

---

## Editing content

Pages are plain Markdown with VitePress extensions (containers like `::: tip`,
`::: warning`, code groups, etc.). Edit the `.md` file and the dev server reloads.

**To add a new page:**

1. Create the English page, e.g. `elements/my-element.md`.
2. Create its translations: `id/elements/my-element.md`, `ru/elements/my-element.md`,
   `zh/elements/my-element.md`.
3. Register it once in `.vitepress/config.mts` — the `sidebar(prefix, lang)` helper builds
   the tree for every locale from a single definition, so adding one entry there covers all
   four languages. If the entry needs a translated label, add a key to the `UI` dictionary
   at the top of the file with a value for each of `en`, `id`, `ru`, `zh`.

**Internal links are locale-relative and omit the base:**
English pages link like `/elements/toggle`; the translations link like
`/id/elements/toggle`, `/ru/elements/toggle`, `/zh/elements/toggle`. VitePress prepends the
base automatically — never hard-code `/ANUI/` in a link.

**Navigation & UI strings** (navbar, sidebar group titles, search labels, footer, prev/next)
live in a single `UI` dictionary in `config.mts`, keyed by string then language, so all four
locales stay in sync. Element names (`Button`, `Toggle`, …) are API identifiers and stay in
English in every locale.

**To add a language:** add its code to the `Lang` type, add a translation to every `UI`
entry, add a `searchTr(...)` line, and register it in `locales` at the bottom of the file.

---

## Deployment (GitHub Pages)

Docs are deployed straight from this repo (`ANHub-Script/ANUI`) via the GitHub Actions
workflow at [`../.github/workflows/deploy-docs.yml`](../.github/workflows/deploy-docs.yml).
It builds this `docs/` folder and publishes it to GitHub Pages on every push to `main`.

**One-time setup:**

1. Make sure the `docs/` folder is committed (it must **not** be git-ignored).
2. Push to GitHub.
3. In the repo: **Settings → Pages → Build and deployment → Source → GitHub Actions**.
4. Push to `main` (or run the workflow manually via **Actions → Deploy Docs → Run
   workflow**). The site goes live at **https://ANHub-Script.github.io/ANUI/**.

### Base path & repo name

VitePress needs to know the sub-path it's served from. In `.vitepress/config.mts`:

```ts
base: '/ANUI/',
```

**This must equal `/<your-repo-name>/`.** It's currently `/ANUI/`, which serves the
site at `https://ANHub-Script.github.io/ANUI/`.

- Repo stays named **`ANUI`** → keep `base: '/ANUI/'`. ✅
- If you rename the repo (e.g. to `ANUI-Docs`) → change `base` to match (`/ANUI-Docs/`).
- Using a **custom domain** or a `<user>.github.io` **user page** → set `base: '/'`.

---

## Credits

ANUI is based on [WindUI](https://github.com/Footagesus/WindUI) by Footagesus.
Documentation content © 2024–present ANHub-Script. Released under the MIT License.
