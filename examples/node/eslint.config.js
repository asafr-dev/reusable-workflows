import js from '@eslint/js';
import tseslint from 'typescript-eslint';
import reactHooks from 'eslint-plugin-react-hooks';
import reactRefresh from 'eslint-plugin-react-refresh';

export default tseslint.config(
  js.configs.recommended,
  ...tseslint.configs.recommended,

  // Shared TS/TSX config
  {
    files: ['**/*.{ts,tsx}'],
    languageOptions: {
      parserOptions: { ecmaVersion: 'latest', sourceType: 'module' },
      globals: { document: 'readonly' },
    },
    plugins: {
      'react-hooks': reactHooks,
      'react-refresh': reactRefresh,
    },
  },

  // React/TSX: enforce Fast Refresh-friendly exports and hooks rules
  {
    files: ['**/*.tsx'],
    rules: {
      ...reactHooks.configs.recommended.rules,
      'react-refresh/only-export-components': ['error', { allowConstantExport: true }],
    },
  },

  // Entry points are typically side-effectful and don't export components.
  // The Fast Refresh rule is noisy for these.
  {
    files: ['**/main.tsx'],
    rules: {
      'react-refresh/only-export-components': 'off',
    },
  },

  // Plain TS utilities: do not enforce component-only exports
  {
    files: ['**/*.ts'],
    rules: {
      'react-refresh/only-export-components': 'off',
    },
  },
);
