import prettier from "eslint-config-prettier";

export default [
  {
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: 2021,
      sourceType: "module",
      globals: {
        window: "readonly",
        document: "readonly",
      }
    },
    plugins: {},
    rules: {
      // primjeri
      "no-unused-vars": "warn",
      "no-console": "off",
      "prefer-const": "error"
    }
  },
  prettier // ✅ ovo dodaj na kraj
];
