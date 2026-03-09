<h1 align="center">Reusable Workflows</h1>

<p align="center">
  Reusable GitHub Actions workflows + small scaffolds to keep my demo repos consistent, automated, and reviewer-friendly.
</p>

<p align="center">
  <a href="https://github.com/asafr-dev/reusable-workflows/actions/workflows/selftest.yml"><img alt="Selftest" src="https://img.shields.io/github/actions/workflow/status/asafr-dev/reusable-workflows/selftest.yml?branch=main&style=for-the-badge&label=SELFTEST"></a>
  <a href="https://github.com/asafr-dev/reusable-workflows/actions/workflows/codeql.yml"><img alt="CodeQL" src="https://img.shields.io/github/actions/workflow/status/asafr-dev/reusable-workflows/codeql.yml?branch=main&style=for-the-badge&label=CODEQL"></a>
  <a href="https://github.com/asafr-dev/reusable-workflows/tags"><img alt="Release" src="https://img.shields.io/github/v/tag/asafr-dev/reusable-workflows?label=release&style=for-the-badge"></a>
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/github/license/asafr-dev/reusable-workflows?style=for-the-badge"></a>
</p>

## ⚡ Quickstart

### Copy “caller” workflows + baseline files into a repo

From this repo:

```bash
bash scripts/apply.sh --type node --target ../your-node-repo --owner asafr-dev --repo reusable-workflows --repo-baseline
bash scripts/apply.sh --type python --target ../your-python-repo --owner asafr-dev --repo reusable-workflows --repo-baseline
```

For the full reusable workflows catalog + inputs, see [WORKFLOWS.md](docs/WORKFLOWS.md).

## 🧪 How to test

Runs the same checks CI runs, against the example projects:

```bash
bash scripts/selfcheck.sh
```

## 🗂️ Project structure

For the full directory map and “what goes where” conventions, see [STRUCTURE.md](docs/STRUCTURE.md).

- `.github/workflows/` – reusable workflows + selftest pipelines
- `scaffolds/` – copy/paste caller workflows
- `configs/` – shared Node config (eslint/prettier/tsconfig/etc)
- `scripts/` – apply + local checks (selfcheck)
- `examples/` – minimal Node + Python example repos used by selfcheck
- `docs/` – longer-form documentation (workflow API + architecture notes, etc)

## 📚 Documentation

See [documentation](docs/)

## 🤝 Contributing

See the [contributing guidelines](https://github.com/asafr-dev/.github/blob/main/CONTRIBUTING.md)

## 🔒 Security

See the [security policy](https://github.com/asafr-dev/.github/blob/main/SECURITY.md)

## 📄 License

See [LICENSE](LICENSE)
