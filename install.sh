#!/usr/bin/env bash
set -euo pipefail

TOOLBOX_DIR="$(cd "$(dirname "$0")" && pwd)"
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
if [[ -d "$TOOLBOX_DIR/scripts" ]]; then
    for script in "$TOOLBOX_DIR/scripts"/*; do
        [[ -f "$script" ]] || continue
        name=$(basename "$script")
        target="$BIN_DIR/$name"
        if [[ -L "$target" || -f "$target" ]]; then
            rm "$target"
        fi
        ln -s "$script" "$target"
        echo "  Script: $name -> $target"
    done
fi

# 2. Symlink skills into ~/.claude/skills
mkdir -p "$CLAUDE_DIR/skills"
if [[ -d "$TOOLBOX_DIR/skills" ]]; then
    for skill in "$TOOLBOX_DIR/skills"/*.md; do
        [[ -f "$skill" ]] || continue
        name=$(basename "$skill")
        target="$CLAUDE_DIR/skills/$name"
        if [[ -L "$target" || -f "$target" ]]; then
            rm "$target"
        fi
        ln -s "$skill" "$target"
        echo "  Skill: $name -> $target"
    done
fi

# 3. Symlink commands into ~/.claude/commands
mkdir -p "$CLAUDE_DIR/commands"
if [[ -d "$TOOLBOX_DIR/commands" ]]; then
    for cmd in "$TOOLBOX_DIR/commands"/*.md; do
        [[ -f "$cmd" ]] || continue
        name=$(basename "$cmd")
        target="$CLAUDE_DIR/commands/$name"
        if [[ -L "$target" || -f "$target" ]]; then
            rm "$target"
        fi
        ln -s "$cmd" "$target"
        echo "  Command: $name -> $target"
    done
fi

# 4. Install statusline
if [[ -f "$TOOLBOX_DIR/statusline/statusline.sh" ]]; then
    target="$CLAUDE_DIR/statusline.sh"
    if [[ -L "$target" || -f "$target" ]]; then
        rm "$target"
    fi
    ln -s "$TOOLBOX_DIR/statusline/statusline.sh" "$target"
    echo "  Statusline: statusline.sh -> $target"

    # Inject statusLine config into settings.json via Python (no jq dependency)
    SETTINGS="$CLAUDE_DIR/settings.json"
    python3 -c "
import json, os
path = '$SETTINGS'
data = {}
if os.path.isfile(path):
    with open(path) as f:
        data = json.load(f)
if 'statusLine' not in data:
    data['statusLine'] = {
        'type': 'command',
        'command': '~/.claude/statusline.sh'
    }
    with open(path, 'w') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write('\n')
    print('  Statusline config ajoutee a settings.json')
else:
    print('  Statusline config deja presente dans settings.json')
"
fi

# 5. Inject instructions into ~/.claude/CLAUDE.md
mkdir -p "$CLAUDE_DIR"

if [[ -f "$CLAUDE_MD" ]]; then
    if grep -q "$MARKER_START" "$CLAUDE_MD"; then
        sed -i "/$MARKER_START/,/$MARKER_END/d" "$CLAUDE_MD"
    fi
else
    touch "$CLAUDE_MD"
fi

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
