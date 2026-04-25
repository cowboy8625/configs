local function focus_mode_toggle()
  if vim.g.focus_mode_enabled == nil then
    vim.g.focus_mode_enabled = false
  end

  vim.g.focus_mode_enabled = not vim.g.focus_mode_enabled

  vim.wo.number = not vim.wo.number
  vim.wo.relativenumber = not vim.wo.relativenumber
  vim.opt.signcolumn = (vim.wo.number and "yes") or "no"

  if vim.o.laststatus > 0 then
    vim.o.laststatus = 0
  else
    vim.o.laststatus = 3
  end
  vim.o.cmdheight = vim.o.cmdheight == 1 and 0 or 1

  vim.diagnostic.config({
    virtual_text = not vim.diagnostic.config().virtual_text,
  })
end

vim.api.nvim_create_user_command("FocusModeToggle", focus_mode_toggle, { bang = true })

vim.keymap.set("n", "<leader>fm", ":FocusModeToggle<CR>", { desc = "Toggle [F]ocus [M]ode", silent = true })
