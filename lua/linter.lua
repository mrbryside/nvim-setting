  local lint = require('lint')
  --lint.linters.cargo = {
  --  cmd = 'cargo check',
  --  stdin = true,
  --  args = {},
  --  stream = 'both',
  --  ignore_exitcode = false,
  --  env = nil,
  --}
  -- Add Linter by File type
  lint.linters_by_ft = {
    go = {'golangcilint', 'revive'},
    --rust = {'cargo'},
  }
  -- Get golangcilint to configure it
  local golangcilint = require("lint.linters.golangcilint")
  golangcilint.args = {
    'run',
    '--out-format',
    'json',
    }

	-- Configure revive
  local revive = require("lint.linters.revive")
  revive.args = {
    '-config',
    vim.fn.getcwd() .. '/config.toml'
  }

-- Add TryLint on bufferwrite as a auto command
-- vim.api.nvim_create_autocmd({ "BufWritePost", "*" }, {
--   callback = function()
-- 	reset_linter()
--     require("lint").try_lint()
--   end,
-- })

-- Function to remove signs
function _G.remove_lint_signs()
  local signs = vim.fn.sign_getplaced('', {group = 'nvim_lint', all = 1})
  for _, sign in ipairs(signs) do
    for _, placed_sign in ipairs(sign.signs) do
      vim.fn.sign_unplace('nvim_lint', {buffer = sign.bufnr, id = placed_sign.id})
    end
  end
end

-- Clear diagnostics and run linting
function _G.reset_linter_and_lint()
  _G.remove_lint_signs()
  lint.try_lint()
end

vim.api.nvim_exec([[
  autocmd BufWritePost * lua _G.reset_linter_and_lint()
]], false)
