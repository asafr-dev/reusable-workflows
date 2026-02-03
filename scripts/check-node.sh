#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
cd "$ROOT"

if [ -f package-lock.json ]; then
  npm ci
else
  npm install
fi

npx --yes prettier@3.3.3 --check . --ignore-unknown

npm run -s lint --if-present
npm run -s typecheck --if-present
npm run -s test --if-present
npm run -s build --if-present

echo "✅ Node checks OK"
