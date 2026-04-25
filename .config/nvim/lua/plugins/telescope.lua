vim.pack.add({
  -- Dependency's
  GH("isak102/telescope-git-file-history.nvim"),
  GH("tpope/vim-fugitive"),
  GH("nvim-lua/plenary.nvim"),
  GH("nvim-telescope/telescope-fzf-native.nvim"),
  GH("nvim-telescope/telescope-ui-select.nvim"),
  GH("nvim-tree/nvim-web-devicons"),
  -- Plugin
  GH("nvim-telescope/telescope.nvim"),
})

-- Setup
require("telescope").setup({
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown(),
    },
  },
})

-- Keybindings
local function tsdisplay(builtin)
  return function()
    builtin({
      layout_strategy = "vertical",
      layout_config = {
        preview_cutoff = 1,
        prompt_position = "bottom",
        horizontal = { width = 0.9, height = 0.9 },
        vertical = { height = 0.9, width = 0.9 },
        preview_height = 0.6,
      },
    })
  end
end

-- Enable Telescope extensions if they are installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
pcall(require("telescope").load_extension, "git_file_history")

-- See `:help telescope.builtin`
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", tsdisplay(builtin.help_tags), { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", tsdisplay(builtin.keymaps), { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>sf", tsdisplay(builtin.find_files), { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>ss", tsdisplay(builtin.builtin), { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sw", tsdisplay(builtin.grep_string), { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sg", tsdisplay(builtin.live_grep), { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", tsdisplay(builtin.diagnostics), { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", tsdisplay(builtin.resume), { desc = "[S]earch [R]esume" })
vim.keymap.set("n", "<leader>s.", tsdisplay(builtin.oldfiles), { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", tsdisplay(builtin.buffers), { desc = "[ ] Find existing buffers" })
vim.keymap.set(
  "n",
  "<leader>gh",
  tsdisplay(require("telescope").extensions.git_file_history.git_file_history),
  { desc = "[G]it file [H]istory" }
)

vim.keymap.set("n", "<leader>/", function()
  builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
    winblend = 10,
    previewer = false,
  }))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>s/", function()
  builtin.live_grep({
    grep_open_files = true,
    prompt_title = "Live Grep in Open Files",
  })
end, { desc = "[S]earch [/] in Open Files" })

vim.keymap.set("n", "<leader>sn", function()
  builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })
