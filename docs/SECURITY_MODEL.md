# Security model

## Goals
- Keep permissions **least-privilege by default**.
- Avoid secret sprawl: workflows should run without extra secrets unless explicitly required.

## Permissions (by reusable)

### `reusable-node.yml`
- Permissions: `contents: read`
- Secrets: none
- Notes: uses Actions marketplace tooling (`actions/checkout`, `actions/setup-node`).

### `reusable-python.yml`
- Permissions: `contents: read`
- Secrets: none
- Notes: uses `actions/setup-python` with pip caching.

### `reusable-repo-hygiene.yml`
- Permissions: `contents: read`
- Secrets: none
- Notes: runs repo-local git/file checks only.

### `reusable-codeql.yml`
- Permissions: `actions: read`, `contents: read`, `security-events: write`
- Secrets: none
- Notes: uploads results to GitHub Code Scanning; callers must allow `security-events: write`.

## Version pinning
- **Reusable workflows** are referenced by a repo ref (tag/branch/SHA). For consumer repos, prefer a stable tag like `v1`.
- For higher assurance, pin to a commit SHA and update intentionally.

## Secret forwarding
- If a caller uses `secrets: inherit`, secrets are provided to the called workflow for that job.
- Keep reusable workflows written so they work without secrets by default.

## Supply-chain hardening (recommended)
- This toolkit pins common first-party actions to full commit SHAs (with version comments).
- Keep it updated via Dependabot GitHub Actions updates (`.github/dependabot.yml` is included).
- Enable branch protection + required status checks on consumer repos.
- If you want SHA-only for *reusable workflow* references too, enforce it via org allowlist patterns.
