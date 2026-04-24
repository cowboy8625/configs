vim.pack.add({
	{ src = GH("mfussenegger/nvim-dap") },
	{ src = GH("rcarriga/nvim-dap-ui") },
	{ src = GH("nvim-neotest/nvim-nio") },
	{ src = GH("mxsdev/nvim-dap-vscode-js") },

	-- Go
	{ src = GH("leoluz/nvim-dap-go") },

	-- Python
	{ src = GH("mfussenegger/nvim-dap-python") },

	-- Optional but nice
	{ src = GH("nvim-telescope/telescope.nvim") },
	{ src = GH("nvim-telescope/telescope-dap.nvim") },
})

local dap = require("dap")
local dapui = require("dapui")

require("dapui").setup({
	icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
})

vim.fn.sign_define("DapBreakpoint", {
	text = "🔴",
	texthl = "DiagnosticSignError",
})
vim.fn.sign_define("DapStopped", {
	text = "👉",
	texthl = "DiagnosticSignWarn",
	linehl = "Visual",
})

dap.listeners.after.event_initialized["dapui"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui"] = function()
	dapui.close()
end

local detect = require("plugins.debugger.detect")
local loader = require("plugins.debugger.loader")

vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F1>", dap.step_into)
vim.keymap.set("n", "<F2>", dap.step_over)
vim.keymap.set("n", "<F3>", dap.step_out)

vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>B", function()
	dap.set_breakpoint(vim.fn.input("Condition: "))
end)

vim.keymap.set("n", "<F7>", dapui.toggle)

vim.api.nvim_create_user_command("Debug", function()
	local lang = detect.detect()

	if not lang then
		vim.notify("No project type detected", vim.log.levels.WARN)
		return
	end

	loader.load(lang)

	vim.notify("DAP loaded for: " .. lang)

	dap.continue()
end, {})
