return {
  'NeogitOrg/neogit',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'sindrets/diffview.nvim',
  },
  config = {
    disable_hint = true,
  },
  vim.keymap.set('n', '<leader>ng', ':Neogit<cr>', { desc = 'Open Neogit' }),
  -- vim.cmd [[
  --   augroup MyAutoCmds
  --     autocmd!
  --     autocmd TabClosed * DeleteNoNameBuffers
  --   augroup END
  -- ]],
}
