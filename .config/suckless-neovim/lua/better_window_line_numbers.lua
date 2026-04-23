vim.api.nvim_create_autocmd("WinEnter", {
  pattern = "*",
  callback = function()
    if vim.g.focus_mode_enabled then
      return
    end
    vim.opt.number = true
    vim.opt.relativenumber = true
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  pattern = "*",
  callback = function()
    if vim.g.focus_mode_enabled then
      return
    end
    vim.opt.number = true
    vim.opt.relativenumber = false
  end,
})
