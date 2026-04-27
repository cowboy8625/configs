vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(info)
    if info.match == "oil" then
      return
    end
    if vim.tbl_contains({ "oil" }, vim.bo.ft) then
      return
    end
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
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
