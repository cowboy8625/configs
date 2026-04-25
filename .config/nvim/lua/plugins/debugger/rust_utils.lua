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

  require("plugins.utils.picker").pick(targets, function(entry)
    return {
      value = entry,
      display = entry.name .. " [" .. entry.kind .. "]",
      ordinal = entry.name,
    }
  end, callback)
end

return M
