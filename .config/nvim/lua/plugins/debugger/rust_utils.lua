local M = {}

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local themes = require("telescope.themes")

local function get_cargo_metadata()
  local output = vim.fn.system("cargo metadata --no-deps --format-version 1")
  if vim.v.shell_error ~= 0 then
    vim.notify("cargo metadata failed", vim.log.levels.ERROR)
    return nil
  end
  return vim.json.decode(output)
end

local function get_targets()
  local metadata = get_cargo_metadata()
  if not metadata then
    return {}
  end

  local targets = {}

  for _, pkg in ipairs(metadata.packages) do
    for _, target in ipairs(pkg.targets) do
      if vim.tbl_contains(target.kind, "bin") or vim.tbl_contains(target.kind, "example") then
        table.insert(targets, {
          name = target.name,
          kind = target.kind[1], -- "bin" or "example"
        })
      end
    end
  end

  return targets
end

function M.pick_target(callback)
  local targets = get_targets()

  if #targets == 0 then
    vim.notify("No Rust targets found", vim.log.levels.ERROR)
    callback(nil)
    return
  end

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
          results = targets,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry.name .. " [" .. entry.kind .. "]",
              ordinal = entry.name,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(_, _)
          actions.select_default:replace(function(prompt_bufnr)
            actions.close(prompt_bufnr)

            local selection = action_state.get_selected_entry()
            callback(selection.value)
          end)
          return true
        end,
      }
    )
    :find()
end

return M
