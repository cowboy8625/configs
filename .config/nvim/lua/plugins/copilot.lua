vim.pack.add({
    GH("copilotlsp-nvim/copilot-lsp"),
    GH("zbirenbaum/copilot.lua"),
})

require("copilot").setup({
    panel = {
        auto_refresh = true,
    },
    suggestion = {
        auto_trigger = true,
    },
})
