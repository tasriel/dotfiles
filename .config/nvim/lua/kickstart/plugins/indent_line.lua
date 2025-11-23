return {
  'lukas-reineke/indent-blankline.nvim',
  main = 'ibl',

  config = function()
    local hooks = require 'ibl.hooks'

    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#232433', nocombine = true })
      vim.api.nvim_set_hl(0, 'IblActiveScope', { fg = '#363b54', nocombine = true })
    end)

    require('ibl').setup {
      indent = {
        highlight = {
          'IblIndent'
        },
        char = '▏',
        -- char = '▎',
      },
      scope = {
        enabled = true,
        highlight = "IblActiveScope",
        char = '▎',
      }
    }
  end,
}
