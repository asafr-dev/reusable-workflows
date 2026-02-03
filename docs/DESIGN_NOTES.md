# Design notes

## Why reusable workflows?

They prevent copy/paste drift across multiple repos. Each repo gets a tiny `ci.yml` that calls this toolkit.

## Why local scripts?

People forget CI commands. `scripts/check-*.sh` provides parity so “works on my machine” matches CI behavior.

## Dependabot configuration

The repo itself tracks dependencies inside `examples/*` only.
For real repos, use `scaffolds/dependabot.yml` and set the directories to match your repo layout.
