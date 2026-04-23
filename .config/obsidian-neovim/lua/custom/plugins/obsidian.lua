return {
  'epwalsh/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = 'markdown',
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    'BufReadPre '
      .. vim.fn.expand '~'
      .. '/vaults/*/**.md',
    'BufNewFile ' .. vim.fn.expand '~' .. '/vaults/**/**.md',
  },
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',
  },
  opts = {
    workspaces = {
      {
        name = 'personal',
        path = '~/vaults/personal',
      },
      {
        name = 'work',
        path = '~/vaults/work',
      },
      {
        name = 'world-bible',
        path = '~/vaults/World Bible/',
      },
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    -- daily_notes = {
    --   -- Optional, if you keep daily notes in a separate directory.
    --   folder = 'daily',
    --   template = 'Template/daily-template.md',
    -- },
    templates = {
      folder = 'Template',
      date_format = '%Y-%m-%d',
      time_format = '%H:%M',
      substitutions = {},
    },
  },
}
