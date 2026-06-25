#!/usr/bin/env bash
# claude-design-stack — remove what install.sh added.
set -euo pipefail

CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
SKILLS_DIR="${SKILLS_DIR:-$CLAUDE_DIR/skills}"

if [ -t 1 ]; then B=$'\033[1m'; G=$'\033[32m'; Y=$'\033[33m'; X=$'\033[0m'; else B=; G=; Y=; X=; fi
ok()   { printf '%s✓%s %s\n' "$G" "$X" "$*"; }
warn() { printf '%s!%s %s\n' "$Y" "$X" "$*"; }

for s in impeccable design-taste-frontend high-end-visual-design \
         redesign-existing-projects minimalist-ui industrial-brutalist-ui \
         full-output-enforcement ui-ux-pro-max; do
  if [ -e "$SKILLS_DIR/$s" ]; then rm -rf "$SKILLS_DIR/$s"; ok "removed $s"; fi
done

if [ -f "$CLAUDE_DIR/DESIGN-SKILLS.md" ]; then
  rm -f "$CLAUDE_DIR/DESIGN-SKILLS.md"; ok "removed DESIGN-SKILLS.md"
fi
if [ -f "$CLAUDE_DIR/DESIGN-SKILLS.md.bak" ]; then
  mv "$CLAUDE_DIR/DESIGN-SKILLS.md.bak" "$CLAUDE_DIR/DESIGN-SKILLS.md"
  ok "restored your previous DESIGN-SKILLS.md from .bak"
fi

warn "The auto-load line in ${B}$CLAUDE_DIR/CLAUDE.md${X} (if added) was left in place — remove it by hand if you want."
ok "Done. Restart Claude Code."
