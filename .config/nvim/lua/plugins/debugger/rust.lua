-- local function get_cargo_metadata()
-- 	local output = vim.fn.system("cargo metadata --no-deps --format-version 1")
-- 	if vim.v.shell_error ~= 0 then
-- 		vim.notify("cargo metadata failed", vim.log.levels.ERROR)
-- 		return nil
-- 	end
-- 	return vim.json.decode(output)
-- end
--
-- local function get_targets()
-- 	local metadata = get_cargo_metadata()
-- 	if not metadata then
-- 		return {}
-- 	end
--
-- 	local targets = {}
--
-- 	for _, pkg in ipairs(metadata.packages) do
-- 		for _, target in ipairs(pkg.targets) do
-- 			if vim.tbl_contains(target.kind, "bin") or vim.tbl_contains(target.kind, "example") then
-- 				table.insert(targets, target.name)
-- 			end
-- 		end
-- 	end
--
-- 	return targets
-- end
--
-- local function pick_target(targets)
-- 	if #targets == 0 then
-- 		vim.notify("No runnable Rust targets found", vim.log.levels.ERROR)
-- 		return nil
-- 	end
--
-- 	if #targets == 1 then
-- 		return targets[1]
-- 	end
--
-- 	local t = {}
-- 	for k, v in ipairs(targets) do
-- 		table.insert(t, tostring(k) .. ": " .. v)
-- 	end
--
-- 	local options = vim.list_extend({ "Select target:" }, t)
-- 	local choice = vim.fn.inputlist(options)
--
-- 	if choice < 1 or choice > #targets then
-- 		return nil
-- 	end
--
-- 	return targets[choice]
-- end
--
-- local function get_executable()
-- 	local targets = get_targets()
-- 	local choice = pick_target(targets)
--
-- 	if not choice then
-- 		return nil
-- 	end
--
-- 	vim.notify("Building " .. choice)
--
-- 	local is_example = vim.fn.filereadable("examples/" .. choice .. ".rs") == 1
--
-- 	local cmd
-- 	if is_example then
-- 		cmd = "cargo build --example " .. choice
-- 	else
-- 		cmd = "cargo build --bin " .. choice
-- 	end
--
-- 	vim.fn.system(cmd)
--
-- 	if vim.v.shell_error ~= 0 then
-- 		vim.notify("Build failed: " .. cmd, vim.log.levels.ERROR)
-- 		return nil
-- 	end
--
-- 	local path
-- 	if is_example then
-- 		path = "target/debug/examples/" .. choice
-- 	else
-- 		path = "target/debug/" .. choice
-- 	end
--
-- 	local full_path = vim.fn.getcwd() .. "/" .. path
--
-- 	print("DAP program:", full_path)
--
-- 	return full_path
-- end
local rust_utils = require("plugins.debugger.rust_utils")

local function get_executable()
  local co = coroutine.running()

  rust_utils.pick_target(function(target)
    if not target then
      coroutine.resume(co, nil)
      return
    end

    vim.notify("Building " .. target.name)

    local cmd
    if target.kind == "example" then
      cmd = "cargo build --example " .. target.name
    else
      cmd = "cargo build --bin " .. target.name
    end

    vim.fn.system(cmd)

    if vim.v.shell_error ~= 0 then
      vim.notify("Build failed", vim.log.levels.ERROR)
      coroutine.resume(co, nil)
      return
    end

    local path
    if target.kind == "example" then
      path = "target/debug/examples/" .. target.name
    else
      path = "target/debug/" .. target.name
    end

    local full_path = vim.fn.getcwd() .. "/" .. path
    print("DAP program:", full_path)

    coroutine.resume(co, full_path)
  end)

  return coroutine.yield()
end

local dap = require("dap")
local last_args = ""

dap.configurations.rust = {
  {
    name = "Debug cargo",
    type = "codelldb",
    request = "launch",
    program = get_executable,
    args = function()
      local input = vim.fn.input("Args: ", last_args)
      last_args = input or ""
      if last_args == "" then
        return {}
      end
      return vim.split(input, "%s+")
    end,
    cwd = "${workspaceFolder}",
  },
  {
    name = "Launch Rust (codelldb)",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = "codelldb", -- make sure it's in PATH
    args = { "--port", "${port}" },
  },
}
