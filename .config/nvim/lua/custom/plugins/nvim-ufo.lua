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
      -- Neovim Einstellungen für besseres Folding (wichtig für ufo)
      vim.o.foldcolumn = '1' -- Zeigt eine kleine Spalte links für Folds an
      vim.o.foldlevel = 99   -- Öffnet Dateien standardmäßig ungeklappt
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Keymaps zum Öffnen/Schließen aller Folds auf einmal
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = "Alle Folds öffnen" })
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = "Alle Folds schließen" })
    end,
  },
}
