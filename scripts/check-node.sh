#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: scripts/check-node.sh [ROOT]

Recommended local preflight checks for a Node/TS repo:
  - install deps (npm ci if package-lock.json exists, else npm install)
  - format check: prefer repo's "format:check"; else prettier (local), else pinned npx fallback
  - lint / typecheck / test / build (npm scripts, --if-present)

Env vars:
  CHECK_NO_INSTALL=1         Skip dependency install
  CHECK_REQUIRE_LOCKFILE=1   Fail if package-lock.json is missing
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

if [[ "${CHECK_NO_INSTALL:-0}" != "1" ]]; then
  if [[ -f package-lock.json ]]; then
    echo "→ deps: npm ci (lockfile present)"
    npm ci
  else
    if [[ "${CHECK_REQUIRE_LOCKFILE:-0}" == "1" ]]; then
      echo "ERROR: package-lock.json is missing (CHECK_REQUIRE_LOCKFILE=1)." >&2
      exit 1
    fi
    echo "→ deps: npm install (no lockfile)"
    npm install
  fi
else
  echo "→ deps: skipped (CHECK_NO_INSTALL=1)"
fi

if [[ "${CHECK_NO_FORMAT:-0}" != "1" ]]; then
  if node -e "const p=require('./package.json'); process.exit(p.scripts && p.scripts['format:check'] ? 0 : 1)"; then
    echo "→ format: npm run -s format:check"
    npm run -s format:check
  elif [[ -x ./node_modules/.bin/prettier ]]; then
    echo "→ format: ./node_modules/.bin/prettier --check"
    ./node_modules/.bin/prettier --check . --ignore-unknown
  else
    echo "→ format: npx prettier@3.3.3 --check"
    npx --yes prettier@3.3.3 --check . --ignore-unknown
  fi
else
  echo "→ format: skipped (CHECK_NO_FORMAT=1)"
fi

echo "→ lint"
npm run -s lint --if-present

echo "→ typecheck"
npm run -s typecheck --if-present

echo "→ test"
npm run -s test --if-present

echo "→ build"
npm run -s build --if-present

echo "✅ Node preflight OK"
