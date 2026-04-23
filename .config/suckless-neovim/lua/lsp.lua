vim.pack.add({
	GH("neovim/nvim-lspconfig"),
	GH("mason-org/mason.nvim"),
	GH("mason-org/mason-lspconfig.nvim"),
	GH("WhoIsSethDaniel/mason-tool-installer.nvim"),
	GH("L3MON4D3/LuaSnip"),
	GH("rafamadriz/friendly-snippets"),
	GH("Saghen/blink.lib"),
	GH("Saghen/blink.cmp"),
})

-- Mason
require("mason").setup()

require("mason-tool-installer").setup({
	ensure_installed = {
		-- LSPs
		"lua_ls",
		"pyright",
		"typescript-language-server",
		"gopls",
		"rust_analyzer",
		"clangd",

		-- Formatters / linters
		"stylua",
		"prettier",
		"black",
		"isort",
		"gofumpt",
		"goimports",
		"rustfmt",
		"clang-format",
	},
})

-- Capabilities
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- LSP setup via mason-lspconfig
require("mason-lspconfig").setup({
	handlers = {
		function(server_name)
			vim.lsp.config(server_name, {
				capabilities = capabilities,
				flags = {
					debounce_text_changes = 150,
				},
			})
		end,

		["lua_ls"] = function()
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				flags = {
					debounce_text_changes = 150,
				},
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = {
							globals = { "vim", "require" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = { enable = false },
					},
				},
			})
		end,

		["clangd"] = function()
			vim.lsp.config("clangd", {
				capabilities = capabilities,
				cmd = { "clangd", "--background-index", "--clang-tidy" },
				flags = {
					debounce_text_changes = 150,
				},
			})
		end,
	},
})

-- Snippets
require("luasnip.loaders.from_vscode").lazy_load()

-- Completion
require("blink.cmp").setup({
	signature = { enabled = true },
	fuzzy = { implementation = "lua" },

	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 300,
		},
		menu = {
			auto_show = true,
			draw = {
				columns = {
					{ "kind_icon", "label", "label_description", gap = 1 },
					{ "kind" },
				},
			},
		},
	},
})

-- Diagnostics
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
	},
})

-- LSP Attach
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		local map = function(keys, func)
			vim.keymap.set("n", keys, func, { buffer = args.buf })
		end

		map("gd", vim.lsp.buf.definition)
		map("gr", vim.lsp.buf.references)
		map("gi", vim.lsp.buf.implementation)
		map("K", vim.lsp.buf.hover)
		map("<leader>rn", vim.lsp.buf.rename)
		map("<leader>ca", vim.lsp.buf.code_action)
		map("<leader>d", vim.diagnostic.open_float)
		map("[d", vim.diagnostic.goto_prev)
		map("]d", vim.diagnostic.goto_next)

		if client:supports_method("textDocument/formatting") then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = args.buf,
				callback = function()
					vim.lsp.buf.format({
						bufnr = args.buf,
						filter = function(c)
							return c.name ~= "typescript-language-server"
						end,
					})
				end,
			})
		end
	end,
})
