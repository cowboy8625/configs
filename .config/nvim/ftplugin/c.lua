vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.cmd [[ set makeprg=make]]
vim.keymap.set('n', ';;', ':make<CR>')
