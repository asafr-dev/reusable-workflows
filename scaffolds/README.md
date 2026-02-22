# Scaffolds (copied into consumer repos)

These files are **copied into a target repo** (manually or via `scripts/apply.sh`).

## What gets copied where
- `node/ci.yml` -> `.github/workflows/ci.yml` (Node)
- `python/ci.yml` -> `.github/workflows/ci.yml` (Python)
- `dependabot.yml` -> `.github/dependabot.yml`
- `codeql-js-ts.yml` or `codeql-python.yml` -> `.github/workflows/codeql.yml`
- `repo-hygiene.yml` -> `.github/workflows/repo-hygiene.yml`
- `repo/*` -> optional repo-baseline files (editorconfig/gitattributes/gitignore/CODEOWNERS)

## Placeholders
The apply scripts replace:
- `<OWNER>`
- `<REUSABLE_WORKFLOWS_REPO>`
