#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

echo "=== Installation de la statusline ==="
echo ""

# 1. Symlink statusline.sh
target="$CLAUDE_DIR/statusline.sh"
if [[ -L "$target" || -f "$target" ]]; then
    rm "$target"
fi
ln -s "$SCRIPT_DIR/statusline.sh" "$target"
echo "  Statusline: statusline.sh -> $target"

# 2. Inject statusLine config into settings.json
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

echo ""
echo "Installation terminée !"
