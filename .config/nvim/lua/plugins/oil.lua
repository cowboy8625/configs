vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    local file = vim.uv.fs_realpath(event.match)

    if not file then
      return
    end

    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end,
})

vim.pack.add({
  -- Dependency's
  GH("echasnovski/mini.icons"),
  -- Plugin
  GH("stevearc/oil.nvim"),
})

-- Setup
require("mini.icons").setup()
require("oil").setup()

-- Keybindings
vim.keymap.set("n", "-", ":Oil<CR>", { desc = "Open file explorer" })
