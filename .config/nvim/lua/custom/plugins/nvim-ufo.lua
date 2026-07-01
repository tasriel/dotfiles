return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    opts = {
      -- Strategie: Nutze zuerst das LSP für Folds, falls nicht verfügbar, Treesitter
      provider_selector = function(bufnr, filetype, buftype)
        return { 'lsp', 'indent' }
      end,
    },
    init = function()
      vim.o.foldcolumn = '1' -- Zeigt eine kleine Spalte links für Folds an
      vim.o.foldenable = true
    end,
  },
}
