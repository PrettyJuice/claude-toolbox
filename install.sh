#!/usr/bin/env bash
set -euo pipefail

TOOLBOX_DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS_DIR="$TOOLBOX_DIR/scripts"
INSTRUCTIONS="$TOOLBOX_DIR/claude-instructions.md"
BIN_DIR="$HOME/.local/bin"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"

MARKER_START="# >>> erwin-toolbox >>>"
MARKER_END="# <<< erwin-toolbox <<<"

echo "=== Installation de la toolbox ==="
echo ""

# 1. Symlink scripts into ~/.local/bin
mkdir -p "$BIN_DIR"
for script in "$SCRIPTS_DIR"/*.sh; do
    [[ -f "$script" ]] || continue
    name=$(basename "$script")
    target="$BIN_DIR/$name"
    if [[ -L "$target" || -f "$target" ]]; then
        rm "$target"
    fi
    ln -s "$script" "$target"
    echo "  Lié: $name -> $target"
done

# 2. Inject instructions into ~/.claude/CLAUDE.md
mkdir -p "$CLAUDE_DIR"

if [[ -f "$CLAUDE_MD" ]]; then
    # Remove old toolbox section if present
    if grep -q "$MARKER_START" "$CLAUDE_MD"; then
        sed -i "/$MARKER_START/,/$MARKER_END/d" "$CLAUDE_MD"
    fi
else
    touch "$CLAUDE_MD"
fi

# Append toolbox instructions
{
    echo ""
    echo "$MARKER_START"
    cat "$INSTRUCTIONS"
    echo ""
    echo "$MARKER_END"
} >> "$CLAUDE_MD"

echo "  Instructions injectées dans $CLAUDE_MD"

echo ""
echo "Installation terminée !"
echo "Les scripts sont disponibles dans $BIN_DIR"
echo "Claude connaît tes outils via $CLAUDE_MD"
