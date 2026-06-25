# Design / UI / Art — Skills Router

> A decision table so any Claude Code instance knows **which design skill to use for which task**, how each is invoked, and where they overlap.
> This file is the single source of truth. When you add or remove design tooling, update it here.
> Installed by [claude-design-stack](https://github.com/YunyueLi/claude-design-stack).

---

## 0. 30-second orientation

Design capability comes in three layers with **different availability**:

| Layer | Where | Who can use it |
|---|---|---|
| ① Global skills | `~/.claude/skills/` | **Any** Claude Code on this machine, automatically |
| ② `design:*` suite | Anthropic design plugin | Only sessions with the **design plugin installed** |
| ③ Design MCPs | pencil / visualize MCP server | Only sessions **connected to that MCP** |

**The stack this router ships installs layer ①** (impeccable, the taste suite, ui-ux-pro-max). Layers ② and ③ are referenced below but installed separately.

**How they're invoked:**
- Skills → called via the **Skill tool** by `name`. The model auto-invokes when a task matches a skill's description. **Only `impeccable` is user-invocable** — i.e. you can type `/impeccable …`. The taste skills can't be slashed; the model picks them up automatically or when you name them.
- MCPs (pencil / visualize) → called directly as tools.

**They overlap a lot.** impeccable / the taste suite / ui-ux-pro-max / `design:*` all cover "frontend design." **Pick one from §1 first** — don't stack several on the same micro-task.

---

## 1. Decision table: to do X → use Y

> Rows marked _(design plugin)_ or _(MCP)_ need that layer installed; everything else ships with the stack.

| What you want to do | First choice | Alternative / add-on |
|---|---|---|
| Build a landing page / portfolio / marketing site from scratch, "not looking like an AI template" | `design-taste-frontend` or `/impeccable craft` | `high-end-visual-design` (layer on taste) |
| Build a whole new feature end to end (incl. UX planning) | `/impeccable shape` (plan) → `/impeccable craft` (build) | — |
| Upgrade an existing site to feel high-end | `redesign-existing-projects` | `/impeccable audit` → `/impeccable polish`/`bolder`/`delight` |
| Make a UI "look expensive" (type / spacing / shadow / motion) | `high-end-visual-design` | `/impeccable polish`, `/impeccable typeset` |
| Specific style: minimalist editorial | `minimalist-ui` | `ui-ux-pro-max` (pick style / palette) |
| Specific style: industrial brutalist (dashboards / editorial) | `industrial-brutalist-ui` | — |
| Pick a palette / font pairing / chart / style from a curated library | `ui-ux-pro-max` | — |
| Get design rules for a product type (SaaS / e-commerce / dashboard …) | `ui-ux-pro-max` | — |
| Technical quality audit (a11y + perf + theming + responsive + anti-patterns, scored) | `/impeccable audit` | `design:accessibility-review` _(design plugin)_ |
| Pure WCAG 2.1 AA accessibility audit | `design:accessibility-review` _(design plugin)_ | `/impeccable audit` |
| Design review / want critique | `/impeccable critique` | `design:design-critique` _(design plugin)_ |
| Engineering handoff spec (tokens / props / states / breakpoints) | `design:design-handoff` _(design plugin)_ | `/impeccable document` (writes DESIGN.md) |
| Design system: audit / document / extend, extract tokens | `design:design-system` _(design plugin)_ | `/impeccable extract`, `/impeccable document` |
| UX copy (microcopy / errors / empty states / CTAs) | `design:ux-copy` _(design plugin)_ | `/impeccable clarify` |
| Plan + synthesize user research (interviews / usability / surveys) | `design:user-research` / `design:research-synthesis` _(design plugin)_ | — |
| Responsive / multi-device adaptation | `/impeccable adapt` | `ui-ux-pro-max` |
| Add motion / micro-interactions / show-off effects | `/impeccable animate`, `/impeccable overdrive` | — |
| Simplify / de-noise an overloaded UI | `/impeccable distill`, `/impeccable quieter` | — |
| Too plain → add visual impact / color | `/impeccable bolder`, `/impeccable colorize` | — |
| Productionize (error states / i18n / overflow / edge cases) | `/impeccable harden` | — |
| Performance (loading / rendering / animation / bundle) | `/impeccable optimize` | — |
| Onboarding / first-run / empty states | `/impeccable onboard` | — |
| Try design variants live in the browser (HMR hot-swap) | `/impeccable live` (needs a dev server) | — |
| Produce a visual in chat: diagram / chart / dashboard / mockup / illustration | `visualize` → `show_widget` _(MCP)_ | — |
| Read/write or generate mockups in a `.pen` design file | `pencil` _(MCP)_ | — |
| Emit very long, complete code without truncation | `full-output-enforcement` | — |

---

## 2. Invocation mechanics (don't get this wrong)

- **Global skills**: at startup Claude Code scans `~/.claude/skills/*/SKILL.md` and injects each `name` + `description`. **The model auto-invokes (via the Skill tool) when it judges a task matches a description.** It's automatic but *judgment-based, not a hard trigger* — when descriptions overlap, the choice is unstable, so **name the skill or use a slash command** to be sure.
- **User-invocable**: only `impeccable` sets `user-invocable: true`, so you can type `/impeccable <cmd> [target]`. The 6 taste skills are **not** user-invocable — you can't slash them; the model auto-invokes them or you name them in plain language ("use the high-end-visual-design standard"). Another Claude Code can still call them by `name` via the Skill tool.
- **`design:*`**: plugin skills, called by full name via the Skill tool (e.g. `design:design-critique`); trigger phrases in their descriptions (e.g. "review this design") prompt auto-invocation.
- **MCPs (pencil / visualize)**: not skills — MCP tools, called directly. For `visualize`, **silently call `read_me` once before the first `show_widget`**.

---

## 3. The installed stack (`~/.claude/skills/`)

### 3.1 `ui-ux-pro-max` — design intelligence database
- **What**: a searchable design library — 50+ styles, 161 color palettes, 57 font pairings, 161 product types (with reasoning rules), 99 UX guidelines, 25 chart types, across 10 stacks (React / Next / Vue / Svelte / SwiftUI / RN / Flutter / Tailwind / shadcn/ui / HTML+CSS). Integrates the shadcn/ui MCP for component search.
- **When**: when you need an *evidence-based* pick of palette / font / style / chart, or concrete design rules for a product type (SaaS, e-commerce, dashboard, portfolio, blog, admin…). Actions: plan/build/create/design/implement/review/fix/improve/optimize/enhance/refactor/check.
- **Role**: it's a knowledge base, not a taste engine — **complements** impeccable / taste and can layer with them.
- **Note**: its search scripts use python3. Source: `github.com/nextlevelbuilder/ui-ux-pro-max-skill`.

### 3.2 `impeccable` — anti-AI-slop design skill (1 skill + 23 commands)
- **What**: Paul Bakaus's frontend design skill. `user-invocable`, via `/impeccable <cmd> [target]`. Ships a project-level workflow, a live browser mode, and an optional PostToolUse detector hook (see §6).
- **Project files**: `/impeccable init` runs a discovery interview and writes `PRODUCT.md` (strategy) + `DESIGN.md` (visual language, when code exists); **other commands read those two first**. Run init once per project.
- **23 commands**:

| Command | Does | Arg |
|---|---|---|
| `craft` | Build a new feature end to end (multi-round shape discovery, then build + visual iteration) | [feature] |
| `shape` | Plan UX/UI before writing code; produce a confirmed design brief | [feature] |
| `init` | Initialize impeccable for the project; write PRODUCT.md / DESIGN.md | — |
| `document` | Generate DESIGN.md (extract palette/type/spacing/radius/components from code) | — |
| `extract` | Converge repeated patterns/components/tokens into a design system | [target] |
| `audit` | Technical audit: a11y + perf + theming + responsive + anti-patterns; P0–P3 scoring + plan | [area] |
| `critique` | UX-lens review: hierarchy / IA / cognitive load; quantitative scoring + persona tests | [area] |
| `polish` | Final pre-ship pass: alignment / spacing / consistency / detail | [target] |
| `typeset` | Typography / hierarchy / size / weight / readability | [target] |
| `layout` | Layout / spacing / rhythm; fix monotonous grids and weak hierarchy | [target] |
| `colorize` | Add strategic color to an over-monochrome UI | [target] |
| `animate` | Add purposeful motion / micro-interactions | [target] |
| `delight` | Add surprise / personality; make it memorable | [target] |
| `bolder` | Amplify a too-conservative / boring design | [target] |
| `quieter` | Tone down a too-loud / aggressive design | [target] |
| `distill` | Reduce complexity; back to essentials | [target] |
| `adapt` | Responsive / multi-device / multi-context (breakpoints / fluid / touch) | [target] [context] |
| `clarify` | Improve UX copy / errors / labels / instructions | [target] |
| `harden` | Productionize: error handling / i18n / overflow / edge cases / real-data resilience | [target] |
| `optimize` | UI performance: loading / rendering / animation / images / bundle | [target] |
| `onboard` | Onboarding / first-run / empty states / activation moment | [target] |
| `overdrive` | Break convention: shaders / spring physics / scroll-driven / 60fps showpieces | [target] |
| `live` | In-browser live variants (select element → action → AI generates HTML+CSS via HMR); needs a dev server | — |
| `hooks` | Manage the §6 detector hook: `on`/`off`/`status`/`ignore-rule`/`ignore-file`/`ignore-value` | <sub> |

- Source: `github.com/pbakaus/impeccable` (Apache-2.0, site: impeccable.style).

### 3.3 The taste suite (6 picks, source `github.com/Leonxlnx/taste-skill`)
> All "knowledge / taste" skills (pure SKILL.md, no commands). The model auto-invokes them or you name them. Not user-invocable.

| name | Does | Use for | Not for |
|---|---|---|---|
| `design-taste-frontend` | Anti-slop core: read brief → infer direction → produce non-template UI | landing pages / portfolios / redesigns | dashboards, data tables, multi-step product UI (author excludes these) |
| `high-end-visual-design` | Like a high-end agency: define the type/spacing/shadow/card/motion that make a site "look expensive"; close off cheap defaults | wanting polish / a premium feel | — |
| `redesign-existing-projects` | Audit an existing site, spot generic AI patterns, upgrade without breaking it (any CSS framework) | upgrading an old site/app | — |
| `minimalist-ui` | Minimalist editorial: warm monochrome, type contrast, flat bento, soft pastels; no gradients or heavy shadows | a specified minimalist style | — |
| `industrial-brutalist-ui` | Industrial brutalism: Swiss type × military terminal, rigid grids, extreme scale contrast, distressed effects | data-dense dashboards / editorial / portfolio | — |
| `full-output-enforcement` | Override LLM truncation; force complete code, no placeholders, clean token-limit segmentation | any task needing exhaustive output (orthogonal to taste) | — |

---

## 4. Anthropic `design:*` suite (7; needs the design plugin)

Called by full name via the Skill tool, or prompted by trigger phrases.

| name | Does | Trigger phrase example |
|---|---|---|
| `design:accessibility-review` | WCAG 2.1 AA audit: contrast / keyboard nav / touch target size / screen reader | "audit accessibility", "check a11y" |
| `design:design-critique` | Structured design feedback: usability / hierarchy / consistency | "review this design", "critique this mockup" |
| `design:design-handoff` | Dev handoff spec: layout / tokens / component props / interaction states / breakpoints / motion | finalized design going to engineering |
| `design:design-system` | Design system: find naming inconsistencies / hardcoded values, document variants + states + a11y, extend patterns | maintaining / extending a design system |
| `design:research-synthesis` | Synthesize interviews / surveys / usability notes / tickets / NPS into themes / insights / segments / priorities | a pile of research to distill |
| `design:user-research` | Plan + run + synthesize user research (interview guides / usability tests / survey design) | "user research plan", "interview guide" |
| `design:ux-copy` | Write / review UX copy: microcopy / errors / empty states / CTAs | "write copy for", "what should this button say?" |

---

## 5. Design / visualization MCPs

### 5.1 `pencil` (.pen design-file editor)
- Expert design generator + validator for web/mobile, reads/writes `.pen` files.
- **Important**: `.pen` content is encrypted — **only the pencil MCP tools can read/write it** (`batch_get` to read, `batch_design` to write). **Never** use Read/Grep.
- Common tools: `get_editor_state` (look first), `open_document`, `get_guidelines`, `batch_get`, `batch_design`, `get_screenshot`, `export_nodes`, `get_variables`/`set_variables`.

### 5.2 `visualize` (inline chat visuals via `show_widget`)
- Inline SVG / HTML: flowcharts, architecture diagrams, charts, dashboards, forms, calculators, data tables, games, illustrations, mockups, interactive widgets.
- **Silently call `read_me` once before the first `show_widget`** (pick the module by content type: diagram/mockup/interactive/data_viz/art/chart/elicitation). Don't mention that read_me call to the user.
- When: you need a visual artifact in the conversation, not in the codebase.

---

## 6. Optional: per-project auto-detector hook (impeccable)

impeccable ships a PostToolUse hook that, after each UI-file edit, runs its design detectors and returns issues as a **system reminder** — **never interrupts the turn, always exits 0, doesn't touch files, non-destructive**.

- **It's project-scoped** (its command paths are pinned to `${CLAUDE_PROJECT_DIR}/.claude/skills/impeccable/...`), so enable it per project where you want automatic checks.
- **Wiring (vendor style)**: inside the project, make `.claude/skills/impeccable` a **symlink** to the global skill; the hook lives in `.claude/settings.local.json` (`PostToolUse`, matcher `Edit|Write|MultiEdit`); on/off + limits in `.impeccable/config.json`.

```bash
P=<project absolute path>
mkdir -p "$P/.claude/skills"
ln -sfn ~/.claude/skills/impeccable "$P/.claude/skills/impeccable"
cd "$P" && node "$P/.claude/skills/impeccable/scripts/hook-admin.mjs" on
# keep it out of the repo if .claude/ isn't already gitignored:
printf '\n.impeccable/\n' >> "$P/.git/info/exclude"
```

- **Manage** (inside that project): `/impeccable hooks status | off | on`, `/impeccable hooks ignore-file "src/legacy/**"`, `ignore-rule <id>`.

---

## 7. Cheat sheet

- Global skills dir: `~/.claude/skills/`
- This router: `~/.claude/DESIGN-SKILLS.md` (single source of truth; update when tooling changes)
- The only thing you can slash: `/impeccable <cmd> [target]` (everything else is model-invoked or named)
- Not sure which to use → back to §1
- Overlap reminder: don't stack a taste knowledge skill + impeccable on the same micro-task; for end-to-end builds make `/impeccable craft` the spine and let the taste skills inform it passively.
