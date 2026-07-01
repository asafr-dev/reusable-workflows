/** @type {import('lint-staged').Config} */
module.exports = {
  "*.{ts,tsx,js,jsx}": ["eslint --fix"],
  "*.{md,json,yml,yaml}": ["prettier --write"]
};
