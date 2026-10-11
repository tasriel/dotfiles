-- Cooklang (https://cooklang.org): filetype detection and language server (`cook lsp`, part of CookCLI).
--
-- Lives in `after/plugin/` on purpose: `init.lua` (Kickstart) stays untouched, and `cooklang` is
-- not added to the `servers` table there, because that table is also fed to Mason and `cook lsp`
-- does not come from Mason but from the CookCLI binary (see `scripts/install_cookcli.sh`).
--
-- Requires Neovim >= 0.11 (`vim.lsp.config` / `vim.lsp.enable`) and `cook` in the PATH.
-- Without `cook`, Neovim only reports an error when a `.cook` file is opened.

vim.filetype.add { extension = { cook = 'cooklang' } }

-- Workaround: `cook lsp` (CookCLI 0.38.1 / cooklang-language-server 0.3.0) parses with an empty unit
-- converter and therefore reports *every* timer unit as "Unknown timer unit", although `cook recipe` and
-- `cook server` accept them. Drop these false positives for the time units bundled with CookCLI
-- (units.toml of the cooklang crate); unknown units such as typos are still reported.
---@type table<string, true>
local known_time_units = {}
for _, unit in ipairs { 's', 'sec', 'secs', 'second', 'seconds', 'min', 'mins', 'minute', 'minutes', 'h', 'hour', 'hours', 'd', 'day', 'days' } do
  known_time_units[unit] = true
end

---@param diagnostic lsp.Diagnostic
---@return boolean
local function is_false_timer_unit_error(diagnostic)
  ---@type string?
  local unit = diagnostic.message:match '^Unknown timer unit: (.+)$'
  return unit ~= nil and known_time_units[unit] == true
end

---@param err lsp.ResponseError?
---@param result lsp.PublishDiagnosticsParams
---@param ctx lsp.HandlerContext
local function on_publish_diagnostics(err, result, ctx)
  if result and result.diagnostics then
    result.diagnostics = vim.tbl_filter(function(diagnostic) ---@param diagnostic lsp.Diagnostic
      return not is_false_timer_unit_error(diagnostic)
    end, result.diagnostics)
  end
  vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
end

-- Same capabilities as the servers in `init.lua`, so blink.cmp completion works here as well
---@type lsp.ClientCapabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
---@type boolean, table
local has_blink, blink = pcall(require, 'blink.cmp')
if has_blink then
  capabilities = blink.get_lsp_capabilities()
end

---@type vim.lsp.Config
local config = {
  cmd = { 'cook', 'lsp' },
  filetypes = { 'cooklang' },
  -- Recipe collection = git repo. The server looks for `config/aisle.conf` below the workspace root.
  root_markers = { '.git' },
  capabilities = capabilities,
  handlers = { ['textDocument/publishDiagnostics'] = on_publish_diagnostics },
}

vim.lsp.config['cooklang'] = config
vim.lsp.enable 'cooklang'

-- Highlighting via semantic tokens: the server sends ingredients (@) as `variable`. Most colorschemes,
-- tokyonight included, draw `@variable` in the normal text color, so ingredients would not stand out.
-- Cookware (`class`), timers (`function`), quantities (`number`) and units (`string`) are already colored.
-- `default = true` keeps any own definition; re-applied after `:colorscheme`, which clears highlights.
---@return nil
local function set_cooklang_highlights()
  vim.api.nvim_set_hl(0, '@lsp.type.variable.cooklang', { link = 'Identifier', default = true })
end

set_cooklang_highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('cooklang-highlights', { clear = true }),
  callback = set_cooklang_highlights,
})
