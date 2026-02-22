# Workflows catalog

This repo exposes **reusable workflows** (called via `jobs.<id>.uses`) and provides **scaffolds** to drop the corresponding wrapper workflows into consumer repos.

## Reusable workflows (the API)

| File | Purpose | Key inputs | Required permissions | Secrets |
|---|---|---|---|---|
| `.github/workflows/reusable-node.yml` | Node/TS CI: install → format → lint → typecheck → test → build | `working_directory`, `node_version`, `run_*` toggles | `contents: read` | none |
| `.github/workflows/reusable-python.yml` | Python CI: install → format → lint → typecheck → tests (format can be disabled) | `working_directory`, `python_version`, `format_cmd` (set to "" to disable), `*_cmd` overrides, `install_cmd`, `install_extra_dev` | `contents: read` | none |
| `.github/workflows/reusable-repo-hygiene.yml` | Fails if generated outputs/caches are tracked (and optionally if they exist) | `strict` | `contents: read` | none |
| `.github/workflows/reusable-codeql.yml` | CodeQL scan via `github/codeql-action` | `languages` | `actions: read`, `contents: read`, `security-events: write` | none |

> Python formatter note: the default `format_cmd` uses `ruff format --check` (requires a Ruff version that supports `ruff format`). Keep `ruff` in dev deps, or set `format_cmd: ""` to disable formatting.

## Scaffolds (copied into consumer repos)

Scaffolds live under `scaffolds/` and are copied by `scripts/apply.sh`.

| Scaffold | Copied to | Notes |
|---|---|---|
| `scaffolds/node/ci.yml` | `.github/workflows/ci.yml` | Wrapper that calls `reusable-node.yml` |
| `scaffolds/python/ci.yml` | `.github/workflows/ci.yml` | Wrapper that calls `reusable-python.yml` |
| `scaffolds/repo-hygiene.yml` | `.github/workflows/repo-hygiene.yml` | Wrapper that calls `reusable-repo-hygiene.yml` |
| `scaffolds/codeql-js-ts.yml` / `scaffolds/codeql-python.yml` | `.github/workflows/codeql.yml` | Wrapper that calls `reusable-codeql.yml` |
| `scaffolds/dependabot.yml` | `.github/dependabot.yml` | Includes `github-actions` updates |
| `scaffolds/repo/*` | repo root / `.github/CODEOWNERS` | Minimal baseline files |

## Caller example

```yaml
jobs:
  ci:
    uses: asafr-dev/reusable-workflows/.github/workflows/reusable-node.yml@v1
    with:
      working_directory: "."
    secrets: inherit
```
