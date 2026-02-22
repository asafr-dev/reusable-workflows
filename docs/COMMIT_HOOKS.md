# Optional commit hooks

CI is the contract. Local hooks are optional, fast feedback.

## Option A: pre-commit (language-agnostic)

Good for polyglot repos (or when you don't want a Node-only hook manager).

This repo includes an example `.pre-commit-config.yml` that runs:
- `actionlint` on `.github/workflows/*`
- `shellcheck` + `shfmt` on `scripts/*.sh`
- `prettier --check` on common text formats (`.md`, `.yml`, `.yaml`, `.json`, `.js`, `.ts`, `.css`, `.html`)
- `ruff format --check` and `ruff check` on staged Python files
- basic whitespace + YAML sanity checks

```bash
pipx install pre-commit  # or: python -m pip install --user pre-commit
pre-commit install
pre-commit run -a
```

Notes:
- The Prettier hook uses pre-commit's Node environment and installs `prettier@3.3.3` for consistency.
- Hooks should stay fast; run full suites via `scripts/check-*.sh` or CI.

## Option B: Husky + lint-staged (Node/TS)

```bash
npm i -D husky lint-staged
npx husky init
```

### Add lint-staged config

Copy `configs/node/lintstaged.config.cjs` into your repo root (or adapt it).

Then in `package.json`:

```json
{
  "lint-staged": {
    "*.{ts,tsx,js,jsx}": ["eslint --fix"],
    "*.{md,json,yml,yaml}": ["prettier --write"]
  }
}
```

### Add a pre-commit hook

`.husky/pre-commit`:

```sh
#!/usr/bin/env sh
npm run -s lint
```

Keep hooks fast; heavier checks belong in CI.
