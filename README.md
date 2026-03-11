# Erwin's Toolbox

Boîte à outils personnelle pour [Claude Code](https://claude.com/claude-code).
Clone le repo, lance `install.sh`, et tous les outils sont disponibles depuis n'importe quel projet.

## Installation

```bash
git clone <repo-url> ~/projects/toolbox
cd ~/projects/toolbox
./install.sh
```

L'installateur :
- Crée des symlinks de chaque script vers `~/.local/bin/` (accessible partout)
- Injecte les instructions dans `~/.claude/CLAUDE.md` (Claude connaît les outils dans tous les projets)

Pour mettre à jour après un `git pull`, relance simplement `./install.sh` — il est idempotent.

## Désinstallation

```bash
./uninstall.sh
```

## Structure

```
toolbox/
├── scripts/                  # Scripts CLI exécutables
│   └── extract-frames.sh
├── commands/                 # (optionnel) Slash commands Claude (/nom)
├── claude-instructions.md    # Instructions injectées dans ~/.claude/CLAUDE.md
├── install.sh
├── uninstall.sh
└── README.md
```

## Outils disponibles

### extract-frames.sh

Extrait des images JPG d'une vidéo avec ffmpeg.

```bash
# Mode interactif
extract-frames.sh

# Mode direct
extract-frames.sh video.mp4 00:01:30 00:02:00 5
```

| Paramètre | Description | Exemple |
|-----------|-------------|---------|
| `video` | Chemin du fichier vidéo (Windows ou Linux) | `video.mp4` |
| `start` | Temps de début | `00:01:30` |
| `end` | Temps de fin | `00:02:00` |
| `fps` | Images par seconde | `5` |

> Supporte les chemins Windows sous WSL (`C:\Users\...` → `/mnt/c/Users/...`).

---

## Ajouter un nouvel outil

### 1. Ajouter un script

Crée ton script dans `scripts/` :

```bash
# scripts/mon-script.sh
#!/usr/bin/env bash
set -euo pipefail
# ...
```

Rends-le exécutable :

```bash
chmod +x scripts/mon-script.sh
```

### 2. Documenter pour Claude

Ajoute une section dans `claude-instructions.md` en suivant ce format :

```markdown
### mon-script — Description courte

**Quand l'utiliser :** Décris les situations où Claude doit utiliser cet outil.

**Commande :**
\```bash
mon-script.sh <arg1> <arg2>
\```

**Paramètres :**
- `arg1` : description
- `arg2` : description
```

### 3. Installer

```bash
./install.sh
```

### 4. (Optionnel) Ajouter une slash command

Si tu veux un raccourci `/mon-script` dans Claude Code, crée `commands/mon-script.md` :

```markdown
Exécute mon-script.sh avec les arguments suivants : $ARGUMENTS
```

Puis copie-le manuellement dans `~/.claude/commands/` (ou ajoute la logique dans `install.sh`).

## Prérequis

- [Claude Code](https://claude.com/claude-code)
- bash
- Dépendances par script (ex: `ffmpeg` pour extract-frames)
