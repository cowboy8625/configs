vim.pack.add({
    GH("cowboy8625/case-swap.nvim"),
    GH("cowboy8625/epoc.nvim"),
    GH("lewis6991/gitsigns.nvim"),
    GH("stevearc/quicker.nvim"),
})

require("epoc").setup()
require("gitsigns").setup()
require("quicker").setup()

require("plugins.oil")
require("plugins.neogit")
require("plugins.telescope")
-- require("plugins.dap")
