local M = {}

local function exists(path)
  return vim.uv.fs_stat(path) ~= nil
end

local function find_root(markers)
  local cwd = vim.fn.getcwd()

  for _, marker in ipairs(markers) do
    local found = vim.fs.find(marker, {
      upward = true,
      path = cwd,
    })[1]

    if found then
      return vim.fs.dirname(found)
    end
  end
end

function M.detect()
  -- Rust
  if find_root({ "Cargo.toml" }) then
    return "rust"
  end

  -- Node / JS
  if find_root({ "package.json" }) then
    return "node"
  end

  -- Python
  if find_root({ "pyproject.toml", "requirements.txt", "setup.py" }) then
    return "python"
  end

  return nil
end

return M
