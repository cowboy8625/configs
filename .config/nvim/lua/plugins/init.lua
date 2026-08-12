vim.pack.add({
  GH("cowboy8625/case-swap.nvim"),
  GH("cowboy8625/epoc.nvim"),
  GH("lewis6991/gitsigns.nvim"),
  GH("stevearc/quicker.nvim"),
  GH("MeanderingProgrammer/render-markdown.nvim"),
  GH("karb94/neoscroll.nvim"),
})

require("case-swap").setup()
require("epoc").setup()
require("gitsigns").setup()
require("quicker").setup()
require("neoscroll").setup({
  mappings = { -- Keys to be mapped to their corresponding default scrolling animation
    "<C-u>",
    "<C-d>",
    "<C-b>",
    "<C-f>",
    "<C-y>",
    "<C-e>",
    "zt",
    "zz",
    "zb",
  },
  hide_cursor = true, -- Hide cursor while scrolling
  stop_eof = true, -- Stop at <EOF> when scrolling downwards
  respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  duration_multiplier = 1.0, -- Global duration multiplier
  easing = "linear", -- Default easing function
  pre_hook = nil, -- Function to run before the scrolling animation starts
  post_hook = nil, -- Function to run after the scrolling animation ends
  performance_mode = false, -- Disable "Performance Mode" on all buffers.
  ignored_events = { -- Events ignored while scrolling
    "WinScrolled",
    "CursorMoved",
  },
})

require("plugins.oil")
require("plugins.neogit")
require("plugins.telescope")
require("plugins.debugger.init")
if not IS_OS("Windows") then
  require("plugins.treesitter")
end
require("plugins.conform")

vim.api.nvim_create_user_command("PackDel", function()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local themes = require("telescope.themes")

  pickers
    .new(
      themes.get_dropdown({
        prompt_title = "Rust Targets",
        previewer = false,
        layout_config = {
          width = 0.5,
          height = 0.4,
        },
      }),
      {
        finder = finders.new_table({
          results = vim.pack.get(),
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry.spec.name,
              ordinal = entry.spec.name,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(_, _)
          actions.select_default:replace(function(prompt_bufnr)
            actions.close(prompt_bufnr)

            local selection = action_state.get_selected_entry()
            vim.pack.del({ selection.display })
          end)
          return true
        end,
      }
    )
    :find()
end, { desc = "Removes a given plugin" })
