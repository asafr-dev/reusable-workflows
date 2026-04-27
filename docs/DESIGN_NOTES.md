# Design notes

## Why reusable workflows?

They prevent copy/paste drift across multiple repos. Each repo gets a tiny `ci.yml` that calls this toolkit.

## Why local scripts?

People forget CI commands. `scripts/check-*.sh` are **recommended local preflight checks** to reduce friction; CI remains the source of truth and may differ based on workflow inputs.

## Dependabot configuration

This repo updates GitHub Actions at `/`, and tracks package dependencies only inside `examples/*`.
For consumer repos, start from `scaffolds/dependabot.yml` (copied by `scripts/apply.*`) and adjust the `package-ecosystem` + `directory` entries to match your layout.
