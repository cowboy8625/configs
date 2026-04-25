---@param list string[]
---@param callback function
local function picker(list, format, callback)
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
          results = list,
          entry_maker = format,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(_, _)
          actions.select_default:replace(function(prompt_bufnr)
            actions.close(prompt_bufnr)

            local selection = action_state.get_selected_entry()
            callback(selection)
          end)
          return true
        end,
      }
    )
    :find()
end

---@class Picker
M = {}

---@param list string[]
---@param format function
---@param callback function
function M.pick(list, format, callback)
  picker(list, format, callback)
end

return M
