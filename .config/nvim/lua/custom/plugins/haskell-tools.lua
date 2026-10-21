-- Haskell: LSP (haskell-language-server), Hoogle, REPL, ... via haskell-tools.nvim.
-- Syntax highlighting is NOT provided by this plugin; it comes from the Treesitter
-- `haskell` parser (installed and started in the nvim-treesitter spec in init.lua).
-- Requires Neovim >= 0.12. Do not call `require('lspconfig').hls.setup()` in addition.
---@type LazySpec
return {
  {
    'mrcjkb/haskell-tools.nvim',
    version = '^10', -- pin the major version to avoid breaking changes
    lazy = false, -- the plugin lazy-loads itself on Haskell filetypes
  },
}
