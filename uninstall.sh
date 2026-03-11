#!/usr/bin/env bash
set -euo pipefail

TOOLBOX_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_DIR="$TOOLBOX_DIR/scripts"
BIN_DIR="$HOME/.local/bin"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"

MARKER_START="# >>> erwin-toolbox >>>"
MARKER_END="# <<< erwin-toolbox <<<"

echo "=== Désinstallation de la toolbox ==="
echo ""

# 1. Remove symlinks from ~/.local/bin
for script in "$SCRIPTS_DIR"/*.sh; do
    [[ -f "$script" ]] || continue
    name=$(basename "$script")
    target="$BIN_DIR/$name"
    if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$script" ]]; then
        rm "$target"
        echo "  Supprimé: $target"
    fi
done

# 2. Remove toolbox section from ~/.claude/CLAUDE.md
if [[ -f "$CLAUDE_MD" ]] && grep -q "$MARKER_START" "$CLAUDE_MD"; then
    sed -i "/$MARKER_START/,/$MARKER_END/d" "$CLAUDE_MD"
    # Remove trailing empty lines
    sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$CLAUDE_MD"
    echo "  Instructions retirées de $CLAUDE_MD"
fi

echo ""
echo "Désinstallation terminée."
