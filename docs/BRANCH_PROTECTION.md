# Branch protection (recommended)

For each repo using this toolkit, set these GitHub rules on `main`:

- Require pull request before merging
- Require status checks to pass:
  - `ci` (or `build` depending on workflow name)
  - optionally `codeql`
- Require branches to be up to date before merging
- Require conversation resolution
- Require signed commits (optional)
