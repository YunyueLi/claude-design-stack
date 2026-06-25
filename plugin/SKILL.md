---
name: claude-design-stack
description: Install, update, or remove claude-design-stack — a curated set of Claude Code design skills (impeccable, the taste suite, ui-ux-pro-max) plus a decision-table router. Use when the user wants to set up their design stack, "install the design skills", "set up claude-design-stack", add the design tooling, or uninstall it.
user-invocable: true
---

# claude-design-stack — set up a curated design skill stack

Installs a vetted set of Claude Code design skills into `~/.claude/skills/` plus a
decision-table router into `~/.claude/DESIGN-SKILLS.md`. Your job is to run the
project's installer — do **not** hand-copy skills or invent your own steps.

**What it installs** (each fetched live from its own upstream, never redistributed):
- `impeccable` — anti-AI-slop frontend design, 23 commands, slashable as `/impeccable`
- the taste suite (6) — `design-taste-frontend`, `high-end-visual-design`, `redesign-existing-projects`, `minimalist-ui`, `industrial-brutalist-ui`, `full-output-enforcement`
- `ui-ux-pro-max` — searchable design DB (palettes, font pairings, UX rules, charts)
- `DESIGN-SKILLS.md` — the router: which skill to use for which task

## Install / update

Run this (one shot — it clones each upstream and copies the router):

```bash
D="$(mktemp -d)" && git clone --depth 1 -q https://github.com/YunyueLi/claude-design-stack.git "$D" && bash "$D/install.sh"; rm -rf "$D"
```

Append flags to `install.sh` based on what the user asked for:
- they don't want their `~/.claude/CLAUDE.md` modified → `bash "$D/install.sh" --no-claude-md`
- they want to skip the large DB skill → `bash "$D/install.sh" --no-ui-ux-pro-max`

Re-running it is also how you **update** the stack to the latest upstream skills.

## Remove

```bash
D="$(mktemp -d)" && git clone --depth 1 -q https://github.com/YunyueLi/claude-design-stack.git "$D" && bash "$D/uninstall.sh"; rm -rf "$D"
```

## After installing

- Tell the user to **restart Claude Code** so it loads the new skills.
- Then they can ask for design work in plain language, type `/impeccable` to drive it
  directly, or open `~/.claude/DESIGN-SKILLS.md` (§1 is the decision table) to see which
  skill does what.
- `python3` is optional but powers `ui-ux-pro-max`'s search scripts — mention it only if missing.

## Notes

- Requires `git` and network access. The install is just `git clone` + `cp` — nothing runs
  in the background, nothing phones home.
- The router stays accurate only if its upstreams haven't drifted; re-run install to refresh.
