# Optional commit hooks (Husky + lint-staged)

Optional, but a nice “quality signal” if you want it.

## Install in a Node/TS repo

```bash
npm i -D husky lint-staged
npx husky init
```

## Add lint-staged config

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

## Add a pre-commit hook

`.husky/pre-commit`:

```bash
npm run lint
```

Keep hooks fast; heavier checks belong in CI.
