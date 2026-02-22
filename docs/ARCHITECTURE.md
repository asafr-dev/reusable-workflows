# Architecture

This toolkit has one goal: **make multiple repos have a uniform look/maintenance** with minimal copy/paste and minimal CI drift.

## Components

### 1) Reusable workflows (preferred)
- `.github/workflows/reusable-node.yml`
- `.github/workflows/reusable-python.yml`

These are called from a target repo’s `ci.yml` using `uses: asafr-dev/reusable-workflows/.github/workflows/...@v1`.

**Design goal:** target repos keep a tiny CI file, while behavior lives here.

### 2) Copy/paste scaffolds (fallback)
- `scaffolds/*` are small files meant to be copied into other repos.
- `scripts/apply.sh` automates copying + token/template replacement.

### 3) Local preflight scripts
- `scripts/check-node.sh` and `scripts/check-python.sh` are **recommended local preflight checks**.
- CI is the contract and may differ because reusable workflows are configurable via inputs.
- OS: scripts are Bash (require `bash`); on Windows, run them via WSL.
- Repo hygiene is enforced in CI via the reusable `reusable-repo-hygiene.yml` workflow.

### 4) Shared configs
- `configs/node/*` holds baseline ESLint/Prettier/tsconfig configs.

## Extension points

- Add more `scaffolds/<stack>` folders when you introduce another ecosystem.
- Extend reusable workflows via optional inputs (keep defaults sane for small repos).

## Philosophy

- **Formatter-first, linter-second, then tests** (avoid review churn).
- Prefer small, deterministic scripts and workflows.
- Keep repo setup “one command” when possible.
