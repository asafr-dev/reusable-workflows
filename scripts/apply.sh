#!/usr/bin/env bash
set -euo pipefail

TYPE=""
TARGET=""
OWNER=""
REPO=""
REPO_BASELINE="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --type) TYPE="$2"; shift 2;;
    --target) TARGET="$2"; shift 2;;
    --owner) OWNER="$2"; shift 2;;
    --repo) REPO="$2"; shift 2;;
    --repo-baseline) REPO_BASELINE="true"; shift 1;;
    *) echo "Unknown arg: $1" >&2; exit 2;;
  esac
done

if [[ -z "$TYPE" || -z "$TARGET" || -z "$OWNER" || -z "$REPO" ]]; then
  echo "Usage: bash scripts/apply.sh --type node|python --target ../repo --owner <USER> --repo <REUSABLE_WORKFLOWS_REPO> [--repo-baseline]" >&2
  exit 2
fi

mkdir -p "$TARGET/.github/workflows" "$TARGET/.github"

# 1) CI caller
if [[ "$TYPE" == "node" ]]; then
  cp "scaffolds/node/ci.yml" "$TARGET/.github/workflows/ci.yml"

  # Optional shared configs (copy only if missing)
  [[ -f "$TARGET/eslint.config.js" ]] || cp "configs/node/eslint.config.js" "$TARGET/eslint.config.js"
  [[ -f "$TARGET/.prettierrc.json" ]] || cp "configs/node/.prettierrc.json" "$TARGET/.prettierrc.json"
  [[ -f "$TARGET/.prettierignore" ]] || cp "configs/node/.prettierignore" "$TARGET/.prettierignore"
  [[ -f "$TARGET/tsconfig.base.json" ]] || cp "configs/node/tsconfig.base.json" "$TARGET/tsconfig.base.json"
  [[ -f "$TARGET/lintstaged.config.cjs" ]] || cp "configs/node/lintstaged.config.cjs" "$TARGET/lintstaged.config.cjs"

elif [[ "$TYPE" == "python" ]]; then
  cp "scaffolds/python/ci.yml" "$TARGET/.github/workflows/ci.yml"

else
  echo "Invalid --type. Use node or python." >&2
  exit 2
fi

# 2) Always-on callers
cp "scaffolds/repo-hygiene.yml" "$TARGET/.github/workflows/repo-hygiene.yml"
cp "scaffolds/dependabot.yml" "$TARGET/.github/dependabot.yml"

# 3) CodeQL (language-specific scaffold)
if [[ "$TYPE" == "node" ]]; then
  cp "scaffolds/codeql-js-ts.yml" "$TARGET/.github/workflows/codeql.yml"
else
  cp "scaffolds/codeql-python.yml" "$TARGET/.github/workflows/codeql.yml"
fi

# 4) Optional: repo-layer baseline (copy only if missing)
if [[ "$REPO_BASELINE" == "true" ]]; then
  [[ -f "$TARGET/.editorconfig" ]] || cp "scaffolds/repo/.editorconfig" "$TARGET/.editorconfig"
  [[ -f "$TARGET/.gitattributes" ]] || cp "scaffolds/repo/.gitattributes" "$TARGET/.gitattributes"
  [[ -f "$TARGET/.gitignore" ]] || cp "scaffolds/repo/.gitignore" "$TARGET/.gitignore"

  mkdir -p "$TARGET/.github"
  [[ -f "$TARGET/.github/CODEOWNERS" ]] || cp "scaffolds/repo/CODEOWNERS" "$TARGET/.github/CODEOWNERS"
fi

# 5) Replace placeholders in all scaffolded files
for f in \
  "$TARGET/.github/workflows/ci.yml" \
  "$TARGET/.github/workflows/repo-hygiene.yml" \
  "$TARGET/.github/workflows/codeql.yml" \
  "$TARGET/.github/CODEOWNERS"; do
  if [[ -f "$f" ]]; then
    sed -i.bak "s/<OWNER>/${OWNER}/g; s/<REUSABLE_WORKFLOWS_REPO>/${REPO}/g" "$f" && rm -f "${f}.bak"
  fi
done

echo "✅ Applied reusable-workflows scaffolds to: $TARGET"
