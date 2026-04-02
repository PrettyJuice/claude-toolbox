# Claude Toolbox

Outils personnels installés via https://github.com/PrettyJuice/claude-toolbox.
Les scripts sont disponibles dans le PATH (~/.local/bin/).

## Outils disponibles

### extract-frames — Extraire des images d'une vidéo

**Quand l'utiliser :** Quand l'utilisateur demande d'extraire des frames/images d'une vidéo,
d'analyser une séquence vidéo, ou de capturer des images entre deux timestamps.

**Commande :**
```bash
extract-frames.sh <video> <debut> <fin> <fps>
```

**Paramètres :**
- `video` : chemin vers le fichier vidéo (supporte les chemins Windows sous WSL)
- `debut` : timestamp de début (ex: 00:01:30)
- `fin` : timestamp de fin (ex: 00:02:00)
- `fps` : nombre d'images par seconde (ex: 5)

**Exemple :**
```bash
extract-frames.sh video.mp4 00:01:30 00:02:00 5
```

Les images sont générées dans un dossier `frames_<nom>_<debut>-<fin>_<fps>fps/`.

### statusline — Barre de statut avec quotas Claude Code

**Quand l'utiliser :** Installé automatiquement par le toolbox. Affiche en permanence dans la
statusline de Claude Code les quotas 5h et 7d avec barres de progression visuelles.

**Fonctionnement :**
- Barre verte : quota consommé
- Barre rouge : surconsommation (quota > temps écoulé)
- Barre grise : temps écoulé dans la fenêtre
- Barre vide : temps restant

**Pré-requis :** Python 3

**Configuration :** Automatique via `install.sh` (symlink + injection dans settings.json).
