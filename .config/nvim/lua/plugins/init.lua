vim.pack.add({
  GH("cowboy8625/case-swap.nvim"),
  GH("cowboy8625/epoc.nvim"),
  GH("lewis6991/gitsigns.nvim"),
  GH("stevearc/quicker.nvim"),
})

require("case-swap").setup()
require("epoc").setup()
require("gitsigns").setup()
require("quicker").setup()

require("plugins.oil")
require("plugins.neogit")
require("plugins.telescope")
require("plugins.debugger.init")
require("plugins.treesitter")
require("plugins.copilot")
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
