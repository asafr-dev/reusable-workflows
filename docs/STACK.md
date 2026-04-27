# Stack

Reusable GitHub Actions workflows + scaffolds/scripts for consistent CI across demo repos.

| Area                | Technologies                                            | Evidence                                        |
| ------------------- | ------------------------------------------------------- | ----------------------------------------------- |
| Automation platform | GitHub Actions (reusable workflows via `workflow_call`) | `.github/workflows/*.yml`                       |
| Targets             | Node.js/TypeScript CI • Python CI • Repo hygiene        | `docs/WORKFLOWS.md`, `scaffolds/`               |
| Security            | CodeQL workflows • pinned actions SHAs • Dependabot     | `.github/workflows/*`, `.github/dependabot.yml` |
| Quality             | pre-commit • Prettier config                            | `.pre-commit-config.yml`, `.prettierrc.json`    |
| Scripting           | Bash utilities (apply/selfcheck)                        | `scripts/*.sh`                                  |
