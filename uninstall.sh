#!/usr/bin/env bash
set -euo pipefail

TOOLBOX_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"

MARKER_START="# >>> erwin-toolbox >>>"
MARKER_END="# <<< erwin-toolbox <<<"

echo "=== Désinstallation de la toolbox ==="
echo ""

# 1. Remove script symlinks from ~/.local/bin
if [[ -d "$TOOLBOX_DIR/scripts" ]]; then
    for script in "$TOOLBOX_DIR/scripts"/*; do
        [[ -f "$script" ]] || continue
        name=$(basename "$script")
        target="$BIN_DIR/$name"
        if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$script" ]]; then
            rm "$target"
            echo "  Script supprimé: $target"
        fi
    done
fi

# 2. Remove skill symlinks from ~/.claude/skills
if [[ -d "$TOOLBOX_DIR/skills" ]]; then
    for skill in "$TOOLBOX_DIR/skills"/*.md; do
        [[ -f "$skill" ]] || continue
        name=$(basename "$skill")
        target="$CLAUDE_DIR/skills/$name"
        if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$skill" ]]; then
            rm "$target"
            echo "  Skill supprimé: $target"
        fi
    done
fi

# 3. Remove command symlinks from ~/.claude/commands
if [[ -d "$TOOLBOX_DIR/commands" ]]; then
    for cmd in "$TOOLBOX_DIR/commands"/*.md; do
        [[ -f "$cmd" ]] || continue
        name=$(basename "$cmd")
        target="$CLAUDE_DIR/commands/$name"
        if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$cmd" ]]; then
            rm "$target"
            echo "  Command supprimé: $target"
        fi
    done
fi

# 4. Remove toolbox section from ~/.claude/CLAUDE.md
if [[ -f "$CLAUDE_MD" ]] && grep -q "$MARKER_START" "$CLAUDE_MD"; then
    sed -i "/$MARKER_START/,/$MARKER_END/d" "$CLAUDE_MD"
    sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$CLAUDE_MD"
    echo "  Instructions retirées de $CLAUDE_MD"
fi

echo ""
echo "Désinstallation terminée."
