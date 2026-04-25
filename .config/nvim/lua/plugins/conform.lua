vim.pack.add({ GH("stevearc/conform.nvim") })

require("conform").setup({
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return {
        timeout_ms = 500,
        lsp_format = "fallback",
      }
    end
  end,
  formatters_by_ft = {
    lua = { "stylua" },
    go = { "gofmt" },
    rust = { "rustfmt" },
    cpp = { "clang_format" },
    c = { "clang_format" },
    javascript = { "eslint", "prettier" },
    typescript = { "eslint", "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    svelte = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },
    python = { "isort", "black" },
    handlebars = { "prettier" },
  },
})

vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = "*",
  callback = function()
    require("conform").format({ async = true, lsp_format = "fallback" })
  end,
})
