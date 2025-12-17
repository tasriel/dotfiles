return {
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    event = 'VeryLazy',
    priority = 1000,
    opts = {
      preset = 'classic',
      options = {
        show_all_diags_on_cursorline = true,
        add_messages = {
          messages = true,
          display_count = false
        },
        multilines = {
          enabled = true,
          always_show = true
        }
      }
    },
  },
}
