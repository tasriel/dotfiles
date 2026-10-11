-- Cooklang (https://cooklang.org): filetype detection and language server (`cook lsp`, part of CookCLI).
--
-- Lives in `after/plugin/` on purpose: `init.lua` (Kickstart) stays untouched, and `cooklang` is
-- not added to the `servers` table there, because that table is also fed to Mason and `cook lsp`
-- does not come from Mason but from the CookCLI binary (see `scripts/install_cookcli.sh`).
--
-- Requires Neovim >= 0.11 (`vim.lsp.config` / `vim.lsp.enable`) and `cook` in the PATH.
-- Without `cook`, Neovim only reports an error when a `.cook` file is opened.

vim.filetype.add { extension = { cook = 'cooklang' } }

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
}

vim.lsp.config['cooklang'] = config
vim.lsp.enable 'cooklang'
