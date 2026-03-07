#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

bash scripts/check-node.sh examples/node
bash scripts/check-python.sh examples/python
bash scripts/check-python.sh examples/python-pyproject

echo "✅ reusable-workflows selfcheck OK"
