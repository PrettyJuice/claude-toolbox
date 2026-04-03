#!/usr/bin/env python3
"""
Claude Code statusline — Affiche les quotas 5h et 7d avec barres de progression.

Barre verte = quota consomme, gris = temps ecoule, vide = temps restant.
Si le quota depasse le temps ecoule, la partie excedentaire passe en rouge.

Installe par claude-toolbox: https://github.com/PrettyJuice/claude-toolbox
"""
import sys, json, time

data = json.loads(sys.stdin.read())

# ─── Model ───
model = data.get("model", {}).get("display_name", "?")

# ─── Rate limits ───
rl = data.get("rate_limits") or {}
five_h = rl.get("five_hour") or {}
seven_d = rl.get("seven_day") or {}

quota_5h = five_h.get("used_percentage")
resets_5h = five_h.get("resets_at")
quota_7d = seven_d.get("used_percentage")
resets_7d = seven_d.get("resets_at")

# Pas encore de rate limits → juste le modele
if quota_5h is None:
    print(f"[{model}]")
    sys.exit(0)

now = time.time()

def make_bar(pct, resets_at, window, width=10):
    """Construit une barre : vert (quota) + rouge (surconso) + gris (temps) + vide (reste)"""
    pct_int = min(round(pct), 100)

    if resets_at:
        remaining = max(int(resets_at - now), 0)
        elapsed = max(window - remaining, 0)
        time_pct = min(elapsed * 100 // window, 100)
        rd = remaining // 86400
        rh = (remaining % 86400) // 3600
        rm = (remaining % 3600) // 60
        if rd > 0:
            time_left = f"{rd}j{rh:02d}h"
        elif rh > 0:
            time_left = f"{rh}h{rm:02d}"
        else:
            time_left = f"{rm}min"
    else:
        time_pct = 0
        time_left = "?"

    quota_fill = pct_int * width // 100
    time_fill = time_pct * width // 100

    # Si le quota depasse le temps ecoule → surconsommation → rouge
    if quota_fill > time_fill:
        green = time_fill
        red = quota_fill - time_fill
        gray = 0
        empty = width - quota_fill
        color = "31"  # rouge
    else:
        green = quota_fill
        red = 0
        gray = time_fill - quota_fill
        empty = width - time_fill
        color = "32"  # vert

    bar = f"\033[32m{'█' * green}\033[0m"
    bar += f"\033[31m{'█' * red}\033[0m"
    bar += f"\033[90m{'▓' * gray}\033[0m"
    bar += f"\033[90m{'░' * empty}\033[0m"

    return bar, pct_int, time_left, color

# ─── 5h ───
bar_5h, pct_5h, left_5h, col_5h = make_bar(quota_5h, resets_5h, 18000)

# ─── Assemblage ───
line = f"[{model}] 5h {bar_5h} \033[{col_5h}m{pct_5h}%\033[0m \033[90m⏱  {left_5h}\033[0m"

if quota_7d is not None:
    bar_7d, pct_7d, left_7d, col_7d = make_bar(quota_7d, resets_7d, 604800, width=10)
    line += f" \033[90m│\033[0m 7d {bar_7d} \033[{col_7d}m{pct_7d}%\033[0m \033[90m⏱  {left_7d}\033[0m"

print(line)
