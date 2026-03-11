#!/usr/bin/env bash
set -euo pipefail

# Extract frames from a video using ffmpeg
# Usage: ./extract-frames.sh [video] [start] [end] [fps]
# Or run without arguments for interactive mode

show_usage() {
    echo "Usage: $0 <video> <start> <end> <fps>"
    echo ""
    echo "  video  : chemin vers le fichier vidéo (ex: video.mp4)"
    echo "  start  : temps de début (ex: 00:01:30 ou 90)"
    echo "  end    : temps de fin   (ex: 00:02:00 ou 120)"
    echo "  fps    : images par seconde à extraire (ex: 5)"
    echo ""
    echo "Exemple: $0 ma_video.mp4 00:01:30 00:02:00 5"
}

# Check ffmpeg
if ! command -v ffmpeg &>/dev/null; then
    echo "Erreur: ffmpeg n'est pas installé."
    echo "  sudo apt install ffmpeg    # Debian/Ubuntu"
    echo "  brew install ffmpeg         # macOS"
    exit 1
fi

# Interactive mode if no args
if [[ $# -eq 0 ]]; then
    echo "=== Extracteur de frames vidéo ==="
    echo ""

    read -rp "Chemin de la vidéo : " VIDEO
    read -rp "Temps de début (ex: 00:01:30) : " START
    read -rp "Temps de fin   (ex: 00:02:00) : " END
    read -rp "Images par seconde (ex: 5) : " FPS
elif [[ $# -eq 4 ]]; then
    VIDEO="$1"
    START="$2"
    END="$3"
    FPS="$4"
else
    show_usage
    exit 1
fi

# Convert Windows path to WSL path if needed (e.g. C:\Users\... -> /mnt/c/Users/...)
if [[ "$VIDEO" =~ ^[A-Za-z]:\\ ]]; then
    DRIVE="${VIDEO:0:1}"
    DRIVE_LOWER=$(echo "$DRIVE" | tr '[:upper:]' '[:lower:]')
    VIDEO="/mnt/${DRIVE_LOWER}/${VIDEO:3}"
    VIDEO="${VIDEO//\\//}"
    echo "(WSL) Chemin converti : $VIDEO"
fi

# Validate input
if [[ ! -f "$VIDEO" ]]; then
    echo "Erreur: fichier '$VIDEO' introuvable."
    exit 1
fi

if ! [[ "$FPS" =~ ^[0-9]+([.][0-9]+)?$ ]] || (( $(echo "$FPS <= 0" | bc -l) )); then
    echo "Erreur: le FPS doit être un nombre positif."
    exit 1
fi

# Create output directory based on video name
BASENAME=$(basename "${VIDEO%.*}")
OUTPUT_DIR="frames_${BASENAME}_${START//:/}-${END//:/}_${FPS}fps"
mkdir -p "$OUTPUT_DIR"

echo ""
echo "Vidéo   : $VIDEO"
echo "Début   : $START"
echo "Fin     : $END"
echo "FPS     : $FPS"
echo "Sortie  : $OUTPUT_DIR/"
echo ""

# Extract frames
ffmpeg -ss "$START" -to "$END" -i "$VIDEO" -vf "fps=$FPS" -q:v 2 "$OUTPUT_DIR/frame_%05d.jpg"

COUNT=$(find "$OUTPUT_DIR" -name 'frame_*.jpg' | wc -l)
echo ""
echo "Terminé ! $COUNT images extraites dans $OUTPUT_DIR/"
