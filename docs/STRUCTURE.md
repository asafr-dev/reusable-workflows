# Repository structure

Purpose: a fast map of this repo for onboarding and “where does X go?”

## Directory map (trimmed)

```text
.
├── README.md  # Main entrypoint (what it is + quickstart + links)
├── LICENSE
├── docs  # Longer-form docs
│   ├── STRUCTURE.md  # Repo map (you are here)
│   ├── ARCHITECTURE.md  # Key doc
│   ├── BRANCH_PROTECTION.md  # Key doc
│   ├── COMMIT_HOOKS.md  # Key doc
│   └── DESIGN_NOTES.md  # Key doc
├── scripts  # Dev/CI helper scripts
│   └── apply.sh
├── configs  # Reusable configuration files
│   └── node
├── .github  # GitHub metadata (CI, automation)
│   ├── workflows  # GitHub Actions workflows
│   ├── dependabot.yml
│   └── CODEOWNERS
├── examples  # Usage examples
│   ├── node
│   ├── python
│   └── python-pyproject
└── scaffolds  # Templates/scaffolding
    ├── node
    ├── python
    ├── repo
    └── README.md
```

## Conventions (what goes where)

- `docs/`: canonical docs; README links here.
- `.github/workflows/`: reusable workflows; keep them small, composable, and documented.
- `scaffolds/`: templates to copy into other repos.
- `examples/`: working examples for consumers.
- `scripts/`: helper scripts (idempotent where possible).
- `.github/`: CI + automation; keep workflow logic out of README.

