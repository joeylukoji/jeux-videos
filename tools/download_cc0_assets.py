#!/usr/bin/env python3
"""Download optional Kenney CC0 GLB models for English Quest 3D.

Run from any directory:
    python tools/download_cc0_assets.py

The game is playable without these optional files.
"""
from __future__ import annotations

import hashlib
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = "https://raw.githubusercontent.com/Hidencod/tge-assets/main/packs"
ASSETS = {
    "animals/dog.glb": "cube-pets/animal-dog.glb",
    "animals/cat.glb": "cube-pets/animal-cat.glb",
    "animals/cow.glb": "cube-pets/animal-cow.glb",
    "animals/elephant.glb": "cube-pets/animal-elephant.glb",
    "food/apple.glb": "food-kit/apple.glb",
    "food/banana.glb": "food-kit/banana.glb",
    "food/carrot.glb": "food-kit/carrot.glb",
    "food/orange.glb": "food-kit/orange.glb",
    "environment/tree-oak.glb": "nature-kit/tree-oak.glb",
    "environment/tree-palm.glb": "nature-kit/tree-palm.glb",
    "environment/rock-large.glb": "nature-kit/rock-largea.glb",
}


def main() -> int:
    failures = 0
    print("Téléchargement des modèles Kenney (CC0)...")
    for target_name, source_name in ASSETS.items():
        url = f"{BASE}/{source_name}"
        target = ROOT / "assets" / "models" / target_name
        target.parent.mkdir(parents=True, exist_ok=True)
        request = urllib.request.Request(
            url, headers={"User-Agent": "EnglishQuest3D/1.0"}
        )
        try:
            with urllib.request.urlopen(request, timeout=30) as response:
                data = response.read()
            if not data.startswith(b"glTF"):
                raise ValueError("le fichier reçu n'est pas un GLB valide")
            target.write_bytes(data)
            digest = hashlib.sha256(data).hexdigest()[:12]
            print(
                f"[OK] {target.relative_to(ROOT)} "
                f"({len(data):,} octets, sha256:{digest})"
            )
        except Exception as exc:  # noqa: BLE001
            failures += 1
            print(f"[ERREUR] {url}: {exc}", file=sys.stderr)
    if failures:
        print(
            f"{failures} asset(s) non téléchargé(s). "
            "Le jeu reste jouable avec les modèles procéduraux."
        )
        return 1
    print("Terminé. Rouvre le projet dans Godot pour importer les fichiers GLB.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
