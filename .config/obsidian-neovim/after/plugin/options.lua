vim.o.winborder = 'rounded'

-- Line numbers
vim.wo.number = true
vim.wo.relativenumber = true
-- enable lua filetype
vim.g.do_filetype_lua = 1
vim.opt.backspace = '2'
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autowrite = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.autoread = true
vim.wo.foldmethod = 'marker'
vim.wo.foldmarker = '{{{,}}}'

-- This keeps the swapping lines when pressing <esc> j/k
-- vim.opt.timeoutlen = 1000
-- vim.opt.ttimeoutlen = 0

vim.cmd [[ packadd cfilter ]]

local uname = vim.loop.os_uname()
if uname.sysname == 'Darwin' then
  -- Disable newlines at the end of files
  vim.opt.binary = true
  vim.opt.eol = false
end

local projectfile = vim.fn.getcwd() .. '/project.godot'
if vim.fn.filereadable(projectfile) == 1 then
  vim.fn.serverstart './godothost'
end
