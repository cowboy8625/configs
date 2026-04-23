-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { 'glacambre/firenvim', build = ':call firenvim#install(0)' },
  -- { dir = '~/Documents/neovim_plugins/epoc.nvim' },
  { 'cowboy8625/epoc.nvim' },
  { 'cowboy8625/case-swap.nvim' },
  { 'nvim-neotest/nvim-nio' },
  { 'mattn/webapi-vim' },
  {
    'azratul/live-share.nvim',
    dependencies = {
      'jbyuki/instant.nvim',
    },
    config = function()
      vim.g.instant_username = 'cowboy8625'
      require('live-share').setup {
        port_internal = 8765,
        max_attempts = 40, -- 10 seconds
        service = 'serveo.net',
      }
    end,
  },
  -- json and yaml formating and more tools
  {
    'gennaro-tedesco/nvim-jqx',
    ft = { 'json', 'yaml' },
  },
  {
    'tjdevries/colorbuddy.nvim',
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'

      -- REQUIRED
      harpoon:setup()
      -- REQUIRED
      -- basic telescope configuration
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<leader><C-e>', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon window' })

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = 'Add file to harpoon' })
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      vim.keymap.set('n', '<leader><C-h>', function()
        harpoon:list():select(1)
      end)
      vim.keymap.set('n', '<leader><C-t>', function()
        harpoon:list():select(2)
      end)
      vim.keymap.set('n', '<leader><C-n>', function()
        harpoon:list():select(3)
      end)
      vim.keymap.set('n', '<leader><C-s>', function()
        harpoon:list():select(4)
      end)

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<leader><C-S-P>', function()
        harpoon:list():prev()
      end)
      vim.keymap.set('n', '<leader><C-S-N>', function()
        harpoon:list():next()
      end)
    end,
  },
  {
    'smoka7/hop.nvim',
    version = '*',
    opts = {
      keys = 'etovxqpdygfblzhckisuran',
    },
    config = function(_, opts)
      require('hop').setup(opts)

      vim.keymap.set('n', '<leader>hw', ':HopWord<cr>', { desc = '[H]op [W]ord', remap = true })
      vim.keymap.set('n', '<leader>ha', ':HopAnywhere<cr>', { desc = '[H]op [A]ny [W]here', remap = true })
    end,
  },
}
