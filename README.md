# claude-design-stack

One command installs a **curated set of Claude Code design skills** — and a **decision table** that tells you (and the model) which one to use for which task.

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![Skills](https://img.shields.io/badge/skills-8-orange)
![Shell](https://img.shields.io/badge/install-pure%20bash-555)

[中文](./README.zh-CN.md)

---

Claude Code has genuinely good design skills now — [impeccable](https://github.com/pbakaus/impeccable), the [taste suite](https://github.com/Leonxlnx/taste-skill), [ui-ux-pro-max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill), Anthropic's `design:*`. Two problems follow:

1. **You install them one by one**, each from a different repo with a different layout.
2. **They overlap heavily.** "Redesign this page" matches four skills at once, and the model picks unpredictably — or you stack them and they fight.

`claude-design-stack` fixes both: it **installs a curated stack in one command**, and ships a **router** — a decision table, copied to `~/.claude/DESIGN-SKILLS.md` and auto-loaded — so the right skill fires for the right task instead of a coin flip.

## Install

```bash
git clone https://github.com/YunyueLi/claude-design-stack.git
cd claude-design-stack
./install.sh
```

Then **restart Claude Code**. That's it — ask for design work, or type `/impeccable` to drive it directly.

```
./install.sh --no-claude-md        # don't touch ~/.claude/CLAUDE.md
./install.sh --no-ui-ux-pro-max    # skip the big DB skill
./uninstall.sh                     # remove everything it added
```

> **Prerequisite:** `git`. `ui-ux-pro-max`'s search scripts also use `python3` (optional).
>
> **Prefer talking to Claude?** Install it as a plugin instead of cloning:
> ```
> claude plugin marketplace add YunyueLi/claude-design-stack
> claude plugin install claude-design-stack@claude-design-stack
> ```
> then just ask: *"set up the design stack."* (Or run `/claude-design-stack`.)

## What's in the stack

| Skill | What it's for | Invoke | Source |
|---|---|---|---|
| **impeccable** | Anti-AI-slop frontend design; 23 commands (craft, audit, critique, polish, animate, harden…) | `/impeccable <cmd>` | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) · Apache-2.0 |
| **design-taste-frontend** | Anti-slop core: brief → non-template UI | auto / named | [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) · MIT |
| **high-end-visual-design** | Make a UI "look expensive" | auto / named | ↑ |
| **redesign-existing-projects** | Upgrade an old site without breaking it | auto / named | ↑ |
| **minimalist-ui** | Minimalist editorial style | auto / named | ↑ |
| **industrial-brutalist-ui** | Industrial brutalist style | auto / named | ↑ |
| **full-output-enforcement** | Force complete, untruncated code output | auto / named | ↑ |
| **ui-ux-pro-max** | Searchable design DB: 161 palettes, 57 font pairings, 99 UX rules, 25 charts… | auto / named | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) · MIT |

This repo **doesn't redistribute** these skills — `install.sh` fetches each from its own upstream under its own license.

## The router (the actual point)

The full decision table lives in [`DESIGN-SKILLS.md`](./DESIGN-SKILLS.md) and is copied to `~/.claude/DESIGN-SKILLS.md` on install. A taste of it:

| What you want to do | Use |
|---|---|
| Build a landing page that doesn't look like an AI template | `design-taste-frontend` or `/impeccable craft` |
| Upgrade an existing site to feel high-end | `redesign-existing-projects` |
| Make a UI "look expensive" (type / spacing / shadow / motion) | `high-end-visual-design` |
| Pick a palette / font pairing / chart from a curated library | `ui-ux-pro-max` |
| Technical audit (a11y + perf + responsive, scored) | `/impeccable audit` |
| Design review / critique | `/impeccable critique` |
| Add motion / micro-interactions | `/impeccable animate` |
| Simplify an overloaded UI | `/impeccable distill` |
| Too plain → more impact / color | `/impeccable bolder`, `/impeccable colorize` |

It also documents **invocation mechanics** (only `impeccable` is slashable; the taste skills are model-invoked) and **overlap rules** (don't stack a taste skill and impeccable on the same micro-task).

## How it works

- `install.sh` drops the 8 skill folders into `~/.claude/skills/`, where Claude Code already scans for skills.
- It copies the router to `~/.claude/DESIGN-SKILLS.md` and adds one line to `~/.claude/CLAUDE.md` so Claude **reads the router before any design task** (skip with `--no-claude-md`).
- Nothing runs in the background; nothing phones home. It's a `git clone` + `cp` you could do by hand.

## Optional add-ons (referenced by the router, installed separately)

- **Anthropic `design:*` suite** — `accessibility-review`, `design-critique`, `design-handoff`, `design-system`, `ux-copy`, `user-research`, `research-synthesis`. Install the design plugin to get them; the router already knows when to reach for each.
- **MCPs** — `pencil` (edit `.pen` files), `visualize` (inline SVG/HTML widgets in chat). Available when the MCP server is connected.

## Credits

This is curation + routing. The skills are the work of their authors — go star them:
[pbakaus/impeccable](https://github.com/pbakaus/impeccable), [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill), [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill).

## License

[MIT](./LICENSE) © YunyueLi and contributors. Bundled skills keep their own licenses (see [LICENSE](./LICENSE)).
