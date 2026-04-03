#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

echo "=== Désinstallation de la statusline ==="
echo ""

# 1. Remove symlink
STATUSLINE_TARGET="$CLAUDE_DIR/statusline.sh"
if [[ -L "$STATUSLINE_TARGET" ]] && [[ "$(readlink "$STATUSLINE_TARGET")" == "$SCRIPT_DIR/statusline.sh" ]]; then
    rm "$STATUSLINE_TARGET"
    echo "  Statusline supprimee: $STATUSLINE_TARGET"
elif [[ -L "$STATUSLINE_TARGET" || -f "$STATUSLINE_TARGET" ]]; then
    echo "  Statusline presente mais ne pointe pas vers ce repo, ignoree."
else
    echo "  Statusline deja absente."
fi

# 2. Remove statusLine config from settings.json
if [[ -f "$SETTINGS" ]]; then
    python3 -c "
import json
path = '$SETTINGS'
with open(path) as f:
    data = json.load(f)
if 'statusLine' in data:
    del data['statusLine']
    with open(path, 'w') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write('\n')
    print('  Statusline config retiree de settings.json')
else:
    print('  Statusline config deja absente de settings.json')
"
fi

echo ""
echo "Désinstallation terminée."
