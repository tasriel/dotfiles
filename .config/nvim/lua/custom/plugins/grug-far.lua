-- lua/custom/plugins/grug-far.lua
return {
  'MagicDuck/grug-far.nvim',
  cmd = 'GrugFar',
  keys = {
    { '<leader>sR', '<cmd>GrugFar<cr>', desc = '[S]earch and [R]eplace in project' },
  },
  opts = {},
}
