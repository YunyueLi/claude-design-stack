#!/usr/bin/env bash
# claude-design-stack — install a curated set of Claude Code design skills + the router.
# https://github.com/YunyueLi/claude-design-stack
set -euo pipefail

# ---------- config (override via env) ----------
CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
SKILLS_DIR="${SKILLS_DIR:-$CLAUDE_DIR/skills}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH_CLAUDE_MD=1
INSTALL_UUXPM=1

for arg in "${@:-}"; do
  case "$arg" in
    --no-claude-md)      PATCH_CLAUDE_MD=0 ;;
    --no-ui-ux-pro-max)  INSTALL_UUXPM=0 ;;
    -h|--help)
      echo "Usage: ./install.sh [--no-claude-md] [--no-ui-ux-pro-max]"
      echo "Env:   CLAUDE_DIR (default ~/.claude), SKILLS_DIR (default \$CLAUDE_DIR/skills)"
      exit 0 ;;
  esac
done

# ---------- pretty ----------
if [ -t 1 ]; then B=$'\033[1m'; G=$'\033[32m'; Y=$'\033[33m'; R=$'\033[31m'; D=$'\033[2m'; X=$'\033[0m'; else B=; G=; Y=; R=; D=; X=; fi
say()  { printf '%s\n' "$*"; }
ok()   { printf '%s✓%s %s\n' "$G" "$X" "$*"; }
warn() { printf '%s!%s %s\n' "$Y" "$X" "$*"; }
err()  { printf '%s✗%s %s\n' "$R" "$X" "$*" >&2; }
step() { printf '\n%s== %s ==%s\n' "$B" "$*" "$X"; }

command -v git >/dev/null 2>&1 || { err "git is required (https://git-scm.com)."; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$SKILLS_DIR"

clone() { git clone --depth 1 -q "$1" "$2"; }

install_folder() { # src dstname [--deref]
  local src="$1" dst="$SKILLS_DIR/$2" deref="${3:-}"
  [ -e "$dst" ] && rm -rf "$dst"
  if [ "$deref" = "--deref" ]; then cp -RL "$src" "$dst"; else cp -R "$src" "$dst"; fi
}

say "${B}claude-design-stack${X} → installing into ${B}$SKILLS_DIR${X}"

# ---------- impeccable ----------
step "impeccable  (Apache-2.0 · pbakaus/impeccable)"
clone https://github.com/pbakaus/impeccable.git "$TMP/imp"
install_folder "$TMP/imp/.claude/skills/impeccable" "impeccable"
ok "impeccable  → user-invocable as ${B}/impeccable${X}"

# ---------- taste suite ----------
step "taste suite  (MIT · Leonxlnx/taste-skill)"
clone https://github.com/Leonxlnx/taste-skill.git "$TMP/taste"
printf '%s\n' \
  "taste-skill:design-taste-frontend" \
  "soft-skill:high-end-visual-design" \
  "redesign-skill:redesign-existing-projects" \
  "minimalist-skill:minimalist-ui" \
  "brutalist-skill:industrial-brutalist-ui" \
  "output-skill:full-output-enforcement" \
| while IFS=: read -r srcf dstn; do
    if [ -d "$TMP/taste/skills/$srcf" ]; then
      install_folder "$TMP/taste/skills/$srcf" "$dstn"
      ok "$srcf  → $dstn"
    else
      warn "taste folder '$srcf' not found upstream — skipped"
    fi
  done

# ---------- ui-ux-pro-max ----------
if [ "$INSTALL_UUXPM" = "1" ]; then
  step "ui-ux-pro-max  (MIT · nextlevelbuilder/ui-ux-pro-max-skill)"
  clone https://github.com/nextlevelbuilder/ui-ux-pro-max-skill.git "$TMP/uuxpm"
  if [ -d "$TMP/uuxpm/.claude/skills/ui-ux-pro-max" ]; then
    # data/ and scripts/ are symlinks into src/ — --deref copies the real files
    install_folder "$TMP/uuxpm/.claude/skills/ui-ux-pro-max" "ui-ux-pro-max" --deref
    ok "ui-ux-pro-max  → $SKILLS_DIR/ui-ux-pro-max"
    command -v python3 >/dev/null 2>&1 || warn "python3 not found — ui-ux-pro-max's search scripts need it (e.g. brew install python3)."
  else
    warn "ui-ux-pro-max layout changed upstream — skipped."
    warn "  install it directly:  /plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill"
  fi
fi

# ---------- router doc ----------
step "router  (DESIGN-SKILLS.md)"
ROUTER_SRC="$SCRIPT_DIR/DESIGN-SKILLS.md"
ROUTER_DST="$CLAUDE_DIR/DESIGN-SKILLS.md"
if [ -f "$ROUTER_SRC" ]; then
  if [ -f "$ROUTER_DST" ] && ! cmp -s "$ROUTER_SRC" "$ROUTER_DST"; then
    cp "$ROUTER_DST" "$ROUTER_DST.bak"
    warn "existing DESIGN-SKILLS.md backed up → DESIGN-SKILLS.md.bak"
  fi
  cp "$ROUTER_SRC" "$ROUTER_DST"
  ok "router → $ROUTER_DST"
else
  warn "DESIGN-SKILLS.md not found next to install.sh — skipped"
fi

# ---------- CLAUDE.md auto-load ----------
if [ "$PATCH_CLAUDE_MD" = "1" ]; then
  step "auto-load  (CLAUDE.md)"
  CMD_FILE="$CLAUDE_DIR/CLAUDE.md"
  if [ -f "$CMD_FILE" ] && grep -q "DESIGN-SKILLS.md" "$CMD_FILE"; then
    ok "CLAUDE.md already points at the router — left as is"
  else
    {
      printf '\n# Design / UI / art work\n'
      printf -- '- Before any UI/design/art task, read `~/.claude/DESIGN-SKILLS.md` — a decision table for which installed design skill to use for which task. Update it when your design tooling changes.\n'
    } >> "$CMD_FILE"
    ok "added router auto-load to $CMD_FILE  ${D}(reversible; or re-run with --no-claude-md)${X}"
  fi
fi

step "done"
say "Installed into ${B}$SKILLS_DIR${X}.  ${Y}Restart Claude Code${X} so it loads the new skills."
say "Then just ask for design work — or type ${B}/impeccable${X} to drive it directly."
say "${D}Not sure which skill does what? Open ~/.claude/DESIGN-SKILLS.md — §1 is the decision table.${X}"
