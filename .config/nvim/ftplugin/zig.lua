-- set makeprg=sbcl\ --script\ %
vim.cmd [[ set makeprg=zig ]]
-- vim.api.nvim_set_var('makeprg', 'sbcl --script %')
vim.keymap.set('n', ';;', ':make run<CR>')
vim.keymap.set('n', ';b', ':make <CR>')
vim.keymap.set('n', ';rf', ':make run %<CR>')

vim.bo.tabstop = 2
vim.bo.softtabstop = 0
vim.bo.shiftwidth = 2
vim.bo.expandtab = true
