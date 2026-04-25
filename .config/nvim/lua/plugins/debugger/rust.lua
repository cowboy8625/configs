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

local function build_test_exes()
  local result = vim
    .system({
      "cargo",
      "test",
      "--workspace",
      "--no-run",
      "--message-format=json",
    }, { text = true })
    :wait()

  local executables = {}

  if result.code ~= 0 then
    error(result.stderr, 4)
  end

  for _, line in ipairs(vim.split(result.stdout, "\n")) do
    local ok, obj = pcall(vim.json.decode, line)
    if ok and obj.profile and obj.profile.test and obj.executable then
      table.insert(executables, {
        name = obj.target.name,
        package = obj.package_id,
        executable = obj.executable,
      })
    end
  end

  return executables
end

local function get_tests_data()
  local result = vim
    .system({ "cargo", "test", "-q", "--workspace", "--message-format=json", "--", "--list" }, { text = true })
    :wait()

  if result.code ~= 0 then
    vim.notify("Failed to get test names: " .. (result.stderr or "unknown error"), vim.log.levels.ERROR)
    return
  end

  local tests = {}

  if result.code ~= 0 then
    error(result.stderr, 4)
  end

  for _, line in ipairs(vim.split(result.stdout, "\n")) do
    local ok, obj = pcall(vim.json.decode, line)
    if ok and obj.profile and obj.profile.test and obj.executable ~= vim.NIL then
      table.insert(tests, {
        name = obj.target.name,
        package = obj.package_id,
        executable = obj.executable,
      })
    end
  end

  return tests
end

local function get_tests_for_exe(exe)
  local result = vim.system({ exe, "--list" }, { text = true }):wait()

  local tests = {}
  for _, line in ipairs(vim.split(result.stdout, "\n")) do
    local name = line:match("^(.-): test$")
    if name then
      table.insert(tests, name)
    end
  end

  return tests
end

local function get_test_names()
  local result = vim
    .system({ "sh", "-c", "cargo test -q --workspace -- --list | sed -n 's/: test$//p'" }, { text = true })
    :wait()

  if result.code ~= 0 then
    vim.notify("Failed to get test names: " .. (result.stderr or "unknown error"), vim.log.levels.ERROR)
    return
  end

  return vim.split(vim.trim(result.stdout), "\n")
end

local function create_test_to_binary_map()
  local tests_data = get_tests_data()
  if tests_data == nil then
    error("no test data", 4)
    return
  end
  local data = {}
  for _, value in ipairs(tests_data) do
    local tests = get_tests_for_exe(value.executable)
    for _, test in pairs(tests) do
      if data[test] == nil then
        data[test] = value.executable
      end
    end
  end
  return data
end

local dap = require("dap")
local last_args = ""
local args = {}

dap.configurations.rust = {
  {
    name = "Debug cargo",
    type = "codelldb",
    request = "launch",
    mode = "test",
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
    name = "Debug test",
    type = "codelldb",
    request = "launch",
    mode = "test",
    program = function()
      local names = get_test_names()
      local co = coroutine.running()
      require("plugins.utils.picker").pick(names or {}, function(entry)
        return {
          value = entry,
          display = entry,
          ordinal = entry,
        }
      end, function(selected)
        coroutine.resume(co, selected.value)
      end)
      build_test_exes()
      local test_name = coroutine.yield()
      local map = create_test_to_binary_map()
      if map ~= nil and map[test_name] == nil then
        error("no executable found for test: " .. test_name, 4)
        return
      end
      if map == nil then
        error("no test executables found", 4)
        return
      end
      args = { "--test", test_name }

      return map[test_name]
    end,
    args = function()
      return args
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
