P = function(v)
  print(vim.inspect(v))
  return v
end

GH = function(x)
  return "https://github.com/" .. x
end

CB = function(x)
  return "https://codeberg.org/" .. x
end

---@param os_name "Darwin" | "Linux" | "Windows"
---@return boolean
IS_OS = function(os_name)
  local ok, info = pcall(vim.loop.os_uname)
  if not ok or not info or not info.sysname then
    return false
  end
  return info.sysname:lower() == tostring(os_name):lower()
end
