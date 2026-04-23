vim.pack.add({
  -- Dependency's
  GH("nvim-lua/plenary.nvim"),
  -- Plugin
  GH("NeogitOrg/neogit"),
})

-- Setup
require("neogit").setup({
  disable_hint = true,
})

-- Keybindings
vim.keymap.set("n", "<leader>ng", ":Neogit<cr>", { desc = "Open Neogit" })
