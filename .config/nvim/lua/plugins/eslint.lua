-- ESLint and Prettier are handled by VS Code
if vim.g.vscode then
  return {}
else
  return {
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
  }
end
