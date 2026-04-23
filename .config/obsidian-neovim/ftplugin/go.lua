print("Setting Go filetype options")

-- vim.cmd([[
--   augroup GoSettings
--     autocmd!
--     autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=4
--   augroup END
-- ]])

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true
vim.bo.softtabstop = 0
