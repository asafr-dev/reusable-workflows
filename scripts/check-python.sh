#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/check-python.sh [ROOT]

Recommended local preflight checks for a Python repo:
  - create/use an isolated venv (default: .venv/)
  - install deps (requirements*.txt OR editable install from pyproject/setup.*)
  - ruff format --check (if supported) + ruff check
  - mypy + pytest (defaults assume ./app + tests)

Env vars:
  PYTHON_BIN=python3         Python interpreter to use for venv creation
  VENV_DIR=.venv             Venv directory
  CHECK_NO_INSTALL=1         Skip dependency install
  CHECK_NO_FORMAT=1          Skip formatting check

Notes:
  - CI is the contract; this script is a best-effort preflight.
  - Windows: run via WSL (`bash` required).
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

ROOT="${1:-.}"
cd "$ROOT"

PYTHON_BIN="${PYTHON_BIN:-python3}"
if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  PYTHON_BIN="python"
fi
if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "ERROR: python3/python not found. Set PYTHON_BIN to a Python 3 interpreter." >&2
  exit 1
fi

VENV_DIR="${VENV_DIR:-.venv}"
VENV_PY="$VENV_DIR/bin/python"

if [[ ! -d "$VENV_DIR" ]]; then
  echo "→ venv: creating $VENV_DIR"
  "$PYTHON_BIN" -m venv "$VENV_DIR"
else
  echo "→ venv: using existing $VENV_DIR"
fi

if [[ ! -x "$VENV_PY" ]]; then
  echo "ERROR: venv python not found at $VENV_PY" >&2
  exit 1
fi

if [[ "${CHECK_NO_INSTALL:-0}" != "1" ]]; then
  echo "→ deps: installing"

  if [[ -f requirements.txt || -f requirements-dev.txt ]]; then
    if [[ -f requirements.txt ]]; then "$VENV_PY" -m pip install -r "requirements.txt"; fi
    if [[ -f requirements-dev.txt ]]; then "$VENV_PY" -m pip install -r "requirements-dev.txt"; fi
  elif [[ -f pyproject.toml || -f setup.py || -f setup.cfg ]]; then
    "$VENV_PY" -m pip install ".[dev]"
  else
    echo "No dependency manifest found. Expected requirements*.txt or pyproject.toml/setup.py/setup.cfg." >&2
    exit 1
  fi
else
  echo "→ deps: skipped (CHECK_NO_INSTALL=1)"
fi

# Ensure Ruff is available (script expects it in your dev deps / venv)
if ! "$VENV_PY" -m ruff --version >/dev/null 2>&1; then
  echo "ERROR: ruff is not installed in $VENV_DIR. Add it to your dev dependencies and re-run." >&2
  exit 1
fi

if [[ "${CHECK_NO_FORMAT:-0}" != "1" ]]; then
  if "$VENV_PY" -m ruff format --help >/dev/null 2>&1; then
    echo "→ format: ruff format --check"
    "$VENV_PY" -m ruff format --check .
  else
    echo "→ format: skipped (ruff format not available)"
  fi
else
  echo "→ format: skipped (CHECK_NO_FORMAT=1)"
fi

echo "→ lint: ruff check"
"$VENV_PY" -m ruff check .

echo "→ typecheck: mypy"
"$VENV_PY" -m mypy app

echo "→ test: pytest"
"$VENV_PY" -m pytest -q

echo "✅ Python preflight OK"
