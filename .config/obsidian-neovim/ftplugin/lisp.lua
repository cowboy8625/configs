-- set makeprg=sbcl\ --script\ %
vim.cmd [[ set makeprg=sbcl\ --script\ % ]]
-- vim.api.nvim_set_var('makeprg', 'sbcl --script %')
vim.keymap.set('n', ';;', ':make<CR>')
vim.bo.tabstop = 2
vim.bo.softtabstop = 0
vim.bo.shiftwidth = 2
vim.bo.expandtab = true
