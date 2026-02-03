#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

python -m pip install -U pip

if [ -f requirements.txt ] || [ -f requirements-dev.txt ]; then
  # requirements*.txt
  if [ -f requirements.txt ]; then python -m pip install -r requirements.txt; fi
  if [ -f requirements-dev.txt ]; then python -m pip install -r requirements-dev.txt; fi
else
  # pyproject.toml / setup.py / setup.cfg
  if [ -f pyproject.toml ] || [ -f setup.py ] || [ -f setup.cfg ]; then
    python -m pip install ".[dev]"
  else
    echo "No dependency manifest found. Expected requirements*.txt or pyproject.toml/setup.py/setup.cfg." >&2
    exit 1
  fi
fi

# Format (if ruff supports it)
if python -m ruff --help 2>/dev/null | grep -q "format"; then
  python -m ruff format --check .
fi

python -m ruff check .
python -m mypy app
python -m pytest -q

echo "✅ Python checks OK"
