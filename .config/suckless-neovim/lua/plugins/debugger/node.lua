local dap = require("dap")

local function add_plugin_with_build(name, build_cmd)
    vim.pack.add({ GH(name) })

    local plugin_dir = vim.fn.stdpath("data") .. "/site/pack/core/opt/" .. name:gsub(".*/", "")

    if vim.fn.isdirectory(plugin_dir) == 0 then
        print("Error: Plugin directory not found at " .. plugin_dir)
        return
    end

    vim.fn.jobstart(build_cmd, {
        cwd = plugin_dir,
        on_exit = function(_, code)
            if code == 0 then
                print(name .. " built successfully")
            else
                print(name .. " build failed with code " .. code)
            end
        end,
    })
end

-- Usage: Use the short name if your GH() helper already resolved the full path
add_plugin_with_build("Joakker/lua-json5", "./install.sh")

require("dap.ext.vscode").json_decode = require("json5").parse

for _, adapterType in ipairs({ "node", "chrome", "msedge" }) do
    local pwaType = "pwa-" .. adapterType
    print("creating adapterTypes " .. pwaType)

    if not dap.adapters[pwaType] then
        dap.adapters[pwaType] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
                command = "js-debug-adapter",
                args = { "${port}" },
            },
        }
    end

    -- Define adapters without the "pwa-" prefix for VSCode compatibility
    if not dap.adapters[adapterType] then
        dap.adapters[adapterType] = function(cb, config)
            local nativeAdapter = dap.adapters[pwaType]

            config.type = pwaType

            if type(nativeAdapter) == "function" then
                nativeAdapter(cb, config)
            else
                cb(nativeAdapter)
            end
        end
    end
end

local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

local vscode = require("dap.ext.vscode")
vscode.type_to_filetypes["node"] = js_filetypes
vscode.type_to_filetypes["pwa-node"] = js_filetypes
local last_port = ""

for _, language in ipairs(js_filetypes) do
    if not dap.configurations[language] then
        local runtimeExecutable = nil
        if language:find("typescript") then
            runtimeExecutable = vim.fn.executable("tsx") == 1 and "tsx" or "ts-node"
        end
        dap.configurations[language] = {
            {
                type = "pwa-node",
                request = "attach",
                name = "Attach (custom port)",
                address = "localhost",
                port = function()
                    local input = vim.fn.input("Port: ", last_port)
                    last_port = input or ""
                    if last_port == "" then
                        error("Port is required", vim.log.levels.ERROR)
                    end
                    return tonumber(last_port)
                end,
                cwd = "${workspaceFolder}",
                skipFiles = {
                    "<node_internals>/**",
                    "**/node_modules/**",
                },
            },
            {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = "${workspaceFolder}",
                sourceMaps = true,
                runtimeExecutable = runtimeExecutable,
                skipFiles = {
                    "<node_internals>/**",
                    "node_modules/**",
                },
                resolveSourceMapLocations = {
                    "${workspaceFolder}/**",
                    "!**/node_modules/**",
                },
            },
            {
                type = "pwa-node",
                request = "attach",
                name = "Attach",
                processId = require("dap.utils").pick_process,
                cwd = "${workspaceFolder}",
                sourceMaps = true,
                runtimeExecutable = runtimeExecutable,
                skipFiles = {
                    "<node_internals>/**",
                    "node_modules/**",
                },
                resolveSourceMapLocations = {
                    "${workspaceFolder}/**",
                    "!**/node_modules/**",
                },
            },
        }
    end
end
