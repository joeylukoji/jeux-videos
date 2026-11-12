#!/usr/bin/env python3
"""Validate the lesson JSON without requiring Godot."""
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
LESSON = ROOT / "data" / "words.json"


def main() -> int:
    try:
        data = json.loads(LESSON.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        print(f"Invalid lesson JSON: {exc}", file=sys.stderr)
        return 1

    steps = data.get("steps")
    if not isinstance(steps, list) or not steps:
        print("'steps' must be a non-empty array.", file=sys.stderr)
        return 1

    ids: set[str] = set()
    words: set[str] = set()
    errors: list[str] = []
    for index, step in enumerate(steps, start=1):
        if not isinstance(step, dict):
            errors.append(f"Step {index}: expected an object.")
            continue
        for field in ("id", "english", "french", "category", "position"):
            if field not in step:
                errors.append(f"Step {index}: missing '{field}'.")
        word_id = str(step.get("id", "")).strip()
        english = str(step.get("english", "")).strip().lower()
        french = str(step.get("french", "")).strip()
        if not word_id or not english or not french:
            errors.append(f"Step {index}: id, english and french must not be empty.")
        if word_id in ids:
            errors.append(f"Step {index}: duplicate id '{word_id}'.")
        if english in words:
            errors.append(f"Step {index}: duplicate English word '{english}'.")
        ids.add(word_id)
        words.add(english)
        position = step.get("position")
        if (
            not isinstance(position, list)
            or len(position) != 3
            or not all(isinstance(value, (int, float)) for value in position)
        ):
            errors.append(f"Step {index}: position must contain three numbers.")
        if step.get("category") not in {"animal", "food"}:
            errors.append(f"Step {index}: unsupported category.")

    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1
    print(f"Lesson OK: {len(steps)} unique vocabulary items.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
