# reusable-workflows

![selftest](https://github.com/asafr-dev/reusable-workflows/actions/workflows/selftest.yml/badge.svg?branch=main)

> **Built as a portfolio MVP.** This repo standardizes CI + quality across my portfolio repos.

A **portable CI + code-quality toolkit** for small-to-medium repos (portfolio or production).
Designed to be **copied into other repos** or used via **reusable GitHub Actions workflows**.

## Overview

A portable baseline for **CI + quality automation** (workflows, configs, scripts) so multiple repos stay consistent and reviewable. It exists to prevent quality drift across multi-repo projects (apps + services): linting, typechecking, tests, build, and security basics (Dependabot + CodeQL).

### Defaults

#### Node

- Uses `npm ci` when `package-lock.json` exists; otherwise `npm install`
- Runs scripts if present: `lint`, `typecheck`, `test`, `build`

#### Python

- Installs dependencies via (in order):
  - `requirements.txt` (+ optional `requirements-dev.txt`)
  - editable install from `pyproject.toml`/`setup.*` (uses `.[dev]` when `install_extra_dev: true`)
  - optional `install_cmd` for fully custom installs
- Runs: `ruff check .` + `mypy app` + `pytest -q` (all overridable via inputs)


## Quickstart

### Apply to a Node repo (Vite/React/Next.js)

```bash
# from this repo:
bash scripts/apply.sh --type node --target ../your-node-repo --owner asafr-dev --repo reusable-workflows
```

### Apply to a Python repo (FastAPI)

```bash
bash scripts/apply.sh --type python --target ../your-python-repo --owner asafr-dev --repo reusable-workflows
```

### Use reusable workflows

```yaml
jobs:
  ci:
    uses: <OWNER>/<REUSABLE_WORKFLOWS_REPO>/.github/workflows/reusable-node.yml@v1
    with:
      working_directory: "."
      run_typecheck: true
      run_build: true
```

Other reusable workflows:

- CodeQL: `.github/workflows/reusable-codeql.yml` (input: `languages`)
- Repo hygiene: `.github/workflows/reusable-repo-hygiene.yml` (input: `strict`)

### Copy shared configs

- `configs/node/eslint.config.js`
- `configs/node/.prettierrc.json`
- `configs/node/.prettierignore`
- `configs/node/tsconfig.base.json`
- Optional commit hooks: see [docs/COMMIT_HOOKS.md](docs/COMMIT_HOOKS.md)

### Branch protection

See [`BRANCH_PROTECTION.md`](docs/BRANCH_PROTECTION.md)

## How to test

```bash
bash scripts/selfcheck.sh
```

## Project structure

- `docs/`: documentation + full directory map → [docs/STRUCTURE.md](docs/STRUCTURE.md)
- `scripts/`: dev/CI scripts
- `configs/`: shared tooling/config
- `.github/workflows/`: CI automation

## Documentation

See [Documentation](docs/)

## Contributing

See the [contributing guidelines](https://github.com/asafr-dev/.github/blob/main/CONTRIBUTING.md).

## Security

See the [security policy](https://github.com/asafr-dev/.github/blob/main/SECURITY.md).

## License

See [LICENSE](LICENSE).
