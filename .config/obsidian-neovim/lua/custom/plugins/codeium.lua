return {
  'exafunction/codeium.vim',
  config = function()
    -- change '<c-g>' here to any keycode you like.
    vim.keymap.set('i', '<c-g>', function()
      return vim.fn['codeium#accept']()
    end, { expr = true })
    vim.keymap.set('i', '<c-;>', function()
      return vim.fn['codeium#cyclecompletions'](1)
    end, { expr = true })
    vim.keymap.set('i', '<c-,>', function()
      return vim.fn['codeium#cyclecompletions'](-1)
    end, { expr = true })
    vim.keymap.set('i', '<c-x>', function()
      return vim.fn['codeium#clear']()
    end, { expr = true })
  end,
}
