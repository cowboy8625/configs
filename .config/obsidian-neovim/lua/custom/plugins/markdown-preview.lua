return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = 'cd app && npm i',
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
  end,
  ft = { 'markdown' },
  lazy = true,
  vim.keymap.set('n', '<leader>md', ':MarkdownPreview<CR>', { desc = 'Toggle [m]ark[d]own previewer', silent = true }),
}
